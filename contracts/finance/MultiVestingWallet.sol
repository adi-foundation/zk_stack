// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (finance/VestingWallet.sol)
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

/**
 * @dev A vesting wallet is a contract that can receive native currency and ERC20 tokens, and release these
 * assets to the wallet beneficiary, according to a vesting schedule.
 *
 * Any assets transferred to this contract will follow the vesting schedule as if they were locked from the beginning.
 * Consequently, if the vesting has already started, any amount of tokens sent to this contract will (at least partly)
 * be immediately releasable.
 *
 * By setting the duration to 0, one can configure this contract to behave like an asset timelock that hold tokens for
 * a beneficiary until a specified time.
 *
 * NOTE: When using this contract with any token whose balance is adjusted automatically (i.e. a rebase token), make
 * sure to account the supply/balance adjustment in the vesting schedule to ensure the vested amount is as intended.
 */
contract MultiVestingWallet is Context {
    event EtherReleased(address indexed beneficiary, uint256 amount);
    event ERC20Released(address indexed beneficiary, address indexed token, uint256 amount);

    mapping(address beneficiary => uint256) private _balance;
    mapping(address beneficiary => mapping(address token => uint256)) private _erc20Balance;
    mapping(address beneficiary => uint256) private _released;
    mapping(address beneficiary => mapping(address token => uint256)) private _erc20Released;
    uint64 private immutable _start;
    uint64 private immutable _duration;

    /**
     * @dev Set the start timestamp and the vesting duration of the vesting wallet.
     */
    constructor(uint64 startTimestamp, uint64 durationSeconds) {
        _start = startTimestamp;
        _duration = durationSeconds;
    }

    /**
     * @dev Getter for the start timestamp.
     */
    function start() public view virtual returns (uint256) {
        return _start;
    }

    /**
     * @dev Getter for the vesting duration.
     */
    function duration() public view virtual returns (uint256) {
        return _duration;
    }

    /**
     * @dev Getter for the end timestamp.
     */
    function end() public view virtual returns (uint256) {
        return start() + duration();
    }

    /**
     * @dev Deposit native currency to the beneficiary's vesting wallet.
     * @param beneficiary The address of the beneficiary.
     */
    function deposit(address beneficiary) public virtual payable {
        _balance[beneficiary] += msg.value;
    }

    /**
     * @dev Deposit ERC20 tokens to the beneficiary's vesting wallet. The contract must have been approved to spend the tokens.
     * @param beneficiary The address of the beneficiary.
     * @param token The address of the ERC20 token.
     * @param amount The amount of tokens to deposit.
     */
    function deposit(address beneficiary, address token, uint256 amount) public virtual {
        _erc20Balance[beneficiary][token] += amount;
        SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
    }

    /**
     * Getter for the remaining native token balance of the beneficiary.
     * @param beneficiary The address of the beneficiary.
     */
    function balanceOf(address beneficiary) public view virtual returns (uint256) {
        return _balance[beneficiary];
    }

    /**
     * Getter for the remaining token balance of the beneficiary.
     * @param beneficiary The address of the beneficiary.
     * @param token The address of the ERC20 token.
     */
    function balanceOf(address beneficiary, address token) public view virtual returns (uint256) {
        return _erc20Balance[beneficiary][token];
    }

    /**
     * @dev Amount of eth already released
     */
    function released(address beneficiary) public view virtual returns (uint256) {
        return _released[beneficiary];
    }

    /**
     * @dev Amount of token already released
     */
    function released(address beneficiary, address token) public view virtual returns (uint256) {
        return _erc20Released[beneficiary][token];
    }

    /**
     * @dev Getter for the amount of releasable eth.
     */
    function releasable(address beneficiary) public view virtual returns (uint256) {
        return vestedAmount(beneficiary, uint64(block.timestamp)) - released(beneficiary);
    }

    /**
     * @dev Getter for the amount of releasable `token` tokens. `token` should be the address of an
     * IERC20 contract.
     */
    function releasable(address beneficiary, address token) public view virtual returns (uint256) {
        return vestedAmount(beneficiary, token, uint64(block.timestamp)) - released(beneficiary, token);
    }

    /**
     * @dev Release the native token (ether) that have already vested.
     *
     * Emits a {EtherReleased} event.
     */
    function release(address beneficiary) public virtual {
        uint256 amount = releasable(beneficiary);
        _released[beneficiary] += amount;
        emit EtherReleased(amount);
        Address.sendValue(payable(beneficiary), amount);
    }

    /**
     * @dev Release the tokens that have already vested.
     *
     * Emits a {ERC20Released} event.
     */
    function release(address beneficiary, address token) public virtual {
        uint256 amount = releasable(beneficiary, token);
        _erc20Released[beneficiary][token] += amount;
        emit ERC20Released(token, amount);
        SafeERC20.safeTransfer(IERC20(token), beneficiary, amount);
    }

    /**
     * @dev Calculates the amount of ether that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(address beneficiary, uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(_balance[beneficiary] + released(beneficiary), timestamp);
    }

    /**
     * @dev Calculates the amount of tokens that has already vested. Default implementation is a linear vesting curve.
     */
    function vestedAmount(address beneficiary, address token, uint64 timestamp) public view virtual returns (uint256) {
        return _vestingSchedule(_erc20Balance[beneficiary][token] + released(beneficiary, token), timestamp);
    }

    /**
     * @dev Virtual implementation of the vesting formula. This returns the amount vested, as a function of time, for
     * an asset given its total historical allocation.
     */
    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp) internal view virtual returns (uint256) {
        if (timestamp < start()) {
            return 0;
        } else if (timestamp >= end()) {
            return totalAllocation;
        } else {
            return (totalAllocation * (timestamp - start())) / duration();
        }
    }
}
