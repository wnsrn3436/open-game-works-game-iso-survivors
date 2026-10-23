## commit

- instance: ba948bce7498a0cafc6bb61c262bed7329b18f23
- baseline: none
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/create-1792781138827/check-1.json |
| static check | pass | records/loops/create-1792781138827/check-1.json |
| no blocker | pass | records/loops/create-1792781138827/check-1.json |
| full flow | pass | records/loops/create-1792781138827/check-1.json |
| performance | fail | records/loops/create-1792781138827/check-1.json |
| UI quality | fail | records/loops/create-1792781138827/check-1.json |
| no placeholder | fail | records/loops/create-1792781138827/check-1.json |
| row simulation | pass | records/loops/create-1792781138827/check-1.json |

## judge

### records/loops/create-1792781138827/judge-1-1.md

- kind: main
- status: done
- A: ba948bce7498a0cafc6bb61c262bed7329b18f23
- B: none
- vs baseline: none
- vs reference: fail
- omitted moments: none

#### moments

- first 30000ms of `A`: terms popup → lobby → run took 3 taps, with scene loads of 542ms and 650ms. The run opens at 0:00 with the move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom. By 0:25 there were 20 kills, 7 gold and the first level-up popup. Health stayed at 100/100 for the whole 30s (`mvldzqoec49a81`, captures 1792785269673–1792785608830).
- core action of `A`: holding a move key moves the lit box player and the camera follows. The auto weapon kills boxes at a distance, with white `12` damage numbers. Enemies, gems and obstacles share one lavender box look, so the target of each hit cannot be told on screen (`mvldzqoec49a81`, 0:04–0:19).
- first reward of `A`: level 2 at 0:25. Three cards: `질풍 장화` (move speed +8%), `분노의 불씨` (damage +10%), `낙뢰` (lightning). Picking `3` logged Sound 5, CameraShake 1, Tween 8, Effect 8, and a lightning column appeared at 0:26 (`mvldzqoec49a81-1792785638171`).
- first failure of `A`: the first run took no damage until about 1:10, and I did not see a death there. The failure I observed is on fixture `mvldzxt6027bf0`: standing still from 10:01, health went 200 → 184 (10:06) → 40 (10:10) → 0 (10:12), with the player covered by enemy boxes. The 0/200 frame shows no death presentation. The result panel `어둠에 쓰러졌다` lists 10분 12초, 4,493 kills, level 46 and gold +1,184 (Fail → panel 1700ms of game time).
- restart of `A`: `다시 출발` on the result panel started a new run, at 0:01 within 1000ms of game time (scene load 514ms, Restart mark at play 1067930). The new run starts again at Lv 1 with the lantern bolt only (`mvldzxt6027bf0-1792786447144`).
- late_run_horde of `A`: at 10:00 the player is Lv 45 with 4 weapons and 4 passives, all at level 5, and 200/200 health. Hundreds of boxes fill the screen around a white aura square, with stacked damage numbers (13, 20, 42) and enemies hit-tinted pink. When every item is at max, the level-up offers only one card, `따뜻한 수프` (heal 30) (`mvldzxt6027bf0`, 1792786249377, 1792786300717, 1792786369873).
- second_run_after_meta_upgrade of `A`: the run starts with 100/100 health and the lantern bolt. The HUD shows nothing about the bought upgrade. The first level-up came at 0:12, offering `바람의 깃털`, `분노의 불씨` and `자석 부적`. At 0:29 the player had 27 kills, 8 gold and 85/100 health (`mvle08ri4493c4`, 1792786466359, 1792786617086, 1792786763384).

#### loser better

none

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/create-1792781138827/play-1-1.md | 0 | 2 | 10 | 5 |
| records/loops/create-1792781138827/play-1-2.md | 0 | 0 | 7 | 4 |
| records/loops/create-1792781138827/play-1-3.md | 0 | 2 | 7 | 4 |
| records/loops/create-1792781138827/play-1-4.md | 0 | 3 | 3 | 1 |
| records/loops/create-1792781138827/play-1-5.md | 0 | 2 | 3 | 5 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| opening-no-threat | major | data | first minute of a run | No threat: standing still from 0:26 to 0:56 cost 0 health, and the first hit came at about 1:10 | There is no challenge that can fail in the opening, so the first minute has no tension | `mvldzqoec49a81-1792786007963` (0:56, 100/100), `mvldzqoec49a81-1792786185633` (1:10, 97/100), Captures `mvldzqoec49a81-1792786007963` (0:56, 100/100, 68 kills), `mvldzqoec49a81-1792786185633` (1:10, 97/100), `mvldzxt6027bf0-1792786394742` (10:12, 0/200), `mvldzxt6027bf0-1792786417980` (result panel). Telemetry `mvldzxt6027bf0`: Fail at play 1065030, Goal (panel) at 1066730. Reference frames 496000–503000ms, records/loops/create-1792781138827/judge-1-1.md | judge | open |
| hurt-not-visible | major | client content | run 0:56 | none (standing still) → health fell from 100 to 6/100 in about 16 s of standing still; second level-up popup (거인의 심장, 회전 낫, 낙뢰 Lv 2) | health dropped fast with no on-screen warning; the red bar frame is a placeholder and does not show the drop clearly (only the number 6/100) | captures/mvle0pdkc59058-1792785804824.png, records/loops/create-1792781138827/play-1-1.md:25, captures/mvle1gaxa545f2-1792785739698.png, records/loops/create-1792781138827/play-1-3.md:23, `mvldzxt6027bf0-1792786300717` (10:06, 184/200), `mvldzxt6027bf0-1792786369873` (10:10, 40/200), `mvldzxt6027bf0-1792786394742` (10:12, 0/200) | play | open |
| levelup-capture-popup-not-open | major | client content | scene/run/run | run.open_levelup failed: "the popup did not open" (ko, macbook_pro_14_notch) | the UI quality check cannot capture the level-up popup on any screen, so its layout is not checked | records/loops/create-1792781138827/check-1.json#UI quality | check | open |
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 41 is below targetFps 60 (2 samples) | the run must hold targetFps on the target Macs; the 5th percentile is 41 | records/loops/create-1792781138827/check-1.json#performance, records/loops/create-1792781138827/evidence/check-1/performance-macos/samples.json | check | open |
| scene-load-slow | major | design | scene_load_ms | value 6248 out of 0..3000 | scene load must end within the loading time limit (3000ms) | records/loops/create-1792781138827/measure-1.json#scene_load_ms | check | open |
| early-xp-pace-slow | major | data | first_reward_ms | value 79355 out of 5000..30000 | the first reward must come within the target range of design.md | records/loops/create-1792781138827/measure-1.json#first_reward_ms, captures/mvle0pdkc59058-1792785564359.png, records/loops/create-1792781138827/play-1-1.md:22, `ogw telemetry mvldzqoec49a81` rewards at play 118069 and 157619 | check | open |
| damage-numbers-overlap | major | client content | scene/run/run | step 200 (D held) → many damage numbers (19, 27, 30, 63) stacked at the same spots around the player | numbers overlap into unreadable blobs, e.g. `3019`, `2719`. Enemies (pink/red tall boxes) look much like the lavender building blocks around them, so which blocks are enemies is hard to tell | captures/mvle1uqt3a7cf4-1792785315783.png, records/loops/create-1792781138827/play-1-4.md:18 | play | open |
| lobby-title-gold-overlap | major | client content | scene/lobby/lobby | overlap UICore/Panel/SafeAreaRoot/LobbyPanel/Title UICore/Panel/SafeAreaRoot/LobbyPanel/GoldPlate/Row/Gold in prefab/lobby/lobby_panel (ko, macbook_air_13, lobby.open_lobby, text scale 1000) | UI quality requires no overlap on every supported screen and language | records/loops/create-1792781138827/check-1.json#UI quality, records/loops/create-1792781138827/evidence/check-1/ui-macos/0001-ko-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0001-ko-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0010-ko-macbook_pro_14_notch-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0010-ko-macbook_pro_14_notch-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0018-ko-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0018-ko-display_16_9-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0034-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0034-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0042-en-macbook_pro_14_notch-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0042-en-macbook_pro_14_notch-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0050-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0050-en-display_16_9-lobby.open_lobby-1000.json | check | open |
| giveup-result-title | major | data | scene/run/result | key P, tap_anchor pause_give_up → result panel `어둠에 쓰러졌다` after about 3s: survived 10분 8초, kills 4,420, level 45, gold +1,165 | the panel opens fine, but a big `PANELFRAME` placeholder text covers the middle lines (kills, level) and the two buttons carry `BUTTON_PRIMARY` text over `다시 출발` / `야영지로`. A deliberate give-up is titled `어둠에 쓰러졌다` (fell in the dark), which does not say it was a give-up | captures/mvle1uqt3a7cf4-1792785358888.png, records/loops/create-1792781138827/play-1-4.md:21 | play | open |
| death-no-presentation | minor | client content | fall → result panel | At health 0 the field shows no death presentation (no tint, no title, no player reaction) before the result panel | The fall has no moment of its own. The reference shows a red-tinted `GAME OVER` over the field | `mvldzxt6027bf0-1792786394742` (10:12, 0/200), telemetry Fail at play 1065030, panel at 1066730 | judge | open |
| difficulty-cliff | minor | data | result | idle for about 30 game seconds → Fell at 39s. The panel shows survived time 39s, kills 32, level 2, gold +11. Only 3 hits in about 11s of standing still took the HP from 100 to 0, so the fall comes fast | stats are readable, but the placeholder frame text sits behind them; standing still dies quickly | captures/mvle10cgbb9f15-1792785944077.png, records/loops/create-1792781138827/play-1-2.md:23 | play | open |
| meta-upgrade-not-visible | minor | client content | second run HUD | Nothing on the run HUD shows the permanent upgrade bought with the first run's gold (health 100/100, the same start as the first run) | The player cannot see that the meta purchase changed anything | `mvle08ri4493c4-1792786466359` (0:00), `mvle08ri4493c4-1792786763384` (0:29) | judge | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 57 is below targetFps 60 (3 samples) | the camp must hold targetFps; the 5th percentile is 57 | records/loops/create-1792781138827/check-1.json#performance, records/loops/create-1792781138827/evidence/check-1/performance-macos/samples.json | check | open |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 17 | 0..100 | in |
| no_response_permille | 0 | 0..150 | in |
| scene_load_ms | 6248 | 0..3000 | out |
| restart_delay_ms | 6537 | 2000..60000 | in |
| first_reward_ms | 79355 | 5000..30000 | out |
| reward_interval_ms | 17800 | 8000..45000 | in |
| goal_interval_ms | 77197 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":83.4,"memoryMaxPercent":99.9,"instancesMax":3} |
