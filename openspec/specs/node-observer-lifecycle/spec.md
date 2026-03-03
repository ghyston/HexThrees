## ADDED Requirements

### Requirement: Notification observers follow node lifetime
SpriteKit gameplay nodes that register selector-based `NotificationCenter` observers SHALL unregister those observers when the node is removed from the scene graph.

#### Scenario: GameCell leaves the board
- **WHEN** a `GameCell` has registered for palette and motion blur notifications and is removed from its parent node
- **THEN** the `GameCell` MUST unregister its `NotificationCenter` observers before it can receive any later notification callbacks

### Requirement: Observer cleanup is safe to repeat
Observer teardown for gameplay nodes MUST be idempotent so repeated removal and deallocation paths do not crash or require callers to coordinate cleanup order.

#### Scenario: Cleanup runs more than once
- **WHEN** the `GameCell` observer cleanup path is invoked multiple times during node removal and final deallocation
- **THEN** the cleanup MUST complete without throwing, crashing, or re-registering observers

### Requirement: Gameplay behavior stays unchanged before removal
Observer lifecycle fixes SHALL preserve the existing runtime behavior of active `GameCell` nodes while they remain attached to the board.

#### Scenario: Active cell receives visual updates
- **WHEN** a live `GameCell` remains attached to the scene and palette or motion blur notifications are posted
- **THEN** the cell MUST continue updating its visual state exactly as before removal support was added
