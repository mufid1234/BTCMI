// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Flattened BTCMonInu contract with OpenZeppelin ERC20
 * Includes all imports directly in this file
 */

/* -------------------- OpenZeppelin Contracts -------------------- */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

/* -------------------- BTCMonInu Contract -------------------- */
contract BTCMonInu is Context, IERC20, IERC20Metadata {
    string private _name = "BTC Mon-Inu";
    string private _symbol = "BTCMI";
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 21000000000000000000000000000000;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function decimals() external view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external override returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[_msgSender()] >= amount, "ERC20: insufficient balance");
        _balances[_msgSender()] -= amount;
        _balances[to] += amount;
        emit Transfer(_msgSender(), to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        require(spender != address(0), "ERC20: approve to zero address");
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool) {
        require(from != address(0), "ERC20: transfer from zero address");
        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[from] >= amount, "ERC20: insufficient balance");
        require(_allowances[from][_msgSender()] >= amount, "ERC20: allowance exceeded");

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][_msgSender()] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }
}
