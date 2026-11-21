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
(Changed 2026-11-21 after feedback: the hook is thrown first, then dragged with WASD / arrows inside a radius.)

1. **Go to the truck.** A TOW TRUCK button (and a Tow Truck row in the Teleport window) sends you to the central tow truck.
2. **Cast.** Press CAST HOOK (or E). A power meter swings up and down and shows how far the throw will go.
3. **Throw.** Press THROW! (or Space / E). The hook is thrown straight out from the truck in an arc: more power, further out, up to your gear's reach. Your camera follows it. This is where the throw animation will go.
4. **Search.** When it lands, a big circle shows how far you can drag the hook from the landing point. Move it along the ground with **WASD, the arrow keys or the thumbstick**. Up on the screen is deeper into the swamp. You have 15 seconds.
5. **Hook it.** Put the hook on a muddy lump (its ring turns green and the lump lights up) and press HOOK IT (or Space / E). Pressing it on empty ground does nothing bad; you keep searching.
6. **Haul.** The winch drags the wreck back to the truck while your camera rides along. A strain bar shows how close the line is to breaking.
7. **Snap or deliver.** If the wreck is too heavy for your line, the line snaps part way, the wreck goes back, and the winch needs 4 seconds to wind in. Otherwise the wreck goes straight into your wash bay and you are sent there too.

## What tow gear does
| Tier | Reach | Zones | Search radius | Line holds weight up to | Throw speed | Reel speed |
|---|---|---|---|---|---|---|
| 1 Rope | 220 | 1 | 120 | 1.3 | 90 | 70 |
| 2 Chain | 660 | 1–3 | 135 | 1.6 | 120 | 110 |
| 3 Winch | 1100 | 1–5 | 150 | 1.9 | 150 | 160 |
| 4 Power Winch | 1540 | 1–7 | 170 | 2.3 | 185 | 220 |
| 5 Mega Hook | 2200 | 1–10 | 200 | never snaps | 220 | 300 |

The hook can never be dragged past the gear's reach, even if the circle sticks out past it.

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
| Feel | `TowConfig` | Power meter speed, throw arc, drag speed, search time, grab radius, cooldowns, snap timing, auto return. |

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
- The server decides where the throw lands (from the power, 0 to 1). The client drags the hook, so it feels instant, but the server only accepts a hook attempt inside the search radius of that landing point, inside the gear's reach, and reachable in the time since landing. A cheater can aim perfectly but cannot reach further or faster.
- Which wreck is hooked, whether the line snaps, and the delivery are all decided on the server.
- The player is anchored at the truck during a cast, and teleporting is refused until it ends.

## Tested (in a Studio playtest, 2026-11-21)
With simulated key presses:
- E started the power meter, Space threw the hook, and it landed where the meter said.
- Right arrow and W moved the hook right and deeper. A and Up arrow steered it onto a wreck: ring green, "HOOK IT!" shown.
- Space on empty ground: "Nothing here", cast carried on.

With exact positions sent to the server:
- Hook attempt while still in the air: ignored. Outside the search circle: refused.
- Hook on a wreck 71 studs from the landing point: hauled in and queued for the bay, camera restored.
- Snap (earlier, with the line temporarily weakened): strain bar hit "TOO HEAVY!", line snapped, wreck returned.

**Not tested:** a real person playing it, a thumbstick on a phone, two players casting at once.

## Known rough edges
- The wash HUD (CLEAN bar, HOLD TO SPRAY) still shows during a cast.
- Scenery far out loads as the hook flies; at high tiers the hook may outrun it.
- The per-tier truck swap hides the default truck's parts once; parts that load later are not hidden.
- `TowDropZone` markers in the plots are no longer used.

## Still to decide
- [ ] Should a snapped line cost anything beyond the wait (cash, a consumable line)?
- [ ] Should other players see your hook flying, not just the haul?
- [ ] Should deeper wrecks fight back (wiggle the strain bar, need taps to hold)?
