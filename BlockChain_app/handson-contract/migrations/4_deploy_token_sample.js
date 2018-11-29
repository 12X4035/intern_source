const TokenSample = artifacts.require('./TokenSample.sol');

module.exports = function(deployer) {
    const initialSupply = 1000000000000 ;
    deployer.deploy(TokenSample , initialSupply);
}