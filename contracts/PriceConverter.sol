// SPDX-License-Identifier: MIT

/**
 * @author Aayush Gupta  Github:AAYUSH-GUPTA-coder   Twitter:Aayush_gupta_ji
 * smart contract to get real time price of MATIC / USD using `Chainlink Data feeds`
 */

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

 /**
     * Network: Mumbai
     * Aggregator: MATIC / USD
     * Address: 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
     */

library PriceConverter {

    /**
     * @dev function to get the Price of MATIC / USD. 
     * The problem with this we get value with 8 float point while Matic/ETH have 18 float point. 
     * Therefore we raise the power of our answer with 10 floating point.
     */
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10); // 1* 10 ** 10 == 10000000000
    }

    /**
     * @dev function to get eth(matic) in USD. 
     * Will get the actual ETH/USD conversion rate, after adjusting the extra 0s.
     */
    function getConversionRate(uint256 ethAmount)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // 1 * 10 ** 18 == 1000000000000000000
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
