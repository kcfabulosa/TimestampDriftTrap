// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract TimestampDriftTrap is ITrap {
    struct CollectOutput {
        uint256 timestamp;
    }

    uint256 public constant DRIFT_THRESHOLD = 10; // seconds

    function collect() external view override returns (bytes memory) {
        return abi.encode(CollectOutput({
            timestamp: block.timestamp
        }));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 3) {
            return (false, abi.encode("Need 3 timestamps"));
        }

        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory prev = abi.decode(data[1], (CollectOutput));
        CollectOutput memory prev2 = abi.decode(data[2], (CollectOutput));

        if (prev2.timestamp >= prev.timestamp || prev.timestamp >= current.timestamp) {
            return (false, abi.encode("Timestamps not increasing"));
        }

        uint256 expectedInterval = prev.timestamp - prev2.timestamp;
        uint256 actualInterval = current.timestamp - prev.timestamp;

        uint256 diff = _absDiff(expectedInterval, actualInterval);

        if (diff > DRIFT_THRESHOLD) {
            return (true, abi.encode("Timestamp drift detected"));
        }

        return (false, abi.encode("No significant drift"));
    }

    function _absDiff(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? a - b : b - a;
    }
}
