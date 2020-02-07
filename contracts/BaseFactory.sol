pragma solidity ^0.5.0;

import "./ProxyContract.sol";

/**
 * @title BaseFactory
 * @dev This contract creates proxy contracts
 */

contract BaseFactory {

    /***************
  EVENTS
  ***************/
    event ProxyCreated(address proxyContract, address logicContract);
    event LogicContractUpdated(address masterCopy, address _newImplementation);

    /******************
  INTERNAL ACCOUNTING
  ******************/
    address public logicContract; // address of the logic contract that all proxies will point to

    /**
   * @dev It sets logicContract to the address of the initial implementation
   * @param _implementation address of the initial implementation.
   */
    constructor(address _logicContract) public {
        logicContract = _logicContract;
    }

    /**
   * @dev Creates a proxy with the initial implementation and calls it.
   * @param _data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called
   * @return Address of the new proxy.
   */
    function createProxyContract(bytes memory _data) public returns (ProxyContract) {
        ProxyContract proxyContract = new ProxyContract(logicContract, _data);

        emit ProxyCreated(address(proxyContract), logicContract);
        return proxyContract;
    }

    /**
  * @dev updates logicContract with the new implementation address
  * @param _newImplementation address of new implementation contract
  */
    function updateLogicContract(address _newLogicContract) public {
        logicContract = _newLogicContract;
        emit MasterCopyUpdated(address(logicContract), _newLogicContract);
    }

}
