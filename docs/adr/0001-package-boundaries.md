# ADR 0001: Keep the core SDK independent of Flutter and offline storage

## Status

Accepted.

## Decision

The first package is `four_d`, a pure Dart REST/ORDA client. `four_d_flutter`,
`four_d_offline`, and `four_d_codegen` will be separate packages.

## Consequences

The core remains usable by command-line, server, and Flutter applications.
Offline persistence and platform integrations cannot delay protocol correctness.
