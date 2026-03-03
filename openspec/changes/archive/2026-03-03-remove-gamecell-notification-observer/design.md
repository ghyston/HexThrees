## Context

`GameCell` is a SpriteKit node that subscribes to `.switchPalette` and `.switchMotionBlur` in its initializer. Gameplay continuously creates and removes these nodes during merges, cleanup, and game resets, so observer lifetime must follow node lifetime rather than process lifetime.

This fix is narrow in scope, but it touches a recurring pattern in the node layer: node classes own visual subscriptions and are removed from the scene graph independently of the view controller and model. The design needs to be safe for repeated add/remove cycles and compatible with the current selector-based `NotificationCenter` usage.

## Goals / Non-Goals

**Goals:**
- Ensure a `GameCell` stops receiving notifications after it leaves the SpriteKit scene graph.
- Keep the fix local to node lifecycle code without changing game rules, persistence, or command flow.
- Establish a reusable lifecycle pattern for other node classes that currently subscribe in `init`.

**Non-Goals:**
- Replacing selector-based observation with Combine or another notification abstraction.
- Broad refactoring of all `NotificationCenter` subscribers in the codebase as part of this single change.
- Changing how palette or motion blur notifications are published.

## Decisions

Use SpriteKit lifecycle hooks instead of relying only on `deinit`.
`deinit` is a useful backstop, but it does not express the actual requirement: the node must stop observing when it is removed from the scene. Overriding `removeFromParent()` or reacting to `parent`/scene transitions keeps teardown aligned with the moment the node becomes inactive. Alternative considered: only removing in `deinit`. Rejected because deallocation may happen later than scene removal and leaves a window where detached nodes still receive callbacks.

Keep registration and teardown encapsulated inside `GameCell`.
The object that registers observers should own their removal. This avoids pushing lifecycle cleanup into callers such as `BgCell` or command objects, which would create hidden coupling. Alternative considered: have removal commands explicitly unregister observers. Rejected because every code path that removes a cell would need to remember this extra step.

Make cleanup idempotent.
Observer removal must be safe if called multiple times because SpriteKit cleanup paths can stack (`removeFromParent`, later deallocation, and game cleanup). Alternative considered: assuming a single teardown path. Rejected because it is brittle and easy to break during future refactors.

Add focused verification around removal behavior.
A small unit test or lifecycle-focused test should assert that observer cleanup happens on removal and does not break repeated teardown. Alternative considered: manual verification only. Rejected because this bug is exactly the kind that regresses silently.

## Risks / Trade-offs

- Removing observers in a lifecycle override may miss edge cases if some nodes are retained without ever being attached to a parent. -> Also keep `deinit` cleanup as a defensive fallback.
- The chosen hook may be reused incorrectly by other nodes if the pattern is not documented. -> Capture the behavior in the spec and tasks so later cleanups can follow the same rule.
- Testing SpriteKit node removal can be awkward in pure unit tests. -> Keep tests narrow and assert the cleanup contract through observable side effects or safe repeated teardown.

## Migration Plan

No data migration or rollout steps are required. The change is internal to runtime node lifecycle management and can be rolled back by reverting the `GameCell` lifecycle cleanup if it introduces regressions.

## Open Questions

- None for the proposal phase. The implementation can decide the exact SpriteKit lifecycle hook as long as removal happens when the node leaves the scene and repeated teardown remains safe.
