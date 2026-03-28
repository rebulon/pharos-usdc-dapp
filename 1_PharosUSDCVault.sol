// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharosUSDCVault
 * @notice USDC Vault with staking and rewards
 * @dev Deploy this FIRST in Remix
 */

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract PharosUSDCVault {
    IERC20 public usdc;
    
    // Staking parameters
    uint256 public constant APR = 1250; // 12.5% per year (basis points)
    uint256 public constant YEAR = 365 days;
    
    // User balances
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public lastStakeTime;
    mapping(address => uint256) public claimedRewards;
    
    uint256 public totalStaked;
    uint256 public totalDeposits;
    
    // Counters for footprint
    uint256 public totalTransactions;
    uint256 public totalUsersInteracted;
    mapping(address => bool) public userInteracted;
    
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    
    constructor(address _usdc) {
        usdc = IERC20(_usdc);
    }
    
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        
        bool success = usdc.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");
        
        deposits[msg.sender] += amount;
        totalDeposits += amount;
        
        _trackUser();
        totalTransactions++;
        
        emit Deposited(msg.sender, amount);
    }
    
    function withdraw(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;
        
        bool success = usdc.transfer(msg.sender, amount);
        require(success, "Transfer failed");
        
        _trackUser();
        totalTransactions++;
        
        emit Withdrawn(msg.sender, amount);
    }
    
    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(deposits[msg.sender] >= amount, "Insufficient deposit");
        
        deposits[msg.sender] -= amount;
        stakedAmount[msg.sender] += amount;
        totalStaked += amount;
        lastStakeTime[msg.sender] = block.timestamp;
        
        _trackUser();
        totalTransactions++;
        
        emit Staked(msg.sender, amount);
    }
    
    function unstake(uint256 amount) external {
        require(amount > 0, "Amount must be > 0");
        require(stakedAmount[msg.sender] >= amount, "Insufficient staked");
        
        // Claim pending rewards before unstaking
        _claimRewards();
        
        stakedAmount[msg.sender] -= amount;
        totalStaked -= amount;
        deposits[msg.sender] += amount;
        
        _trackUser();
        totalTransactions++;
        
        emit Unstaked(msg.sender, amount);
    }
    
    function claimRewards() external {
        _claimRewards();
    }
    
    function _claimRewards() internal {
        uint256 rewards = calculateRewards(msg.sender);
        if (rewards > 0) {
            claimedRewards[msg.sender] += rewards;
            deposits[msg.sender] += rewards;
            
            totalTransactions++;
            emit RewardsClaimed(msg.sender, rewards);
        }
        lastStakeTime[msg.sender] = block.timestamp;
    }
    
    function calculateRewards(address user) public view returns (uint256) {
        if (stakedAmount[user] == 0) return 0;
        
        uint256 stakingTime = block.timestamp - lastStakeTime[user];
        uint256 rewards = (stakedAmount[user] * APR * stakingTime) / (10000 * YEAR);
        
        return rewards;
    }
    
    function getUserStats(address user) external view returns (
        uint256 depositedAmount,
        uint256 stakedAmount_,
        uint256 pendingRewards,
        uint256 totalRewardsClaimed
    ) {
        return (
            deposits[user],
            stakedAmount[user],
            calculateRewards(user),
            claimedRewards[user]
        );
    }
    
    function getVaultStats() external view returns (
        uint256 total_deposits,
        uint256 total_staked,
        uint256 total_txs,
        uint256 total_users,
        uint256 contract_balance
    ) {
        return (
            totalDeposits,
            totalStaked,
            totalTransactions,
            totalUsersInteracted,
            usdc.balanceOf(address(this))
        );
    }
    
    function _trackUser() internal {
        if (!userInteracted[msg.sender]) {
            userInteracted[msg.sender] = true;
            totalUsersInteracted++;
        }
    }
}
