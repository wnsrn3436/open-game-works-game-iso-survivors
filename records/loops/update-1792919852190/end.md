## reason

stopped by human

- last verdict: continue (iteration 1)

## result

- merge commit: 3749d10403626367e95f3c1bff49f9109e3d48ce
- vs baseline: indistinguishable
- last judge result: records/loops/update-1792919852190/judge-1-1.md
- no blocker: pass
- performance: fail
- no placeholder: pass
- full flow: pass
- UI quality: fail

## failures

- open defect shrine-buy-button-clipped: clipped UICore/Panel/SafeAreaRoot/UpgradePanel/Frame/Box/Grid/Entry1/Row/Side/Buy in prefab/lobby/upgrade_panel (ko, macbook_air_13, lobby.open_upgrades, text scale 1000)
- open defect run-fps-below-target: fps 5 percentile 55 is below targetFps 60 (2 samples)
- open defect low-health-warning-hidden: The red `체력이 위험해요!` text under the player is drawn beneath the fire aura ring, gems and enemies, and cannot be read.
- open defect run-field-too-dark: none (stood still) → At 0:05 there were 1 kill, 8 or more enemies on screen and an XP gem at the left
- open defect first-levelup-no-weapon-card: key P → At 0:11 (Lv 2) the level-up popup was open, so `P` did nothing and the run stayed held. The cards offered were `질풍 장화`, `바람의 깃털`, `분노의 불씨`, all passives, with no weapon card
- open defect levelup-pace-uneven: step → Run time 0:54, 64 kills, XP bar about 65%. Lv 3 → Lv 4 took 39 seconds of run time, against 14 seconds for Lv 2 → Lv 3 and 4 seconds for Lv 1 → Lv 2
- open defect low-pressure-early: key_down W then A+S, step 200ms → Run time 0:34, 40 kills, 13 gold. Many enemies (zombies, bats) were on screen. The player was at full health, not hit once
- open defect lantern-attack-not-visible: step 200 x40, holding D → at 0:10: 7 kills, 2 gold, level 1 and an empty XP bar, with 3 blue gems lying on the left while the player walked right
- open defect upgrade-cost-curve-steep: tap_anchor result_lobby, lobby_upgrades → Camp gold showed 25 and the shrine showed 25 too. Prices are 50 힘, 40 생명력, 100 서두름, 30 자력, 60 신속, 80 탐욕
- open defect shrine-toast-small-overlap: tap_anchor lobby_upgrades, upgrade_buy [upgrade_might] → Shrine panel lists six rows with `금화가 부족해요` over each dimmed button. The press showed a toast, also reading `금화가 부족해요`, as a dark horizontal band across the middle two rows
- open defect run-hud-flat-boxes: The health/weapon box (top left), the kills/gold box (top right) and the three stat rows of the result panel are plain dark single-color rectangles with a thin outline. The other panels use art frames.
- open defect lobby-fps-below-target: fps 5 percentile 43 is below targetFps 60 (3 samples)

## human

none
