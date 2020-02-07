pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./BaseFactory.sol";

/**
 * @title AdminFactory
 * @dev Extends from BaseFactory with a constructor for 
 * initializing the implementation, admin, and init data.
 */

contract AdminFactory is BaseFactory {
    using SafeMath for uint256;

    /***************
  EVENTS
  ***************/
    event ChangedProxyOwner(address _currentOwner, address _newOwner, address _proxy);

    /******************
  INTERNAL ACCOUNTING
  ******************/
    mapping(address => uint256) public ownerProxyCount; // keeps track of how many proxies an owner has
    mapping(address => address) public proxyToOwner; // mapping of proxy address to owner address
    mapping(address => bool) public isProxyOwner; // informs whether an address is a proxy owner
    mapping(address => bool) public isProxy; // informs whether an address is a proxy contract
    address[] public proxyOwners; // array of proxy contract owners
    address[] public proxies; // array of proxy contract addresses
    /**
   * It sets logicContract to the address of the initial implementation
   * @param _implementation address of the initial implementation.
   */
    constructor(address _logicContract) public {
        BaseFactory(_logicContract)
    }

    /**
   * @dev Creates a proxy with the initial implementation and calls it.
   * @param _data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called
   * @return Address of the new proxy.
   */
    function createProxyContract(bytes memory _data) public returns (bool) {
        address proxyContract = createProxyContract(_data);

        ownerProxyCount[msg.sender]++;
        proxyToOwner[address(proxyContract)] = msg.sender;
        isProxy[address(proxyContract)] = true;
        isProxyOwner[msg.sender] = true;

        proxies.push(address(proxyContract));
        proxyOwners.push(msg.sender);

    }

    /**
  * @dev updates logicContract with the new implementation address
  * @param _newImplementation address of new implementation contract
  */
    function updateLogicContract(address _newImplementation) public {
        logicContract = _newImplementation;
        emit LogicContractUpdated(address(logicContract), _newImplementation);
    }

    /**
  * @dev updates the mappings when a proxy is transferred by an owner
  * @param _currentOwner address of current owner transferring proxy
  * @param _newOwner address of new owner
  */
    function changeProxyOwner(address _currentOwner, address _newOwner)
        public
        returns (bool)
    {
        require(isProxy[msg.sender] == true, "The calling address must be a proxy contract");
        require(proxyToOwner[msg.sender] == _currentOwner, "The current owner must own the proxy contract");
        emit ChangedProxyOwner(_currentOwner, _newOwner, msg.sender);

        // if current owner only has one proxy, set their mapping to false, remove them from the owners Array &
        // decrease count
        if (ownerProxyCount[_currentOwner] == 1) {
            isProxyOwner[_currentOwner] = false;
            for (uint256 i = 0; i < proxyOwners.length; i++) {
                if (proxyOwners[i] == _currentOwner) {
                    proxyOwners = _remove(i);
                }
            }
        }

        isProxyOwner[_newOwner] = true;
        proxyOwners.push(_newOwner);
        ownerProxyCount[_newOwner]++;
        ownerProxyCount[_currentOwner]--;
        proxyToOwner[msg.sender] = _newOwner;

        return true;
    }

    /**
  * @dev checks if contract address is a proxy contract 
  * @param _address address of proxy contract
  */
    function isProxy(address _address) public view returns (bool) {
        return isProxy[_address];
    }

    /**
  * @dev checks if user address is a proxy owner
  * @param _owner address of proxy owner
  */
    function isProxyOwner(address _owner) public view returns (bool) {
        return isProxyOwner[_owner];
    }

    /**
  * @dev returns array of proxy contract
  */
    function getProxies() public view returns (address[] memory) {
        return proxies;
    }

    /**
  * @dev returns array of proxy contract owners
  */
    function getProxyOwners() public view returns (address[] memory) {
        return proxyOwners;
    }

    /**
  * @dev returns count of proxy contracts
  */
    function getProxyCount() public view returns (uint256) {
        return proxies.length;
    }

    /**
  * @dev returns count of proxy owners
  */
    function getProxyOwnerCount() public view returns (uint256) {
        return proxyOwners.length;
    }

    /**
  * @dev returns owner address of a proxy contract
  */
    function getProxyOwner(address _proxyAddress) public view returns (address) {
        return proxyToOwner[_proxyAddress];
    }

    /**
  * @dev removes proxy owner from the proxyOwners array
  */
    function _remove(uint256 index) internal returns (address[] memory) {
        if (index >= proxyOwners.length) return proxyOwners;
        for (uint256 i = index; i < proxyOwners.length - 1; i++) {
            proxyOwners[i] = proxyOwners[i + 1];
        }
        delete proxyOwners[proxyOwners.length - 1];
        proxyOwners.length--;
        return proxyOwners;
    }

}
