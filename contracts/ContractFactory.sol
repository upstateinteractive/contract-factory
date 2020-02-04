pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./ProxyContract.sol";

contract ContractFactory {
    using SafeMath for uint256;

    /***************
  EVENTS
  ***************/
    event ProxyCreated(address proxyContract, address logicContract);
    event MasterCopyUpdated(address masterCopy, address _newImplementation);
    event ChangedProxyOwner(address _currentOwner, address _newOwner, address _proxy);

    /******************
  INTERNAL ACCOUNTING
  ******************/
    address public logicContract; // address of the logic contract that all proxies will point to

    /**
   * It sets logicContract to the address of the initial implementation
   * @param _implementation address of the initial implementation.
   */
    constructor(address _implementation) public {
        logicContract = _implementation;
    }

    /**
   * @dev Creates a proxy with the initial implementation and calls it.
   * @param _data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called
   * @return Address of the new proxy.
   */
    function createClone(bytes memory _data) public returns (ProxyContract) {
        ProxyContract proxyContract = new ProxyContract(logicContract, _data);

        emit ProxyCreated(address(proxyContract), logicContract);
        return proxyContract;
    }

    /**
  * @dev updates logicContract with the new implementation address
  * @param _newImplementation address of new implementation contract
  */
    function updatedLogicContract(address _newImplementation) public {
        logicContract = _newImplementation;
    }

}
