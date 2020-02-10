# Contract Factory
This library can be used to build an Ethereum contract factory that generates contract clones, each with their own unique state.

### How does it work
The AdminFactory contract is used to generate and deploy your Logic Contract. Then, you can generate and deploy ProxyContract’s that act as clones and have all of the same functionality as your Logic Contract. The key difference is that each ProxyContract has its own state.

This architecture pattern and library is inspired by [OpenZepplin’s Proxy Upgrade Pattern](https://docs.openzeppelin.com/upgrades/2.6/proxies):

### Functionality

The AdminFactory contract has the following functionality:
- The AdminFactory can be used to create ProxyContracts
- The AdminFactory can be used to update the Logic Contract’s address, so that newly generated ProxyContracts have new, upgraded functionality
- The AdminFactory can be used to identify and retrieve ProxyContract addresses and their corresponding owners
- The AdminFactory can be used to replace a ProxyContract owner

The ProxyContract has the following functionality:
- Proxy owners can update the Logic Contract’s address that they want their proxies to use
- A ProxyContract owner can replace themself as the owner of the ProxyContract

### Installation

`$ npm i contract-factory (TBD - Need to create the node package)`

### Usage

Once installed, you can use the contracts in the library by importing them:
`TBD - Import code sample`
`TBD - Import code sample`

### Architecture
![alt text][logo]

[logo]: https://github.com/upstateinteractive/contract-factory/blob/master/ARCHITECTURE.png "Contract Factory architecture"

### Example Use Cases
- Deploying multisig wallet clones for end users to receive and store their assets
- Deploying governance contracts clones for different entities and organizations
- Deploying registry contract clones that can be used to set and retrieve contract addresses
- Deploying and managing gambling pools (e.g., NCAA tournament, FIFA World Cup, etc).

### Contribute
We value and appreciate contributions to open source software. If you’d like to contribute, fork this repository, iterate upon your own fork and then submit a pull request. The pull requests will be reviewed and eventually merged into `master`.

### Questions
For questions and feedback please contact us at doug@upstateinteractive.io and kseniya@upstateinteractive.io.

### License
Contract Factory is released under the [MIT License](https://github.com/upstateinteractive/contract-factory/blob/master/LICENSE).