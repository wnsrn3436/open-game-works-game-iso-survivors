# judge result — run update-1792903851574, iteration 1

Instances: A main `mvnggsu84633f1`, B main `mvnggzlxe8c134`, A fixture `titles_and_buttons` `mvngh6cue7a91d`, B fixture `titles_and_buttons` `mvngheb052599c`. All captures are in `captures/` under the judge folder. `play ms` values below are those printed by `ogw step` / `ogw telemetry --summary`.

Telemetry windows used (`ogw telemetry compare`):
- `first 30000ms`: A 290438–320438, B 284082–314082 (terms tap → camp → run start)
- `core action`: A 316049–596897, B 318314–739388 (`원정 시작` tap → fall)
- `first reward`: A 366218–405147, B 367582–406488 (first `Reward` mark: A play ms 402681, B 403857)
- `first failure`: A 580163–610606, B 737971–752442 (`Fail` A 596897 / B 739388, `Goal` result panel A 610606 / B 752442)
- `restart`: A 610606–646687, B 752442–766048 (`다시 출발` → new run 0:00)
- `titles_and_buttons` fixture: whole instances

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| game feel | B | slight | In the `core action` window, telemetry gave B: input_latency_ms 16 vs 17, and feedback_per_input is the same at 4. | `ogw telemetry compare` core action window: input_latency_ms A 17 / B 16 (d 0.059), feedback_per_input A 4 / B 4. First-reward window: feedback_per_input A 4 / B 5 (B clear). Whole run: feedback_per_input A 2 / B 4 |
| tension and release | indistinguishable | slight | No telemetry. Both have the same failure points (contact damage, 0.7 s hit glow, red health bar) and the same success reward (level-up popup at about 0:06). The fall shows the same red field, title and result panel. | A `mvnggsu84633f1-1792910856205.png` (0:38, 0/100, `등불이 꺼졌다…`), B `mvnggzlxe8c134-1792911009108.png` (1:16, 0/120, same title); level-up popups A `mvngh6cue7a91d-1792910429751.png`, B `mvngheb052599c-1792910484545.png` |
| progression | indistinguishable | slight | Telemetry reward_interval_ms is 7450 vs 7500 (d 0.007), so it reports indistinguishable. | `ogw telemetry compare` core action window: reward_interval_ms A 7450 / B 7500; fixture: 2350 / 2350 |
| one more run | indistinguishable | slight | Telemetry restart_delay_ms is 2750 vs 2700 (d 0.018), so it reports indistinguishable. | `ogw telemetry compare` whole: restart_delay_ms A 2750 / B 2700; restart captures A `mvnggsu84633f1-1792910891951.png`, B `mvnggzlxe8c134-1792911024964.png` |
| no friction | A | clear | Telemetry idle_span_ms is A 23931 vs B 32666 (d 0.267). In both games this span is the camp wait before the judge pressed `원정 시작`, so it is judge pacing and not a game wait. Telemetry is used as given. | `ogw telemetry compare` first-30000 window: idle_span_ms A 23931 / B 32666; scene_loads run 512 ms (A) |
| presentation | A | slight | No telemetry. A draws every title and button label in bold with a dark drop shadow: `레벨 업!`, `일시 정지`, `계속하기`, `원정 포기`, `원정을 포기했다`, `다시 출발`, `야영지로`, `등불 제단`, `원정 시작`, `나의 기록`, the HUD timer and `Lv`. B draws them in regular weight with thin strokes. Art, layout and panels are the same pixel for pixel. | fixture camp A `mvngh6cue7a91d-1792910307168.png` / B `mvngheb052599c-1792910309262.png`; shrine A `-1792910325869` / B `-1792910326910`; pause A `-1792910498928` / B `-1792910503908`; result A `-1792910519113` / B `-1792910525504`; terms A `mvnggsu84633f1-1792910303264.png` / B `mvnggzlxe8c134-1792910305159.png` |

## vs reference

Reference: Vampire Survivors, `reference-video-1.mp4`. Frames viewed: 0–30000 ms (every 3000), 10000–17000 (every 2000), 19000–23000 (every 1000), 496000–504000 (every 2000).

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | game feel | pass | Movement answers in 17 ms, and each key_down gives Tween+Effect feedback. Auto attacks show a lantern fireball glow, scythe arcs, floating damage numbers (`12`, `9`) and gem drops. The reference at 10–17 s shows whip slashes killing bats and gem drops at a similar density of feedback. | `mvnggsu84633f1-1792910614633.png` (0:06), `-1792910765030.png` (0:23); ref frames 10000–16000 |
| A | tension and release | pass | The game can be lost: contact damage killed a standing player at 0:38. The fall turns the field red and shows the title `등불이 꺼졌다…`, and the result panel follows after about 1.6 s. Success gets a level-up popup about 6 s in. The reference at 496–504 s shows a red tint and `GAME OVER` over a swarm. Neither side shows a stronger failure beat. | `mvnggsu84633f1-1792910856205.png`, `-1792910874789.png`; ref 498000, 502000 |
| A | progression | pass | First level-up comes at about 0:06 of the run, and rewards keep coming about 7.45 s apart. The popup has 3 painted cards (`낙뢰`, `회전 낫`, `등불 탄환 Lv 2`). The reference at 19–23 s shows a level-up at 0:21 with 3 options and a gem burst. | reward_interval_ms 7450; `mvngh6cue7a91d-1792910429751.png`; ref 19000–21000 |
| A | one more run | n/a | The `restart` moment has `startMs` null in the reference. | input.json |
| A | no friction | pass | Two taps lead from terms to camp, and one more tap starts the run. The run scene loads in 512 ms. The reference spends about 10 s in character select before play. | scene_loads run 512 ms; telemetry goal_input_count 35 for the whole run |
| A | presentation | fail | Camp, shrine, popups and buttons use art frames. The run HUD does not: the left health/weapon panel (about 538×211 px, mostly empty), the right kill/gold panel, the camp gold counter and the result stat rows are flat translucent navy boxes with a 1 px border. The field is so dark that enemies at the screen edge are barely visible. The reference keeps one pixel-art style with framed UI. | `mvnggsu84633f1-1792910614633.png` (HUD boxes), `mvngh6cue7a91d-1792910307168.png` (gold counter), `mvnggsu84633f1-1792910874789.png` (stat rows); ref 0–30000 |
| B | game feel | pass | Movement answers in 16 ms, with Tween+Effect feedback on key_down. Lightning, aura ring and damage numbers (`12`, `22`) show on hits. Feedback density is like the reference at 10–17 s. | `mvnggzlxe8c134-1792910792464.png` (0:28), `-1792911009108.png`; ref 10000–16000 |
| B | tension and release | pass | The standing player died at 1:16 (0/120). The field turns red, the `등불이 꺼졌다…` title shows, then the result panel opens. Success gets a level-up popup. This matches the reference failure beat. | `mvnggzlxe8c134-1792911009108.png`, `-1792911015155.png`; ref 498000 |
| B | progression | pass | Level-up popup at about 0:06–0:09, rewards about 7.5 s apart, 3 painted cards (`성화 오라`, `분노의 불씨`, `자석 부적`). | reward_interval_ms 7500; `mvngheb052599c-1792910484545.png`; ref 20000 |
| B | one more run | n/a | The `restart` moment has `startMs` null in the reference. | input.json |
| B | no friction | pass | Same path and load time as A: terms → camp → run in 3 taps, run load about 0.5 s. | fixture/main scene_loads |
| B | presentation | fail | B has the same flat translucent HUD boxes, gold counter and stat rows as A, plus thin regular-weight titles over banner art. The field is just as dark. | `mvnggzlxe8c134-1792910792464.png`, `mvngheb052599c-1792910309262.png`, `mvnggzlxe8c134-1792911015155.png` |

## moments

- `A` is better at titles_and_buttons. Reason: on the camp, shrine, level-up, pause and result screens, A draws the titles (`등불 제단`, `레벨 업!`, `일시 정지`, `원정을 포기했다`) and button labels (`원정 시작`, `계속하기`, `원정 포기`, `다시 출발`, `야영지로`, `닫기`) in bold with a drop shadow. B draws the same strings in regular weight, so they read thinner on the wood and gold buttons. Banner, panel and button art and positions are the same, and telemetry is the same (reward_interval_ms 2350/2350, goal_input_count 18/18).
- `A` is better at first 30000ms. Reason: telemetry idle_span_ms is A 23931 vs B 32666. Both spans are the camp wait before the run tap. Apart from text weight the screens (terms, camp) are the same.
- `B` is better at core action. Reason: telemetry input_latency_ms is B 16 vs A 17 with feedback_per_input 4/4. On screen, both show auto weapons, damage numbers and gem drops on the same dark graveyard field.
- `B` is better at first reward. Reason: telemetry feedback_per_input is B 5 vs A 4 in the first-reward window. Both show the same level-up popup with 3 painted cards, and only the text weight differs.
- Indistinguishable at first failure. Reason: both turn the field red, show `등불이 꺼졌다…`, and open the result panel about 1.6 s after `Fail` (A 596897→610606, B 739388→752442). A's window had no input telemetry.
- Indistinguishable at restart. Reason: restart_delay_ms is 2750 vs 2700, and `다시 출발` starts a new run at 0:00 with the move hint in both, with feedback_per_input 1/1.

## loser better

- A won presentation and no friction, and B won game feel. What B did better: in the first-reward window B logged 5 feedback events per input vs 4 for A, and over the whole session B logged feedback_per_input 4 vs 2 for A. Input latency was 16 ms vs 17 ms in the core action window.
- What A did better: bold, shadowed heading and button text on every titled screen, and a shorter camp idle span in the first 30000 ms.

## strengths

- Fall and restart loop: the field turns red, the player tips over, and the large title `등불이 꺼졌다…` shows. The result panel then lists survival time, kills, level and gold (`금화 +19`, `금화 +52`). `다시 출발` starts a new run in about 2.7 s (restart_delay_ms 2750/2700).
- Level-up popup at about 0:06 of the first run, with three framed cards with painted icons (lightning bolt, twin scythes, lantern, magnet, fire fist) and `새로 얻기` / `Lv 2` labels. After that, rewards come about every 7.5 s.
- Camp screen art: a painted hooded hero holding a lit lantern beside a campfire and tent, a winged title logo, the framed `나의 기록` card, and wood/gold buttons. The shrine panel has six lantern-icon upgrade rows with level pips and coin-cost buttons.
- Input responds in 16–17 ms, and each move key_down gives Tween+Effect feedback. Hits show glow bursts and floating damage numbers.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | run HUD, camp gold counter, result stat rows | The left health/weapon panel (about 538×211 px, mostly empty below 2–7 small icons), the right kill/gold panel, the camp gold counter box and the three result stat rows are flat translucent navy rectangles with a 1 px border, not art frames. | They are single-color boxes made in code, while the popups and buttons use framed art, so each screen mixes two styles. | major | `mvnggsu84633f1-1792910614633.png`, `mvnggsu84633f1-1792910765030.png`, `mvngh6cue7a91d-1792910307168.png`, `mvnggsu84633f1-1792910874789.png` |
| B | run HUD, camp gold counter, result stat rows | Same flat translucent navy boxes as A. | Same as A. | major | `mvnggzlxe8c134-1792910792464.png`, `mvngheb052599c-1792910309262.png`, `mvnggzlxe8c134-1792911015155.png` |
| A | run field | The field is dark navy and the enemies (grey zombies, purple bats) at the screen edges have low contrast. At 0:03 the bats at the bottom right are hard to make out. | Threats coming from off-screen are hard to read, and the reference field is bright and high-contrast. | minor | `mvngh6cue7a91d` capture at 0:03 (`-1792910355352.png`), `mvnggsu84633f1-1792910614633.png` |
| B | run field | Same dark, low-contrast field. | Same as A. | minor | `mvngheb052599c-1792910368328.png`, `mvnggzlxe8c134-1792910792464.png` |
| A | level-up popup | The lower third of each card (about y 770–890) is empty below the description. | The cards look unfinished or padded. | minor | `mvngh6cue7a91d-1792910429751.png` |
| B | level-up popup | Same empty lower third in each card. | Same as A. | minor | `mvngheb052599c-1792910484545.png` |
| B | run HUD weapon icons | The level digit `1` overlaps the bottom-right of the aura, magnet and heart icons. | The digit runs into the icon art and is hard to read. | minor | `mvngheb052599c-1792910503908.png` (aura), `mvnggzlxe8c134-1792911009108.png` (magnet, heart) |
| A | level-up in step mode | When the level-up popup opened, `ogw step` did not stop on a popup change. It reported `step failed: "the command went over its time limit"`, and later steps reported `"game time is paused"`. | The popup is not reported as a `popups` change in `get_state`, so automated play stalls at every level-up. | minor | play log: A main iterations 2–11; A fixture step before `-1792910429751.png` |
| B | level-up in step mode | Same: `the command went over its time limit` at each level-up. | Same as A. | minor | play log: B main iterations; B fixture step before `-1792910484545.png` |
