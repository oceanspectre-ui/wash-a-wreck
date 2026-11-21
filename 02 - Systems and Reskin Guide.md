---
project: Wash a Wreck
status: greybox
created: 2026-11-21
tags: [roblox, wash-a-wreck, systems, modular, reskin]
---

# Systems and Reskin Guide

How the game is put together, and what you can change without touching code. Written 2026-11-21 after build steps 1–5.

Related: [[00 - Wash a Wreck - Master Plan]], [[01 - Swamp Layout (Greybox)]].

## The one rule
**Code never reads art.** Scripts only look for:
1. **Tagged markers** (invisible parts with a CollectionService tag), and
2. **Config modules** in `ReplicatedStorage.Shared`.

So any model, colour, size or position can change. Delete all of `Workspace.Swamp.Art` and the game still runs on the bare baseplate.

## Markers (move, add or delete freely)
| Tag | Where | What it does |
|---|---|---|
| `SwampOrigin` | 1 part in `Swamp.Gameplay` | Depth 0. Its front face points "deeper". Move or rotate it to move the whole swamp. |
| `WreckSpawn` | 36 parts in `Swamp.Gameplay.WreckSpawns` | A wreck can appear here. Its zone comes from how deep it is. Add more by tagging any part. |
| `TowDropZone` | 1 box in each plot's `Markers` | The owner standing inside it while towing delivers the wreck. |
| `SafeZone` | 9 boxes in `Swamp.Gameplay.SafeZones` | Reserved for the chaser (not built yet). |

Each marker and folder has a `Note` attribute in Studio saying what it is for.

## Config (all numbers are placeholders)
| Module | Controls |
|---|---|
| `SwampConfig` | Zones (depth range, rarity odds, tow gear needed, max wrecks), restock time, tag names |
| `WreckData` | Wrecks, rarities, mutations, values, weights |
| `TowConfig` | Hook range, tow speed formula, follow distance, wash bay queue size |
| `UpgradeConfig` | Upgrade tracks, tier names, prices, effects. Add a row = new tier. The board UI builds itself from this. |
| `WashConfig` | Spray feel, mud layout, par timer |
| `ShowroomConfig` | Slots, income tick |

## Art you can replace
| Thing | Where | Contract (what must stay) |
|---|---|---|
| Swamp scenery | `Workspace.Swamp.Art` | Nothing. Pure decoration. |
| Tow hitch + truck | `Plot.TowHitch` | Nothing. The `TowDropZone` marker is separate. |
| Muddy wreck in the swamp | `ServerStorage.Assets.WreckTemplates` | A Model with a PrimaryPart, named `Default`, or named after a rarity (e.g. `Legendary`) to give that rarity its own look. Parts with attribute `MudTint=true` take the rarity's mud colour. |
| Car in the wash bay | `Plot1.Garage.WashBay.Core` | Parts use attributes: `Paint` (takes the car colour), `MudFaces` (which faces get mud), `Detail` + `Look` (windows, lights, chrome). |
| HUD | Tow and upgrade HUDs are built in code by `TowController` and `UpgradeController` | Replace with designed ScreenGuis later; the server side does not change. |

## Not modular yet (known debt)
- ~~One live plot.~~ **Done 2026-11-21:** all 8 plots are live. Every Model in `Workspace.Plots` is a plot; copy one to add another. A plot needs `Garage.WashBay.Core`, showroom pads, and `Markers` with a `TowDropZone` and a `PlotSpawn` (tag `PlotSpawn`: where its owner spawns). No script uses a plot by name.
- **Server size.** The place allows 60 players but there are 8 plots. Player 9+ waits in a queue with no plot. Set max players to 8 in Game Settings.
- **One car shape.** Every wreck uses the same wash bay car, recoloured. Per-wreck models need a `CarTemplates` folder and a mud layout per model.
- **Mud is box-based.** Mud chunks are generated on box faces, so a Blender car needs simple hidden boxes with `MudFaces`, or a new mud method.

## Services (server)
| Service | Job |
|---|---|
| `WreckService` | Spawns wrecks on markers, rarity by depth, hidden roll at spawn, restock every 5 min |
| `TowService` | Hook, trail behind the player, slow by weight and tow gear, deliver at the drop zone |
| `WashService` | Empty bay until a wreck arrives. New players get the rigged first wreck. Up to 2 wrecks can queue. |
| `UpgradeService` | Buy 1 / Buy Max for any track in `UpgradeConfig` |
| `CashService` | Only place cash changes (`Add`, `Spend`) |
| `Util.Analytics` | Onboarding funnel (10 steps, once per player) and cash source/sink events |
| Existing | `DataService`, `PlotService`, `InventoryService`, `IndexService`, `ShowroomService`, `Util.SecurityHelper` |

## Security notes
- Rarity is public (mud colour is the hint). The wreck and mutation never leave the server until the reveal.
- Hooking checks range and tow gear on the server.
- Delivery is judged from the **player's** position and a minimum trip time, so teleporting home early does not deliver.
- The towed wreck is moved by the player's client for smoothness. It has no collisions and its position is never trusted.
- Speed hacks while towing are only limited by the trip-time check. A proper movement check is still to do.

## Playtest results (2026-11-21, simulated in Studio)
- New player: first wreck in the bay on join, washed, revealed Chrome Muscle Car.
- Zone gate: starter rope refused a Mangroves wreck; worked after buying the Chain.
- Tow: wreck trails ~10 studs behind. Uncommon wreck slows you to 11.2 (from 16); a heavy Epic to 7.6.
- Teleporting home was refused until the honest walking time had passed.
- Delivered wreck queued behind the first one, then loaded when the bay emptied.
- Keep put the car in the showroom at $50/s. Sell paid out.
- Dropping mid-tow leaves the wreck on the ground, hookable again.
- **Not tested:** a real human playing on a phone, two players at once, real saves.

## Still to decide
- [ ] Tow on foot or drive a truck?
- [ ] Can other players steal a wreck mid-tow?
- [ ] Is the first sale ($5,000+) too generous? It buys 2 upgrades at once.
