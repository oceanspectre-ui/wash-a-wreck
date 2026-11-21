---
project: Wash a Wreck
status: greybox
created: 2026-11-21
tags: [roblox, wash-a-wreck, level-design, greybox]
---

# Swamp Layout (Greybox)

Built in Studio on 2026-11-21. **Everything visible is a grey placeholder.** It exists to test layout and walk times, and is meant to be thrown away and rebuilt in Blender.

Part of [[00 - Wash a Wreck - Master Plan]]. How to swap the art: [[02 - Systems and Reskin Guide]].

## The idea
Every plot has a **tow hitch** at its front edge. The swamp starts right past the hitches and gets deeper the further you walk. Deeper = rarer wrecks. You hook a wreck, drag it back to your hitch, and it goes into your wash bay.

## What is in the place
- **Plots:** 8 in a row, 90 studs apart, fronts facing the swamp.
  - `Workspace.Plots.Plot1`: the live plot.
  - `Workspace.PlotsInactive.Plot2–Plot8`: layout-only copies. The wash and showroom scripts still only run on Plot1.
- **Swamp** (`Workspace.Swamp`), split in two:
  - `Gameplay`: invisible markers the scripts read (by tag).
  - `Art`: zone ground, gates, signs, docks, depth markers, trees, puddles, walls. No script reads any of it.

## Zones (set in `SwampConfig`, not in the map)
| Zone | Depth | Wrecks | Tow gear needed |
|---|---|---|---|
| The Shallows | 0–200 | Common, Uncommon | 1 (open) |
| The Mangroves | 200–400 | Common to Epic | 2 Chain |
| The Deep Swamp | 400–600 | Uncommon to Mythic | 4 Power Winch |

Depth is measured from the `SwampOrigin` marker. The gate signs and red gate lines in `Art` are decoration: the real gate is that you cannot hook a wreck in a zone above your tow gear.

## Open questions from the greybox
- [ ] Is 600 studs deep too far on foot while towing? Time a walk to each zone.
- [ ] Is the swamp too wide (723 studs)? Could narrow it or bring plots closer.
- [ ] Tow on foot or drive the tow truck? Currently on foot with a rope.
