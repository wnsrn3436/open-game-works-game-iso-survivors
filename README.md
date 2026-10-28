# open-game-works-game-iso-survivors

[한국어](README.ko.md)

**Iso Survivors** (`아이소 서바이버즈`) is an isometric 3D horde survival game for macOS in the style of Vampire
Survivors. One lantern bearer holds out against a horde that keeps coming all night. AI agents made it with
[open-game-works](https://github.com/wnsrn3436/open-game-works-core).

<p align="center"><img src=".github/media/iso-survivors.gif" alt="iso-survivors gameplay" width="640"></p>

## Status

The game was made with open-game-works through a `create game` loop (3 iterations) and an `update game` loop that
reworked the UI (1 iteration), and was played and checked on macOS during development. Both loops were stopped by a
human, and the defects still open are listed in each loop's end record (`records/loops/*/end.md`). There is
no release build yet: the `build` command has never been run.

## What it is

A lone lantern bearer walks an endless graveyard field at night. The player only moves, and the weapons attack on
their own. Defeated enemies drop blue XP gems. Each level-up lets you pick one of 3 cards, and the horde grows every
minute. If you last 15 minutes, dawn breaks, the horde crumbles in the light and the run is recorded as a win.
Dawn or not, the gold earned in a run buys permanent upgrades at the camp's lantern shrine.

The game started from a one-line request to the harness: an isometric 3D game like Vampire Survivors for macOS, in
Korean and English. `brief.md` keeps that request under `## request`, along with the items the content agent decided
because the request left them out, and it also lists how the game differs from the reference game. The human named the
reference game in the request and gave its gameplay video during `setup game`.

| | |
|---|---|
| Players | one player |
| Platform | macOS (`settings.json` `buildPlatforms`) |
| Input | keyboard and gamepad |
| Screen | landscape, base resolution 1920x1080 |
| Languages | Korean (source text) and English |
| Client / server | Godot / TypeScript |
| Core version | `0.1.0` (`settings.json` `coreVersion`) |

### A run

1. Start: one press of `원정 시작` (Start Run) at the camp loads the run. Until the server opens the play session, the
   HUD shows `원정 준비 중` (Getting the run ready) and nothing moves. The run timer then starts at 0:00 with one
   weapon, the lantern bolt.
2. Move and collect: bats and ghouls close in from off screen. Walking near a blue gem pulls it in and fills the
   XP bar. A defeated enemy sometimes drops a bowl of soup that heals.
3. Level-up: when the XP bar fills, the run pauses and three cards open, each a new weapon, the next level of an owned
   weapon or a passive. The chosen card takes effect at once and the run continues. The player can hold up to 4 weapons and
   4 passives, each up to level 5. When no card is left to pick, a level-up heals instead of offering cards.
4. Waves: each minute a new wave raises the spawn rate, the enemy mix and the enemy health (`data/tables/wave.csv`).
   Skeletons, wraiths and grave brutes join. At 4:00, 8:00 and 12:00 a bone knight arrives with a red warning banner
   and a roar, and beating it drops a chest. The chest gives one more pick from 3 cards.
5. Run end: when health reaches 0, the field turns blood red, the hero falls and `등불이 꺼졌다…` (The lantern has
   gone out…) shows. At 15:00 dawn breaks, every enemy vanishes and the result title is `새벽이 밝았다!` (Dawn has
   broken!). `원정 포기` (Give Up Run) in the pause popup also ends the run. The server grants the run's gold and
   records the run, and the result panel shows the survived time, kills, level and gold. One press of `다시 출발` (Go
   again) starts the next run, and `야영지로` (To Camp) goes back to the camp.

A new player sees the terms popup once, and then the camp opens with a line inviting them to start a first run. A run
still in progress when the app closes resumes, paused, the next time the game starts. Gold, the shrine upgrades and the record
(runs, dawns, longest survival, most kills, total kills) are kept between runs. There is no character select, stage
select or weapon evolution, and there are no ads, payments or energy timers.

The weapons are `등불 탄환` (Lantern Bolt), `회전 낫` (Spinning Blade), `성화 오라` (Holy Aura), `투척 도끼` (Throwing
Axe) and `낙뢰` (Lightning Strike) (`data/tables/weapon.csv`, values per level in `weapon_level.csv`). The passives
raise damage, maximum health, pickup range or move speed, or shorten weapon cooldowns (`data/tables/passive.csv`).

### The camp and the lantern shrine

The camp shows the gold, the record card `나의 기록` (My Records), the hero by the campfire, the shrine button, and
`원정 시작` (Start Run) with the goal line under it. The badge on the shrine button shows how many upgrades you can
afford with your gold. `등불 제단` (Lantern Shrine) sells six permanent upgrades. They can be bought one level at a time and only in
level order.

| upgrade | effect per level | levels |
|---|---|---|
| `힘` (Might) | all damage +5% | 5 |
| `생명력` (Vitality) | maximum health +15 | 5 |
| `서두름` (Haste) | weapon cooldown −4% | 3 |
| `자력` (Magnet) | pickup range +20% | 3 |
| `신속` (Swiftness) | move speed +5% | 3 |
| `탐욕` (Greed) | run gold +10% | 3 |

The effects are in `data/tables/upgrade.csv` and the cost of each level in `data/tables/shop_product.csv` (the first
level costs 30 to 100 gold). A run that starts with shrine upgrades shows `등불 제단의 가호가 함께합니다` (The Lantern
Shrine blesses you), and the HUD shows a plate with the effect of each upgrade that applies to that run.

### Controls

| input | action |
|---|---|
| `W` `A` `S` `D` or arrow keys, gamepad D-pad or left stick | walk in that screen direction while held; two keys together walk diagonally |
| `1` `2` `3`, gamepad `X` `Y` `RB` | pick the first, second or third card of the level-up popup |
| `P`, gamepad `Start` | pause during a run |
| `Esc`, gamepad `B` | pause during a run; back on other screens |
| mouse click, `Enter` or `Space`, gamepad `A` | press a UI button or card (`Enter`, `Space` and `A` press the focused one) |

There is no attack input.

### Look and sound

The game is stylized low-poly 3D with hand-painted textures, seen through an orthographic isometric camera. The palette is night
(`#1B1A2E`), moss (`#3E5C3A`), lantern gold (`#C9A227`), blood red (`#8E1F2F`) and bone (`#E8E1D0`). A warm gold light
around the player pushes back the dark, and cool moonlight and fog lie over the field. The XP gems glow a deep blue so
they stand apart from the horde. When a weapon hits an enemy, an impact flash with sparks and a damage number appear.
The lantern flashes each time it fires, and every step kicks up dust. Touching an enemy makes the screen flash red and
shake briefly, and low health makes the health bars pulse. Panel titles sit on gold ribbons, and the main buttons are
large gold plates. During a run, drums and low strings play under the hit sounds, and the camp has a quiet campfire
tune. The title has no music. Every weapon has its own fire sound, and the level-up, chest, elite arrival, dawn, fall
and shrine purchase each have their own sound.

## How it works

The run plays out on the client. The server checks the result, grants the gold and keeps the record and the shrine upgrades.

```
client/ (Godot)                                server/ (TypeScript)
features/run/run_world.gd                      server core modules play-session, item-ledger, shop
  player, horde, weapons and gems in
  meters on the ground, one tick every 50 ms

run start   --- StartPlaySession ------------> hooks/play_session.ts
            <-- PlaySessionLoadout ----------    prepare_run
                (seed, upgrade_ids,
                 upgrade_levels)
run end     --- FinishPlaySession -----------> hooks/play_session.ts
                PlaySessionResult                verify_run
                (survived_ms, kills,             apply_run
                 level, dawn)
            <-- gold, updated RunRecordUserState  runs, dawns, best_survived_ms, best_kills, total_kills
shrine buy  --- BuyShopProduct --------------> hooks/shop.ts
            <-- gold spent, upgrade level +1     validate_upgrade_step
```

- `prepare_run` accepts only `level_id` 0 (`GAME_ERROR_LEVEL_NOT_FOUND` otherwise) and returns a simulation seed and
  the level of each shrine upgrade the user owns.
- `verify_run` accepts a result only when the survived time is at most `[run_duration]` and at most the play session
  time plus `[run_time_slack]`, `dawn` is set exactly when the survived time is `[run_duration]`, the kills are at
  most `[max_kills_per_minute]` per minute survived, and the level is at most `[max_level]`. It does not simulate the
  run again and only checks that the result is within these bounds.
- `apply_run` grants gold by the shared formula `run.gold_reward` and adds the run to `RunRecordUserState`. The
  gold is 1 per 10 seconds survived, plus a quarter per kill, plus a dawn bonus, with the `Greed` upgrade applied and
  every division rounded down. The client shows the gold earned so far with the same formula
  (`client/features/run/run_gold.gd`, `server/common/run_reward.ts`, cases in `data/fixtures/run.gold_reward.json`).
  The result panel shows the gold the server granted.
- `validate_upgrade_step` allows buying only the next shrine level of each upgrade
  (`GAME_ERROR_UPGRADE_ORDER` otherwise). The cost of each level, the gold check and the one-purchase limit per level
  are handled by the `shop` core module from `data/tables/shop_product.csv`.
- Gameplay values (run length, tick, player, pickup, waves, enemies, weapons, passives, gold) are rows of
  `data/system/game_setting.csv` and the tables in `data/tables/`, not constants in code.
- The game defines no requests of its own. `service Game` in `contract/service.proto` is empty, and that file holds
  `PlaySessionLoadout` and `PlaySessionResult`. `contract/user_state.proto` defines `RunRecordUserState`, and
  `contract/error.proto` defines the two game errors.
- Core modules the game chose (`settings.json` `coreModules`): client `CameraCore`, `PoolCore`, `TweenCore`,
  `ScreenEffectCore`, `InputCore`, `SoundCore`, `QualityCore`, `NativeUiCore`; server `play-session`, `item-ledger`,
  `shop`.

## Made with open-game-works

[open-game-works](https://github.com/wnsrn3436/open-game-works-core) is a harness for AI agents to make server-client
games. Features that come up again and again across games are prebuilt as core, and agents write only the gameplay
as content code. Games are made in loops. The content agent edits the game, and the play agent plays an instance with
real input. The
judge agent compares that instance with the baseline game and with the gameplay video of a reference game, and the
harness tool decides success from the judge results and automated checks. Resource sub-agents make the final
resources, and translation sub-agents make the translations.

`client/core/` and `server/core/` are copies of
[core release v0.1.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.1.0), and that release
also sets the engine version (Godot 4.7.2). When it starts, `update game` raises `coreVersion` to the newest core release
the game can use.

| repository | contents |
|---|---|
| [open-game-works-core](https://github.com/wnsrn3436/open-game-works-core) | the harness: agent rules, skills, module specs, the CLI `ogw` |
| [open-game-works-core-impl](https://github.com/wnsrn3436/open-game-works-core-impl) | the core implementation; core releases are its GitHub Releases |
| open-game-works-game-iso-survivors | this game |

## Repository layout

| path | contents |
|---|---|
| `brief.md` | The brief: player fantasy, emotion, memorable moment, genre conventions, prohibitions, failure penalty, prediction, reference game, the request and the items the content agent decided |
| `design.md` | The design doc: core loop, controls, screens, systems (field and movement, enemies and waves, weapons and passives, XP and picks, run and record, lantern shrine), progression, economy, new user, feel and tuning targets, art and audio direction, terms, core usage |
| `play-guide.md` | The play guide that the play agent and the judge agent receive: goal, controls, game flow, failure, input lock windows, fastest start path, play mode per scene |
| `settings.json` | Game settings: core version, engine, core modules, build platforms, languages, resolutions, UI check screens, per-environment values (admin operators, secrets by name only), terms documents, consent |
| `contract/` | Contract (protobuf): `service.proto`, `user_state.proto`, `error.proto` |
| `data/` | CSV tables (`tables/`, including `wave.csv`, `enemy.csv`, `weapon.csv`, `weapon_level.csv`, `passive.csv`, `upgrade.csv`, `shop_product.csv`), system tables (`system/`, including `game_setting.csv`), the shared formula fixture (`fixtures/`), translations (`translations/`), glossary (`glossary.csv`), enums and invariants |
| `resource/` | Resources by resource key: app icon, splash, backgrounds, ground texture, 3D models, UI frames, icons, images, particles, font, BGM, sound effects, scenes, prefabs, tween presets. `resources.csv` lists every resource key, with the method and license of each generated or catalog resource (and the source of the font) |
| `client/` | Godot project. Content code in `boot/`, `common/` and `features/` (`title`, `lobby`, `run`), regression tests in `tests/`, DEV code in `dev/` (bot playtest scenario `dev/bot/scenario.json`, save fixtures in `dev/bot/fixtures/`). `core/` and `generated/` are written by the harness tool. `resource` is a link to `../resource` |
| `server/` | TypeScript server. `main.ts` registers the hooks in `hooks/play_session.ts` and `hooks/shop.ts`, the run gold formula is in `common/run_reward.ts`, regression tests in `tests/`, DEV code in `dev/`. `core/` and `generated/` are written by the harness tool |
| `records/` | Process records that agents and the tool write: `setup/` (the saved request, game name, art direction, host check, `reference/reference.md`), `loops/` (the loop iteration records, play and judge results, defect lists and loop end record of each loop) and `core-proposals/` (one core proposal, font weights for `LocalizationCore`) |
| `LICENSE`, `LICENSES/` | License texts |

The branch `id-registry` holds only the ID registry (`id_registry.json`). Only the data tool writes to this branch,
and it is never merged with another branch. Build artifacts (`builds/`), the data binaries (`client/build/`,
`server/build/`), captures, loop evidence and the reference game video are not committed.

### Languages

The source text is Korean. `settings.json` sets no `sourceLanguage`, so the default `ko` applies, and
`supportedLanguages` is `ko` and `en`. The English text is in `data/translations/en.csv`. `data/glossary.csv` fixes
the translation of names such as the game title, the weapons, the passives and the upgrades. The documents
(`brief.md`, `design.md`, `play-guide.md`, `reference.md`) are written in English and keep the Korean game text in code
spans.

## Requirements

- An open-game-works workspace with the harness set up as the harness
  [README](https://github.com/wnsrn3436/open-game-works-core) describes (Node 24 or later, Git, GitHub CLI, Docker with
  buildx, uv and Python, Claude Code or Codex)
- Godot 4.7.2, the engine version set by the core release this game pins. `update env` installs it into
  `<workspace>/.ogw/`
- To build the macOS app, you need an Apple silicon Mac with Xcode 27 (as set in the `engine.json` of core release 0.1.0).
  macOS is the only build platform of this game
- Windows: `client/resource` is a symbolic link. Before cloning, you need to enable Developer Mode and run
  `git config --global core.symlinks true`, or the link checks out as a plain text file. The play agent and the judge
  agent run only on macOS and Linux, so the loop and builds cannot run on Windows

## Setup

Clone the repository into the workspace's `games/` folder, and create the local branch `id-registry` from the remote one. A
clone creates only the local branch `main`, but the data tool reads the ID registry from the local `id-registry`
branch.

```
<workspace>/
  open-game-works-core/
  open-game-works-core-impl/
  games/open-game-works-game-iso-survivors/
```

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-iso-survivors.git games/open-game-works-game-iso-survivors
git -C games/open-game-works-game-iso-survivors branch id-registry origin/id-registry
```

The folder name is the game name used in commands. Then open Claude Code or Codex in `open-game-works-core/` and run
`update env`. This command checks this game's build toolchain and installs the engine that matches its core
version.

### Reference game video

`records/setup/reference/reference.md` records the reference game that a human picked during `setup game`, the source
URL of its gameplay video and the moments in the video that the judge agent compares against. The video file is not
in the repository (`.gitignore` excludes every file in `records/setup/reference/` except `reference.md`), but the
judge agent of `update game` needs it. Before you run the loop, fetch it by running this command from
`open-game-works-core/` (needs `yt-dlp`).

```sh
tools/bin/ogw game reference open-game-works-game-iso-survivors https://youtu.be/eqiqu3fliak
```

The video is saved in `records/setup/reference/` as `<video id>.mp4`. For this video that is `eqiqu3fliak.mp4`, the
name already listed under `## video` in `reference.md`.

## Usage

Give the commands below in a Claude Code or Codex session opened in `open-game-works-core/`. The agent that receives a
command carries it through to the end and reports the result.

| command | what it does |
|---|---|
| `update game: open-game-works-game-iso-survivors <request>` | Changes the game through the loop. The request is feedback from a human or a PROD problem to fix. When the loop stops, the commit the tool picked is merged into main if main has not changed in the meantime, and the agent reports back using the loop end record |
| `build: open-game-works-game-iso-survivors DEV` | Hardens the server and client content code, runs the checks again with PostgreSQL, builds the macOS app into `builds/`, tags the commit `dev-<version>` and deploys the DEV server. Without `--version`, the first build is `0.1.0` |

STG and PROD builds also produce signed artifacts. STG also deploys the server, and a human deploys PROD.

### Running an instance

An instance is a dev run of the game, made up of one local server with its own DB and a client that draws the screen.
`ogw` is `tools/bin/ogw` in the harness repository and runs from `open-game-works-core/`.

```sh
tools/bin/ogw instance start open-game-works-game-iso-survivors   # prints the instance id and address
tools/bin/ogw instance stop <id>
```

The client logs in with a dev account and starts without the terms popup. The DB is SQLite unless you pass
`--db postgresql`. `--commit <sha>` starts the instance from another commit, and `--fixture <file>` runs a save
fixture after boot (this game's fixtures are in `client/dev/bot/fixtures/`). `ogw capture <id>` captures the
screen, `ogw log <id>` shows the error log, and `ogw command <id> list_commands` lists the content commands of the
game.

### Before the first DEV build

Run these commands from `open-game-works-core/`.

- `settings.json` does not hold the build values yet.
  `tools/bin/ogw game check open-game-works-game-iso-survivors --build` lists the missing ones: `appId`,
  `serverImage`, and per environment `serverUrl`, `trustedProxyCount`, `secrets` (names), `adapters`, `deploy` for DEV
  and STG, `cdnR2` for PROD, and `signing.macos` for STG and PROD. If values for the environment being built are missing
  when you give a `build` command, the agent that receives the command asks you for them, fills them in and runs
  `ogw secret generate` for that environment. A DEV build made without `signing.macos` produces a macOS app that is
  only ad-hoc signed and not notarized.
- Secret values go into your host's secret store, not into `settings.json`. Values that can be generated go in
  with `tools/bin/ogw secret generate open-game-works-game-iso-survivors DEV`, and the rest, such as the deploy SSH
  key, with `tools/bin/ogw secret set open-game-works-game-iso-survivors <DEV|signing> <name>`. `secret set` reads
  the value from standard input.
- The terms document URLs in `settings.json` are placeholders (`.invalid` hosts). Replace them with your own.

## License

| part | license |
|---|---|
| The content of this repository | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) (`LICENSE`) |
| `client/core/`, `server/core/` (copies of an open-game-works core release) | Apache-2.0 (`LICENSES/Apache-2.0.txt`) |
| `resource/font/main.ttf` (Noto Sans KR) | SIL Open Font License 1.1 (`LICENSES/OFL-1.1-NotoSansKR.txt`) |

`resource/resources.csv` lists every resource key. For the final resources made by a generation method or taken from a
pinned catalog, it also gives the method and license, and for the font also the source and attribution. Those
resources are:

| resources | method | license |
|---|---|---|
| `app_icon/main`, `splash/main`, `background/*`, `texture/ground`, `nine_slice/ui/*`, `icon/*`, `image/ui/logo_emblem` | `flux2-klein` | Apache-2.0 |
| `image/lobby/hero` | `flux2-klein` | Apache-2.0 and game-owned |
| `model/*` | `blender` | game-owned |
| `particle/*` | `procedural` | game-owned |
| `bgm/lobby`, `bgm/run` | `ace-step` | MIT |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `font/main` | `font-catalog` | OFL-1.1 |

Game-owned (`LicenseRef-game-owned` in `resources.csv`) resources were made by scripts the game wrote itself and fall
under the license of the content of this repository. The license manifest of the game, `client/generated/licenses.json`,
lists the third-party components, such as the Godot Engine, with their licenses and notices.
