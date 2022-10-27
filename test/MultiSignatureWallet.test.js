const { web3 } = require("@openzeppelin/test-helpers/src/setup");

const Wallet = artifacts.require("MultiSigWallet");

contract("MultiSigWallet", (accounts) => {
    let wallet;
    beforeEach(async () => {
        wallet = await Wallet.deployed();
        await web3.eth.sendTransaction({
            from: accounts[0],
            to: wallet.address,
            value: 100,
        });
    });

    it("should add approver", async () => {
        await wallet.addApprover(accounts[1]);

        console.log(await wallet.doesApproverExist(accounts[1]));

        assert.equal(
            await wallet.doesApproverExist(accounts[1]),
            true,
            "approvers not added",
        );
    });

    it("should create a transfer & approve the transfer", async () => {
        // First make a transfer to account 2
        await wallet.createTransfer(accounts[2], 100);

        // Approve the transfer with account 0 & 1
        await wallet.approveTransfer(accounts[2], { from: accounts[0] });
        await wallet.approveTransfer(accounts[2], { from: accounts[1] });

        // check the status of the transfer
        assert.equal(
            await wallet.checkTransferStatus(accounts[2]),
            true,
            "transfer did not happen",
        );
    });
});
