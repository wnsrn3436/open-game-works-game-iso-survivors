# judge result — run update-1792799704503, iteration 1

Instances: A `mvlo9ook21cea5` (fixture `mvloa1tsa32ef5`), B `mvlo9vgbd53fbc` (fixture `mvloacoa546ee0`). Reference: Vampire Survivors, `reference-video-1.mp4`.
Captures are under `captures/`. Each file name is `<instance id>-<unix ms of capture>`.
How I played: both main instances went through terms → camp → run in step mode (200 ms steps). Both ran the same 8 s of WASD movement, then stood still and took card 1 at each level-up until they fell. Then each pressed `result_again`. In both fixture instances I opened the shrine, bought `[upgrade_vitality]` and then `[upgrade_might]`, closed the shrine and started a run.
Telemetry intervals in play ms: whole run plus restart was A 85291–788548 and B 85073–572169. Restart was A 758074–788548 and B 520410–572169. Fixture camp/shrine was A 317771–384904 and B 305738–372732.

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| `game feel` | A | slight | Whole-session telemetry: input_latency_ms A 16 / B 17 and feedback_per_input 1 / 1. In the camp fixture A gave 3 feedbacks per input and B gave 2 (A decisive there). | `ogw telemetry compare` whole session; fixture compare 317771–384904 / 305738–372732 |
| `tension and release` | indistinguishable | slight | No telemetry. Both runs have the same contact damage, the same red-field fall, `등불이 꺼졌다…`, and a level-up popup with three cards after XP. | `mvlo9ook21cea5-1792803183944.png`, `mvlo9vgbd53fbc-1792802954573.png` (fall); `mvlo9ook21cea5-1792802621557.png`, `mvlo9vgbd53fbc-1792802731331.png` (level-up) |
| `progression` | B | slight | Telemetry reward_interval_ms: A 7050, B 6451 (d 0.085). Level choices and random spawns differed between runs. | `ogw telemetry compare` whole session and run interval |
| `one more run` | indistinguishable | slight | Telemetry restart_delay_ms: A 2050, B 2000 (d 0.024). | `ogw telemetry compare` whole session; `mvlo9ook21cea5-1792803209358.png`, `mvlo9vgbd53fbc-1792803000983.png` |
| `no friction` | A | clear | Telemetry idle_span_ms: A 19158, B 25308. goal_input_count: 23 / 23. The idle spans fall on the terms/title screens, where my own pace between captures differed. Within the run interval idle_span is 0 / 0. | `ogw telemetry compare` whole session and run interval |
| `presentation` | A | slight | No telemetry. Leaving out placeholders, A's camp has a framed record card with an icon per stat. Its shrine dims buy buttons the gold cannot cover, and its result panel has a framed row with an icon for each stat. B's shrine keeps unaffordable `강화` buttons bright yellow, and its result is plain text lines. | `mvloa1tsa32ef5-1792802479076.png`, `mvloacoa546ee0-1792802481119.png`, `mvloa1tsa32ef5-1792802793036-video/frame-00007.png`, `mvloacoa546ee0-1792802795223-video/frame-00007.png`, `mvlo9ook21cea5-1792803203555.png`, `mvlo9vgbd53fbc-1792802977538.png` |

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | pass | Around 0:10–0:15 the auto weapons (lantern bolt, flame ring) show damage numbers and a hit glow on the player. Every move key_down got Tween+Effect feedback. The reference (10–17 s) shows a whip arc and damage numbers at a similar density. Sound was not checked. | `mvlo9ook21cea5-1792802805302.png`; `ogw telemetry mvlo9ook21cea5`; `frames-rIONeL/000012000.png`, `000015000.png` |
| A | `tension and release` | pass | On fall the field turns red, the hero tips over, `등불이 꺼졌다…` shows, and a result panel follows with time, kills, level and gold. The reference (496–504 s) shows a red tint, `GAME OVER`, and revive/quit. | `mvlo9ook21cea5-1792803183944.png`, `mvlo9ook21cea5-1792803203555.png`; `frames-2q9dIw/000498000.png` |
| A | `progression` | pass | The first level-up came at 0:08 with three cards, each with a drawn icon (`성화 오라`, `투척 도끼`, `등불 탄환 Lv2`). The reference's first level-up is at 0:21 with three choices. | `mvlo9ook21cea5-1792802621557.png`; `frames-3eAxBj/000020000.png` |
| A | `one more run` | n/a | The reference moment `restart` has a startMs of null. | input.json |
| A | `no friction` | pass | From the camp, `원정 시작` starts a run with one tap, and the run timer is at 0:02 after 2 s. The reference needs title → character select → stage select → loading before play at about 6 s. | `mvlo9ook21cea5-1792802495654.png`, `mvlo9ook21cea5-1792802515070.png`; `frames-rIONeL/000000000.png`–`000012000.png` |
| A | `presentation` | fail | Placeholders aside, the run HUD (HP panel, kill/gold panel) is a flat single-color navy box with a thin outline. The purchase toast is a flat dark strip with about 14 px text. The run field is dark and low in contrast. The reference keeps one pixel-art style across its HUD and menus. | `mvlo9ook21cea5-1792802515070.png`, `mvloa1tsa32ef5-1792802793036-video/frame-00007.png`; `frames-rIONeL/000015000.png` |
| B | `game feel` | pass | Around 0:10–0:15 the auto weapons show damage numbers (`12`) and the player glows red on hit. Move key_down got feedback. Sound was not checked. | `mvlo9vgbd53fbc-1792802681562.png`, `mvlo9vgbd53fbc-1792802807403.png`; `frames-rIONeL/000012000.png` |
| B | `tension and release` | pass | Same fall sequence: red field, `등불이 꺼졌다…`, then a result panel with time, kills, level and gold. | `mvlo9vgbd53fbc-1792802954573.png`, `mvlo9vgbd53fbc-1792802977538.png`; `frames-2q9dIw/000498000.png` |
| B | `progression` | pass | The first level-up came at 0:10 with three cards with drawn icons. The reference's first is at 0:21. | `mvlo9vgbd53fbc-1792802731331.png`; `frames-3eAxBj/000020000.png` |
| B | `one more run` | n/a | The reference moment `restart` has a startMs of null. | input.json |
| B | `no friction` | pass | One tap on `원정 시작` starts the run, and the timer is at 0:02 after 2 s. | `mvlo9vgbd53fbc-1792802497797.png`, `mvlo9vgbd53fbc-1792802522931.png` |
| B | `presentation` | fail | The run HUD and the camp gold box are flat single-color boxes with thin outlines. The purchase toast is the same flat strip with tiny text. The camp title is plain outlined text over the background. | `mvlo9vgbd53fbc-1792802522931.png`, `mvloacoa546ee0-1792802795223-video/frame-00007.png`, `mvlo9vgbd53fbc-1792802497797.png` |

## moments

- Indistinguishable at `first 30000ms`. Reason: both start with the same terms popup and reach the run with one tap. Telemetry from 0 to 30000 ms gives idle_span 0 / 0 and goal_input_count 23 / 23.
- Indistinguishable at `core action`. Reason: the run field, starting weapon (lantern bolt), enemies and damage numbers are the same in both. Telemetry for the first 30 s of the run is input_latency 0 / 0 and feedback_per_input 1 / 1.
- `B` is better at `first reward`. Reason: reward_interval_ms is B 6451 and A 7050. Both popups have three drawn-icon cards. A's popup title `레벨 업!` sits on a `TITLE_RIBBON` placeholder.
- `A` is better at `first failure`. Reason: both show the same red field and fall title. A's result panel puts each stat (time, kills, level) in a framed row with an icon. B shows four plain centered text lines.
- Indistinguishable at `restart`. Reason: `다시 출발` restarts at 0:00 in both, with restart_delay_ms A 2050 and B 2000.
- `A` is better at `camp_returning_player`. Reason: A's camp shows a record card with an icon per stat (best survival 2분 30초, kills, runs, dawns) and a count badge on `등불 제단`. In A's shrine, buttons the gold cannot cover are dimmed. In B's shrine they stay bright yellow under a small red `금화가 부족해요`. Fixture telemetry: feedback_per_input A 3 vs B 2 (A decisive).

## loser better

- B's camp shows the full camp art (tents, fire, trees) without blocks over it, and the title, record line and three buttons sit in one centered column. A's camp currently covers the centre and top-left with placeholder blocks.
- B's reward interval was slightly shorter (6451 ms vs 7050 ms).
- In B's level-up popup and shrine, the titles (`레벨 업!`, `등불 제단`) are drawn directly on the panel, so no title text sits on another element.

## strengths

- A run started after a shrine purchase shows `등불 제단의 가호가 함께합니다` and a `등불 제단의 가호` plate listing each bought upgrade (`피해 +5%`, `최대 체력 +15`, `줍는 범위 +20%`). HP starts at 115/115 (both fixtures).
- The fall reads clearly: the field turns red, the hero tips over, a large `등불이 꺼졌다…` title shows, and the result panel follows with survived time, kills, level and gold. `다시 출발` restarts in about 2000 ms (both).
- Level-up cards carry a drawn icon, a `새로 얻기`/`Lv N` tag and a one-line effect, and the keys 1/2/3 are shown under the cards (both).
- A's returning-player camp turns the stored record into a card with best survival, kills, runs and dawns. A count badge on the shrine button and the line `금화로 살 수 있는 강화가 있어요` point to affordable upgrades (A).

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | run HUD | The HP panel and the kill/gold panel are flat single-color navy boxes with a thin outline, not art frames | `presentation` looks for engine-default or code-made boxes, and the reference HUD is drawn in one art style | major | `mvlo9ook21cea5-1792802515070.png` |
| B | run HUD | The same flat single-color boxes, plus the camp gold box at the top right | same as above | major | `mvlo9vgbd53fbc-1792802522931.png`, `mvlo9vgbd53fbc-1792802497797.png` |
| A | shrine, after a purchase | The `힘 강화 완료!` toast is a flat dark strip across the whole panel with text about 14 px tall. It runs through the middle of the second upgrade row | Purchase confirmation is hard to read and covers row content, and the strip is a code-made box | minor | `mvloa1tsa32ef5-1792802793036-video/frame-00007.png` |
| B | shrine, after a purchase | The same toast strip with about 14 px text runs through the second row | same as above | minor | `mvloacoa546ee0-1792802795223-video/frame-00007.png` |
| B | shrine rows | When gold does not cover a row, its `강화` button stays bright yellow and only a small red `금화가 부족해요` and a red cost change | The button looks pressable while a press does nothing | minor | `mvloacoa546ee0-1792802795223-video/frame-00007.png` |
| B | shrine `서두름` row | The effect text wraps, so `-4%` sits alone on a second line | The value is split from its label, unlike the other five rows | minor | `mvloacoa546ee0-1792802768309.png` |
| A | run field | The field is very dark (navy on navy), so tombstones and enemies at the screen edge are low in contrast | Threats approaching from the edges are hard to see, and the reference field is bright | minor | `mvlo9ook21cea5-1792802515070.png`, `mvlo9ook21cea5-1792802805302.png` |
| B | run field | Same dark, low-contrast field | same as above | minor | `mvlo9vgbd53fbc-1792802681562.png` |
