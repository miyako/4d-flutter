# Architecture overview

`four_d` is a pure-Dart core SDK. Flutter integration, durable offline state,
and catalog-driven code generation are deliberately separate future packages.

The core follows a strict layering rule:

1. Public API (`FourDClient`, catalog, future ORDA objects)
2. REST/ORDA repositories
3. Wire protocol and response decoding
4. Transport, cookies, TLS, timeouts and diagnostics

All endpoint paths are constructed by `RestUriBuilder`; application code must
not concatenate REST URL strings.
