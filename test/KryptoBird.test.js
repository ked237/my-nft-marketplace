const {assert} = require('chai');
//const { Item } = require('react-bootstrap/lib/Breadcrumb');

const KryptoBird = artifacts.require('./Kryptobird');

//check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {
    let contract 
    //before tells our tests to run this before anything else
    before( async () => {
        contract = await KryptoBird.deployed()
    })
    //testing container - describe

    describe('deployement', async() => {

        //test samples with writing it
        it('deploys succesfully', async() => {

            const address = contract.address;
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })
        it('has a name', async() => {
            const name = await contract.name()
            assert.equal(name, 'KryptoBird')
        })
        it('has a symbol', async() => {
            const symbol = await contract.symbol()
            assert.equal(symbol, 'KBIDZ')
        })
    })

    describe('minting', async() => {

        it('successfuly minted a token', async() => {
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()
            //Success
            assert.equal(totalSupply, 1)
            const event = result.logs[0].args
            //test checking the address from
            assert.equal(event._from, '0x0000000000000000000000000000000000000000','from is the contract')
            assert.equal(event._to, accounts[0], 'to is msg sender')
            //Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () => {

        it('counted a new token', async() => {
            //mint 3 tokens. Since Java is synchronous, we've alrady mint 
            //the first token earlier
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            //get total supply again since we're on a different container
            const totalSupply = await contract.totalSupply()
            //Loop through the array and grab each NFT from it
            let result = []
            let KryptoBird
            for(i=1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i-1)
                result.push(KryptoBird)
            }
            // assert that our new array join result will equal our expected join result
            let expected = ['https...1','https...2','https...3','https...4']
            assert.equal(result.join(','), expected.join(','))
        })
    })
})