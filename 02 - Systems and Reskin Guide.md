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
| `WreckSpawn` | 140 parts in `Swamp.Gameplay.WreckSpawns` | A wreck can appear here. Its zone comes from how deep it is. Its height does not matter: wrecks sit on the terrain below it. Add more by tagging any part. |
| `TowDropZone` | 1 box in each plot | The owner standing inside it while towing delivers the wreck. |
| `PlotSpawn` | 1 part in each plot | Where the plot's owner spawns. Keep it within about 15 studs of the wash bay car so a new player can spray at once. |
| `SafeZone` | 10 boxes in `Swamp.Gameplay.SafeZones` | Reserved for the chaser (not built yet). |

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
- ~~One live plot.~~ **Done 2026-11-21:** every Model in `Workspace.Plots` is a live plot (6 on the current map); copy one to add another. A plot needs `Garage.WashBay.Core`, showroom pads, a `TowDropZone` and a `PlotSpawn`. No script uses a plot by name.
- **Server size.** The place allows 60 players but there are 6 plots. Player 7+ waits in a queue with no plot. Set max players to 6 in Game Settings.
- **Central tow truck not wired.** `Workspace.Map.TowTruck` has a `HookLaunchPoint` and `HookCorridor`, but towing is still on foot. Decided design, not built: throw the hook from the truck, the winch reels the wreck in, and it goes straight to your bay. Tow gear sets how far you can throw.
- **Teleport window has 3 swamp rows.** The server accepts `Swamp1`–`Swamp10`; add a row named `Swamp7` to the Teleport window to offer it.
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

## Codes (added 2026-11-21)
Players type a code and get a reward. Each player can use each code once.

| Piece | Where | What to change |
|---|---|---|
| The codes | `ServerScriptService.Config.Codes` | Add a row per code: rewards, optional `Enabled = false`, optional `Expires`. Server only, so players can't read the list. The 3 codes in there (`RELEASE`, `SWAMP`, `CHROME`) are placeholders. |
| Reward types | `ServerScriptService.Util.Rewards` | `Cash` and `Wreck` exist. Add a handler to add a type. Reusable for daily rewards, quests and events. |
| Logic | `Services.CodeService` | Checks the code, marks it used in the player's save, gives the rewards. |
| Window | `StarterGui.CodesGui` (greybox) | Replace freely. `CodesController` finds things by tag and name, not layout. |

**GUI contract** (what a replacement window needs):
- Any button tagged `CodesOpen` opens and closes the window. It can be in any ScreenGui.
- One frame tagged `CodesWindow` is the window.
- Inside it, by name: `CodeBox` (TextBox), `RedeemButton` (button), `Status` (TextLabel, optional), `Close` (button, optional), `FitScale` (UIScale, optional).

Notes:
- Codes are not case sensitive and spaces are ignored.
- A wrong code and a switched-off code give the same message, and there is a 1.5 second wait between tries, to slow guessing.
- New or changed codes go live when the game is published and servers restart. There is no server-wide "first 100 players" limit yet.

Also changed: `Main` and `ClientMain` now skip a module that fails to load and print a warning, so one broken script can't stop the others.

## Maintenance pass on the new map (2026-11-21)
Fixed:
- Wrecks now sit on the terrain (sunk 1 stud) instead of at the marker's height, which had left many buried.
- 2 spawn markers moved out of solid props.
- Plot spawns moved from 26 to 15 studs from the car. From 26, the far side of the car was out of spray range, so a new player's first sprays did nothing.
- Wash bays stream to a client as one piece, so the wash HUD never binds to a half-loaded car.
- Teleporting is refused while towing (it skipped the walk home).
- Zone lighting follows `SwampConfig` instead of a hard-coded zone width.
- Teleport accepts any zone number from `SwampConfig`.

Checked and fine: every remote goes through `SecurityHelper`; no script uses a plot by name; no unanchored parts; full loop (wash, keep, sell, upgrade, teleport, hook, deliver) ran with no errors.

Left alone: `ServerStorage._OldGuiBackup` (old UI scripts) and `ServerStorage._MapBuilder` (the map generator). Neither runs in the game.

## Still to decide
- [ ] Tow on foot or drive a truck?
- [ ] Can other players steal a wreck mid-tow?
- [ ] Is the first sale ($5,000+) too generous? It buys 2 upgrades at once.
