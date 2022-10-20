import React, {Component} from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider"; 
import KryptoBird from '../abis/KryptoBird.json';
import {MDBCard, MDBTitle, MDBCardText, MDBImage, MDBtn, MDBCardImage, MDBCardTitle, MDBCardBody, MDBBtn} from 'mdb-react-ui-kit';
import './App.css'


class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    //First we need to detect an ethereum provider
    async loadWeb3 () {
        const provider = await detectEthereumProvider();

        //modern browsers
        //if there is a provider then lets log that it's working and 
        //access the window from the doc to set web3 to the provider

        if(provider) {
            console.log('ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            //no ethereum provider
            console.log('no ethereum wallet detected')
        }
    }
    
    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts()
        this.setState({account:accounts[0]})
        //console.log(this.state.account)
        //web3 js library
        const networkId = await web3.eth.net.getId()
        //from the Json file, netwokData(Json representation of our contract) 
        //basically connect networkId(web3)
        const networkData = KryptoBird.networks[networkId]
        if(networkData) {
            //1. Create a var abi to set Kryptobird abi
            //2. Create a var address set to networkData
            //3. Create a var contract which grabs a new instance
            //of web3 eth contract
            //4. Log in the console the var contract successfully
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            
            //console.log(contract);
            //it suppose to be ({contract:contract}) but our variable and state 
            //have the same name so we can write it once
            this.setState({contract})
            //console.log(this.state.contract)  
            
            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({totalSupply})
            //console.log(this.state.totalSupply)

            //set up an array to keep track of tokens
            //load KryptoBirdz
            for(let i=1; i <= totalSupply; i++) {
                const KryptoBird = await contract.methods.kryptoBirdz(i-1).call()
                //the state here is our array, so we're setting to the array
                //the spread operator right here help us update the state before
                //merging to the var
                //Also we add this.state to kryptoBirdz because it is coming the state
                this.setState({
                    kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]})
            }
            console.log(this.state.kryptoBirdz)
            

        } else {
            window.alert('smart contract non-deployed')
        }
    }
    //with minting we're sending info and we need to specify the account

    mint = (kryptoBird) => {
        this.state.contract.methods.mint(kryptoBird).send({from:this.state.account})
        .once('receipt', (receipt)=> {
            this.setState({
                kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]})

        })
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract:null,
            totalSupply:0,
            kryptoBirdz:[]
        }
    }

    render() {
        return (
            <div className='container-filled'>
                <nav className='navbar navbar-dark fixed-top 
                bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0'
                    style={{color:'white'}}>
                        Krypto Warriors NFTs     
                    </div>
                    <ul className='navbar-bar px-3'>
                        <li className='nav-item text-nowrap d-none d-sm-none
                        d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>

                        </li>
                    </ul>
                </nav>
                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main' 
                        className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto'
                            style={{opacity:'0.8'}}>
                                <h1 style={{color:'black'}}>Crypto Combat - NFT Marketplace</h1>
                                <form onSubmit={(event)=>{
                                    event.preventDefault()
                                //this.kryptoBird.value comes from ref on line 138
                                const kryptoBird = this.kryptoBird.value
                                this.mint(kryptoBird)
                                }}>
                                    <input
                                    type ='text'
                                    placeholder = 'name'
                                    className='form-control mb-1'
                                    //ref run an anonymous function which takes 
                                    //the input as an argument and set
                                    //the kryptobird to equal that value
                                    ref={(input)=>this.kryptoBird = input}
                                    />
                                    <input style={{margin:'6px'}}
                                    type='submit'
                                    className='btn btn-primary btn-black'
                                    value='MINT'
                                    />                                
                                </form>
                            </div>
                        </main>
                    </div>
                        <hr></hr>
                        <div className='row textcenter'>
                            {this.state.kryptoBirdz.map((kryptoBird, key)=>{
                                return(
                                    <div>
                                        <div>
                                            <MDBCard className='token img' style={{maxWidth:'22rem'}}>
                                            <MDBCardImage src={kryptoBird} position='top' height='250rem'
                                            style={{marginRight:'4px'}}/>
                                            <MDBCardBody>
                                            <MDBCardTitle> Crypto Warrior </MDBCardTitle>
                                            <MDBCardText> This warrior is the one of a few warriors. His high level skills
                                                are incredible and owning him will likely help you win a lot of fights.
                                            </MDBCardText>
                                            <MDBBtn href={kryptoBird}>Download</MDBBtn>
                                            </MDBCardBody>
                                            </MDBCard>
                                        </div>
                                    </div>
                                )
                            })}
                        </div>                   
                </div>
            </div>
        )
    }
}

export default App;
//hr gives some space for lining, it means horizontal rule
//mapping in JS can iterate and create our keys. It can grap info
//and pass it over
//The MDBtitle can be dynamic so that we can propagate different type of names
//Same for the description
//MTBtn is just a download for users to download the image format of the NFT