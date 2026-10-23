# judge result — run create-1792781138827, iteration 1

Input: `A` = `mvldzqoec49a81` (played from the first screen as a new user), `B` = `null`. Fixture instances: `late_run_horde` = `mvldzxt6027bf0`, `second_run_after_meta_upgrade` = `mvle08ri4493c4`. Reference: Vampire Survivors, `reference-video-1.mp4`.

Capture names are `<instance id>-<unix ms>.png` under `captures/`. In-run timer values are read from the HUD in each capture.

Because `B` is `null`, there was no `ogw telemetry compare`. All telemetry values below come from `ogw telemetry <instance>` and its `--summary`.

## vs baseline

none

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | fail | Telemetry shows a fast response: `input_latency_ms` averages 14.9 and peaks at 35, and 12 of 13 movement `key_down` inputs got feedback (Sound/Tween/Effect). On screen, though, the shot and its target cannot be told apart. Enemies, XP gems and obstacles are all the same lavender box, so a hit shows only as a white damage number (`12`) away from the player. In the reference at 10000–17000ms the whip arc, bat sprites and blue gems are each distinct. | `ogw telemetry mvldzqoec49a81`: 31 inputs, latency mean 14.9 / max 35, feedback per input mean 6.42, 13 zero-feedback inputs (12 `key_up`, 1 `key_down` at run start). Captures `mvldzqoec49a81-1792785349205` (0:08), `mvldzqoec49a81-1792785430118` (0:14). Reference frames 10000–17000ms |
| A | `tension and release` | fail | In the first run there is nothing that can fail for over a minute. Standing still from 0:26 to 0:56 cost 0 health while kills rose from 22 to 68, and the first hit came at about 1:10 (97/100). At the late-run moment the player died buried under enemy boxes. The frame at health 0/200 shows the field unchanged: no tint, no death pose, and the player not visible. The result panel then opens. In the reference at 496000–504000ms the field turns red with `GAME OVER` over the visible character before the results. Reward after success is present: the level-up pick logged Sound 5, CameraShake 1, Tween 8, Effect 8 | Captures `mvldzqoec49a81-1792786007963` (0:56, 100/100, 68 kills), `mvldzqoec49a81-1792786185633` (1:10, 97/100), `mvldzxt6027bf0-1792786394742` (10:12, 0/200), `mvldzxt6027bf0-1792786417980` (result panel). Telemetry `mvldzxt6027bf0`: Fail at play 1065030, Goal (panel) at 1066730. Reference frames 496000–503000ms |
| A | `progression` | pass | The first level-up came at 0:25 of the first run, against 0:21 in-run in the reference (video 21000ms). On the second run after the meta upgrade it came at 0:12. The popup shows 3 cards with a `새로 얻기` (new) tag, name and effect text, and picking one adds the weapon to the HUD and fires a lightning column. The level 2→3 gap was 39.5s | `ogw telemetry mvldzqoec49a81` rewards at play 118069 and 157619 (interval 39550ms). `ogw telemetry mvle08ri4493c4` reward at play 1280347, run resumed at about 1268300. Captures `mvldzqoec49a81-1792785608830` (0:25 popup), `mvldzqoec49a81-1792785638171` (0:26 lightning), `mvle08ri4493c4-1792786617086` (0:12 popup). Reference frames 19000–23000ms |
| A | `one more run` | n/a | `restart` has `startMs` `null` in the reference moments | — |
| A | `no friction` | pass | From the terms popup to a running run takes 3 taps (`terms_agree_all`, `terms_confirm`, `lobby_play`), and the scene loads take 542ms (lobby) and 650ms (run). The reference needs about 9s of menus (title, character, stage) before the run. No idle span was logged inside the run. The two idle spans that were logged (77975ms on the terms screen, 11629ms in the lobby) both start at a screen being ready and end at my first input there, so they measure my capture time, not a wait the game imposed | `ogw telemetry mvldzqoec49a81`: idle_spans 77975, 11629; scene_loads lobby 542, run 650; goal_intervals empty. Captures `mvldzqoec49a81-1792785233362` (terms), `mvldzqoec49a81-1792785245517` (lobby), `mvldzqoec49a81-1792785269673` (run 0:02). Reference frames 0–30000ms |
| A | `presentation` | fail | I did not judge the placeholders (`BUTTON`, `PLATE`, `BAR_FRAME`, `PANEL_FRAME`, `GROUND`, `TIMER`, `KILLS`, `GOLD`, card icons). What remains in the first 30000ms is the run field. The player, every enemy, the XP gems and the obstacles are untextured lavender boxes made in code, with one color and no silhouette difference. Damage numbers are plain white digits. The reference first 30000ms has pixel-art menus, distinct bat and character sprites, blue gem sprites and a red health bar under the character | Captures `mvldzqoec49a81-1792785269673` (0:02), `mvldzqoec49a81-1792785551911` (0:25), `mvldzqoec49a81-1792786007963` (0:56). Reference frames 0–27000ms |

## moments

- first 30000ms of `A`: terms popup → lobby → run took 3 taps, with scene loads of 542ms and 650ms. The run opens at 0:00 with the move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom. By 0:25 there were 20 kills, 7 gold and the first level-up popup. Health stayed at 100/100 for the whole 30s (`mvldzqoec49a81`, captures 1792785269673–1792785608830).
- core action of `A`: holding a move key moves the lit box player and the camera follows. The auto weapon kills boxes at a distance, with white `12` damage numbers. Enemies, gems and obstacles share one lavender box look, so the target of each hit cannot be told on screen (`mvldzqoec49a81`, 0:04–0:19).
- first reward of `A`: level 2 at 0:25. Three cards: `질풍 장화` (move speed +8%), `분노의 불씨` (damage +10%), `낙뢰` (lightning). Picking `3` logged Sound 5, CameraShake 1, Tween 8, Effect 8, and a lightning column appeared at 0:26 (`mvldzqoec49a81-1792785638171`).
- first failure of `A`: the first run took no damage until about 1:10, and I did not see a death there. The failure I observed is on fixture `mvldzxt6027bf0`: standing still from 10:01, health went 200 → 184 (10:06) → 40 (10:10) → 0 (10:12), with the player covered by enemy boxes. The 0/200 frame shows no death presentation. The result panel `어둠에 쓰러졌다` lists 10분 12초, 4,493 kills, level 46 and gold +1,184 (Fail → panel 1700ms of game time).
- restart of `A`: `다시 출발` on the result panel started a new run, at 0:01 within 1000ms of game time (scene load 514ms, Restart mark at play 1067930). The new run starts again at Lv 1 with the lantern bolt only (`mvldzxt6027bf0-1792786447144`).
- late_run_horde of `A`: at 10:00 the player is Lv 45 with 4 weapons and 4 passives, all at level 5, and 200/200 health. Hundreds of boxes fill the screen around a white aura square, with stacked damage numbers (13, 20, 42) and enemies hit-tinted pink. When every item is at max, the level-up offers only one card, `따뜻한 수프` (heal 30) (`mvldzxt6027bf0`, 1792786249377, 1792786300717, 1792786369873).
- second_run_after_meta_upgrade of `A`: the run starts with 100/100 health and the lantern bolt. The HUD shows nothing about the bought upgrade. The first level-up came at 0:12, offering `바람의 깃털`, `분노의 불씨` and `자석 부적`. At 0:29 the player had 27 kills, 8 gold and 85/100 health (`mvle08ri4493c4`, 1792786466359, 1792786617086, 1792786763384).

## loser better

none

## strengths

- Input response: `input_latency_ms` averages 14.9 (max 35) on `mvldzqoec49a81`. The level-up card pick logged 5 sounds, 1 camera shake, 8 tweens and 8 effects.
- Short way into play: 3 taps from the terms popup to a running run, with the lobby and run scenes loading in 542ms and 650ms. The reference needs about 9s of menus first.
- Fast loop after a fall: the result panel opens 1700ms (game time) after the fall and shows survived time, kills, level, gold and a pointer to the lantern shrine. One tap on `다시 출발` puts a new run at 0:01 (scene load 514ms).
- The late run at 10:00 shows the end state of a build: 8 slots at level 5, lightning, an aura and a thrown weapon all active, with hundreds of enemies on screen at once.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | run field, all times | Player, enemies, XP gems and obstacles are all the same lavender box with no texture | You cannot tell what to avoid, what to pick up or what the weapon hits. Hits are shown only by floating numbers | major | `mvldzqoec49a81-1792786007963` (0:56), `mvldzxt6027bf0-1792786300717` (10:06) |
| A | first minute of a run | No threat: standing still from 0:26 to 0:56 cost 0 health, and the first hit came at about 1:10 | There is no challenge that can fail in the opening, so the first minute has no tension | major | `mvldzqoec49a81-1792786007963` (0:56, 100/100), `mvldzqoec49a81-1792786185633` (1:10, 97/100) |
| A | late run, moment of death | The player box is hidden under enemy boxes, and health went from 184 to 0 in 6s with nothing showing on the player | The cause of failure is visible only as the health number; the player cannot see the hits land | major | `mvldzxt6027bf0-1792786300717` (10:06, 184/200), `mvldzxt6027bf0-1792786369873` (10:10, 40/200), `mvldzxt6027bf0-1792786394742` (10:12, 0/200) |
| A | fall → result panel | At health 0 the field shows no death presentation (no tint, no title, no player reaction) before the result panel | The fall has no moment of its own. The reference shows a red-tinted `GAME OVER` over the field | minor | `mvldzxt6027bf0-1792786394742` (10:12, 0/200), telemetry Fail at play 1065030, panel at 1066730 |
| A | level 2 → 3 | 39.5s between the first and second level-up in the first run | That is a long gap with no visible growth early in the run | minor | `ogw telemetry mvldzqoec49a81` rewards at play 118069 and 157619 |
| A | second run HUD | Nothing on the run HUD shows the permanent upgrade bought with the first run's gold (health 100/100, the same start as the first run) | The player cannot see that the meta purchase changed anything | minor | `mvle08ri4493c4-1792786466359` (0:00), `mvle08ri4493c4-1792786763384` (0:29) |
