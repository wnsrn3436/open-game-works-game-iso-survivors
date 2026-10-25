## commit

- instance: cc39e52094a0797fb37072e2ab87a0012e8f2ef3
- baseline: e7d6e3ed6c16523bb0e5f08e38a2642211514e75
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/update-1792903851574/check-1.json |
| static check | pass | records/loops/update-1792903851574/check-1.json |
| no blocker | pass | records/loops/update-1792903851574/check-1.json |
| full flow | pass | records/loops/update-1792903851574/check-1.json |
| performance | fail | records/loops/update-1792903851574/check-1.json |
| UI quality | fail | records/loops/update-1792903851574/check-1.json |
| no placeholder | pass | records/loops/update-1792903851574/check-1.json |
| row simulation | pass | records/loops/update-1792903851574/check-1.json |

## judge

### records/loops/update-1792903851574/judge-1-4.md

- kind: main
- status: done
- A: cc39e52094a0797fb37072e2ab87a0012e8f2ef3
- B: e7d6e3ed6c16523bb0e5f08e38a2642211514e75
- vs baseline: better
- vs reference: fail
- omitted moments: none

#### moments

- `A` is better at titles_and_buttons. Reason: on the camp, shrine, level-up, pause and result screens, A draws the titles (`등불 제단`, `레벨 업!`, `일시 정지`, `원정을 포기했다`) and button labels (`원정 시작`, `계속하기`, `원정 포기`, `다시 출발`, `야영지로`, `닫기`) in bold with a drop shadow. B draws the same strings in regular weight, so they read thinner on the wood and gold buttons. Banner, panel and button art and positions are the same, and telemetry is the same (reward_interval_ms 2350/2350, goal_input_count 18/18).
- `A` is better at first 30000ms. Reason: telemetry idle_span_ms is A 23931 vs B 32666. Both spans are the camp wait before the run tap. Apart from text weight the screens (terms, camp) are the same.
- `B` is better at core action. Reason: telemetry input_latency_ms is B 16 vs A 17 with feedback_per_input 4/4. On screen, both show auto weapons, damage numbers and gem drops on the same dark graveyard field.
- `B` is better at first reward. Reason: telemetry feedback_per_input is B 5 vs A 4 in the first-reward window. Both show the same level-up popup with 3 painted cards, and only the text weight differs.
- Indistinguishable at first failure. Reason: both turn the field red, show `등불이 꺼졌다…`, and open the result panel about 1.6 s after `Fail` (A 596897→610606, B 739388→752442). A's window had no input telemetry.
- Indistinguishable at restart. Reason: restart_delay_ms is 2750 vs 2700, and `다시 출발` starts a new run at 0:00 with the move hint in both, with feedback_per_input 1/1.

#### loser better

- A won presentation and no friction, and B won game feel. What B did better: in the first-reward window B logged 5 feedback events per input vs 4 for A, and over the whole session B logged feedback_per_input 4 vs 2 for A. Input latency was 16 ms vs 17 ms in the core action window.
- What A did better: bold, shadowed heading and button text on every titled screen, and a shorter camp idle span in the first 30000 ms.

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/update-1792903851574/play-1-5.md | 0 | 0 | 2 | 18 |
| records/loops/update-1792903851574/play-1-6.md | 0 | 0 | 3 | 13 |
| records/loops/update-1792903851574/play-1-7.md | 0 | 0 | 5 | 11 |
| records/loops/update-1792903851574/play-1-8.md | 0 | 0 | 5 | 11 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| run-hud-flat-boxes | major | client content | run HUD, camp gold counter, result stat rows | The left health/weapon panel (about 538×211 px, mostly empty below 2–7 small icons), the right kill/gold panel, the camp gold counter box and the three result stat rows are flat translucent navy rectangles with a 1 px border, not art frames. | They are single-color boxes made in code, while the popups and buttons use framed art, so each screen mixes two styles. | mvnggsu84633f1-1792910614633.png`, `mvnggsu84633f1-1792910765030.png`, `mvngh6cue7a91d-1792910307168.png`, `mvnggsu84633f1-1792910874789.png, `mvnggsu84633f1-1792910614633.png` (HUD boxes), `mvngh6cue7a91d-1792910307168.png` (gold counter), `mvnggsu84633f1-1792910874789.png` (stat rows); ref 0–30000, records/loops/update-1792903851574/judge-1-4.md | judge | open |
| shrine-buy-button-clipped | major | client content | scene/lobby/lobby | clipped UICore/Panel/SafeAreaRoot/UpgradePanel/Frame/Box/Grid/Entry1/Row/Side/Buy in prefab/lobby/upgrade_panel (ko, macbook_air_13, lobby.open_upgrades, text scale 1000) | UI quality requires no clipping on every supported screen and language | records/loops/update-1792903851574/check-1.json#UI quality, records/loops/update-1792903851574/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792903851574/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792903851574/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.json | check | open |
| early-levelup-too-frequent | major | data | reward_interval_ms | value 6850 out of 8000..45000 | the reward interval must be inside the target range of design.md | records/loops/update-1792903851574/measure-1.json#reward_interval_ms, captures/mvnghsz640ed6e-1792910396448.png, records/loops/update-1792903851574/play-1-6.md:22 | check | open |
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 36 is below targetFps 60 (2 samples) | the run must hold targetFps; the 5th percentile is 36 | records/loops/update-1792903851574/check-1.json#performance, records/loops/update-1792903851574/evidence/check-1/performance-macos/samples.json | check | open |
| run-field-too-dark | minor | client content | scene/run/run | tap_anchor lobby_play → the run started at 0:00. The field is very dark, with the player lit by a small glow and the move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom | the hint is useful, but enemies and gems are hard to see away from the player | captures/mvnghmee7268b5-1792910326173.png, records/loops/update-1792903851574/play-1-5.md:19, captures/mvnghsz640ed6e-1792910336565.png, records/loops/update-1792903851574/play-1-6.md:21, captures/mvngi7et550e80-1792910349763.png, records/loops/update-1792903851574/play-1-8.md:15, captures/mvngi7et550e80-1792910377039.png, records/loops/update-1792903851574/play-1-8.md:17, mvngh6cue7a91d` capture at 0:03 (`-1792910355352.png`), `mvnggsu84633f1-1792910614633.png | play | open |
| player-hard-to-see-in-crowd | minor | client content | scene/run/run | standing still → 1:55: Lv 11, 311 kills, health 12/140. The ring flame weapon surrounds the player, `체력이 위험해요!` shows under the player, the health numbers are red | The danger text and red numbers are clear. The screen is crowded: with 25+ enemies, damage numbers and the ring, the player is hard to see | captures/mvnghzx2c2cea7-1792910992989.png, records/loops/update-1792903851574/play-1-7.md:26 | play | open |
| standing-still-survives | minor | data | scene/run/run | key_up D, key_up S (standing still) → 1:16: Lv 5, 79 kills, health 76/120 while standing still in a crowd of about 25 enemies; 1:21: health 42/120; Lv 6 | A player who does not move still gets to 2 minutes and Lv 12, so a moving player is not rewarded much in the first 2 minutes | captures/mvnghzx2c2cea7-1792910762378.png, records/loops/update-1792903851574/play-1-7.md:25 | play | open |
| upgrade-cost-curve-steep | minor | data | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_vitality], [upgrade_magnet] → Both bought: gold 112 → 42, `Lv 1/5` and `Lv 1/3` with one lit pip, the next costs went from 40 → 100 and 30 → 90, and the toast `자력 강화 완료!` shows over the middle of the panel | The purchase answers at once. The cost of the next level is 2.5~3 times the first, which makes the second level far from the gold of one short run | captures/mvnghzx2c2cea7-1792911082188.png, records/loops/update-1792903851574/play-1-7.md:31 | play | open |
| levelup-card-empty-space | minor | client content | level-up popup | The lower third of each card (about y 770–890) is empty below the description. | The cards look unfinished or padded. | mvngh6cue7a91d-1792910429751.png | judge | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 34 is below targetFps 60 (3 samples) | the camp must hold targetFps; the 5th percentile is 34 | records/loops/update-1792903851574/check-1.json#performance, records/loops/update-1792903851574/evidence/check-1/performance-macos/samples.json | check | open |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 16 | 0..100 | in |
| no_response_permille | 0 | 0..150 | in |
| scene_load_ms | 517 | 0..3000 | in |
| restart_delay_ms | 3278 | 2000..60000 | in |
| feedback_per_input | 5 | 1..1000 | in |
| first_reward_ms | 40171 | 5000..60000 | in |
| reward_interval_ms | 6850 | 8000..45000 | out |
| goal_interval_ms | 68993 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":21.5,"memoryMaxPercent":80.3,"instancesMax":3} |
