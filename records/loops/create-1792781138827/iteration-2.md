## commit

- instance: f0bf583821e0c4d6ab2ddfbcb050f942b49b090b
- baseline: ba948bce7498a0cafc6bb61c262bed7329b18f23
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/create-1792781138827/check-2.json |
| static check | pass | records/loops/create-1792781138827/check-2.json |
| no blocker | pass | records/loops/create-1792781138827/check-2.json |
| full flow | pass | records/loops/create-1792781138827/check-2.json |
| performance | fail | records/loops/create-1792781138827/check-2.json |
| UI quality | pass | records/loops/create-1792781138827/check-2.json |
| no placeholder | fail | records/loops/create-1792781138827/check-2.json |
| row simulation | pass | records/loops/create-1792781138827/check-2.json |

## judge

### records/loops/create-1792781138827/judge-2-1.md

- kind: main
- status: done
- A: ba948bce7498a0cafc6bb61c262bed7329b18f23
- B: f0bf583821e0c4d6ab2ddfbcb050f942b49b090b
- vs baseline: indistinguishable
- vs reference: fail
- omitted moments: none

#### moments

- `A` is better at first 30000ms. Reason: the interval compare gives A decisive on input_latency_ms 1 vs 2 (feedback_per_input 0 vs 0, idle_span 0 vs 0). On screen, the only difference is B's HP bar under the player (A 1792789861799, B 1792789861070).
- `A` is better at core action. Reason: the same interval gives A decisive on input_latency_ms 1 vs 2. On screen, both show the lantern bolt glow with damage numbers of "12", and the enemies are the same boxes.
- `B` is better at first failure. Reason: B shows `체력이 위험해요!` at 16/100 HP (0:53), then a red field and `등불이 꺼졌다…` at 0/100 (0:55). A shows 0/100 at 0:50 with no tint or text, then opens the result panel. The interval compare (A 377380–758281, B 370530–767404) gives game feel to A on latency (2 vs 373 ms); B has feedback_per_input 18 vs 9.
- `A` is better at first reward. Reason: in the interval compare, reward_interval_ms is A 3200 vs B 10574. Both reached Lv 3 by 0:48 with a 3-card popup (A 1792790225005).
- `B` is better at restart. Reason: restart_delay_ms is B 2401 vs A 6400. The restart interval compare is indistinguishable (feedback_per_input 1 vs 1). Both result panels show survived time, kills, level and gold with `다시 출발` / `야영지로`.
- `B` is better at late_run_horde. Reason: the interval compare gives B decisive on input_latency_ms 2 vs 3. On screen, both show a dense box horde with damage numbers 19/30/63 and 8 item icons at Lv 5. A held 184–200/200 HP from 10:02 to 10:07; B ran from 34 to 98 of 100 HP between 10:02 and 10:08 (A mvlgnujp125740 1792790498789–1792790586488, B mvlgo4i1c37b3e 1792790499619–1792790588947).
- `B` is better at second_run_after_meta_upgrade. Reason: the interval compare gives B decisive on input_latency_ms 1 vs 2. B shows a shrine-upgrade plate under the weapon icon and reached Lv 2 with a second weapon at 0:27; A shows no sign of the upgrade and was still Lv 1 at 0:30 (A mvlgoegw10f1de 1792790516447/1792790696586, B mvlgop1515ebff 1792790518110/1792790726389).

#### loser better

- `A` (lost `game feel`, `tension and release`, `one more run`): lower input latency across the session (2 vs 20 ms whole session, 2 vs 373 ms in the first-failure interval).
- `B` (lost `progression`, `no friction`, `presentation`): in the second run after a shrine purchase, `B` shows the bought upgrade on a HUD plate and reached Lv 2 by 0:27; `A` shows no upgrade sign and was still Lv 1 at 0:30. `B` also shows the player's HP next to the player and warns at low HP.

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/create-1792781138827/play-2-1.md | 0 | 0 | 0 | 0 |
| records/loops/create-1792781138827/play-2-2.md | 0 | 1 | 6 | 10 |
| records/loops/create-1792781138827/play-2-3.md | 0 | 4 | 5 | 8 |
| records/loops/create-1792781138827/play-2-4.md | 0 | 2 | 2 | 2 |
| records/loops/create-1792781138827/play-2-5.md | 0 | 3 | 1 | 4 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| early-xp-pace-slow | major | data | vs reference: progression | Lv 1 at 0:32 in the first run, and Lv 2 only by 0:27 in the second run. Both are later than the reference's level-up at 00:21. | worse than the reference game, so `vs reference` is `fail` | ref frames 19000–22000 ms; B mvlgnomafe63e4 capture 1792790005382 (0:32, Lv 1); mvlgop1515ebff capture 1792790726389 (0:27, Lv 2), records/loops/create-1792781138827/judge-2-1.md | judge | open |
| attack-feedback-weak | major | client content | vs reference: game feel | Same as `A`, apart from the HP bar under the player. There is no slash or impact effect at the level of the whip arc, and the telemetry shows no feedback on inputs in the interval. | worse than the reference game, so `vs reference` is `fail` | ref frame 15000 ms; B mvlgnomafe63e4 capture 1792789861070 (0:12); compare interval 95877–370530: feedback_per_input B 0, records/loops/create-1792781138827/judge-2-1.md | judge | open |
| code-drawn-ui-flat | major | client content | HP bar under the player | A flat dark-red rectangle with a fill. | A code-drawn box in the field (`presentation`). | mvlgnomafe63e4 1792789764046, ref frames 0, 5000, 21000 ms; B mvlgnomafe63e4 captures 1792789764046, 1792790381040, records/loops/create-1792781138827/judge-2-1.md | judge | open |
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 16 is below targetFps 60 (2 samples) | the run must hold targetFps; the 5th percentile is 16 (hostLoad memory 99.9%) | records/loops/create-1792781138827/check-2.json#performance, records/loops/create-1792781138827/evidence/check-2/performance-macos/samples.json | check | open |
| damage-numbers-overlap | major | client content | scene/run/run | hold D 3200ms then hold W 3000ms in steps → Timer 10:06, HP 68/100, kills 4,514, gold 1,188 | Damage numbers (19/27/30/63) stack and overlap near the player, hard to read; enemies are plain boxes, tough to tell enemies from gems and scenery (blue and lilac cubes of the same palette) | captures/mvlhf2mp000630-1792790995592.png, records/loops/create-1792781138827/play-2-4.md:17 | play | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 35 is below targetFps 60 (3 samples) | the camp must hold targetFps; the 5th percentile is 35 (hostLoad memory 99.9%) | records/loops/create-1792781138827/check-2.json#performance, records/loops/create-1792781138827/evidence/check-2/performance-macos/samples.json | check | open |
| standing-still-survives | minor | data | ~190000 | run → standing still for 2:50 | the player survived 2:59 with no movement at all, killing 581 enemies with the auto weapons | minor, records/loops/create-1792781138827/play-2-1.md:27 | play | open |
| meta-upgrade-not-visible | minor | client content | ~350000 | run → tap_anchor upgrade_close, lobby_play | the new run showed health 115/115 (+15 from vitality) and a small plate under the weapon row with 2 icons marked 1 and 1 | minor, records/loops/create-1792781138827/play-2-1.md:24 | play | open |
| fall-input-latency | minor | client content | first-failure interval | input_latency_ms 373 in the interval that includes the low-HP and fall sequence (whole session 20 vs A 2). | Inputs are slower to respond around the fall (`game feel`). | `ogw telemetry compare` interval 370530–767404 | judge | open |
| levelup-card-text-wrap | minor | client content | level-up | 60 steps after the pick → second level-up at 0:24 with Lv 3, health 72/100, kills 27; cards `낙뢰`, `등불 탄환 Lv 2`, `질풍 장화`. The description of `낙뢰` wraps to `다` alone on a second line | consistent with the first popup; health already lost 28 in 24 s | captures/mvlhev4u85ad06-1792791180545.png, records/loops/create-1792781138827/play-2-3.md:25 | play | open |
| play-guide-anchor-key-form | minor | design | ~310000 | lobby → tap_anchor upgrade_buy upgrade_vitality (no brackets) | `ok:false`, the key was rejected; the guide wrote the key as `[upgrade_vitality]`, and with brackets it worked | minor, records/loops/create-1792781138827/play-2-1.md:22 | play | open |
| opening-no-threat | major | data | first minute of a run | No threat: standing still from 0:26 to 0:56 cost 0 health, and the first hit came at about 1:10 | There is no challenge that can fail in the opening, so the first minute has no tension | `mvldzqoec49a81-1792786007963` (0:56, 100/100), `mvldzqoec49a81-1792786185633` (1:10, 97/100), Captures `mvldzqoec49a81-1792786007963` (0:56, 100/100, 68 kills), `mvldzqoec49a81-1792786185633` (1:10, 97/100), `mvldzxt6027bf0-1792786394742` (10:12, 0/200), `mvldzxt6027bf0-1792786417980` (result panel). Telemetry `mvldzxt6027bf0`: Fail at play 1065030, Goal (panel) at 1066730. Reference frames 496000–503000ms, records/loops/create-1792781138827/judge-1-1.md | judge | fixed |
| hurt-not-visible | major | client content | run 0:56 | none (standing still) → health fell from 100 to 6/100 in about 16 s of standing still; second level-up popup (거인의 심장, 회전 낫, 낙뢰 Lv 2) | health dropped fast with no on-screen warning; the red bar frame is a placeholder and does not show the drop clearly (only the number 6/100) | captures/mvle0pdkc59058-1792785804824.png, records/loops/create-1792781138827/play-1-1.md:25, captures/mvle1gaxa545f2-1792785739698.png, records/loops/create-1792781138827/play-1-3.md:23, `mvldzxt6027bf0-1792786300717` (10:06, 184/200), `mvldzxt6027bf0-1792786369873` (10:10, 40/200), `mvldzxt6027bf0-1792786394742` (10:12, 0/200) | play | fixed |
| levelup-capture-popup-not-open | major | client content | scene/run/run | run.open_levelup failed: "the popup did not open" (ko, macbook_pro_14_notch) | the UI quality check cannot capture the level-up popup on any screen, so its layout is not checked | records/loops/create-1792781138827/check-1.json#UI quality | check | fixed |
| scene-load-slow | major | design | scene_load_ms | value 6248 out of 0..3000 | scene load must end within the loading time limit (3000ms) | records/loops/create-1792781138827/measure-1.json#scene_load_ms | check | fixed |
| lobby-title-gold-overlap | major | client content | scene/lobby/lobby | overlap UICore/Panel/SafeAreaRoot/LobbyPanel/Title UICore/Panel/SafeAreaRoot/LobbyPanel/GoldPlate/Row/Gold in prefab/lobby/lobby_panel (ko, macbook_air_13, lobby.open_lobby, text scale 1000) | UI quality requires no overlap on every supported screen and language | records/loops/create-1792781138827/check-1.json#UI quality, records/loops/create-1792781138827/evidence/check-1/ui-macos/0001-ko-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0001-ko-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0010-ko-macbook_pro_14_notch-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0010-ko-macbook_pro_14_notch-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0018-ko-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0018-ko-display_16_9-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0034-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0034-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0042-en-macbook_pro_14_notch-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0042-en-macbook_pro_14_notch-lobby.open_lobby-1000.json, records/loops/create-1792781138827/evidence/check-1/ui-macos/0050-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792781138827/evidence/check-1/ui-macos/0050-en-display_16_9-lobby.open_lobby-1000.json | check | fixed |
| giveup-result-title | major | data | scene/run/result | key P, tap_anchor pause_give_up → result panel `어둠에 쓰러졌다` after about 3s: survived 10분 8초, kills 4,420, level 45, gold +1,165 | the panel opens fine, but a big `PANELFRAME` placeholder text covers the middle lines (kills, level) and the two buttons carry `BUTTON_PRIMARY` text over `다시 출발` / `야영지로`. A deliberate give-up is titled `어둠에 쓰러졌다` (fell in the dark), which does not say it was a give-up | captures/mvle1uqt3a7cf4-1792785358888.png, records/loops/create-1792781138827/play-1-4.md:21 | play | fixed |
| death-no-presentation | minor | client content | fall → result panel | At health 0 the field shows no death presentation (no tint, no title, no player reaction) before the result panel | The fall has no moment of its own. The reference shows a red-tinted `GAME OVER` over the field | `mvldzxt6027bf0-1792786394742` (10:12, 0/200), telemetry Fail at play 1065030, panel at 1066730 | judge | fixed |
| difficulty-cliff | minor | data | result | idle for about 30 game seconds → Fell at 39s. The panel shows survived time 39s, kills 32, level 2, gold +11. Only 3 hits in about 11s of standing still took the HP from 100 to 0, so the fall comes fast | stats are readable, but the placeholder frame text sits behind them; standing still dies quickly | captures/mvle10cgbb9f15-1792785944077.png, records/loops/create-1792781138827/play-1-2.md:23 | play | fixed |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 17 | 0..100 | in |
| no_response_permille | 124 | 0..150 | in |
| scene_load_ms | 934 | 0..3000 | in |
| restart_delay_ms | 11533 | 2000..60000 | in |
| first_reward_ms | 42763 | 5000..60000 | in |
| reward_interval_ms | 12342 | 8000..45000 | in |
| goal_interval_ms | 70121 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":59.2,"memoryMaxPercent":99.9,"instancesMax":3} |
