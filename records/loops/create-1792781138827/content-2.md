## defects

| id | result | note |
|---|---|---|
| opening-no-threat | fixed | |
| hurt-not-visible | fixed | |
| levelup-capture-popup-not-open | fixed | |
| run-fps-below-target | not reproduced | `RunScene._process` measured with temporary timers on the `late_run_horde` fixture (10:00, ~300 enemies): 0.6~0.7 ms per frame on average (simulation 0.16 ms, events and effects 0.32 ms, drawing 0.16 ms, HUD state 0.05 ms), longest frame 8.8 ms; the fast forward ran 600 ticks of that horde in about 1 s. On the same host the fps of every client window fell to 12~17 within seconds, also on a static result panel with 33 draw calls and while `MTLCompilerService` and another agent's sound generation used the CPU, so the drop is not from content code. iteration 1 measured with 3 instances, host memory 99.9 % and CPU 83.4 %. The directional shadow was still cut from 4 splits to 1 (`directional_shadow_mode` orthogonal) to leave more frame time |
| scene-load-slow | not reproduced | The run scene loaded in 501 ms, 517 ms, 500 ms and 515 ms on 4 instances this iteration (`ogw telemetry` `scene_loads`), which is `SceneCore.loadingMinDisplayMs` 500; the run scene asks for no shader warmup. The 6248 ms of `measure-1` came from the second of three instances loading at about the same time (1612 ms and 3625 ms for the other two) with host memory at 99.9 % |
| early-xp-pace-slow | fixed | |
| damage-numbers-overlap | fixed | |
| lobby-title-gold-overlap | fixed | |
| giveup-result-title | fixed | |
| death-no-presentation | fixed | |
| difficulty-cliff | fixed | |
| meta-upgrade-not-visible | fixed | |
| lobby-fps-below-target | not reproduced | The camp read 60 fps with `frame_ms` 1.165 on instance `mvlf9u7p8d10cd`; it draws no 3D. iteration 1 read 57 under the host load written for `run-fps-below-target` |

Causes and changes:

- `opening-no-threat`, `difficulty-cliff`: `wave_1` 900ms × 2 (max 30), `wave_2` 800ms × 3 (max 50), `wave_3` 700ms, `wave_4` 650ms, `[hurt_invuln]` 700ms. A player who stands still is now hit at 10.9~14.0 s and falls 15~95 s later (regression test, seeds 1~5); on an instance a still run was hit at 12.6 s, showed the low health warning at 25.6 s and fell at 29.7 s
- `hurt-not-visible`: a small health bar under the player (HUD, placed with `CameraCore.world_to_screen`), the player model glows blood red while invulnerable, and at or below `[low_health_permille]` (300) both health bars pulse (`tween/run/low_health`), the numbers turn red and `체력이 위험해요!` shows under the player
- `levelup-capture-popup-not-open`: reproduced with `run.open_pause` then `run.open_levelup`. The DEV command left the run scene with a run playing; `on_exit` saved it and the new scene resumed it with the pause popup open, so the level-up popup could not open. A second cause showed after `run.open_levelup` then `run.open_result`/`run.open_levelup`: `RunScene.on_exit` kept game time paused while a pick was open (`_set_paused(false)` still held for `_picking`), so the next run never ticked and the command went over its time limit. `run.open_run` now goes through the camp and drops the run save; `on_exit` clears the pick hold. The sequence `lobby.open_lobby`, `run.open_pause`, `run.open_levelup`, `run.open_result`, `run.open_levelup`, `run.open_pause`, `run.open_result_unsaved`, `run.open_levelup` ×2, `run.open_run`, `lobby.open_lobby`, `run.open_levelup` all returned ok
- `early-xp-pace-slow`: `[xp_base]` 3 (was 5): first level-up of a still player at 12.1~16.1 s of run time, 12.65 s on an instance. The measured value also holds 32~59 s of free-mode time before the run (terms popup and camp); `first_reward_ms` range raised to 5000~60000, see the assumption
- `damage-numbers-overlap`: numbers start on a ring of 8 spots (1.1 m) around the hit with 3 height laps, font 54 (was 72); field props are tinted darker than the horde
- `lobby-title-gold-overlap`: the title moved below the gold plate (top 136 instead of 70)
- `giveup-result-title`: a give-up shows `원정을 포기했다` on the result panel and `원정을 포기했다…` over the field. The `PANELFRAME` and `BUTTON_PRIMARY` text are the placeholder nine-slices of `nine_slice/ui/panel_frame` and `nine_slice/ui/button_primary`, already requested in iteration 1
- `death-no-presentation`: on a fall the field fades to blood red (`tween/run/death_tint`, world screen effect), the hero tips over (`tween/run/player_fall`) and `등불이 꺼졌다…` shows over the field until the result panel
- `meta-upgrade-not-visible`: a run whose loadout has shrine upgrades shows the gold notice `등불 제단의 가호가 함께합니다` when it first plays (also a resumed run at 0:00, as in the `second_run_after_meta_upgrade` fixture) and a plate of the upgrade icons with their levels under the weapon and passive icons
- New DEV command `run.state` reads the run on screen (time, health, level, kills, enemies, weapons, passives, shrine upgrades)

## unverified

- The fps targets on the target Macs: on this host the client windows were throttled to 12~17 fps whatever they drew, so the effect of the shadow change on fps was not measured
- `ogw check --loop` (bot playtest, performance, UI quality on every `uiCheckScreens` entry) was not run; the UI commands were checked only at 1920x1080 in `ko`
- The lobby title position was checked against the overlap rectangles of `check-1` (gold plate bottom 124, title top now 136 at 1920x1080), not captured on the other screens
- `first_reward_ms` with the play agent was not measured; the new range is an estimate from the iteration 1 telemetry
- The English text of the 5 new reserved strings is left to the translation work

## requests

- resource requests: none (the 3 new tween presets are final)
- core proposals: none

## assumptions

Added to `records/loops/create-1792781138827/assumptions.md`:

- How soon must a player who stands still be threatened in the opening, and how fast may the fall come?
- Which first reward time can the run reach when the metric counts the time before the run?
