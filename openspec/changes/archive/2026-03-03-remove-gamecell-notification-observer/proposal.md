## Why

`GameCell` subscribes to `NotificationCenter` during initialization and never unregisters. Cells are created and destroyed throughout normal gameplay, so stale observers can outlive their SpriteKit node lifecycle and cause leaks, unexpected callbacks, or crashes when notifications fire after the node has been removed.

## What Changes

- Define lifecycle requirements for SpriteKit nodes that subscribe to `NotificationCenter`.
- Require `GameCell` to unregister its notifications when it is removed from the scene graph.
- Cover the teardown behavior with focused verification so future node classes can follow the same pattern safely.

## Capabilities

### New Capabilities
- `node-observer-lifecycle`: SpriteKit gameplay nodes must detach `NotificationCenter` observers when their scene lifecycle ends.

### Modified Capabilities
- None.

## Impact

- Affected code: [GameCell.swift](/Users/hyston/projects/HexThrees/HexThrees Shared/Nodes/GameCell.swift), related node lifecycle code under `HexThrees Shared/Nodes/`, and tests in `HexThreesTests/`.
- APIs/systems: `NotificationCenter` observer registration and SpriteKit node removal behavior.
- Dependencies: no new external dependencies.
