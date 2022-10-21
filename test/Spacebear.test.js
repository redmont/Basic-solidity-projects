const Spacebear = artifacts.require("Spacebear");

contract("Spacebear",(accounts)=>{
    it('should credit an NFT to a specific account', async () => {
        const SpacebearInstance = await Spacebear.deployed();
        await SpacebearInstance.safeMint(accounts[2],"spacebear_1.json");
        
        console.log(await SpacebearInstance.name())
        console.log(await SpacebearInstance.tokenURI(0))
        console.log(await SpacebearInstance.ownerOf(0));
        console.log(accounts);
        
        assert.equal(await SpacebearInstance.ownerOf(0), accounts[2], "Owner of Token is the wrong address");
    })
})