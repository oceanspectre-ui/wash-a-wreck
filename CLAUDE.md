# CLAUDE.md — Wash a Wreck

You are the co-developer and Luau expert on **Wash a Wreck**, a Roblox game. Goal: first 1K CCU. Keep scope small and ship fast.

## Read first
The design lives in this repo. Before building a system, read the relevant note.
- Master plan: `00 - Wash a Wreck - Master Plan.md`
- Research (kept in the project owner's Obsidian vault, not in this repo): `Roblox Game Dev Research/`
  - `Roblox Studio Dev Methods & Tools/` (architecture, performance, security, analytics)
  - `Tizzy Video Success/` and `Taptify Video Success/` (design and monetization lessons)

If the plan and this file disagree, ask before building.

## The game in one line
Tow a mystery wreck out of the swamp, get it home before something takes it off you, then wash it to find out what you got.

Loop: scout → tow → survive the chaser → wash (the reveal) → sell or park in showroom for income → upgrade → go deeper.

## Design rules
- A new player is washing within 10 seconds of joining.
- Solo first: the full loop must work on an empty server. PvP is optional spice.
- The wash is the reveal. Build suspense; never skip it.
- One simple mechanic with depth. If a feature needs a text tutorial, simplify it.
- Mobile first: everything works with one thumb.
- Every player action gets feedback: sound, VFX, a pop or floating number.

## Current build order
Work in this order. Finish and test each before the next.
1. Wash mechanic on grey boxes (kill switch: if spraying is not fun, stop and report)
2. Wreck data module (`ReplicatedStorage/Shared/WreckData`)
3. Player data with ProfileStore
4. Wreck spawner (restock every 5 min)
5. Towing
6. Showroom, income, offline earnings
7. Upgrades (Buy 1 / Buy Max)
Also: security helper and analytics wrapper as soon as remotes or funnel steps exist.

**Do not build yet:** stealing, zones, the chaser, dusty showroom, shop and dev products. These wait on open design decisions.

## Architecture
```
ServerScriptService/Services/   -- one ModuleScript per service, Init() then Start()
ServerScriptService/Main.server.luau
ServerScriptService/Packages/   -- server-only third-party modules (ProfileStore)
ServerStorage/                  -- server-only assets and templates
ReplicatedStorage/Shared/       -- data tables, types, constants, pure logic
ReplicatedStorage/Packages/     -- third-party modules
StarterPlayerScripts/Controllers/ -- one ModuleScript per client controller
StarterGui/
```
Services: DataService, WreckService, TowService, WashService, ShowroomService, UpgradeService, AnalyticsWrapper. Later: StealService, ChaserService, ShopService.

## Code rules
- Luau with `--!strict` where practical. Type the public functions.
- **The server owns all state.** Cash, gear, showroom, index and rolls change only on the server. The client sends intent ("I sprayed chunk 12"), never results.
- **Wreck rarity and mutation are rolled on the server at spawn and kept hidden.** Send the clean model to clients only at the reveal.
- **Every RemoteEvent/Function goes through the security helper:** type-check every argument, rate-limit per player, check range/ownership. Reject silently, log suspicious traffic.
- All balance numbers live in data modules (later ConfigService), never hard-coded in logic.
- Save data with ProfileStore only. Handle player leave and server shutdown.
- Clean up connections (Janitor/Trove pattern). Remove players from tables on PlayerRemoving.
- No per-frame heavy work on RunService events. Throttle remotes; never fire every frame.
- Workspace.StreamingEnabled is on. Client code must wait for instances with timeouts.
- Avatars are R15 only.
- Never insert free models or plugins. If an asset is needed, use a placeholder part and note it.

## Working style
- One system per task. Keep changes small.
- After a change, start a playtest and read the console output. Fix errors before moving on.
- Explain any risk you see (exploits, memory leaks, DataStore limits) before I accept code.
- When a system is done, summarise what was built and anything left to decide, so it can be added to the vault.
