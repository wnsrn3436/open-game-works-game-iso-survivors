## commit

- instance: 63e74d427edecb9926483151b3737863b3378717
- baseline: ba948bce7498a0cafc6bb61c262bed7329b18f23
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/create-1792781138827/check-3.json |
| static check | pass | records/loops/create-1792781138827/check-3.json |
| no blocker | pass | records/loops/create-1792781138827/check-3.json |
| full flow | pass | records/loops/create-1792781138827/check-3.json |
| performance | fail | records/loops/create-1792781138827/check-3.json |
| UI quality | pass | records/loops/create-1792781138827/check-3.json |
| no placeholder | fail | records/loops/create-1792781138827/check-3.json |
| row simulation | pass | records/loops/create-1792781138827/check-3.json |

## judge

### records/loops/create-1792781138827/judge-3-1.md

- kind: main
- status: done
- A: ba948bce7498a0cafc6bb61c262bed7329b18f23
- B: 63e74d427edecb9926483151b3737863b3378717
- vs baseline: better
- vs reference: pass
- omitted moments: none

#### moments

- `B` is better at first 30000ms. Reason: at 0:30 B was Lv4 with 40 kills and three weapons, and A was Lv2 with 22 kills. Feedback per input was B 2 vs A 0.
- `B` is better at core action. Reason: B's lantern bolt shows as a glowing projectile hitting enemies (0:09, 0:16, 0:30). A shows no weapon projectile in its captures from 0:01–0:30, only a damage number `12`.
- `B` is better at first reward. Reason: B's first level-up opened at 0:05 and A's at 0:28.
- `B` is better at first failure. Reason: B shows red HP numbers at 2/100, a red field and the `등불이 꺼졌다…` title before the result panel. A's field stays unchanged until the result panel opens.
- `A` is better at restart. Reason: under the same procedure, restart_delay_ms was A 1649 vs B 1766.
- `A` is better at late_run_horde. Reason: telemetry in that interval gave A the win in game feel (209 vs 0), progression (5800 vs 7496ms) and one more run (1772 vs 7411ms). B's restart value includes ~20 steps I took after its fall. On screen, B's horde is distinct enemy types (trolls, skeletons, hooded figures) with gems. A's is overlapping untextured cubes, with damage numbers stacked over the player (`mvlk6lv5dfab76-1792796141190`, `mvlk6uaq9fe449-1792796155759`).
- `B` is better at second_run_after_meta_upgrade. Reason: B opens with `등불 제단의 가호가 함께합니다` and a plate showing `줍는 범위 +20%`, and reached Lv3 by 0:19. A shows nothing about the purchase and was Lv1 at 0:30 under the same inputs. Feedback per input was A 1 vs B 11.

#### loser better

- A restarted 117ms sooner after a fall under the same procedure (1649 vs 1766ms).
- In the late_run_horde interval, A's reward interval was shorter (5800 vs 7496ms). A's horde at 10:00 also put real pressure on the player: 200→136 HP in 2s after resume, and a fall at 10:07. B's player stayed at 100/100 for the first 2s and fell at 10:17, only after walking into the horde.

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/create-1792781138827/play-3-1.md | 0 | 1 | 3 | 11 |
| records/loops/create-1792781138827/play-3-2.md | 0 | 0 | 0 | 10 |
| records/loops/create-1792781138827/play-3-3.md | 0 | 0 | 2 | 12 |
| records/loops/create-1792781138827/play-3-4.md | 0 | 0 | 2 | 5 |
| records/loops/create-1792781138827/play-3-5.md | 0 | 0 | 1 | 11 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 15 is below targetFps 60 (2 samples) | the run must hold targetFps; the 5th percentile is 15 (hostLoad memory 83.4%) | records/loops/create-1792781138827/check-3.json#performance, records/loops/create-1792781138827/evidence/check-3/performance-macos/samples.json | check | open |
| standing-still-survives | major | data | run | standing still, no movement from 0:24 to 1:40 → At 1:40 Lv12, kills 319, gold 89, health 74/100. 8 passives and weapons owned; enemies crowd around the player; aura ring and scythe kill them. Many blue gems lie uncollected within view | A player who never moves has lost only 26 health in 1:40 after taking one weapon of each kind. Early difficulty is low, and moving does not seem needed | captures/mvllohojba6a6b-1792798535402.png, records/loops/create-1792781138827/play-3-1.md:24, records/loops/create-1792781138827/play-3-2.md:23 | play | open |
| early-levelup-too-frequent | minor | data | levelup | key 2 at Lv3 (0:21) → Next level-up (scythe, hatchet, feather) comes about 3 s later, at Lv4 0:24 | Level-ups are very frequent early. Several popups interrupt the run within 15 s | captures/mvllohojba6a6b-1792798420448.png, records/loops/create-1792781138827/play-3-1.md:22, minor, records/loops/create-1792781138827/play-3-2.md:20 | play | open |
| enemy-field-contrast | minor | client content | run 11:05 | held A/W/D/S in turn, 5000ms per key → HP 49/200, `체력이 위험해요!` under the player, numbers red; Lv 58 | the low-health warning shows as written; the bolts and the ring of weapons are hard to tell apart from the enemy colours at this density | captures/mvllp1sqffedcb-1792798291328.png, records/loops/create-1792781138827/play-3-4.md:18, mvlk6fnac8e67f-1792795733371` (0:04), `mvlk7doa181852-1792796632225 | play | open |
| xp-bar-unreadable | minor | client content | scene/run/run | key_down D+S, stepped → level-up popup at 0:06 (Lv 2) with 2 kills; cards 낙뢰, 성화 오라, 등불 탄환 and hint `1 2 3 로도 고를 수 있어요` | popup is clear. Lv 2 came after only 2 kills and the XP bar looked almost empty in the capture just before, so the XP bar did not show how close the level-up was | captures/mvllov46c1f92d-1792798277303.png, records/loops/create-1792781138827/play-3-3.md:21 | play | open |
| shrine-toast-overlap | minor | client content | shrine | tap_anchor lobby_upgrades, upgrade_buy [upgrade_vitality] with 0 gold → Six rows show level, effect and cost. The press buys nothing. A dim full-width toast band with tiny text `금화가 부족해요` sits across the middle of the panel and overlaps the row text | The row already shows `금화가 부족해요` in red, so the toast is redundant. It is small and covers the row text | captures/mvllohojba6a6b-1792798105561.png, records/loops/create-1792781138827/play-3-1.md:18, minor, records/loops/create-1792781138827/play-3-2.md:25, captures/mvllov46c1f92d-1792798129035.png, records/loops/create-1792781138827/play-3-3.md:18 | play | open |
| shrine-unaffordable-button-state | minor | client content | 83000 | scene/lobby/lobby → upgrade panel | every `강화` button keeps the same bright yellow whether the row is affordable or not; only the cost number and the small red `금화가 부족해요` line differ | minor, records/loops/create-1792781138827/play-3-2.md:26 | play | open |
| move-hint-missing | minor | client content | run | key_down D, 2s → Timer 0:02. The player moved right. The first enemy (a ghoul) showed at the bottom. No move hint was visible at the bottom | The hint the guide describes was not seen. It may have been gone already or may be missing | captures/mvllpcfbb96863-1792798162815.png, records/loops/create-1792781138827/play-3-5.md:18 | play | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 33 is below targetFps 60 (3 samples) | the camp must hold targetFps; the 5th percentile is 33 (hostLoad memory 83.4%) | records/loops/create-1792781138827/check-3.json#performance, records/loops/create-1792781138827/evidence/check-3/performance-macos/samples.json | check | open |
| early-xp-pace-slow | major | data | vs reference: progression | Lv 1 at 0:32 in the first run, and Lv 2 only by 0:27 in the second run. Both are later than the reference's level-up at 00:21. | worse than the reference game, so `vs reference` is `fail` | ref frames 19000–22000 ms; B mvlgnomafe63e4 capture 1792790005382 (0:32, Lv 1); mvlgop1515ebff capture 1792790726389 (0:27, Lv 2), records/loops/create-1792781138827/judge-2-1.md | judge | fixed |
| attack-feedback-weak | major | client content | vs reference: game feel | Same as `A`, apart from the HP bar under the player. There is no slash or impact effect at the level of the whip arc, and the telemetry shows no feedback on inputs in the interval. | worse than the reference game, so `vs reference` is `fail` | ref frame 15000 ms; B mvlgnomafe63e4 capture 1792789861070 (0:12); compare interval 95877–370530: feedback_per_input B 0, records/loops/create-1792781138827/judge-2-1.md | judge | fixed |
| code-drawn-ui-flat | major | client content | HP bar under the player | A flat dark-red rectangle with a fill. | A code-drawn box in the field (`presentation`). | mvlgnomafe63e4 1792789764046, ref frames 0, 5000, 21000 ms; B mvlgnomafe63e4 captures 1792789764046, 1792790381040, records/loops/create-1792781138827/judge-2-1.md | judge | fixed |
| damage-numbers-overlap | major | client content | scene/run/run | hold D 3200ms then hold W 3000ms in steps → Timer 10:06, HP 68/100, kills 4,514, gold 1,188 | Damage numbers (19/27/30/63) stack and overlap near the player, hard to read; enemies are plain boxes, tough to tell enemies from gems and scenery (blue and lilac cubes of the same palette) | captures/mvlhf2mp000630-1792790995592.png, records/loops/create-1792781138827/play-2-4.md:17 | play | fixed |
| meta-upgrade-not-visible | minor | client content | ~350000 | run → tap_anchor upgrade_close, lobby_play | the new run showed health 115/115 (+15 from vitality) and a small plate under the weapon row with 2 icons marked 1 and 1 | minor, records/loops/create-1792781138827/play-2-1.md:24 | play | fixed |
| fall-input-latency | minor | client content | first-failure interval | input_latency_ms 373 in the interval that includes the low-HP and fall sequence (whole session 20 vs A 2). | Inputs are slower to respond around the fall (`game feel`). | `ogw telemetry compare` interval 370530–767404 | judge | fixed |
| levelup-card-text-wrap | minor | client content | level-up | 60 steps after the pick → second level-up at 0:24 with Lv 3, health 72/100, kills 27; cards `낙뢰`, `등불 탄환 Lv 2`, `질풍 장화`. The description of `낙뢰` wraps to `다` alone on a second line | consistent with the first popup; health already lost 28 in 24 s | captures/mvlhev4u85ad06-1792791180545.png, records/loops/create-1792781138827/play-2-3.md:25 | play | fixed |
| play-guide-anchor-key-form | minor | design | ~310000 | lobby → tap_anchor upgrade_buy upgrade_vitality (no brackets) | `ok:false`, the key was rejected; the guide wrote the key as `[upgrade_vitality]`, and with brackets it worked | minor, records/loops/create-1792781138827/play-2-1.md:22 | play | fixed |
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
| no_response_permille | 114 | 0..150 | in |
| scene_load_ms | 510 | 0..3000 | in |
| restart_delay_ms | 19565 | 2000..60000 | in |
| feedback_per_input | 2 | 1..1000 | in |
| first_reward_ms | 46768 | 5000..60000 | in |
| reward_interval_ms | 9582 | 8000..45000 | in |
| goal_interval_ms | 100217 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":58.8,"memoryMaxPercent":83.4,"instancesMax":4} |
