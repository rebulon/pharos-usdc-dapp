// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharosLiquidityPool
 * @notice Liquidity provision with LP token issuance
 * @dev Deploy this THIRD in Remix
 */

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract PharosLiquidityPool {
    IERC20 public usdc;
    
    // LP token tracking
    mapping(address => uint256) public lpTokens;
    uint256 public totalLPTokens;
    
    uint256 public totalUSDCLiquidity;
    
    uint256 public totalProviders;
    mapping(address => bool) public isProvider;
    
    uint256 public totalLiquidityEvents;
    
    event LiquidityAdded(address indexed provider, uint256 usdcAmount, uint256 lpTokensIssued);
    event LiquidityRemoved(address indexed provider, uint256 lpTokensBurned, uint256 usdcReturned);
    
    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }
    
    function addLiquidity(uint256 usdcAmount) external returns (uint256) {
        require(usdcAmount > 0, "Amount must be > 0");
        
        bool success = usdc.transferFrom(msg.sender, address(this), usdcAmount);
        require(success, "USDC transfer failed");
        
        // Issue LP tokens (1.05x value of USDC for incentive)
        uint256 lpTokensToIssue = (usdcAmount * 105) / 100;
        
        lpTokens[msg.sender] += lpTokensToIssue;
        totalLPTokens += lpTokensToIssue;
        totalUSDCLiquidity += usdcAmount;
        
        if (!isProvider[msg.sender]) {
            isProvider[msg.sender] = true;
            totalProviders++;
        }
        
        totalLiquidityEvents++;
        
        emit LiquidityAdded(msg.sender, usdcAmount, lpTokensToIssue);
        
        return lpTokensToIssue;
    }
    
    function removeLiquidity(uint256 lpTokenAmount) external returns (uint256) {
        require(lpTokenAmount > 0, "Amount must be > 0");
        require(lpTokens[msg.sender] >= lpTokenAmount, "Insufficient LP tokens");
        
        uint256 usdcToReturn = (lpTokenAmount * totalUSDCLiquidity) / totalLPTokens;
        
        lpTokens[msg.sender] -= lpTokenAmount;
        totalLPTokens -= lpTokenAmount;
        totalUSDCLiquidity -= usdcToReturn;
        
        bool success = usdc.transfer(msg.sender, usdcToReturn);
        require(success, "USDC transfer failed");
        
        totalLiquidityEvents++;
        
        emit LiquidityRemoved(msg.sender, lpTokenAmount, usdcToReturn);
        
        return usdcToReturn;
    }
    
    function getLiquidityStats() external view returns (
        uint256 total_lp_tokens,
        uint256 total_usdc_liquidity,
        uint256 total_providers,
        uint256 liquidity_events
    ) {
        return (
            totalLPTokens,
            totalUSDCLiquidity,
            totalProviders,
            totalLiquidityEvents
        );
    }
}
