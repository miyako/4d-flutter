# 4D for Flutter

Native Dart foundations for the 4D REST/ORDA API, with Flutter as a primary
consumer rather than a required runtime.

## Current milestone

The repository now contains the M1 core scaffold: a Dart workspace, central
REST URI construction, a transport boundary, session-cookie lifecycle handling,
raw catalog access, and a first DataClass query vertical slice. Server-specific
claims stay **provisional** until verified against a reference 4D Server.

## Packages

- `packages/four_d` — pure-Dart core SDK (current work)
- `four_d_flutter` — planned Flutter platform helpers
- `four_d_offline` — planned durable cache/outbox
- `four_d_codegen` — planned catalog-driven models and clients

## Development

Install a current Dart SDK, then run:

```sh
dart pub get
dart format .
dart analyze
dart test
```

The compatibility ledger in [docs/protocol/compatibility.md](docs/protocol/compatibility.md)
is the source of truth for verified protocol support.

## Local 4D reference fixture

[`reference_server`](reference_server/README.md) is a disposable 4D 21.2
project with a DTD-validated catalog and an idempotent ORDA seed test. It is
ready for the next milestone: secure local REST configuration and recorded
HTTP contract fixtures.
