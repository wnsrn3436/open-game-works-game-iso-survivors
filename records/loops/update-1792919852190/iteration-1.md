## commit

- instance: 3749d10403626367e95f3c1bff49f9109e3d48ce
- baseline: 3abd2b0b5d7f6912655c5e52283319eac9dec533
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/update-1792919852190/check-1.json |
| static check | pass | records/loops/update-1792919852190/check-1.json |
| no blocker | pass | records/loops/update-1792919852190/check-1.json |
| full flow | pass | records/loops/update-1792919852190/check-1.json |
| performance | fail | records/loops/update-1792919852190/check-1.json |
| UI quality | fail | records/loops/update-1792919852190/check-1.json |
| no placeholder | pass | records/loops/update-1792919852190/check-1.json |
| row simulation | pass | records/loops/update-1792919852190/check-1.json |

## judge

### records/loops/update-1792919852190/judge-1-1.md

- kind: main
- status: done
- A: 3749d10403626367e95f3c1bff49f9109e3d48ce
- B: 3abd2b0b5d7f6912655c5e52283319eac9dec533
- vs baseline: indistinguishable
- vs reference: pass
- omitted moments: none

#### moments

- Indistinguishable at first 30000ms. Reason: both show the same terms popup, camp and run start at 0:00 with the hint `WASD 로 움직이세요. 공격은 자동이에요`, and `idle_span_ms` is 0 for both.
- `B` is better at core action. Reason: over the first-30s interval, `feedback_per_input` was B 2 vs A 1, while the effects seen on screen (spark rings, damage numbers, aura) were the same kind in both.
- `A` is better at first reward. Reason: the first level-up popup came at 0:10 vs 0:11, and `reward_interval_ms` was 4000 vs 4500.
- Indistinguishable at first failure. Reason: both show `체력이 위험해요!` at low HP, then `등불이 꺼졌다…`, a red-tinted field and the same `어둠에 쓰러졌다` result panel (A 1:13 / 162 kills / Lv 7 / +47 gold; B 2:12 / 515 kills / Lv 14 / +141 gold, after different card picks).
- `A` is better at restart. Reason: `restart_delay_ms` was 1850 vs 2099, and both new runs start at 0:00 with full health and the move hint.
- `A` is better at three_levelups. Reason: `feedback_per_input` was A 2 vs B 1 (decisive), `reward_interval_ms` was 4050 vs 3900 (indistinguishable), and both reached Lv 4 with the third pick by 0:21 / 0:20.

#### loser better

- `A` (`game feel`): in the three_levelups fixture, A's `feedback_per_input` was 2 vs B's 1, the opposite of the first-30s result.
- `B` (`progression`): in the three_levelups fixture, B's `reward_interval_ms` was shorter, 3900 vs 4050, and B reached the third level-up at run time 0:20 vs 0:21.
- `B` (`one more run`): none seen. The result panel and restart button are the same; only the delay differs (2099 vs 1850 ms).

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/update-1792919852190/play-1-1.md | 0 | 0 | 4 | 10 |
| records/loops/update-1792919852190/play-1-2.md | 0 | 0 | 3 | 11 |
| records/loops/update-1792919852190/play-1-3.md | 0 | 0 | 4 | 14 |
| records/loops/update-1792919852190/play-1-4.md | 0 | 0 | 3 | 8 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| shrine-buy-button-clipped | major | client content | scene/lobby/lobby | clipped UICore/Panel/SafeAreaRoot/UpgradePanel/Frame/Box/Grid/Entry1/Row/Side/Buy in prefab/lobby/upgrade_panel (ko, macbook_air_13, lobby.open_upgrades, text scale 1000) | UI quality requires no clipping on every supported screen and language | records/loops/update-1792919852190/check-1.json#UI quality, records/loops/update-1792919852190/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792919852190/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792919852190/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.json | check | open |
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 55 is below targetFps 60 (2 samples) | the run must hold targetFps; the 5th percentile is 55 | records/loops/update-1792919852190/check-1.json#performance, records/loops/update-1792919852190/evidence/check-1/performance-macos/samples.json | check | open |
| low-health-warning-hidden | minor | client content | run, low health | The red `체력이 위험해요!` text under the player is drawn beneath the fire aura ring, gems and enemies, and cannot be read. | The low-HP warning is a failure cue; if it can't be read, the player has no warning before the fall. | `mvnnd6tr5111cb-1792922724828` (1:13, 1/120) | judge | open |
| run-field-too-dark | minor | client content | scene/run | none (stood still) → At 0:05 there were 1 kill, 8 or more enemies on screen and an XP gem at the left | the screen is dark and enemies are low contrast against the field | captures/mvnne3ktdba3ac-1792921930472.png, records/loops/update-1792919852190/play-1-1.md:21, captures/mvnnea7i16978e-1792921932934.png, records/loops/update-1792919852190/play-1-2.md:18, captures/mvnneh65d2f69c-1792921978080.png, records/loops/update-1792919852190/play-1-3.md:22 | play | open |
| first-levelup-no-weapon-card | minor | data | scene/run | key P → At 0:11 (Lv 2) the level-up popup was open, so `P` did nothing and the run stayed held. The cards offered were `질풍 장화`, `바람의 깃털`, `분노의 불씨`, all passives, with no weapon card | no weapon choice at that level-up | captures/mvnne3ktdba3ac-1792922059054.png, records/loops/update-1792919852190/play-1-1.md:28, captures/mvnnea7i16978e-1792921963726.png, records/loops/update-1792919852190/play-1-2.md:21, captures/mvnneons3b5716-1792921949832.png, records/loops/update-1792919852190/play-1-4.md:16 | play | open |
| levelup-pace-uneven | minor | data | run | step → Run time 0:54, 64 kills, XP bar about 65%. Lv 3 → Lv 4 took 39 seconds of run time, against 14 seconds for Lv 2 → Lv 3 and 4 seconds for Lv 1 → Lv 2 | the level-up pace slows quickly after the first two picks | captures/mvnneons3b5716-1792922181428.png, records/loops/update-1792919852190/play-1-4.md:22 | play | open |
| low-pressure-early | minor | data | run | key_down W then A+S, step 200ms → Run time 0:34, 40 kills, 13 gold. Many enemies (zombies, bats) were on screen. The player was at full health, not hit once | the early wave is easy, with no pressure to move | captures/mvnneons3b5716-1792922094113.png, records/loops/update-1792919852190/play-1-4.md:21 | play | open |
| lantern-attack-not-visible | minor | client content | scene/run/run | step 200 x40, holding D → at 0:10: 7 kills, 2 gold, level 1 and an empty XP bar, with 3 blue gems lying on the left while the player walked right | the weapon (the lantern, level 1) kills on its own, but its attack effect is not visible in the capture; I could only see the kill count rise | captures/mvnnea7i16978e-1792921950708.png, records/loops/update-1792919852190/play-1-2.md:19 | play | open |
| upgrade-cost-curve-steep | minor | data | scene/lobby | tap_anchor result_lobby, lobby_upgrades → Camp gold showed 25 and the shrine showed 25 too. Prices are 50 힘, 40 생명력, 100 서두름, 30 자력, 60 신속, 80 탐욕 | one run earns less than most single upgrades, so only 자력 is within reach after about 1 min of play | captures/mvnne3ktdba3ac-1792922040966.png, records/loops/update-1792919852190/play-1-1.md:26, captures/mvnneh65d2f69c-1792922411133.png, records/loops/update-1792919852190/play-1-3.md:33 | play | open |
| shrine-toast-small-overlap | minor | client content | scene/lobby | tap_anchor lobby_upgrades, upgrade_buy [upgrade_might] → Shrine panel lists six rows with `금화가 부족해요` over each dimmed button. The press showed a toast, also reading `금화가 부족해요`, as a dark horizontal band across the middle two rows | the band cuts across the 서두름 and 자력 text for as long as it shows | captures/mvnne3ktdba3ac-1792921913327.png, records/loops/update-1792919852190/play-1-1.md:19, captures/mvnneh65d2f69c-1792922143377.png, records/loops/update-1792919852190/play-1-3.md:29, captures/mvnneh65d2f69c-1792922411133.png, records/loops/update-1792919852190/play-1-3.md:31 | play | open |
| run-hud-flat-boxes | minor | client content | run HUD, result panel | The health/weapon box (top left), the kills/gold box (top right) and the three stat rows of the result panel are plain dark single-color rectangles with a thin outline. The other panels use art frames. | Under `presentation`, these are code-made boxes next to art-framed panels. | mvnnd6tr5111cb-1792922161142`, `mvnnd6tr5111cb-1792922978751 | judge | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 43 is below targetFps 60 (3 samples) | the camp must hold targetFps; the 5th percentile is 43 | records/loops/update-1792919852190/check-1.json#performance, records/loops/update-1792919852190/evidence/check-1/performance-macos/samples.json | check | open |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 16 | 0..100 | in |
| no_response_permille | 25 | 0..150 | in |
| scene_load_ms | 516 | 0..3000 | in |
| restart_delay_ms | 23301 | 2000..60000 | in |
| feedback_per_input | 3 | 1..1000 | in |
| first_reward_ms | 46082 | 5000..60000 | in |
| reward_interval_ms | 14635 | 8000..45000 | in |
| goal_interval_ms | 66565 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":20.5,"memoryMaxPercent":78.3,"instancesMax":3} |
