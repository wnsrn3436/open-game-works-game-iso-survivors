## How long is one run, and how does it end?
- decision: 15 minutes of run time (`[run_duration]`); reaching it is "dawn", a win that clears the field and adds `[dawn_bonus]` gold. A fall before that ends the run
- evidence: genre convention (the reference ends a 30-minute run with an unbeatable reaper); a shorter run with a win end keeps "one more run" easy and fits the `late_run_horde` moment at 10 minutes. Revertible through `game_setting.run_duration` and the `wave` rows

## Which weapons, passives, enemies and waves does the first version have, and with which numbers?
- decision: 5 weapons and 5 passives up to level 5, 4 weapon slots and 4 passive slots; 6 enemy kinds; 15 one-minute wave rows with bone knights at 4:00, 8:00, 12:00; the numbers in `weapon_level`, `passive`, `enemy`, `wave` and `game_setting`
- evidence: genre-conventional values (rule 3 of deciding without asking). The first bot run of this iteration fell at 18 s, so the first two waves, the start bolt and the early contact damage were softened and `[hurt_invuln]` was added; `first_reward_ms`, `reward_interval_ms` and `goal_interval_ms` targets in `design.md` will correct the pacing with `ogw measure`

## How much gold does a run give and how much do the shrine upgrades cost?
- decision: shared formula `run.gold_reward` with `[gold_interval]` 10s → 1 gold, 250‰ gold per kill, 200 at dawn; shrine first steps 30~50 gold rising to 460~620 at the top level
- evidence: in-game currency only (no real money). A 2:30 fast-forwarded first run gave 128 gold, enough for the cheapest step, which the `second_run_after_meta_upgrade` moment needs. Tuned later by play results

## Can the run gold use the kill count the client reports?
- decision: yes, bounded by `verify_play_session` (`kills` ≤ survived minutes × `[max_kills_per_minute]`, survived time ≤ play session time + `[run_time_slack]`) without recalculating the run
- evidence: the run is a real-number client simulation that the server does not replay; `play-session` `### result verification` allows result values in rewards only when recalculated, so this is a known gap: a tampered client can earn up to the bound. The bound keeps the worst case near a very strong honest run. Hardening at build time decides whether a server recalculation is needed

## Can an unfinished run be saved in local data and resumed?
- decision: yes. `CommonRunSave` keeps the play session ID, its start time, the loadout and the simulation state in the user local data; the next start resumes the run paused while `play_session_mode.max_duration` has not passed. Projectiles in flight are not kept, and the resumed random stream is reseeded from the loadout seed and the run time
- evidence: the save fixture runner restarts the client after the steps (`tools/src/commands/instance/lib/supervisor.ts` `runFixture`), so the 10-minute moment must survive a restart. Losing the save loses only that run; the server grants nothing before `FinishPlaySession`, so no reward or saved progress depends on local data

## How do the save fixtures reach 10:00 and 2:30 of a run quickly?
- decision: DEV command `run.fast_forward <ms>` runs the run simulation faster than real time with the DEV bot policy and its card picks, refilling health each tick (a DEV cheat), in steps of 60000ms that each end well inside `QACore.commandTimeoutMs`; `set_server_time_offset` then moves the server time by the same run time so `verify_play_session` accepts a later finish
- evidence: measured on an instance: 60000ms of run time takes under 1 second. The moment text asks for "600000ms must pass on this path"; the run timer and the server time both pass it

## Should tall field props stay?
- decision: the dead tree prop was removed; the field scatters gravestones, rocks and a few lantern posts, two per 12 m chunk
- evidence: a capture of the second run showed a tall placeholder prop hiding the player under the isometric camera

## Is a weapon evolution system needed in the first version?
- decision: no (`reject` in `brief.md` genre conventions)
- evidence: scope of the first iteration; each card's effect stays readable. Can be added later as content without changing the run structure

## Which play mode does the run use?
- decision: `step` with 200ms steps
- evidence: the run is real-time action where input needs a response within a set time (`## play mode` of `game-design`); 200ms is 4 ticks of `[run_tick]`

## How soon must a player who stands still be threatened in the opening, and how fast may the fall come?
- decision: a player who stands still from 0:00 takes the first contact hit within 20000ms of run time and falls no sooner than 10000ms after that hit (`design.md` `### enemies and waves`, regression test seeds 1~5). Set by `wave_1` 900ms × 2 (max 30), `wave_2` 800ms × 3 (max 50), `wave_3` 700ms, `wave_4` 650ms and `[hurt_invuln]` 700ms (was 1500ms, 1100ms, 750ms, 700ms and 400ms)
- evidence: genre convention (the reference horde reaches a still player within seconds of the start); judge defect `opening-no-threat` (no hit until 1:10) and play defect `difficulty-cliff` (a fall about 11 s after the first hits). Measured with the regression probe: first hit at 10950~13950ms, fall 15050~95000ms after it; on instance `mvlfyg5pd85300` a still run was hit at 12.6 s, showed the low health warning at 25.6 s and fell at 29.7 s

## Which first reward time can the run reach when the metric counts the time before the run?
- decision: `first_reward_ms` range 5000~60000 (was 5000~30000). The first level-up itself was moved earlier with `[xp_base]` 3 (was 5): 12.1~16.1 s of run time for a still player, earlier for a moving one
- evidence: `first_reward_ms` is the `play_at` of the first reward since the telemetry start, and the title, terms popup and camp are `free` scenes where device time counts. In all three measure instances of iteration 1 the playing agent made its first input 22706~28910ms after the start and started the run at about 32000~59000ms of `play_at` (`records/loops/create-1792781138827/evidence/measure-1/*.json`), so no first level-up time can bring the median under 30000ms. This raises a time value without changing that cause; 60000 holds the measured pre-run time plus the in-run first level-up target of about 15 s
