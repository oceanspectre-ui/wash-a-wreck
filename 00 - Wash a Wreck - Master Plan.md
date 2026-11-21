---
project: Wash a Wreck
status: planning
version: 0.1
created: 2026-11-14
goal: 1K CCU
tags: [roblox, wash-a-wreck, gdd, plan]
---

# Wash a Wreck — Master Plan (v0.1)

> **Pitch:** Tow a mystery wreck out of the swamp, get it home before something takes it off you, then wash it to find out what you got.
>
> **Goal:** first 1K CCU. **Constraint:** small scope, fast to market.
> All numbers in this note are **placeholders to balance later**, not final.

Research this plan is built on:
- [[00 - Tizzy Video Successful (MASTER SUMMARY)]]
- [[00 - Taptify Video Successful (MASTER SUMMARY)]]
- [[00 - Dev Methods & Tools (MASTER SUMMARY)]]
- [[02 - Roblox Game Design Explained Like You're 5]] (building-block framework)
- [[09 - Step-by-Step Build Plan (Idea to 1K CCU)]]

---

## 1. Why this idea (evidence so far)
- **Washing has demand, weak retention.** Pressure Wash Simulator: 141M visits, ~1 player now. Wash The Plane: 4K peak in Oct 2026, ~119 now. People come, finish the content, leave. No collection, no RNG.
- **Flipping has demand, more competition.** Fix It Up! (car flipping) ~2.7K playing at last tracker update; Car Flipper, Junk Mechanics, Mechanic Legends also exist, and they lean technical.
- **Our gap:** wash-first, simple, mystery reveal + collection + a steal-game skeleton. None of the games found combine these.
- **Not yet done:** we have not played the competitors. See Phase 0.

## 2. Design pillars
1. **The title in 10 seconds.** A new player is washing a wreck within 10 seconds of joining.
2. **Solo first.** The whole loop works on an empty server. Other players are spice, never required.
3. **The wash is the hatch.** The reveal is the reward. Build suspense, never skip it.
4. **Simple scales.** One mechanic (spray), lots of depth (rarity, mutations, flip-or-keep).
5. **Mobile first.** Every action works with one thumb.

## 3. Building blocks (Tizzy framework)
| Block           | Wash a Wreck                                                                                |
| --------------- | ------------------------------------------------------------------------------------------- |
| Fantasy         | Find treasure under the mud                                                                 |
| Unique mechanic | Hands-on washing as the reveal                                                              |
| Core loop       | Leave garage → tow wreck → wash → flip or keep                                              |
| RNG             | Mud colour hints rarity (pre-acquisition). Wash reveals model + mutation (post-acquisition) |
| Level design    | One linear swamp lane, 3 zones, safe docks along the way                                    |
| Tension         | PvE gator chases anyone towing. Optional PvP showroom steals                                |
| Progression     | Stronger washer, better tow gear, more showroom slots                                       |
| Collection      | Wreck Index with mutations                                                                  |
|                 |                                                                                             |

## 4. Core loop in detail
1. **Scout** — Walk the swamp lane. Wrecks surface every 5 min. Rare spawns are announced server-wide.
2. **Tow** — Hook a wreck. It attaches to you and slows you (heavier = slower). No vehicle physics.
3. **Survive** — Gator hunts towing players. Docks are safe spots (tension, release, tension).
4. **Wash** — At your garage, spray off 20–40 mud chunks. Rising-pitch sounds per chunk. Last chunk triggers the reveal.
5. **Flip or keep** — Sell for a lump sum, or park in the showroom for cash per second.
6. **Upgrade** — Washer, tow gear, slots. Go deeper for rarer wrecks.

## 5. First 90 seconds
| Time | What happens |
|---|---|
| 0–5s | Short cutscene: crane drops a muddy wreck at your garage |
| 5–25s | "Hold to spray." Player washes it. No other UI on screen |
| 25–35s | **First wow:** rigged reveal of something cool (e.g. Chrome Muscle Car) |
| 35–50s | Park it. Cash starts ticking up with a sound |
| 50–90s | Arrow to Zone 1. Tow a second wreck home (gator is slow here) |
| Later | Contextual tutorials only: shutter lock when another player first comes near, shop when first unaffordable upgrade, index after 3rd wreck |

Rules: one mechanic at a time, no text walls, auto-equip everything, starter washer already in hand.

## 6. Systems

### 6.1 Wrecks (starter list, original names, no real brands)
| Rarity | Mud colour | Wrecks |
|---|---|---|
| Common | Brown | Rusty Hatchback, Dented Pickup, Old Scooter, Shopping Trolley, Ice Cream Van |
| Uncommon | Mossy green | Yellow Taxi, Farm Tractor, School Bus, Speedboat, Camper Van |
| Rare | Dark blue | Muscle Car, Monster Truck, Fire Engine, Police Cruiser, Jet Ski |
| Epic | Purple | Supercar, Army Tank, Helicopter, Race Car |
| Legendary | Glowing orange | Golden Limo, Submarine, Rocket Car |
| Mythic | Glowing white | UFO, Mech Walker |

24 wrecks at launch. Each needs: sell value, income per second, weight, mud chunk count.

### 6.2 Mutations (material swaps, cheap content)
| Mutation | Value multiplier | Odds (placeholder) |
|---|---|---|
| Normal | x1 | 85% |
| Chrome | x2 | 10% |
| Gold | x5 | 4% |
| Rainbow | x10 | 1% |

24 wrecks x 4 mutations = 96 index entries.

### 6.3 Zones
| Zone | Wrecks | Gator | Gate |
|---|---|---|---|
| 1 Shallows | Common, Uncommon | Slow | Open |
| 2 Mangroves | Up to Epic | Medium | Tow gear tier 2 |
| 3 Deep Swamp | Up to Mythic | Fast | Tow gear tier 4 |

### 6.4 Gear
- **Washers (5 tiers):** Garden Hose → Pressure Washer → Turbo Jet → Foam Cannon → Hydro Blaster. Each widens the spray and removes chunks faster.
- **Tow gear (5 tiers):** Rope → Chain → Winch → Power Winch → Mega Hook. Each cuts the slowdown and unlocks zones.
- **Showroom slots:** start 4, upgrade to ~12.
- Upgrade board uses **Buy 1 / Buy Max**.

### 6.5 Stealing rules (solo-safe)
- Only **showroom** vehicles can be stolen, and only while the shutter is up.
- **Shutter lock:** free, ~60s locked, on a cooldown.
- **New player shield:** 10 minutes, cannot be stolen from.
- Thief tows the car slowly. Owner gets an alert. Hit the thief → thief is flung, car snaps back.
- **Private servers free.**
- Unwashed wrecks in transit can be knocked loose by the gator, not by players (v1).

### 6.6 Open idea (undecided)
- **Dusty showroom:** cars get dusty over ~24h; a quick rewash gives x2 income. Daily return hook, but may feel like a chore. Test before committing.

## 7. Economy (placeholder shape)
- Common sells ~100 cash, earns ~1/s. Each rarity roughly x5 value of the one below.
- First washer upgrade affordable inside 2 minutes. First zone unlock inside ~10 minutes.
- Early game fast, mid game slower (Taptify). No progression wall in the first 10 minutes (Tizzy's Raise an Anomaly mistake).
- All values live in one data module and in **Configs**, so they can be tuned live.
- **Never sell cash packs.**

## 8. Monetization
| Product | Type | Price (placeholder) | Pain it solves |
|---|---|---|---|
| Washer power +1 (stacking tiers) | Dev product | 5, 9, 19, 39... | Washing is slow |
| Instant Wash | Consumable | 15 | Waiting on a big wreck |
| 24h Shutter Lock | Consumable | 49 | Getting robbed while away |
| Luck Boost 30 min | Consumable | 29 | Only finding commons |
| 2x Offline Earnings | Consumable | 19 | Missing out on gains |
| Starter Pack (72h) | One-time | 27 | First purchase nudge |
| Extra showroom slots | Game pass | 99–199 | Out of space |
| VIP (2x cash, tag) | Game pass | 299 | General |
| Limited wrecks (real stock) | Dev product | 499–999 | Flex |

- Three purchase pathways: shop button, "+" by the cash counter, and the "can't afford" prompt on the 3rd failed attempt.
- Physical buy pads near the garage entrance (foot traffic).
- **R15 only** from day one (18+ US DevEx rate).
- Check Roblox paid random item rules before selling anything luck-based.

## 9. UI screens (Figma list)
- [ ] HUD: cash counter with "+", Shop, Index, Upgrades, Settings
- [ ] Wash HUD: clean % bar, combo counter
- [ ] Reveal card: rarity, mutation, value
- [ ] Sell or Keep popup
- [ ] Upgrade board (Buy 1 / Buy Max)
- [ ] Shop
- [ ] Wreck Index (silhouettes for undiscovered)
- [ ] Rare spawn banner
- [ ] Steal alert + shutter button with cooldown
- [ ] Offline earnings popup (with 2x prompt)
- [ ] Starter pack popup
- [ ] Tutorial arrows and rings

Style: chunky garage look, big buttons, icons over text, phone layout first.

## 10. Assets (AI + Blender list)
- [ ] 24 wreck models, low-poly, one texture atlas each (target under ~2K tris, to confirm on a phone)
- [ ] Mud chunk set (reusable, 3–4 shapes, 6 colours)
- [ ] Garage + showroom plot (open front so others can see in)
- [ ] Swamp lane: 3 zones, docks, props (reuse heavily for low draw calls)
- [ ] Gator (one model, simple chase animation)
- [ ] 5 washers, 5 tow hooks
- [ ] VFX: water spray, mud splat, sparkle reveal
- [ ] SFX: spray, chunk pops (pitch-shifted), reveal sting, cash tick. Hand-picked, not AI.

## 11. Tech plan
**Structure:** Services on the server, Controllers on the client, shared data modules. See [[03 - Game Architecture & Core Libraries]].

| Service | Job |
|---|---|
| DataService | ProfileStore saves (cash, gear, showroom, index) |
| WreckService | Spawns, restock timer, hidden rarity rolls |
| TowService | Attach/detach, speed penalty |
| WashService | Chunk removal, reveal |
| ShowroomService | Slots, income, offline earnings |
| StealService | Shutter, shield, steal and recover |
| GatorService | Chase AI |
| ShopService | Receipts, passes, consumables |
| AnalyticsService wrapper | Funnels, economy events |

**Key technical decisions**
- **Reveal is rolled on the server when the wreck spawns and kept hidden.** The clean model is only sent to clients at reveal, so exploiters cannot read it early.
- **Mud chunks:** client shows the spray instantly; server validates each chunk (distance, rate, tool power) and owns the count.
- **Towing:** weld + walk speed change. No vehicle physics in v1.
- **Every remote** type-checked and rate-limited. Cash only changes on the server.
- **StreamingEnabled on.** Showroom slot cap keeps instance counts down.
- Balance values in Configs for live tuning.

## 12. Analytics (wire in before launch)
**Onboarding funnel:** Joined → Cutscene done → First spray → First wreck revealed → First car parked → Entered Zone 1 → First tow home → Second wash → First upgrade → 5 minutes played.
**Progression funnel:** Washer tier 2, 3... / Zone 2 unlocked / Zone 3 unlocked / 10 index entries / first Legendary.
**Shop funnel:** Shop opened → Product viewed → Prompt shown → Purchased.
**Economy events:** every cash source and sink.
**Custom field:** device type.

## 13. Roadmap
Time estimates are rough guesses.

### Phase 0 — Validate (2–3 days)
- [ ] Play Wash The Plane, Pressure Wash Simulator 2, Fix It Up!, Car Flipper for 1–2 hours each. Note where each is weak.
- [ ] Play Steal a Brainrot / Steal an Egg on a fresh alt. Log the first 10 minutes with timestamps.
- [ ] Keyword check on Creator Exchange: "wash", "wreck", "car". Confirm the title isn't taken.
- [ ] Decide the open questions in section 15.

### Phase 1 — Greybox prototype (week 1)
- [ ] Studio MCP + Claude Code connected, Script Sync, Git repo, CLAUDE.md
- [ ] Grey-box garage, lane, one wreck
- [ ] Wash mechanic feeling good with placeholder cubes. **If spraying isn't fun here, stop and rethink.**
- [ ] Tow + sell + park working

### Phase 2 — Core systems (week 2)
- [ ] ProfileStore data, wreck spawns and restock, rarity and mutations
- [ ] Upgrades, zones, gator
- [ ] Stealing, shutter, shield
- [ ] Analytics funnels

### Phase 3 — Art and UI (week 3)
- [ ] Figma screens → Studio
- [ ] Wreck models through the Blender pipeline
- [ ] SFX and VFX pass
- [ ] Onboarding cutscene and first 90 seconds

### Phase 4 — Test and polish (week 4)
- [ ] Fresh alt playthrough with timestamp log
- [ ] 2–3 paid testers, 3 hour logs
- [ ] Cheap phone performance check, controller check
- [ ] Security pass on remotes
- [ ] Shop, receipts, starter pack

### Phase 5 — Launch (week 5)
- [ ] 20–50 thumbnails, icon, gameplay video on the page
- [ ] Ads at ~$16/day. Budget ~$150–250 to clear the 500 engaged player gate.
- [ ] Discord with bug and feedback channels
- [ ] Daily patches, fix the biggest funnel leak first

## 14. Risks
| Risk | Plan |
|---|---|
| Washing gets boring | Prototype the spray feel first (Phase 1 kill switch) |
| Sims die within a month | Accept for first game; weekly wreck drops are cheap content |
| Stealing drives solo players away | Shield, shutter, free private servers; test numbers early |
| "Steal a" niche is flooded | Lead with washing in title, thumbnail and first 10 seconds |
| Competitors we haven't played are better than expected | Phase 0 before any building |
| Scope creep | No vehicle physics, no trading, no building in v1 |

## 15. Open decisions
- [ ] Dusty showroom mechanic: in or out?
- [ ] Art style: chunky cartoon vs semi-real?
- [ ] Swamp theme or junkyard theme for the lane?
- [ ] Can unwashed wrecks be stolen in transit by players (more chaos) or only by the gator (safer)?
- [ ] Solo dev, or bring in a builder/modeller?
- [ ] Ad budget available?

## 16. Notes to create next
- Wreck Table (full stats)
- Economy and Balance
- First 90 Seconds (storyboard)
- UI Screens (Figma links)
- Asset List (status tracker)
- Systems Library (reusable code notes)
- Changelog
