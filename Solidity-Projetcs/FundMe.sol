// SPDX-License-Identifier: MIT
// FundMe.sol , A Project to fund a smart contract and
// those funds can only be withdrawn by the owner(who created/deployed the contract)

pragma solidity >= 0.6.6 < 0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    // Added to Github Repository(Solidity-Practice)
    // Stop Overflow!
    using SafeMathChainlink for uint256;

    //Array for our Funders
    address[] public funders;

    // Adding our address as owner of this contract
    address public owner;

    // Constructor executed as soon as we hit deploy
    constructor() public {
        // whoever deploys the contract become the owner
        owner = msg.sender;
    }

    // Mapping like Dicts in Python
    mapping (address => uint256) public AddresstoFund;

    // Finding which address sent how much fund
    function fund() public payable {
        // Adding min deposit
        uint256 minimumUsd = 50 * 10 ** 18; // hence everything is in WEI which = 1 ETH = 1 x 10^18 WEI
        require(getConversionRate(msg.value) >= minimumUsd, "Toss more ETH to your Witcher!...");
        AddresstoFund[msg.sender] += msg.value;
        funders.push[msg.sender];
    }

    // Price of ETH-USD from Chainlink Oracles
    function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,)
            = priceFeed.latestRoundData();
        // answer has 8 decimal value, multiply with 10^10 to get to 18 decimal
        // 1 ETH = 1^18 GWEI so multiply by 10^10
        return uint256(answer * 10 ** 10);
    }

    // getting version of Aggregator
    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    // Converting ETH to USD
    // 1 GWEI = 1000000000 WEI = 0.000000001 ETH
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10 ** 18;
        return (ethAmountInUsd);
        // 3962681451330 GWEI
        // 0.000003962681451330 WEI
        // = 1 ETH = 3962$
    }

    // modifier to only allow owner to call this function
    modifier onlyOwner {
        // request sender should be the owner
        require(msg.sender == owner);
        // Run rest of the code( of the function)
        _;
    }
    // Function to withdraw all funds from the contract
    function withdraw() payable onlyOwner public {
        
        // this = current contract
        msg.sender.transfer(address(this).balance);
        // resetting (amount of funders)
        for (uint256 funderIndex; funderIndex =< funders.length; funderIndex ++) {
            address funders = funderIndex
        }
    }

}
