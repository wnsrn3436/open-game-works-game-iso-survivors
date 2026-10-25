# judge result (run update-1792919852190, iteration 1)

Instances played: `A` main `mvnnd6tr5111cb`, `A` fixture `three_levelups` `mvnndk6c7b388e`; `B` main `mvnnddv46beac4`, `B` fixture `three_levelups` `mvnndsea9413f5`. The two `play-guide.md` files are byte-identical. Capture file names end in the unix ms of the capture. Reference: Vampire Survivors, `reference-video-1.mp4` (frames from `ogw frames`, folders `frames-XGyCQ9` 0–30000, `frames-Bapk1R` 10000–17000, `frames-MpNbMh` 19000–23000, `frames-GRRAvV` 496000–504000).

Play path for both main instances: terms (`terms_agree_all` → `terms_confirm`) → camp → step mode on → `lobby_play` → 2s right, then ~26s of game time circling D/S/A/W in 1s chunks, picking the first card at each level-up → stand still until the fall (A at 1:13, B at 2:12) → result panel → `result_again` → new run. Both fixture instances: step mode on → `pause_resume` → circle D/S/A/W until the third level-up pick (A run time 0:21, B 0:20).

Telemetry intervals (play ms): first 30000ms / core action / first reward: A 98830–353813, B 101997–401524. three_levelups: A 442776–586305, B 434116–629872. first failure + restart: A 882000–1433818, B 1378000–1435454.

Each element's verdict uses `ogw telemetry compare` over the interval of its reference moment. The fixture and whole-session compares are listed in the evidence too.

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| `game feel` | B | decisive | Over the first-30s interval, which contains the core action, `feedback_per_input` was B 2 vs A 1, and `input_latency_ms` was 16 for both. | `ogw telemetry compare` first-30s: `feedback_per_input` A 1, B 2, d 0.5. In the three_levelups fixture the result flipped (A 2, B 1, winner A decisive). Over the whole session it was indistinguishable (A 2, B 2). |
| `tension and release` | indistinguishable | slight | Both have the same failure points: contact damage, the red glow after a hit, the `체력이 위험해요!` warning at low HP and the fall at 0 HP. Both open a level-up popup right after the XP bar fills. | No telemetry. Captures `mvnnd6tr5111cb-1792922724828` (1/120, warning) and `mvnnddv46beac4-1792923228762` (6/140, warning). Level-up popups `mvnnd6tr5111cb-1792922073124` (0:10) and `mvnnddv46beac4-1792922108196` (0:11). |
| `progression` | A | slight | Over the first-30s interval, `reward_interval_ms` was A 4000 vs B 4500. | First-30s compare: d 0.111. Fixture: A 4050, B 3900, indistinguishable. Whole session: A 7250, B 8751, A clear. B's whole-session value includes ~30s waits when popups opened (see defects). |
| `one more run` | A | slight | `restart_delay_ms` was A 1850 vs B 2099 from the fall to the new run. | Failure + restart compare: d 0.119. Both result panels have `다시 출발` as the first button: `mvnnd6tr5111cb-1792922978751`, `mvnnddv46beac4-1792923255095`. |
| `no friction` | indistinguishable | | Over the first 30000ms, `idle_span_ms` was 0 for both, and both took the same path: terms → camp → `원정 시작` → run at 0:00. | First-30s compare: `idle_span_ms` A 0, B 0. Over the whole session A won decisive (`idle_span_ms` A 19056, B 28756; `goal_input_count` A 63, B 70). B's longer spans line up with the 30s step time-limit waits when level-up popups opened. |
| `presentation` | indistinguishable | slight | Terms, camp, level-up, pause and result screens use the same art frames, wood buttons, ribbons and icons in both games. The run field uses the same low-poly models and HUD. | No telemetry. Terms `mvnnd6tr5111cb-1792921894383` / `mvnnddv46beac4-1792921896168`; camp `mvnnd6tr5111cb-1792921925927` / `mvnnddv46beac4-1792921927998` look pixel-identical. |

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | pass | Reference 10–17s: a whip slash with a small damage number. A at 0:04–0:23 has auto-fired lantern projectiles, spark rings on hit, white damage numbers (12, 14, 9), a fire aura ring and a red hit glow. Input latency is 16ms, and telemetry logged Sound/Effect/Tween events on move input. | `mvnnd6tr5111cb-1792921997107` (0:04), `mvnnd6tr5111cb-1792922161142` (0:23); `ogw telemetry mvnnd6tr5111cb` key_down feedback {Sound 3, Tween 4, Effect 4}. |
| A | `tension and release` | pass | Reference 496–504s: the screen turns red, then GAME OVER with Revive/Quit. A: health hits 0, the field tints, `등불이 꺼졌다…` shows, and after ~1.6s the field turns dark red and a result panel opens with time, kills, level and gold. Level-up popups follow right after the XP bar fills. | `mvnnd6tr5111cb-1792922725534` (1:13 fall), `mvnnd6tr5111cb-1792922978751` (result). |
| A | `progression` | pass | Reference: first level-up at 0:21 with a gem burst. A: first level-up popup at 0:10, Lv 4 by 0:23, and `reward_interval_ms` 4000 over the first 30s. | `mvnnd6tr5111cb-1792922073124` (0:10, Lv 2), `mvnnd6tr5111cb-1792922161142` (0:23, Lv 4). |
| A | `one more run` | n/a | The reference `restart` moment has `startMs` null. | — |
| A | `no friction` | pass | Reference 0–30s: title → character select → loading, and the run starts at about 6s. A: camp → `원정 시작` → run at 0:00 within ~2s of loading, with `idle_span_ms` 0. | Camp `mvnnd6tr5111cb-1792921925927`, run `mvnnd6tr5111cb-1792921949387` (0:02). |
| A | `presentation` | pass | The reference UI is flat pixel boxes, for example the lavender Level Up panel. A's terms, camp, level-up, pause and result panels use gold-bordered frames, ribbon titles, wood buttons and painted icons in one style. The HUD boxes are plain dark rectangles (see defects), which is no lower than the reference HUD. | `mvnnd6tr5111cb-1792921925927`, `mvnnd6tr5111cb-1792922073124`, `mvnnd6tr5111cb-1792922978751`; reference `frames-MpNbMh/000020000.png`. |
| B | `game feel` | pass | Same weapon effects, damage numbers (9, 12) and red hit glow as A. Input latency is 16ms, and telemetry logged Sound/Effect/Tween events on move input. | `mvnnddv46beac4-1792922011700` (0:04), `mvnnddv46beac4-1792922187866` (0:23, red hit glow); `ogw telemetry mvnnddv46beac4` key_down feedback {Sound 2, Tween 3, Effect 3}. |
| B | `tension and release` | pass | Same fall sequence as A: `등불이 꺼졌다…`, red field, then the result panel. Level-up popups follow right after the XP bar fills. | `mvnnddv46beac4-1792923242082` (2:12 fall), `mvnnddv46beac4-1792923255095` (result). |
| B | `progression` | pass | First level-up popup at 0:11, against 0:21 in the reference. `reward_interval_ms` 4500 over the first 30s. | `mvnnddv46beac4-1792922108196` (0:11, Lv 2). |
| B | `one more run` | n/a | The reference `restart` moment has `startMs` null. | — |
| B | `no friction` | pass | Same path as A, and the run is at 0:02 right after loading. `idle_span_ms` 0 over the first 30s. | `mvnnddv46beac4-1792921927998`, `mvnnddv46beac4-1792921961128`. |
| B | `presentation` | pass | Same art-framed panels and icons as A. | `mvnnddv46beac4-1792921927998`, `mvnnddv46beac4-1792922108196`, `mvnnddv46beac4-1792923255095`. |

## moments

- Indistinguishable at first 30000ms. Reason: both show the same terms popup, camp and run start at 0:00 with the hint `WASD 로 움직이세요. 공격은 자동이에요`, and `idle_span_ms` is 0 for both.
- `B` is better at core action. Reason: over the first-30s interval, `feedback_per_input` was B 2 vs A 1, while the effects seen on screen (spark rings, damage numbers, aura) were the same kind in both.
- `A` is better at first reward. Reason: the first level-up popup came at 0:10 vs 0:11, and `reward_interval_ms` was 4000 vs 4500.
- Indistinguishable at first failure. Reason: both show `체력이 위험해요!` at low HP, then `등불이 꺼졌다…`, a red-tinted field and the same `어둠에 쓰러졌다` result panel (A 1:13 / 162 kills / Lv 7 / +47 gold; B 2:12 / 515 kills / Lv 14 / +141 gold, after different card picks).
- `A` is better at restart. Reason: `restart_delay_ms` was 1850 vs 2099, and both new runs start at 0:00 with full health and the move hint.
- `A` is better at three_levelups. Reason: `feedback_per_input` was A 2 vs B 1 (decisive), `reward_interval_ms` was 4050 vs 3900 (indistinguishable), and both reached Lv 4 with the third pick by 0:21 / 0:20.

## loser better

- `A` (`game feel`): in the three_levelups fixture, A's `feedback_per_input` was 2 vs B's 1, the opposite of the first-30s result.
- `B` (`progression`): in the three_levelups fixture, B's `reward_interval_ms` was shorter, 3900 vs 4050, and B reached the third level-up at run time 0:20 vs 0:21.
- `B` (`one more run`): none seen. The result panel and restart button are the same; only the delay differs (2099 vs 1850 ms).

## strengths

- In both games the first level-up popup comes at 0:10–0:11 of run time, against 0:21 in the reference. Its three cards each have a painted icon, a `새로 얻기`/`Lv 2` label, a one-line effect and the hint `1 2 3 로도 고를 수 있어요`.
- The fall reads clearly in both: `등불이 꺼졌다…` over a tinted field, then a result panel listing survival time, kills, level and gold, with `다시 출발` as the first button. The new run starts about 1.9–2.1s after the press.
- Terms, camp, pause, level-up and result screens share one frame style: gold border, navy fill, ribbon title, gold or wood buttons.
- The run starts about 2s after `원정 시작`, with no character-select step. Input latency is 16ms.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | run, low health | The red `체력이 위험해요!` text under the player is drawn beneath the fire aura ring, gems and enemies, and cannot be read. | The low-HP warning is a failure cue; if it can't be read, the player has no warning before the fall. | minor | `mvnnd6tr5111cb-1792922724828` (1:13, 1/120) |
| B | run, low health | Same as A: `체력이 위험해요!` is covered by the aura ring and enemies. | Same as A. | minor | `mvnnddv46beac4-1792923228762` (2:12, 6/140) |
| A | run HUD, result panel | The health/weapon box (top left), the kills/gold box (top right) and the three stat rows of the result panel are plain dark single-color rectangles with a thin outline. The other panels use art frames. | Under `presentation`, these are code-made boxes next to art-framed panels. | minor | `mvnnd6tr5111cb-1792922161142`, `mvnnd6tr5111cb-1792922978751` |
| B | run HUD, result panel | Same plain HUD boxes and result stat rows as A. | Same as A. | minor | `mvnnddv46beac4-1792922187866`, `mvnnddv46beac4-1792923255095` |
| B | level-up popup opening | When the level-up popup opened, `ogw step` ran until the command time limit (~30s of play ms, e.g. 226125 → 256928) in 11 step calls across `mvnnddv46beac4` and `mvnndsea9413f5`. In A (`mvnnd6tr5111cb`, `mvnndk6c7b388e`), `ogw step` reported `game time is paused` right away every time, with 0 time-limit hits. | B doesn't report the paused state right away when the popup opens. This adds ~30s spans to B's play ms and inflates B's whole-session `idle_span_ms` and `reward_interval_ms`. Whether a human player sees a stall is `unknown`. | minor | Step outputs for `mvnnddv46beac4` and `mvnndsea9413f5` ("the command went over its time limit"), e.g. capture `mvnnddv46beac4-1792922105474` |
