// SPDX-License-Identifier: MIT
/**
 * @author Aayush Gupta  Github:AAYUSH-GUPTA-coder   Twitter:Aayush_gupta_ji
 * 
 * Smart conntract to allow users to mint as many NFTs as they wanted to mint with only one condition that they have to pay a minimum of $1 to mint the NFT. 
 * Using `Thirdweb` contractKit and deploy tool. Get real time price conversion using `Chainlink Data Feeds`
 */
pragma solidity ^0.8.0;

// thirdweb contract for ERC-721 token standard
import "@thirdweb-dev/contracts/base/ERC721Base.sol";
// thirdweb contract for counters
import "@thirdweb-dev/contracts/openzeppelin-presets/utils/Counters.sol";
// chainlink data feed
import "./PriceConverter.sol";

contract Contract is ERC721Base {
    using PriceConverter for uint256;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    // Minimum price of NFT $1 in MATIC
    uint256 public constant MINIMUM_USD = 1 * 10 ** 18;
     

    /**
     * @dev ERC721Base library's constructor takes four Parameters
     * _name of the NFT, _symbol of the NFT,
     *  _royaltyRecipient (address) who will get a royalty on secondary sale, _royaltyBps (royality percentage)
     * we don't need to set Royality for the purpose of our smart contract. setting _royaltyBps to Zero
     * @param _name: name of the whole NFT bundle Collection
     * @param _symbol: symbol of the whole NFT bundle Collection
    */
    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}

    /**
     * @dev createToken: mint the ERC721 Token / NFT with the check that the user have paid $1 to mint the NFT
     */
   function createToken() public payable
    {
        // require statement to check the user have paid $1 to mint the NFT
        require(msg.value.getConversionRate() >= MINIMUM_USD, "SEND_MORE_MATIC");

        // Increment it so next time it's correct when we call .current()
        _tokenIdCounter.increment();

        // Current counter value will be the minted token's token ID.
        uint256 newTokenId = _tokenIdCounter.current();

        // Mint the token
        _mint(msg.sender, newTokenId);

        // Default token Metadata on token minting
        string memory tokenURI = "https://ipfs.io/ipfs/QmVAUVEmr6pxqZq2KtLtjs52d2c91q5sKKhDZweQeqaH7Z";

        // setting default token Metadata 
        _setTokenURI(newTokenId, tokenURI);
    }

    /**
     * @dev function to withdraw funds present in contract address to owner address. In this case, owner is the address that deploy this smart contract
     */
    function withdraw() public onlyOwner(){
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"TRANSFER_FUND_FAIL");
    }

    /**
     * @dev view / Getter function to get the balance of the smart contract
     */
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    
    // A contract receiving Ether must have at least one of the functions

    // fallback is called if msg.data have value
    fallback() external payable {}

    // receive() is called if msg.data is empty
    receive() external payable {}

}