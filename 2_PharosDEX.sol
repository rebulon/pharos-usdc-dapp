// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharosDEX
 * @notice Simple DEX for token swaps on Pharos
 * @dev Deploy this SECOND in Remix
 */

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract PharosDEX {
    IERC20 public usdc;
    
    // Pool state
    mapping(address => uint256) public poolBalance; // token -> balance
    mapping(address => uint256) public usdcBalance;
    
    uint256 public feeRate = 30; // 0.3%
    uint256 public totalSwaps;
    uint256 public totalFeeCollected;
    
    address public owner;
    
    event Swapped(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, uint256 usdcAmount);
    
    constructor(address _usdc) {
        usdc = IERC20(_usdc);
        owner = msg.sender;
    }
    
    function swapUSDCForToken(address token, uint256 usdcAmount) external returns (uint256) {
        require(usdcAmount > 0, "Amount must be > 0");
        
        bool success = usdc.transferFrom(msg.sender, address(this), usdcAmount);
        require(success, "USDC transfer failed");
        
        uint256 fee = (usdcAmount * feeRate) / 10000;
        uint256 amountOut = (usdcAmount - fee);
        
        usdcBalance[token] += usdcAmount;
        totalFeeCollected += fee;
        totalSwaps++;
        
        emit Swapped(msg.sender, address(usdc), token, usdcAmount, amountOut);
        
        return amountOut;
    }
    
    function swapTokenForUSDC(address token, uint256 tokenAmount) external returns (uint256) {
        require(tokenAmount > 0, "Amount must be > 0");
        
        uint256 fee = (tokenAmount * feeRate) / 10000;
        uint256 usdcOut = (tokenAmount - fee) * 1e6; // Normalize decimals
        
        poolBalance[token] += tokenAmount;
        totalFeeCollected += fee;
        totalSwaps++;
        
        bool success = usdc.transfer(msg.sender, usdcOut);
        require(success, "USDC transfer failed");
        
        emit Swapped(msg.sender, token, address(usdc), tokenAmount, usdcOut);
        
        return usdcOut;
    }
    
    function getDEXStats() external view returns (
        uint256 swaps_total,
        uint256 fees_collected,
        uint256 usdc_balance
    ) {
        return (
            totalSwaps,
            totalFeeCollected,
            usdc.balanceOf(address(this))
        );
    }
}
