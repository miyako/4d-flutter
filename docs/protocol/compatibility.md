# Protocol compatibility ledger

Nothing is marked supported solely from documentation or historical native
clients. Each item requires a captured, scrubbed fixture and a contract test.

| Capability | Status | Evidence required |
| --- | --- | --- |
| Reference schema and ORDA seed | verified locally | `reference_server` catalog DTD validation and idempotent tool4d seed run |
| `$catalog` | unverified | Real HTTP response fixture |
| Authentication / Force Login | unverified | Request/response and cookie fixture |
| Cookie continuity | provisional | Concurrent-session test against 4D Server |
| DataClass queries | provisional | Query fixture including Unicode values |
| CRUD | unverified | Create/update/delete contract fixtures |
| Functions, actions, uploads, locks | unverified | Endpoint-specific fixtures |

The initial implementation intentionally exposes raw catalog and query maps
until these contracts are verified across supported 4D Server versions.

## Reference fixture

`reference_server` contains the reproducible local fixture used for protocol
experiments. It has `Companies` and `People` dataclasses, a required N→1
relation, primary/foreign-key indexes, and an idempotent `test_reference_data`
method. Its generated `.4DD` data remains local and is ignored by Git.

Before recording REST fixtures, configure the 4D web server and REST exposure
through 4D’s supported settings, then choose force-login credentials and keep
the service bound to a development-safe interface/port. Do not treat local
ORDA success as proof that REST endpoints, cookies, or authentication work.
