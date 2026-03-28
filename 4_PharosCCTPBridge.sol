// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharosCCTPBridge
 * @notice CCTP Bridge simulator for cross-chain transfers
 * @dev Deploy this FOURTH in Remix
 */

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract PharosCCTPBridge {
    IERC20 public usdc;
    
    enum TargetChain { Ethereum, Arbitrum, Base, Polygon }
    
    mapping(uint256 => uint256) public bridgedVolume;
    mapping(address => uint256) public userBridgedTotal;
    
    uint256 public totalBridges;
    uint256 public totalBridgeVolume;
    
    uint256 constant BRIDGE_FEE_BPS = 10; // 0.1% fee
    uint256 public collectedFees;
    
    event CCTPBridgeInitiated(
        address indexed user,
        uint256 amount,
        uint256 targetChain,
        string nonce
    );
    
    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }
    
    function bridgeUSDC(uint256 amount, uint256 targetChain) external returns (string memory) {
        require(amount > 0, "Amount must be > 0");
        require(targetChain <= 3, "Invalid target chain");
        
        bool success = usdc.transferFrom(msg.sender, address(this), amount);
        require(success, "USDC transfer failed");
        
        uint256 fee = (amount * BRIDGE_FEE_BPS) / 10000;
        uint256 bridgeAmount = amount - fee;
        
        string memory nonce = _generateNonce();
        
        bridgedVolume[targetChain] += bridgeAmount;
        userBridgedTotal[msg.sender] += amount;
        totalBridges++;
        totalBridgeVolume += amount;
        collectedFees += fee;
        
        emit CCTPBridgeInitiated(msg.sender, amount, targetChain, nonce);
        
        return nonce;
    }
    
    function getBridgeStats() external view returns (
        uint256 total_bridges,
        uint256 total_volume,
        uint256 fees_collected,
        uint256 eth_volume,
        uint256 arb_volume,
        uint256 base_volume
    ) {
        return (
            totalBridges,
            totalBridgeVolume,
            collectedFees,
            bridgedVolume[0],
            bridgedVolume[1],
            bridgedVolume[2]
        );
    }
    
    function _generateNonce() internal view returns (string memory) {
        return string(abi.encodePacked(
            "0x",
            bytes1(uint8(totalBridges % 256)),
            bytes1(uint8(block.timestamp % 256))
        ));
    }
}
