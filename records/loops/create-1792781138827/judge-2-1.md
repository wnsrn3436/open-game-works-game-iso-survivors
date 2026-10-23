# judge result — run create-1792781138827, iteration 2

Instances: `A` = mvlgnhstb809f6 (fixtures: late_run_horde mvlgnujp125740, second_run_after_meta_upgrade mvlgoegw10f1de); `B` = mvlgnomafe63e4 (fixtures: late_run_horde mvlgo4i1c37b3e, second_run_after_meta_upgrade mvlgop1515ebff). Reference: Vampire Survivors, `input/reference-video-1.mp4`.

How each game was played: new user → terms → camp → `원정 시작` in step mode (200 ms steps). In the first 30 s I walked D/S/A/W in 5 s legs. After that I stood still until the first fall, pressing `1` on every level-up popup. Then I tapped `다시 출발`. I played the fixture instances after `pause_resume` with the same movement loop: about 10 s for late_run_horde and 30 s for second_run_after_meta_upgrade.

The telemetry intervals below are `play ms` values read with `ogw telemetry <id> --summary`:
- `A` main: first 30000ms 100801–377380, first failure/first reward 377380–758281, restart 758281–774404
- `B` main: first 30000ms 95877–370530, first failure/first reward 370530–767404, restart 767404–781842
- late_run_horde: `A` 825453–936962, `B` 813059–926422
- second_run_after_meta_upgrade: `A` 799068–1020290, `B` 783933–1034826

The element winners and margins come from the whole-session `ogw telemetry compare mvlgnhstb809f6 mvlgnomafe63e4`. The per-moment interval results are under `## moments`.

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| `game feel` | B | decisive | In the telemetry, `B` gives feedback on inputs (feedback_per_input 1 vs 0), though its input latency is higher (20 vs 2 ms). | `ogw telemetry compare` whole session: input_latency_ms A 2 / B 20 (d 0.9), feedback_per_input A 0 / B 1 (d 1). Interval 377380–758281 / 370530–767404: feedback_per_input A 9 / B 18, input_latency_ms A 2 / B 373 |
| `tension and release` | B | slight | `B` makes failure visible before it happens: an HP bar under the player and `체력이 위험해요!` at low health. At the fall it tints the field red and shows `등불이 꺼졌다…`. `A` has no in-field warning and no fall presentation. | B mvlgnomafe63e4 captures 1792790322414 (0:53, 16/100, `체력이 위험해요!`), 1792790339695 (0:55, 0/100, red field and `등불이 꺼졌다…`). A mvlgnhstb809f6 captures 1792790286872 (0:50, 0/100, no tint and no text), 1792790295980 (result panel already open) |
| `progression` | A | decisive | Telemetry: rewards come every 3200 ms in `A` against 10574 ms in `B`. | `ogw telemetry compare` reward_interval_ms A 3200 / B 10574 (d 0.697) |
| `one more run` | B | decisive | Telemetry: `B` gets from the fall back into a new run faster (2401 vs 6400 ms). | `ogw telemetry compare` restart_delay_ms A 6400 / B 2401 (d 0.625) |
| `no friction` | A | slight | `A` has a slightly shorter longest idle span and needs fewer inputs to reach the goal. | `ogw telemetry compare` idle_span_ms A 11322 / B 12669 (d 0.106), goal_input_count A 31 / B 34 (d 0.088) |
| `presentation` | A | slight | Both games share the same placeholder art, flat level-up/result/pause panel backgrounds and box-primitive world. `B` adds one more code-drawn element: a flat dark-red bar under the player. | A mvlgnhstb809f6 capture 1792789750045, B mvlgnomafe63e4 capture 1792789764046 (0:02; the under-player bar appears only in B) |

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | fail | In the reference's 10000–17000 ms, the whip draws a slash arc across bats and there is an HP bar under the character. In `A`'s first 30 s there is only a glow at the player and a lone damage number "12". Enemies and scenery are the same lavender boxes, and the telemetry shows no feedback on inputs. | ref frame 15000 ms; A mvlgnhstb809f6 capture 1792789861799 (0:12); compare interval 100801–377380: feedback_per_input A 0 |
| B | `game feel` | fail | Same as `A`, apart from the HP bar under the player. There is no slash or impact effect at the level of the whip arc, and the telemetry shows no feedback on inputs in the interval. | ref frame 15000 ms; B mvlgnomafe63e4 capture 1792789861070 (0:12); compare interval 95877–370530: feedback_per_input B 0 |
| A | `tension and release` | fail | The reference fall (496000–504000 ms) turns the screen red with `GAME OVER` and revive/quit buttons over the horde. `A` shows no tint or text at 0/100 HP, then the result panel. | ref frames 498000–502000 ms; A mvlgnhstb809f6 captures 1792790286872 (0:50, 0/100), 1792790295980 (result) |
| B | `tension and release` | pass | Like the reference, the field turns red and a fall headline (`등불이 꺼졌다…`) shows over the field. A result panel with survived time, kills, level and gold follows. Before the fall there is a low-HP warning. | ref frames 498000–502000 ms; B mvlgnomafe63e4 captures 1792790339695 (0:55), 1792790381040 (result panel) |
| A | `progression` | fail | In the reference, the first level-up popup opens at 00:21 and offers three cards with icons, descriptions and `New!` tags. In `A`, the player was still Lv 1 at 0:34 of the first run and at 0:30 of the second run. | ref frames 19000–22000 ms; A mvlgnhstb809f6 capture 1792790041689 (0:34, Lv 1); mvlgoegw10f1de capture 1792790696586 (0:30, Lv 1) |
| B | `progression` | fail | Lv 1 at 0:32 in the first run, and Lv 2 only by 0:27 in the second run. Both are later than the reference's level-up at 00:21. | ref frames 19000–22000 ms; B mvlgnomafe63e4 capture 1792790005382 (0:32, Lv 1); mvlgop1515ebff capture 1792790726389 (0:27, Lv 2) |
| A | `one more run` | n/a | The reference `restart` moment has `startMs` null. | input.json reference.moments |
| B | `one more run` | n/a | The reference `restart` moment has `startMs` null. | input.json reference.moments |
| A | `no friction` | pass | The reference spends 0–15 s on the title, character select and loading, so its run timer only shows 00:15 at the 15000 ms frame. `A` goes terms → camp → run within a few taps, and the compare interval shows no idle span. | ref frames 0–15000 ms; compare interval 100801–377380: idle_span_ms A 0 |
| B | `no friction` | pass | Same path as `A`, and the compare interval shows no idle span. | ref frames 0–15000 ms; compare interval 95877–370530: idle_span_ms B 0 |
| A | `presentation` | fail | Leaving out placeholder resources, these elements are still flat single-color boxes: the level-up popup, the pause and result panel backgrounds, and the terms popup background. Enemies, props and gems are untextured box primitives with no clear look. The reference uses pixel art throughout, with framed panels and cards. | ref frames 0, 5000, 21000 ms; A mvlgnhstb809f6 captures 1792790225005 (level-up popup), 1792789709155 (terms) |
| B | `presentation` | fail | Same as `A`, plus a flat code-drawn HP bar under the player. | ref frames 0, 5000, 21000 ms; B mvlgnomafe63e4 captures 1792789764046, 1792790381040 |

## moments

- `A` is better at first 30000ms. Reason: the interval compare gives A decisive on input_latency_ms 1 vs 2 (feedback_per_input 0 vs 0, idle_span 0 vs 0). On screen, the only difference is B's HP bar under the player (A 1792789861799, B 1792789861070).
- `A` is better at core action. Reason: the same interval gives A decisive on input_latency_ms 1 vs 2. On screen, both show the lantern bolt glow with damage numbers of "12", and the enemies are the same boxes.
- `B` is better at first failure. Reason: B shows `체력이 위험해요!` at 16/100 HP (0:53), then a red field and `등불이 꺼졌다…` at 0/100 (0:55). A shows 0/100 at 0:50 with no tint or text, then opens the result panel. The interval compare (A 377380–758281, B 370530–767404) gives game feel to A on latency (2 vs 373 ms); B has feedback_per_input 18 vs 9.
- `A` is better at first reward. Reason: in the interval compare, reward_interval_ms is A 3200 vs B 10574. Both reached Lv 3 by 0:48 with a 3-card popup (A 1792790225005).
- `B` is better at restart. Reason: restart_delay_ms is B 2401 vs A 6400. The restart interval compare is indistinguishable (feedback_per_input 1 vs 1). Both result panels show survived time, kills, level and gold with `다시 출발` / `야영지로`.
- `B` is better at late_run_horde. Reason: the interval compare gives B decisive on input_latency_ms 2 vs 3. On screen, both show a dense box horde with damage numbers 19/30/63 and 8 item icons at Lv 5. A held 184–200/200 HP from 10:02 to 10:07; B ran from 34 to 98 of 100 HP between 10:02 and 10:08 (A mvlgnujp125740 1792790498789–1792790586488, B mvlgo4i1c37b3e 1792790499619–1792790588947).
- `B` is better at second_run_after_meta_upgrade. Reason: the interval compare gives B decisive on input_latency_ms 1 vs 2. B shows a shrine-upgrade plate under the weapon icon and reached Lv 2 with a second weapon at 0:27; A shows no sign of the upgrade and was still Lv 1 at 0:30 (A mvlgoegw10f1de 1792790516447/1792790696586, B mvlgop1515ebff 1792790518110/1792790726389).

## loser better

- `A` (lost `game feel`, `tension and release`, `one more run`): lower input latency across the session (2 vs 20 ms whole session, 2 vs 373 ms in the first-failure interval).
- `B` (lost `progression`, `no friction`, `presentation`): in the second run after a shrine purchase, `B` shows the bought upgrade on a HUD plate and reached Lv 2 by 0:27; `A` shows no upgrade sign and was still Lv 1 at 0:30. `B` also shows the player's HP next to the player and warns at low HP.

## strengths

- Both games: the level-up popup stops the run and offers 3 cards. Each card shows a state label (`새로 얻기` / `Lv 2`), a name and an effect line (e.g. `레벨마다 이동 속도 +8%`), with a `1 2 3 로도 고를 수 있어요` hint (A mvlgnhstb809f6 1792790225005).
- Both games: at 10:00 the late-run fixture shows a dense horde around the player with many damage numbers (19, 30, 63) and 8 levelled items at Lv 5 (A mvlgnujp125740 1792790498789, B mvlgo4i1c37b3e 1792790499619).
- `B`: failure is readable. There is an HP bar under the player, `체력이 위험해요!` at ≤30% HP, then a red field with `등불이 꺼졌다…` at the fall (mvlgnomafe63e4 1792790322414, 1792790339695).
- Both games: the result panel lists survived time, kills, level reached and gold earned, and `다시 출발` starts a new run directly (A 1792790295980, B 1792790381040).

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | fall (first run, 0:50) | At 0/100 HP the field shows no tint, text or fall animation; the next capture is the result panel. | The player gets no on-screen moment of failure, so the cause and timing of the fall are not shown (`tension and release`, `one more run`). | major | mvlgnhstb809f6 captures 1792790286872, 1792790295980 |
| A | run, first 30 s | No feedback recorded on inputs (feedback_per_input 0). | Movement input has no visible or audible response beyond the movement itself (`game feel`). | major | `ogw telemetry compare` whole session feedback_per_input A 0 |
| A, B | run field | Enemies, scenery props and pickups are the same lavender box primitives. A threat can only be told apart from a prop by watching whether it moves. | Danger and pickups are hard to read, which weakens both `tension and release` and `progression`. | major | A mvlgnhstb809f6 1792789861799, B mvlgnomafe63e4 1792789861070 |
| A, B | first level-up | No level-up within the first 30 s (both still Lv 1 at 0:32); the reference levels up at 00:21. | The first reward comes later than in the reference (`progression`). | major | A 1792790007428, B 1792790005382; ref frame 21000 ms |
| A, B | level-up popup, pause and result panels, terms popup | The outer panel backgrounds are flat single-color rectangles. | They look like code-drawn boxes, not art (`presentation`). | minor | A 1792790225005, B 1792790381040, A 1792789709155 |
| B | HP bar under the player | A flat dark-red rectangle with a fill. | A code-drawn box in the field (`presentation`). | minor | mvlgnomafe63e4 1792789764046 |
| B | first-failure interval | input_latency_ms 373 in the interval that includes the low-HP and fall sequence (whole session 20 vs A 2). | Inputs are slower to respond around the fall (`game feel`). | minor | `ogw telemetry compare` interval 370530–767404 |
| A | second run after a shrine purchase | No HUD element or text shows the bought upgrade. | The permanent upgrade bought with run gold has no visible payoff at the start of the next run (`progression`). | minor | mvlgoegw10f1de captures 1792790516447, 1792790696586 |
