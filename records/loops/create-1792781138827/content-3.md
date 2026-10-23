# content report — run create-1792781138827, iteration 3

## defects

| id | result | note |
|---|---|---|
| early-xp-pace-slow | fixed | |
| attack-feedback-weak | fixed | |
| code-drawn-ui-flat | not reproduced | The bar under the player is drawn with `nine_slice/ui/bar_frame` and `nine_slice/ui/bar_fill`, which became final in commit 2d7c1a6, after the judged commit f0bf583. Capture `captures/mvlj121f46ec3d-1792793654131.png` (zoomed) shows a framed bar with shaped end caps, a dark border and a highlight, not a flat rectangle |
| run-fps-below-target | not done | The cause is not in the content (assumption `Is the low fps of the performance check caused by the content?`, needs human). The camp (17 draw calls) fell from 60 to 12~18 fps within about 20 s of idle while process time rose from about 1 ms to 13~17 ms; turning off the 3D world, glow, fog, shadow, effects, UI and half render scale in the run did not change the fps |
| damage-numbers-overlap | fixed | |
| lobby-fps-below-target | not done | Same cause as `run-fps-below-target`: on instance `mvli0npc171014`, which never left the camp, the camp fell from 60 fps to 12 fps with nothing on screen changing |
| standing-still-survives | fixed | |
| meta-upgrade-not-visible | fixed | |
| fall-input-latency | fixed | |
| levelup-card-text-wrap | fixed | |
| play-guide-anchor-key-form | fixed | |

What changed per defect:

- `early-xp-pace-slow`: `[xp_base]` 2, `[xp_step]` 5, `[pickup_radius]` 2.8, `[bolt_range]` 10.0. Regression test `test_a_walking_player_levels_up_early` (first level-up within 15000ms for a 5 s leg walk, level 3 by 60000ms). With the old values the probe gave 11350~38150ms; now 5700~12500ms. On instance `mvlj112x8de07d`: Lv 2 at 0:08, Lv 3 at 0:14
- `attack-feedback-weak`: lantern bolts are drawn stretched as streaks of light; the lantern flashes when it fires (`prefab/run/fire_effect`); each hit plays a bright impact flash next to the sparks (`prefab/run/hit_effect` + `particle/run/impact_flash`); a move press, turn or release puffs dust at the feet (`prefab/run/step_effect`). On instance `mvlj112x8de07d` a `key_up` followed by a step got feedback `{'Tween': 1, 'Effect': 1}` (before: `{}`). The three new particles are placeholders until the resource request ends
- `damage-numbers-overlap`: at most 3 numbers start per frame, biggest hits first, at most 18 live, and a number starts only where no living number stands within 1.8 m. Gems glow a deeper blue (emission ×0.45) so they read apart from enemies and props. Capture `captures/mvlj11jyc07141-1792793679108.png` (10:04) shows separate numbers and blue gems. The enemies are the final models since commit 1acd923, no longer boxes
- `standing-still-survives`: faster spawns in `wave_2`~`wave_4`, more health in `wave_3`/`wave_4`, contact damage bat 4 / ghoul 6 / skeleton 10, aura knockback 0.10~0.15 m. Regression test `test_a_still_player_falls_within_the_still_limit` (fall within 150000ms). One seed survived 249.8 s before the change; now 24.2~132.4 s over 8 seeds
- `meta-upgrade-not-visible`: the shrine plate has the title `등불 제단의 가호` and the icon and run effect of each upgrade (new column `upgrade.bonus`, e.g. `줍는 범위 +20%`). Capture `captures/mvlj121f46ec3d-1792793654131.png`
- `fall-input-latency`: during the fall wait a move input or `pause`/back press pops the fall title (`RunRespondedEvent`), and from `[run_end_skip_after]` (600ms) it opens the result at once. Reproduced before: inputs in the wait had `latency_ms` null. After: 0~2 ms, and `P` at 700 ms opened the result within 100 ms
- `levelup-card-text-wrap`: card names and texts keep a word joiner between the letters of a word, so lines break only at spaces. Capture `captures/mvlj112x8de07d-1792793786218.png`: `주변의 적에게 번개를` / `떨어뜨립니다`
- `play-guide-anchor-key-form`: `play-guide.md` says every anchor key is the ID name with its brackets, with the example `tap_anchor upgrade_buy [upgrade_vitality]`

Also changed: when a level-up offers only the soup (full build), it heals at once without the popup (with the faster XP curve the late fixture opened soup-only popups at Lv 60).

## unverified

- The level-up that offers only the soup and heals at once without the popup was not seen on an instance: the late fixture instance `mvljd1y6ab2a56` had no level-up in the 14 s played at Lv 61. Regression tests pass; the code path was not exercised on screen
- The look of the three new particles (`particle/run/impact_flash`, `particle/run/muzzle_flash`, `particle/run/step_dust`): they are placeholders (empty `GPUParticles3D`) until the resource sub-agent delivers them, so the impact flash, lantern flash and dust were not seen on screen. Only their spawn (telemetry `Effect`) was checked
- The feedback of a move release that is put in right before the next move press in the same step stays `{}`: both inputs reach the run in the same step and the telemetry counts the feedback on the last input only (assumption `Can a move release get feedback when the next move press comes in the same frame?`)
- The cause of the low fps of instance windows (run and camp) is not confirmed (assumption `Is the low fps of the performance check caused by the content?`, needs human)
- `ogw measure` was not run, so `first_reward_ms`, `reward_interval_ms` and the new feel target `feedback_per_input` (1~1000) were not measured with the new values
- English text for the new strings (`[run_blessing_title]`, `upgrade.bonus`) is missing until the translation work

## requests

- records/loops/create-1792781138827/resource-requests/1792793275147.md (`particle/run/impact_flash`, `particle/run/muzzle_flash`, `particle/run/step_dust`)

## assumptions

- How fast should the first level-ups come for a player who walks around?
- How long may a player who never moves survive?
- Is the low fps of the performance check caused by the content? (needs human)
- Can a level-up that offers only the soup open a popup?
- What should answer an input during the fall wait?
- Can a move release get feedback when the next move press comes in the same frame?
