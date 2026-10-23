# judge result — run create-1792781138827, iteration 3

A = `mvlk69kg1bb7b6` (fixtures `mvlk6lv5dfab76` late_run_horde, `mvlk73y7bcbcef` second_run_after_meta_upgrade)
B = `mvlk6fnac8e67f` (fixtures `mvlk6uaq9fe449` late_run_horde, `mvlk7doa181852` second_run_after_meta_upgrade)
Reference: Vampire Survivors, `reference-video-1.mp4`.

The run scene was played in step mode (200ms steps), as both play guides set. Times like 0:28 are the in-run timer shown on screen. Capture names are `<instance id>-<unix ms>.png` under `captures/`.

Telemetry intervals used (`play ms` from `ogw telemetry --summary`):
- first 30000ms / core action / first reward: A 111327→533340, B 105550→525916
- 0:30 → fall → restart (same conditions: stand still, press card 1 at each level-up, tap `result_again` at the first step it is visible): A 533340→1592716, B 525916→2377969
- late_run_horde: A 565476→745350, B 567553→950000
- second_run_after_meta_upgrade (same scripted input on both: D, W, A, S, D, W for 25 steps each): A 1040923→1262366, B 1027246→1252007

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| game feel | B | decisive | In the first 30000ms of the run, A's inputs produced no recorded feedback (0 per input) while B's produced 2 per input. | `ogw telemetry compare` first-30s interval: input_latency_ms A 1 / B 0, feedback_per_input A 0 / B 2 → B decisive. The second-run interval agrees (A 1 / B 11, B decisive). The late_run_horde interval gave A decisive (209 vs 0), but A's 209 comes from the single `pause_resume` tap that took in the whole horde's effects. |
| tension and release | B | slight | No telemetry. Both have failure points, but only B shows danger and the fall on screen: red HP numbers at low health, a red field, and the `등불이 꺼졌다…` title. A's field just freezes before the result panel. | `mvlk6uaq9fe449-1792796431403` (B 10:16, HP `2/100` in red), `mvlk6fnac8e67f-1792797902568` (B 2:18, red field + fall title); `mvlk6lv5dfab76-1792796247097…272671` and `mvlk69kg1bb7b6-1792797104676…131464` (A: field unchanged until the panel) |
| progression | B | decisive | From 0:30 until the fall, B granted a reward every 10200ms against A's 20079ms. | compare 0:30→restart interval: reward_interval_ms A 20079 / B 10200 → B decisive. First-30s interval: A none / B 6183. late_run_horde interval gave A clear (5800 / 7496). |
| one more run | A | slight | Under the same restart procedure, A's restart came 117ms sooner (1649 vs 1766ms). | compare 0:30→restart interval: restart_delay_ms A 1649 / B 1766 → A slight. The late_run_horde value (A 1772 / B 7411) was not used: after B's fall I kept stepping about 20 more steps before tapping. |
| no friction | indistinguishable | | Neither game had an idle span in the first 30000ms. Lobby → run took one tap on both. | compare first-30s: idle_span_ms A 0 / B 0, goal_input_count none / none → indistinguishable |
| presentation | B | slight | No telemetry. B's lobby, terms popup, HUD, level-up cards, pause and result panels use painted wood/gold-frame art in one style. On A, nearly every UI element is a placeholder, which presentation does not judge, so only the bare text is left to compare. | `mvlk6fnac8e67f-1792795647622` (B lobby), `mvlk6fnac8e67f-1792795769756` (B level-up cards); `mvlk69kg1bb7b6-1792795646683` (A lobby: `BUTTON`, `LOBBY`, `PLATE` placeholders) |

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | game feel | fail | Reference 10000–17000ms shows a whip slash every ~1.3s plus damage numbers on hit. A recorded 0 feedback per movement input in the first 30s, and no weapon projectile shows in any capture from 0:01 to 0:30; only a damage number `12` appears. | ref frames 10000–17000 (whip arc at 15000); compare first-30s feedback_per_input A 0; `mvlk69kg1bb7b6-1792795713932`, `-1792795819394`, `-1792795862932` |
| A | tension and release | fail | Reference 496000–504000ms: the field turns red, `GAME OVER` shows, then a result panel. A shows a dense horde at 10:00 but no fall moment: the field stays unchanged for ~1.6s, then the result panel opens. A level-up popup does follow each success. | ref frames 497000–504000; `mvlk6lv5dfab76-1792796247097…272671` (10:06–10:07); `mvlk69kg1bb7b6-1792797104676…131464` (1:14) |
| A | progression | fail | The reference's first level-up appears at run time 0:21. A's first level-up came at 0:28 in the first run (`mvlk69kg1bb7b6-1792795976805`). In the second run A was still Lv1 at 0:30 (`mvlk73y7bcbcef-1792796849464`). | ref frames 19000–23000 (`Level Up!` at 00:21); compare first-30s reward_interval_ms A none |
| A | one more run | n/a | `restart` has `startMs` null in reference | — |
| A | no friction | pass | The reference's first 30s spends ~7s on title → character select → stage select before the run starts. A goes from lobby to run in one tap, with idle_span 0 in the first 30s. | ref frames 0–7500; compare first-30s idle_span_ms A 0; A telemetry scene_loads run 507ms |
| A | presentation | unknown | Almost every visible resource on A's first-30s screens is a placeholder (`BUTTON`, `PLATE`, `BAR_FRAME`, `TIMER`, `GROUND`, `PANEL_FRAME`, card icons labeled with resource keys), and presentation does not look at those places. What is left (Korean text, numbers) is not enough to judge the level. | `mvlk69kg1bb7b6-1792795646683`, `-1792795670207`, `-1792795976805` |
| B | game feel | pass | Like the reference whip arc, B's lantern bolt shows as a glowing projectile hitting enemies, with damage numbers and a kill count rising. Telemetry records 2 feedbacks per input. | `mvlk6fnac8e67f-1792795813173` (0:09), `-1792796077252` (0:30); compare feedback_per_input B 2 |
| B | tension and release | pass | Same order as the reference: HP turns red at low health with `체력이 위험해요!`, then the field turns red and the `등불이 꺼졌다…` title shows over it, then the result panel with time, kills, level and gold. Level-up cards follow successes. | `mvlk6uaq9fe449-1792796431403`, `mvlk6fnac8e67f-1792797902568`, `-1792797928471`; ref 497000–504000 |
| B | progression | pass | B's first level-up came at 0:05 (reference: 0:21), and B was at Lv4 by 0:30. | `mvlk6fnac8e67f-1792795769756` (0:05 popup); compare reward_interval_ms B 6183 |
| B | one more run | n/a | `restart` has `startMs` null in reference | — |
| B | no friction | pass | One tap from lobby to run (reference: ~7s of menus). idle_span 0 in the first 30s. | compare first-30s idle_span_ms B 0 |
| B | presentation | pass | The lobby shows an illustrated camp, wooden buttons and a gold coin counter. Panels have gold frames, and each level-up card has a painted icon. The HUD uses icon slots, a skull and coins. All of it holds one style, as the reference's UI does. | `mvlk6fnac8e67f-1792795647622`, `-1792795769756`, `-1792796001515` |

## moments

- `B` is better at first 30000ms. Reason: at 0:30 B was Lv4 with 40 kills and three weapons, and A was Lv2 with 22 kills. Feedback per input was B 2 vs A 0.
- `B` is better at core action. Reason: B's lantern bolt shows as a glowing projectile hitting enemies (0:09, 0:16, 0:30). A shows no weapon projectile in its captures from 0:01–0:30, only a damage number `12`.
- `B` is better at first reward. Reason: B's first level-up opened at 0:05 and A's at 0:28.
- `B` is better at first failure. Reason: B shows red HP numbers at 2/100, a red field and the `등불이 꺼졌다…` title before the result panel. A's field stays unchanged until the result panel opens.
- `A` is better at restart. Reason: under the same procedure, restart_delay_ms was A 1649 vs B 1766.
- `A` is better at late_run_horde. Reason: telemetry in that interval gave A the win in game feel (209 vs 0), progression (5800 vs 7496ms) and one more run (1772 vs 7411ms). B's restart value includes ~20 steps I took after its fall. On screen, B's horde is distinct enemy types (trolls, skeletons, hooded figures) with gems. A's is overlapping untextured cubes, with damage numbers stacked over the player (`mvlk6lv5dfab76-1792796141190`, `mvlk6uaq9fe449-1792796155759`).
- `B` is better at second_run_after_meta_upgrade. Reason: B opens with `등불 제단의 가호가 함께합니다` and a plate showing `줍는 범위 +20%`, and reached Lv3 by 0:19. A shows nothing about the purchase and was Lv1 at 0:30 under the same inputs. Feedback per input was A 1 vs B 11.

## loser better

- A restarted 117ms sooner after a fall under the same procedure (1649 vs 1766ms).
- In the late_run_horde interval, A's reward interval was shorter (5800 vs 7496ms). A's horde at 10:00 also put real pressure on the player: 200→136 HP in 2s after resume, and a fall at 10:07. B's player stayed at 100/100 for the first 2s and fell at 10:17, only after walking into the horde.

## strengths

- B: first level-up at 0:05 of the run with three illustrated cards that show the card's level (`새로 얻기` / `Lv 2`). Level-ups then came every ~6s in the first 30s (`mvlk6fnac8e67f-1792795769756`, `-1792796001515`).
- B: the fall runs in stages. HP turns red at ≤30% with `체력이 위험해요!`, then the field turns red with the `등불이 꺼졌다…` title, then a result panel showing survived time, kills, level and gold, with `다시 출발` focused (`mvlk6fnac8e67f-1792797902568`, `-1792797928471`).
- B: the second run shows the bought shrine upgrade on screen (`등불 제단의 가호` plate, `줍는 범위 +20%`) (`mvlk7doa181852-1792796632225`).
- Both: the camp's `원정 시작` starts a run in one tap with a ~0.5–0.8s scene load, and neither had an idle span in the first 30000ms.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | run, fall (health 0 → result panel) | Nothing shows between the fall and the result panel: no title, no tint, no player animation. The field just holds still for ~1.6s. | The player gets no moment that says the run ended or why, unlike B and the reference's red `GAME OVER`. | major | `mvlk69kg1bb7b6-1792797104676…131464` (1:14), `mvlk6lv5dfab76-1792796247097…272671` (10:07) |
| A | run, first 30s | First level-up at 0:28 in run 1. Still Lv1 at 0:30 in run 2 (B under the same inputs: Lv3 by 0:19). | The first reward comes later than the reference's 0:21. | major | `mvlk69kg1bb7b6-1792795976805`, `mvlk73y7bcbcef-1792796849464`, `mvlk7doa181852-1792796816077` |
| A | run, weapon attack | No weapon projectile or hit effect shows in captures from 0:01 to 0:30, only a damage number `12`. Telemetry recorded 0 feedback per input in that interval. | Auto-attacks are the core action; without visible feedback the player cannot see their weapon working. | major | `mvlk69kg1bb7b6-1792795713932`, `-1792795862932`, `-1792795931212`; compare feedback_per_input A 0 |
| A | run, late level-up with all slots at level 5 | Each level-up still opens a popup with a single `따뜻한 수프` card that has to be clicked. | It stops the run every level in the late game for a choice that has only one option. | minor | `mvlk6lv5dfab76-1792796206878` (10:03) |
| A | second run after shrine purchase | Nothing on screen shows the bought permanent upgrade. | The player cannot see what the gold from the last run changed. | minor | `mvlk73y7bcbcef-1792796574173`, `-1792796631762` |
| A | run, taking hits at 10:00 | HP fell 200→136 in 2s and 102→38 in 2s with no hit mark on the player. Stacks of damage numbers (`19`, `30`, `63`) cover the player. | The cause of health loss is hard to read on screen. | minor | `mvlk6lv5dfab76-1792796141190`, `-1792796236156` |
| B | run field | The field is dark navy, and enemies (bats, zombies) are drawn in low contrast against it. A bat at 0:04 near the right edge is barely visible. | Approaching threats are harder to spot than in the reference's green field with dark enemies. | minor | `mvlk6fnac8e67f-1792795733371` (0:04), `mvlk7doa181852-1792796632225` |
