---
project: Wash a Wreck
status: first pass
created: 2026-11-21
tags: [roblox, wash-a-wreck, cars, models, art]
---

# Car Models

Built 2026-11-21. Every wreck now has its own model. Related: [[02 - Systems and Reskin Guide]], [[05 - Look and Feel (UI and Hub)]].

## What exists
32 models in `ReplicatedStorage.Assets.Cars`, one per wreck, named exactly like the wreck in `Shared.WreckData`.

| Rarity | Cars |
|---|---|
| Common (5) | Rusty Hatchback, Dented Pickup, Old Scooter, Shopping Trolley, Ice Cream Van |
| Uncommon (5) | Yellow Taxi, Farm Tractor, School Bus, Speedboat, Camper Van |
| Rare (7) | Muscle Car, Monster Truck, Fire Engine, Police Cruiser, Jet Ski, **Rally Car**, **Classic Roadster** |
| Epic (5) | Supercar, Army Tank, Helicopter, Race Car, **Drift Coupe** |
| Legendary (5) | Golden Limo, Submarine, Rocket Car, **Velocity Hypercar**, **Track Hypercar** |
| Mythic (3) | UFO, Mech Walker, **Electric Hypercar** |
| Secret (2) | **Midnight Phantom**, **Starfall Cruiser** |

Bold = new wrecks added with this pass (8). The other 24 kept their names, so saved inventories still work.

## Style
- **The 30 normal cars** are blocky, built from Roblox parts (boxes, ramps, cylinders), to match the hub's trucks. 20 to 86 parts each.
- **The hypercars** are original shapes that follow real car types (a luxury top-speed car, a track car, an electric flagship). No badges, names or signature styling from real brands.
- **The 2 secret cars** are deliberately different: smooth rounded shapes, glass and glowing materials, lights and sparkles. Midnight Phantom is a dark stealth hypercar with light along every edge. Starfall Cruiser is a floating crystal car on hover orbs.

## Why parts and not Blender meshes
Decided for the best result in this game: parts match the existing map art exactly, the paint can be recoloured for Chrome, Gold and Rainbow, and nothing needs uploading. Any model can still be swapped for a Blender mesh later; see the contract below.

## How the game uses them
- **Wash:** the muddy car in the bay is still the plain placeholder shape, so the wreck stays a mystery. At the reveal it is swapped for the real model (`WashService`, model named `RevealCar` in the bay).
- **Showroom:** kept cars are shown as their real model (`ShowroomService`).
- Both go through `Shared.CarModels` (`build`, `fit`). A wreck with no model falls back to the placeholder car.

## Secret rarity
- New top rarity `Secret` in `WreckData`: value 2,500,000, income 25,000 per second (placeholders).
- Only comes up in the 3 deepest zones: 0.3%, 0.6% and 1.5% of casts (`SwampConfig` `RarityWeights`).
- Added to `IndexConfig`, `IndexArt` and `RaceConfig` so those screens know the rarity.

## Model contract (for replacing a car)
- A Model in `ReplicatedStorage.Assets.Cars`, named exactly like the wreck.
- Front faces +X, wheels sit on Y = 0, pivot at the ground centre, parts anchored.
- Parts with attribute `Paint = true` take the mutation's colour and material. A Normal car stays as built.
- Size: about 12 to 16 studs long is ideal. Bigger cars are shrunk to fit the bay and the showroom turntable.

## The build tool
`ServerStorage._Tools.CarKit` is an edit-time helper for making blocky cars from a few numbers (`car`, `box`, `wedge`, `cyl`, `wheels`). Nothing in the game needs it. The finished models are ordinary models and can be edited by hand.

## Tested (Studio playtest)
- All 32 wrecks build a model with no errors.
- Washed the first wreck: the plain car was hidden and the Muscle Car model appeared at the reveal; the kept car showed on the showroom pad as the same model, shrunk to fit.
- **Not tested:** the Index and Garage screens with the new wrecks and the Secret rarity, the race feature with a Secret car, pulling a Secret from the swamp, a phone.

## Known gaps
- The Index and Garage pictures still use whatever they used before (not these models).
- The muddy car has one shape for every wreck (by design, for the mystery). Large wrecks like the Limo or Helicopter are shrunk at the reveal.
- A Chrome car takes a pale tint of its paint (a Chrome Muscle Car looks pink). That is the existing mutation setting (`TintAmount`), not the models.
- Blender mesh versions of the secret cars would look smoother still, but need upload permission set up in Studio.
