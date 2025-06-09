//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

// Interfaces for PancakeSwap (Uniswap V2-compatible)
interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    
    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IUniswapV2Pair {
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface ILendingPool {
    function flashLoan(
        address receiver,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

contract ArbitrageFlashLoan {
    address private immutable owner;
    address private immutable lendingPool;
    // address private constant PANCAKESWAP_ROUTER = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // PancakeSwap V2 Router (BNB Testnet)
    address private PANCAKESWAP_ROUTER;
    address private constant UNISWAP_ROUTER = address(0); // No Uniswap on BNB Testnet
    
    IUniswapV2Router private immutable pancakeswapRouter;
    IUniswapV2Router private immutable uniswapRouter;
    
    constructor(address _lendingPool, address _PANCAKESWAP_ROUTER) {
        owner = msg.sender;
        lendingPool = _lendingPool;
        PANCAKESWAP_ROUTER = _PANCAKESWAP_ROUTER;
        pancakeswapRouter = IUniswapV2Router(PANCAKESWAP_ROUTER);
        uniswapRouter = IUniswapV2Router(UNISWAP_ROUTER);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    struct Trade {
        address tokenIn;
        address tokenOut;
        address pairAddress;
        bool isUniswap;
    }
    
    function initiateArbitrage(
        address[] memory _tokens,
        uint256 _amount,
        address[] memory _pairs,
        bool[] memory _isUniswap
    ) external onlyOwner {
        require(_tokens.length == 3, "Must provide 3 tokens");
        require(_pairs.length == 3, "Must provide 3 pairs");
        require(_isUniswap.length == 3, "Must provide 3 exchange flags");
        
        address[] memory assets = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        uint256[] memory modes = new uint256[](1);
        
        assets[0] = _tokens[0];
        amounts[0] = _amount;
        modes[0] = 0;
        
        bytes memory params = abi.encode(_tokens, _pairs, _isUniswap);
        
        ILendingPool(lendingPool).flashLoan(
            address(this),
            assets,
            amounts,
            modes,
            address(this),
            params,
            0
        );
    }
    
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        console.log("executeOperation");

        require(msg.sender == lendingPool, "Invalid caller");
        require(initiator == address(this), "Invalid initiator");
        
        console.log("executeOperation 1");

        (address[] memory tokens, address[] memory pairs, bool[] memory isUniswap) = 
            abi.decode(params, (address[], address[], bool[]));
            
        Trade[3] memory trades;
        trades[0] = Trade(tokens[0], tokens[1], pairs[0], isUniswap[0]);
        trades[1] = Trade(tokens[1], tokens[2], pairs[1], isUniswap[1]);
        trades[2] = Trade(tokens[2], tokens[0], pairs[2], isUniswap[2]);
        
        uint256 amount = amounts[0];
        
        for (uint i = 0; i < 3; i++) {
            console.log("executeTrade");
            console.log(i);
            console.log(amount);
            amount = executeTrade(
                amount,
                trades[i].tokenIn,
                trades[i].tokenOut,
                trades[i].isUniswap
            );
            console.log(amount);
        }
        
        uint256 totalDebt = amounts[0] + premiums[0];
        require(amount > totalDebt, "Arbitrage not profitable");
        
        console.log("executeOperation 2");

        IERC20(assets[0]).approve(lendingPool, totalDebt);
        IERC20(assets[0]).transfer(owner, amount - totalDebt);

        console.log("executeOperation success");
        
        return true;
    }
    
    function executeTrade(
        uint256 _amountIn,
        address _tokenIn,
        address _tokenOut,
        bool _isUniswap
    ) private returns (uint256) {
        IERC20(_tokenIn).approve(
            _isUniswap ? UNISWAP_ROUTER : PANCAKESWAP_ROUTER,
            _amountIn
        );
        
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        console.log("executeTrade");
        console.log(_amountIn);
        console.log(path[0]);
        console.log(path[1]);
        
        uint[] memory amounts = IUniswapV2Router(
            _isUniswap ? UNISWAP_ROUTER : PANCAKESWAP_ROUTER
        ).swapExactTokensForTokens(
            _amountIn,
            0, // TODO: Add slippage protection in production
            path,
            address(this),
            block.timestamp + 300
        );

        console.log("after swapExactTokensForTokens");
        
        return amounts[1];
    }
    
    function checkArbitrageOpportunity(
        address[] memory _tokens,
        uint256 _amount,
        // address[] memory _pairs,
        bool[] memory _isUniswap
    ) external view returns (uint256) {
        uint256 amount = _amount;
        
        for (uint i = 0; i < 3; i++) {
            amount = getAmountOut(amount, _tokens[i], _tokens[(i + 1) % 3], _isUniswap[i]);
        }
        
        return amount;
    }
    
    function getAmountOut(
        uint256 _amountIn,
        address _tokenIn,
        address _tokenOut,
        bool _isUniswap
    ) private view returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        
        uint[] memory amounts = IUniswapV2Router(
            _isUniswap ? UNISWAP_ROUTER : PANCAKESWAP_ROUTER
        ).getAmountsOut(_amountIn, path);
        
        return amounts[1];
    }
    
    function withdrawToken(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(owner, _amount);
    }
    
    receive() external payable {}
}