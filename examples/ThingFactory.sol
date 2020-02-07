pragma solidity ^0.5.0;

import "./Thing.sol";
import "../contracts/AdminFactory.sol";


contract ThingFactory is AdminFactory {

  address public logicContract;

  event ThingCreated(address newThingAddress, address logicContract);

  constructor (address _logicContract) public {
    logicContract = _logicContract;
  }

  function createThing(bytes memory _data) public {
    address thing = createProxyContract(logicContracts, _data);
    emit ThingCreated(thing, logicContract);
  }

  function isThing(address thing) public view returns (bool) {
    return isProxy(thing);
  }
}
