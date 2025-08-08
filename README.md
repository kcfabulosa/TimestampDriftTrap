# TimestampDriftTrap
Purpose:
Detect subtle inconsistencies in Ethereum block intervals, flagging potential network anomalies when the time between consecutive blocks deviates from the norm.

## Trigger Logic
Unlike gas-based traps, TimestampDriftTrap monitors the natural rhythm of block production using block.timestamp. It tracks the time between the last two blocks and responds if the observed interval strays too far from Ethereum’s expected cadence — even by as little as one second.

## Mechanism
collect() captures the current block’s timestamp and encodes it.

shouldRespond() compares timestamps of the current and previous blocks.

If the drift from the expected 12-second block interval exceeds a configurable threshold (1 second in this trap), the trap fires.

## Use Case
Ideal for detecting time-based anomalies such as:

Irregular block propagation delays.

Validator sync issues.

Network congestion or manipulation attempts affecting block timing.

This trap responds to subtle, systemic signals — a heartbeat monitor for Ethereum’s temporal stability.

## Notes
Purely timestamp-based — gas costs and balances are irrelevant here.

Designed for frequent triggering: it reacts even to minor drifts.

Can be combined with other traps to form a more holistic view of network health.

tg: @opengamero
