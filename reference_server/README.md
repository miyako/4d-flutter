# 4D reference server project

This is a disposable, local 4D project used to establish verified REST/ORDA
fixtures for `four_d`. It deliberately contains no credentials, deployment
settings, or production data.

Its role policy uses force-login. REST is not enabled by this source project;
when it is configured for HTTP contract recording, add a dedicated test-only
authentication function and credentials rather than allowing anonymous access.

## Schema

- `Companies` has an auto-sequenced `ID` and `companyName`.
- `People` has an auto-sequenced `ID`, a required name, and a required
  `companyID` relation to `Companies` (`employer` / `people`).

## Seed test

The `test_reference_data` project method seeds one company and two people.
It is idempotent and emits `PASS: reference data ready` to standard output
when the expected data is present.

Run it from this repository with the local 4D 21.2 installation:

```sh
"/Applications/4D 21.2/tool4d.app/Contents/MacOS/tool4d" \
  --project reference_server/Project/FourDReference.4DProject \
  --startup-method test_reference_data
```

The first data-bearing run creates local data beside the project. Those files
are ignored by Git. REST authentication, session cookies, and endpoint
fixtures remain unverified until the project is started as a REST server and
contract tests capture the actual request/response traffic.
