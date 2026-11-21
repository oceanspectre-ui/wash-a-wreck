---
project: Wash a Wreck
status: greybox
created: 2026-11-21
tags: [roblox, wash-a-wreck, level-design, greybox]
---

# Swamp Layout (Greybox)

Built in Studio on 2026-11-21 (place version 12). Grey parts only: testing layout and walk times, not art.

Part of [[00 - Wash a Wreck - Master Plan]] (sections 3, 4 and 6.3).

## The idea
Every plot has a **tow hitch** at its front edge. The swamp starts right past the hitches and gets deeper the further you walk. Deeper = rarer wrecks. You hook a wreck, drag it back to your hitch, and it goes into your wash bay.

## Layout (world studs)
- **Plots:** 8 in a row along X, fronts facing +Z, 90 studs apart. Row spans x −289 to 422.
  - `Workspace.Plots.Plot1`: the live plot.
  - `Workspace.PlotsInactive.Plot2–Plot8`: layout-only copies. **WashService, ShowroomService, WashController and ShowroomController only use Plot1**, so these stay inactive until the services run per plot.
  - Assignment order puts neighbours together: Plot2 right of Plot1, Plot3 left, and so on.
- **TowHitch** (in each plot): concrete yard, yellow `DropZone` pad (attribute `DropZone=true`), hitch post with `HitchAttachment`, and a greybox tow truck parked beside it.
- **Swamp** (`Workspace.Swamp`): 723 studs wide, starts at z=12. Depth = studs past z=12.

| Zone | Depth | Max rarity | Tow gear needed |
|---|---|---|---|
| 1 The Shallows | 0–200 | Uncommon | 1 (open) |
| 2 The Mangroves | 200–400 | Epic | 2 |
| 3 The Deep Swamp | 400–600 | Mythic | 4 |

- `Zones/ZoneN` ground parts carry the rules as attributes: `ZoneId`, `ZoneName`, `MinDepth`, `MaxDepth`, `MaxRarity`, `RequiredTowTier`.
- `Gates/GateN`: red force-field line at each zone edge (non-colliding for now), attribute `RequiredTowTier`. TowService will enforce it.
- `Docks`: 3 safe docks per zone (9 total), each with a `SafeVolume` (attribute `SafeZone=true`) for the future gator.
- `WreckSpawns`: 36 invisible spawn pads, 12 per zone, attributes `ZoneId` and `Depth`. WreckService (step 2) picks from these.
- `DepthMarkers`: signs every 50 m. `Signs`: zone names at each zone edge. `Bounds`: treeline walls on the sides and far end.

## Open questions from the greybox
- [ ] Is 600 studs deep too far on foot while towing? Time a walk to each zone.
- [ ] Is 723 studs wide too much empty space? Could narrow the swamp or bring plots closer.
- [ ] Tow on foot or drive the tow truck? Current plan: on foot, the truck winches the last stretch.

## Next
1. **WreckService:** spawn muddy wrecks on `WreckSpawns`, rarity by depth, hidden roll at spawn, restock every 5 min.
2. **TowService:** hook, drag with slowdown by weight, deliver at `DropZone` → wash bay.
3. **Per-plot services** before switching on Plot2–8.
