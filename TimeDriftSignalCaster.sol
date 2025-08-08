// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeDriftSignalCaster {
    event TimeDriftAlert(bytes data);

    function castDrift(bytes calldata data) external {
        emit TimeDriftAlert(data);
    }
}
