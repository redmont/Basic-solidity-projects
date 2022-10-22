const EventManagement = artifacts.require("eventManagement");
module.exports = function (deployer) {
    deployer.deploy(EventManagement);
};
