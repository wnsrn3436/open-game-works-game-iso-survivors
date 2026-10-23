## defects

| id | result | note |
|---|---|---|
| none | | The input has no defects |

Work of this iteration (iteration 1 of `create game`):

- `brief.md` written; game name of `records/setup/name.md` as source text of reserved string `[app_name]` (`아이소 서바이버즈`) and as a glossary row with `en` `Iso Survivors`; `## art direction` of `design.md` from `records/setup/art-direction.md`
- `design.md`, `play-guide.md`
- Contract: `PlaySessionLoadout`, `PlaySessionResult`, `RunRecordUserState`, `GameError` (`GAME_ERROR_LEVEL_NOT_FOUND`, `GAME_ERROR_UPGRADE_ORDER`)
- Data: game settings rows, reserved strings, sounds and IDs; tables `weapon`, `weapon_level`, `passive`, `enemy`, `wave`, `upgrade`, `upgrade_step`; core tables `item`, `shop_product`, `play_session_mode`, `language`, `input_prompt`, `mail_template`; glossary; shared formula fixture `data/fixtures/run.gold_reward.json`
- Server: `prepare_play_session`, `verify_play_session`, `apply_play_session`, `validate_shop_purchase` hooks and their regression tests
- Client: title, camp (lobby panel, lantern shrine, options), run (simulation, isometric 3D view, HUD, level-up, pause, result, save and resume), DEV commands, bot, scenario, save fixtures `client/dev/bot/fixtures/late_run_horde.json` and `client/dev/bot/fixtures/second_run_after_meta_upgrade.json`, regression tests
- Game settings: `NativeUiCore` added to `coreModules.client` (the option screen's user ID copy needs it)
- Checks run: `ogw data`, `ogw contract`, `ogw check --regression` pass, `ogw check --static` pass

Checked on instances:

- Both save fixtures start: `late_run_horde` resumes at 10:00 with the pause popup open, level 45, 4 weapons and 4 passives at level 5, a dense horde around the player; `second_run_after_meta_upgrade` has 1 finished run (2:30), one shrine upgrade bought with its gold, and resumes the second run at its start with the pause popup open. No error log on either
- The DEV bot played a live instance through camp → run → level-up picks → fall (2:23) → result → camp → two shrine purchases → next run, with a `Goal` interval, `Fail`/`Restart`/`Reward`/`Response` marks, no invariant failure, no softlock and no error log

## unverified

- `ogw check --loop` (bot playtest no blocker and full flow, performance, UI quality) was not run; it is iteration step 2 of the lead agent. The bot flow was driven by hand on an instance with `run.bot_next_input` (see above), not by the playtest runner
- Frame time of the late run on the target Macs was not measured. The 10:00 horde (up to 240~320 enemies as multimeshes, damage numbers, one shadowed directional light) ran without visible stalls on this host only
- The `save` step of the scenario (restart in the middle of a run resumes it) was checked only through the fixture restarts, not through the scenario step
- The judge's pace in step mode (200ms steps) and the measured targets (`first_reward_ms`, `reward_interval_ms`, `goal_interval_ms`, `restart_delay_ms`) were not measured
- UI layout on the `uiCheckScreens` other than 1920x1080 was not captured
- All art and audio are placeholders; the look (e.g. the aura is a flat box until its ring model is final) was judged only for layout and occlusion

## requests

- resource request: `records/loops/create-1792781138827/resource-requests/1792784549120.md` (78 placeholder rows: models, particles, UI nine-slices, icons, backgrounds, ground texture, BGM, SFX, font, app icon, splash)
- core proposals: none

## assumptions

Written to `records/loops/create-1792781138827/assumptions.md`:

- How long is one run, and how does it end?
- Which weapons, passives, enemies and waves does the first version have, and with which numbers?
- How much gold does a run give and how much do the shrine upgrades cost?
- Can the run gold use the kill count the client reports?
- Can an unfinished run be saved in local data and resumed?
- How do the save fixtures reach 10:00 and 2:30 of a run quickly?
- Should tall field props stay?
- Is a weapon evolution system needed in the first version?
- Which play mode does the run use?
