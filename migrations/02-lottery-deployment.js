const Lottery = artifacts.require("lottery");
const EventManagement = artifacts.require("event_management");
module.exports = function (deployer) {
    deployer.deploy(Lottery);
    deployer.deploy(EventManagement);
};
