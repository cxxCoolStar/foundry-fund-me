// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetWorkConfig public activeNetWorkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    uint256 public constant SOPLIA_CHAIN_ID = 11155111;

    struct NetWorkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == SOPLIA_CHAIN_ID) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else  {
            activeNetWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        if (activeNetWorkConfig.priceFeed != address(0)) {
            return activeNetWorkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetWorkConfig memory anvilEthConfig = NetWorkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilEthConfig;
    }
}
