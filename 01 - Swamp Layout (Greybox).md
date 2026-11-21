---
project: Wash a Wreck
status: greybox
created: 2026-11-21
updated: 2026-11-21
tags: [roblox, wash-a-wreck, level-design, greybox]
---

# Map Layout

The map was rebuilt on 2026-11-21 (hub + 10 swamps). This note describes that version. Everything visible is still replaceable art: see [[02 - Systems and Reskin Guide]].

Part of [[00 - Wash a Wreck - Master Plan]].

## Layout
- **Hub** (west, X below 0): plaza with the spawn, a race circuit, grandstands, and **6 plots** in two rows of 3 (`Workspace.Plots.Plot1–Plot6`). Each plot has a garage with a wash bay and a showroom with 8 pads.
- **Central tow truck** (`Workspace.Map.TowTruck`): one stationary truck at the swamp entrance, facing the swamp. It has a `HookLaunchPoint` and a 28-stud-wide `HookCorridor` running the full length of the swamp. **No script uses these yet.** They are ready for the "throw the hook from the truck" mechanic.
- **Swamp** (east, X 0 to 2200): 10 zones in a line, each 220 studs deep and about 400 wide. There are no walls between zones.

## Zones (set in `SwampConfig`)
| # | Zone | Depth | Tow gear |
|---|---|---|---|
| 1 | Murkroot Mire | 0–220 | 1 Rope |
| 2 | Cinderbog | 220–440 | 1 Rope |
| 3 | Moonpetal Fen | 440–660 | 2 Chain |
| 4 | Sunken Crown | 660–880 | 2 Chain |
| 5 | Blackwater Hollow | 880–1100 | 3 Winch |
| 6 | Frostveil Bog | 1100–1320 | 3 Winch |
| 7 | Venomveil Marsh | 1320–1540 | 4 Power Winch |
| 8 | Thunderroot Marsh | 1540–1760 | 4 Power Winch |
| 9 | Wreckwater Reach | 1760–1980 | 5 Mega Hook |
| 10 | Starfall Fen | 1980–2200 | 5 Mega Hook |

Rarity odds shift from Common/Uncommon in zone 1 to Epic/Legendary/Mythic in zone 10. Each zone has its own lighting, fog and color grade (`AtmosphereController`), which follows `SwampConfig` automatically.

## Markers in the map
- 1 `SwampOrigin` at the swamp entrance (depth 0, pointing east).
- 140 `WreckSpawn` markers, 14 per zone. Up to 6 wrecks wait in each zone.
- 10 `SafeZone` boxes, one per zone, on the middle docks.
- Per plot: `TowDropZone` in front of the garage, and `PlotSpawn` 15 studs from the wash bay car.

## Open questions
- [ ] Walking a wreck home from zone 10 is about 2,900 studs. On-foot towing only makes sense for the first zones; the hook-throw mechanic is meant to replace it.
- [ ] The place allows 60 players but has 6 plots. Set max players to 6.
