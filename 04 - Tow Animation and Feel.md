---
project: Wash a Wreck
status: first pass, placeholder sounds
created: 2026-11-21
tags: [roblox, wash-a-wreck, animation, game-feel, vfx]
---

# Tow Animation and Feel

Built 2026-11-21 on top of [[03 - Tow System (Winch)]]. Looks and sound only: nothing here changes what happens in the game.

## How it is animated (and why not the Animation Editor)
The Animation Editor plays keyframed clips on **rigged** models (parts joined by Motor6Ds, like a character). The tow truck is 155 loose anchored parts, and the hook, rope and wrecks are plain parts too, so there is nothing for a clip to drive.

They are animated **in code** instead, with springs and easing. For props this is the better tool anyway: the motion reacts to how much power you used, where the hook is and how heavy the wreck is, and every number can be tuned without re-keying.

When rigged models arrive from Blender, keyframed clips can replace any of these. The moments below are the hook points.

## The rules it follows
| Rule | Where you see it |
|---|---|
| **Anticipation** (wind up before the action) | The boom leans back as power builds. The wreck strains before it pops free. |
| **Overshoot and settle** | The boom whips past its rest position, then settles. The hook squashes and bounces. The search circle sweeps out past its size and back. |
| **Follow-through** | The rope sags and catches up. The camera drifts in behind the hook instead of snapping. |
| **Ease in and out** | The throw leaves fast and hangs before landing. The haul eases out of the mud and eases in to the truck. |
| **One beat each** | Every moment gets a sound, a small burst and a small camera nudge. |
| **Child friendly** | Bright colors, bouncy motion, soft mud puffs, sparkles. Shakes are small and die away fast. Nothing breaks, bleeds or flashes hard. |

## Every moment
| Moment | Truck | Hook and rope | Camera | Extras |
|---|---|---|---|---|
| **Charge** (power meter) | Boom leans back up to 15°, truck shivers more at high power | — | Moves to a shoulder view of the truck over the swamp, zooms in slightly | Ratchet ticks that rise in pitch |
| **Throw** | Boom whips forward past rest and settles, truck is shoved back and rocks, its own hook disappears, beacons flash | Hook pops big then settles, spins, rope pays out in a sagging arc | Quick widen, small kick | Whoosh |
| **Land** | — | Hook squashes, bounces twice, rope tightens | Small thud | Mud splash, the search circle sweeps out |
| **Search** | Beacons keep flashing | Hook tips toward where you drag it, bobs, kicks up a mud trail, rope ripples | Looks down from behind | Small ring gently pulses |
| **Found a wreck** | — | — | — | Ring pops and turns green, ding, wreck lights up |
| **Hook on nothing** | — | — | Tiny shake | Ring dips, soft click |
| **Hooked** | — | Tow line appears | Punch | Clank |
| **Strain** (0.55 s) | — | Wreck shudders harder and harder | — | Strain bar holds, then climbs |
| **Pop free** | — | Wreck lurches out | Shake | Mud burst, plop |
| **Haul** | — | Wreck rocks side to side, bumps, nose up, throws mud. Speeds up, then slows into the truck | Rides with the wreck, rumbles as strain rises | Tow line reddens and shivers near its limit |
| **Snap** | — | Wreck slides back into its hole (0.9 s) | Biggest shake, holds on the wreck for a beat | White sparks, snap sound |
| **Delivered** | — | — | Small bump, holds on the truck for a beat | Gold sparkle burst, fanfare |
| **Miss / time up / cancel** | — | Hook zips back to the truck in a small arc | Follows it home | Swish |
| **End** | Hook back on the boom, beacons off, every part back exactly where the art had it | — | Glides back to the player (0.55 s) instead of cutting | — |

HUD: buttons and messages pop slightly when pressed or shown. The wash HUD hides while the hook is out.

## Mini cutscenes (added 2026-11-21)
Short designed camera shots on the throw, the reel-in and the snap. They are kept short because a player sees them on every cast.

| Shot | What the camera does | Length |
|---|---|---|
| **Charge** | Sits low behind the truck, looking up past the boom at the swamp | While the meter swings |
| **Throw** | Stays behind the truck for 0.32 s to watch the boom whip, then chases the hook out and rises and tilts down onto the landing | The flight: 0.7–2.6 s |
| **Bite** | Cuts to a close, low shot of the wreck while the line goes tight and it strains | About 0.75 s |
| **Ride** | Pulls wide and rides alongside the wreck as it bursts free and is dragged | Until it nears the truck |
| **Arrive** | Cuts to beside the truck to watch the wreck come in, then the sparkle burst | Last 80 studs |
| **Snap** | Instead of Arrive: pushes in on the wreck as the line turns red, then kicks back out when it breaks | About 1–2 s |

A zone 1 reel-in is about 3 seconds in total; deeper hauls are longer because the ride is longer.

Every shot is one row in `TowFxConfig.Shots` with its distances and timings. Set `Enabled = false` on any row to switch that shot off; the camera then just follows from behind. The shot code is in `TowFx` (`ChargeShot`, `ThrowShot`, `ReelShot`).

Tested in a playtest by sampling the camera: the throw went from a low look-up (11° up) to a 46° look-down over the landing; the reel-in cut to 17 studs from the wreck, pulled out to 34, then cut to the truck's side; on a snap the view zoomed from 70 to 54 and kicked back out. Not judged by eye in motion yet.

## Where things are
| Piece | Where | What to change |
|---|---|---|
| All numbers, colors, sounds | `ReplicatedStorage.Shared.TowFxConfig` | Angles, spring stiffness, bounce height, shake sizes, particle counts, sound ids. |
| The effects code | `StarterPlayerScripts.Fx.TowFx` | One function per moment. |
| Haul motion (seen by everyone) | `TowConfig` (`Haul...`, `SnapReturnSeconds`) and `TowService` | Strain time, rocking, bumping. |

## Making new truck art animate
Tag its parts (tags only, no renaming):
- `TowBoom`: parts that swing on a cast.
- `TowHookRest`: the hook hanging on the truck (hidden while the hook is out).
- `TowBeacon`: lights that flash during a cast.
- Move the `TowBoomHinge` marker (in `Workspace.TowMarkers`) to the boom's pivot. Its red axis is the swing axis.

No tags = the whole truck still recoils and rocks. Per-tier truck models use the same tags.

## Sounds are placeholders
They are sounds that ship with Roblox, picked to be roughly right. Each is one line in `TowFxConfig.Sounds`. Real picks are still needed for: ratchet, whoosh, splash, ding, clank, plop, snap, fanfare.

## Tested (Studio playtest, 2026-11-21)
- Charge: boom tip rose from 20.1 to 24.8 studs with power, truck shivered, view zoomed in.
- Throw: boom overshot to 17.1 then 22.3 and settled at exactly 20.1. Truck was 0.5 studs back when sampled just after the throw, and returned exactly. Hook scaled 2.9–4.5 (base 4). Rope sagged up to 12 studs.
- Snap: wreck strained, popped free, accelerated, line broke, wreck slid back and was hookable again.
- Haul: speed went 0, 8, 48, 72, 90, 84, 61, 29 studs/s (eases out and in), rocked 7°, sparkle burst at the truck, camera held then glided home.
- All 10 sounds load. No script errors.
- **Not tested:** how it feels in a real hand, on a phone, or with two players.

## Limits
- Only the player casting sees the truck animate and the hook fly. Everyone sees the haul.
- No character animation: the camera leaves the player during a cast. A "pull the lever" animation could be added for the charge.
- Parts of the truck that load in after the animation starts are not animated.
