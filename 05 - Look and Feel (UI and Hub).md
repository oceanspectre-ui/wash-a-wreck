---
project: Wash a Wreck
status: first pass
created: 2026-11-21
tags: [roblox, wash-a-wreck, ui, style, lighting]
---

# Look and Feel (UI and Hub)

Set 2026-11-21 from a reference the owner shared: a bright, candy-coloured simulator look. We follow the **style** (bold, colourful, chunky), with our own content, colours and layout.

Related: [[02 - Systems and Reskin Guide]], [[04 - Tow Animation and Feel]].

## The house style
| Element | Rule |
|---|---|
| Outlines | Thick, near-black (`12,14,20` to `22,26,34`), 3–4.5 px on every button, card and bar. |
| Text | Fredoka One, white, with a thick dark outline. Key words in bright green or yellow. |
| Buttons | Vertical gradient (light on top), dark border, a pale "gloss" strip across the top third, 6–8 px corners. |
| Cards | Diagonal two-colour gradient, saturated. A sunburst of pale rays behind a round coin badge that holds the picture. |
| Section titles | `~Title~`, in a gradient that matches the section. |
| Buy buttons | Wide, green, Robux mark and price. Purple square gift button beside it. |
| Tags | Small tilted yellow label on a card: "BEST SELLER!", "BEST DEAL!". |
| Colour pairs | Cyan to blue, yellow to orange, pink to purple, orange to red, lime to green. |

## Stud pattern (added 2026-11-21)
Every main UI surface has a light stud pattern over it: window panels and headers, shop and index cards, and the big buttons.

- **The image** is Roblox's own classic stud tile, `rbxasset://textures/ui/Studs.png`. Nothing was uploaded.
- **One setting changes it everywhere:** `StudImage` in `ReplicatedStorage.Shared.UiStyleConfig`. `UiStyleController` applies it to every ImageLabel tagged `StudLayer`, including ones cloned from templates while the game runs.
- **Strength:** the built-in tile is solid grey, so it is laid on lightly (80–88% see-through) and the colours underneath were pushed about 15% more saturated to stay vivid. A custom see-through stud tile could be shown much stronger; put its `rbxassetid://` in `StudImage` to switch.
- **Per layer:** attributes `StudTransparency` and `StudTile` on a layer override the config.
- **Adding studs to a new surface:** put an ImageLabel named `Studs` inside it (size 1,1, transparent background), tag it `StudLayer`, and give it a ZIndex below the surface's other children.
- 103 layers exist in the saved UI (122 in play, with cloned slots): shop 27, index 46, garage 7, teleport 7, side buttons 5, tow HUD 5, codes 2, leaderboard 2, clean bar and shop frame 2.

Not covered: the money bar, the upgrade board, and text-only elements.

## Shop window
`StarterGui.MainHUD.ShopPanel`, driven by `ShopController` (both existed already). Restyled in place on 2026-11-21 so the script kept working:
- Each card got a **Burst** (the rays) and a **Badge** (the coin) behind its `Picture`.
- Card gradients were made saturated, one colour pair per card.
- Section headers became `~Featured~`, `~Game Passes~`, `~Boosts~`, `~Cash Packs~`.
- "BEST SELLER!" on x2 Cash and "BEST DEAL!" on the $1M pack.
- The **Tabs** column is hidden (`Tabs.Visible = false`). It sat outside the window and overlapped the side buttons. Turn it back on if wanted.

Nothing can be bought yet: every card's `AssetId` is 0, so its button says "Coming soon!". To sell something, create the pass or product and put its id on the card. Passes and products also need server code to grant what they promise (see the notes at the top of `ShopController`).

**Check against the master plan:** the shop has a Cash Packs section, and the master plan says "never sell cash packs". Decide which one stands.

## Tow HUD
`StarterGui.TowGui` now uses the same button style. Each button's words are in a child label named `Label`, so the gradient colours the button and not the text. `TowController` writes to that label when it exists.

## Hub lighting and colour
The first bright pass was too glaring, so it was toned down the same day. Current values sit between the original and that pass.

| Setting | Original | Too bright | Now |
|---|---|---|---|
| Sun brightness | 3.0 | 3.2 | 2.3 |
| Ambient light | 90 | 150 | 112 |
| Outdoor ambient | 128 | 190 | 150 |
| Haze | 0.5 | 0 | 0.3 |
| Fog density | 0.25 | 0.18 | 0.2 |
| Colour saturation (hub total) | +0.10 | +0.37 | +0.24 |
| Contrast | +0.05 | +0.10 | +0.06 |
| Bloom intensity | 1.0 | 1.0 | 0.4 |
| Hub grass | 92,168,72 Grass | 112,222,52 Plastic | 98,196,64 Plastic |

- The hub look is the `HUB` line in `AtmosphereController`.
- `VIBRANCE` in the same script (now 0.08) is added to every area's saturation, swamps included. Raise it for more candy colour; set 0 for the profiles as written.
- Bloom is a single setting in Lighting for the whole game, so the lower bloom also applies in the swamps.
- The old grass look is saved on the part as the attribute `OriginalLook`.
- The swamps keep their own moods; they are just a little more saturated.

## Not done
- No custom icons: pictures are emoji. Real icon art would lift the shop the most.
- Garage, Index, Teleport, Codes and Leaderboard windows got the stud pattern but no other restyling.
