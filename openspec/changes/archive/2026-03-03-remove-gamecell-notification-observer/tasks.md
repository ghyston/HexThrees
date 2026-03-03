## 1. GameCell lifecycle cleanup

- [x] 1.1 Add an internal observer teardown path in `GameCell` that unregisters its `NotificationCenter` subscriptions exactly once.
- [x] 1.2 Hook that teardown path into the `GameCell` scene lifecycle so observers are removed when the node leaves its parent, with `deinit` kept as a defensive fallback.
- [x] 1.3 Verify active `GameCell` instances still respond to palette and motion blur notifications before removal.

## 2. Verification

- [x] 2.1 Add or update a focused test that exercises `GameCell` removal and confirms observer cleanup is safe across repeated teardown.
- [ ] 2.2 Run the relevant test target or targeted tests covering `GameCell` lifecycle behavior and record any follow-up issues.
