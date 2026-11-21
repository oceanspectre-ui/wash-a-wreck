---
project: Wash a Wreck
status: first playable, no animations
created: 2026-11-21
tags: [roblox, wash-a-wreck, tow, winch, systems]
---

# Tow System (Winch)

Built 2026-11-21. Replaces on-foot towing. Nobody walks a wreck home.

Related: [[00 - Wash a Wreck - Master Plan]], [[02 - Systems and Reskin Guide]].

## The loop
1. **Go to the truck.** A TOW TRUCK button (and a Tow Truck row in the Teleport window) sends you to the central tow truck.
2. **Cast.** Press CAST HOOK. Your camera leaves your character and follows the hook out over the swamp.
3. **Steer.** The normal move controls steer the hook: left/right to steer, forward to speed up, back to slow down. A ring on the ground shows where it will land. It turns green and the wreck lights up when you are over one.
4. **Drop.** Press DROP HOOK (or Space / E / A on a controller). The nearest wreck within 16 studs is hooked. Nothing there = a miss and a short wait.
5. **Haul.** The winch drags the wreck back to the truck while your camera rides along. A strain bar shows how close the line is to breaking.
6. **Snap or deliver.** If the wreck is too heavy for your line, the line snaps part way, the wreck goes back, and the winch needs 4 seconds to wind in. Otherwise the wreck goes straight into your wash bay and you are sent there too.

## What tow gear does
| Tier | Reach | Zones | Line holds weight up to | Hook speed | Reel speed |
|---|---|---|---|---|---|
| 1 Rope | 220 | 1 | 1.3 | 90 | 70 |
| 2 Chain | 660 | 1–3 | 1.6 | 120 | 110 |
| 3 Winch | 1100 | 1–5 | 1.9 | 150 | 160 |
| 4 Power Winch | 1540 | 1–7 | 2.3 | 185 | 220 |
| 5 Mega Hook | 2200 | 1–10 | never snaps | 220 | 300 |

All placeholders, in `UpgradeConfig.Tracks.TowGear`. Wreck weights are in `WreckData` (0.4 Shopping Trolley to 2.5 Mech Walker).

## How players read the risk
- **Mud color** = rarity (as before).
- **Lump size** = weight. Heavier wrecks are bigger lumps, so a big lump on a weak line is a gamble.
- The wreck itself stays hidden until the wash.

With the Rope in zone 1: every Common hauls fine. The 3 heaviest Uncommons (Farm Tractor, School Bus, Camper Van) snap the line. That is about 1 cast in 7, and it teaches the upgrade.

## Key design choices
- **Skill is aiming, not walking.** You choose which lump to go for and steer onto it.
- **One truck, many players.** Everyone can cast at once. Each player has their own hook. Two players cannot hook the same wreck.
- **Bay queue.** You can cast while a wreck is in your bay; up to 2 more wait in line. If the haul queues, you stay at the truck for another cast.
- **Auto return.** A haul that goes straight into your bay sends you to your bay (`TowConfig.AutoReturnToBay`).

## What is replaceable
| Thing | Where | Contract |
|---|---|---|
| Truck art | Model tagged `TowTruckModel` | Nothing. |
| Per-tier truck | `ReplicatedStorage.Assets.TowTrucks.Tier1`–`Tier5` | Optional Model. If present, a player with that tier sees it in place of the default truck. Other players see their own tier. |
| Hook | `ReplicatedStorage.Assets.Hooks.Tier1`–`Tier5` or `Default` | Optional Model or Part. Empty = a yellow ball. |
| Muddy lump | `ServerStorage.Assets.WreckTemplates` | As before. It is scaled by weight automatically. |
| HUD | ScreenGui tagged `TowHud` (default `StarterGui.TowGui`) | Found by name, all optional: `GoTruckButton`, `BackToBayButton`, `CastButton`, `DropButton`, `CancelButton`, `Toast`, `Hint`, `ZoneLabel`, `ReachBar` (with `Fill`, `Label`), `StrainBar` (with `Fill`, `Label`). |
| Markers | `Workspace.TowMarkers` | `TowStation` (stand inside to cast), `HookLaunch` (hook leaves here), `TowReelEnd` (wrecks arrive here), `TowStationSpawn` (teleport spot). Move them to fit new truck art. |
| Feel | `TowConfig` | Steering speed, cruise height, grab radius, cooldowns, snap timing, auto return. |

## Where animations will plug in
There are none yet: the hook and wreck slide. The client gets a `TowState` event at each moment, which is where animations and sounds attach:

| Event | Moment |
|---|---|
| `Cast` | Hook launches from the truck |
| `Hooked` | Hook lands on a wreck, haul starts (includes line strain) |
| `Snapped` | Line breaks |
| `Delivered` | Wreck reaches the truck |
| `Missed` | Hook landed on nothing |
| `Ended` | Cast cancelled |

## Security
- The client flies the hook, so steering feels instant. The server only accepts the drop point if it is within the gear's reach and could have been reached in the time since the cast. A cheater can aim perfectly but cannot reach further or faster.
- Which wreck is hooked, whether the line snaps, and the delivery are all decided on the server.
- The player is anchored at the truck during a cast, and teleporting is refused until it ends.

## Tested (simulated in Studio, 2026-11-21)
- Cast, hook camera, reach bar, miss, cancel, cooldown message.
- Drop past the Rope's reach: refused. Drop at 210 studs after 0.3 seconds: refused.
- Haul of a light wreck: delivered into the bay, player sent to the bay, camera restored.
- Snap (with the line temporarily weakened): strain bar hit "TOO HEAVY!", line snapped, wreck returned.
- **Not tested:** a real person steering with a thumbstick or keys, a phone, two players casting at once.

## Known rough edges
- The wash HUD (CLEAN bar, HOLD TO SPRAY) still shows during a cast.
- Scenery far out loads as the hook flies; at high tiers the hook may outrun it.
- The per-tier truck swap hides the default truck's parts once; parts that load later are not hidden.
- `TowDropZone` markers in the plots are no longer used.

## Still to decide
- [ ] Should a snapped line cost anything beyond the wait (cash, a consumable line)?
- [ ] Should other players see your hook flying, not just the haul?
- [ ] Should deeper wrecks fight back (wiggle the strain bar, need taps to hold)?
