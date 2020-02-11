pragma solidity ^0.5.0;

import "./ProxyContract.sol";

/**
 * @title BaseFactory
 * @dev This contract creates proxy contracts
 */

contract BaseFactory {

    event LogicContractUpdated(address masterCopy, address _newImplementation);

    /**
   * @dev Creates a proxy with the initial implementation and calls it.
   * @param _data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called
   * @return Address of the new proxy.
   */
    function createProxyContract(address logicContract, bytes memory _data) public returns (ProxyContract) {
        ProxyContract proxyContract = new ProxyContract(logicContract, _data);
        return proxyContract;
    }

    /**
  * @dev updates logicContract with the new implementation address
  * @param _newLogicContract address of new implementation contract
  */
    function updateLogicContract(address _newLogicContract) public {
        logicContract = _newLogicContract;
        emit LogicContractUpdated(address(logicContract), _newLogicContract);
    }

}
