# open-game-works-game-iso-survivors

[한국어](README.ko.md)

**Iso Survivors** (`아이소 서바이버즈`) is an isometric 3D horde survival game for macOS in the style of Vampire
Survivors, made by AI agents with [open-game-works](https://github.com/wnsrn3436/open-game-works-core).

<p align="center"><img src=".github/media/iso-survivors.gif" alt="iso-survivors gameplay" width="640"></p>

## Play it

You need an open-game-works workspace, set up as in the harness README
[Quick start](https://github.com/wnsrn3436/open-game-works-core#quick-start).

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-iso-survivors.git games/open-game-works-game-iso-survivors
git -C games/open-game-works-game-iso-survivors branch id-registry origin/id-registry

cd open-game-works-core
tools/bin/ogw instance start open-game-works-game-iso-survivors   # prints the instance id and address
tools/bin/ogw instance stop <id>
```

After cloning, run `update env` once in the Claude Code or Codex session opened in `open-game-works-core/`: it
installs the engine of this game. The client logs in with a dev account and starts without the terms popup.

## The game

You walk a lone lantern bearer across an endless graveyard field at night. You only move: the weapons fire on their
own. Defeated enemies drop blue XP gems, each level-up offers a pick of 3 cards (a new weapon, a higher weapon level
or a passive), and the horde grows every minute. At 4:00, 8:00 and 12:00 a bone knight arrives and drops a chest with
another pick of 3. The run ends when your health reaches 0, or at 15:00 when dawn breaks and the run counts as a win.

The gold of every run, dawn or not, buys permanent upgrades at the lantern shrine of the camp, and one press starts
the next run. One player, keyboard or gamepad, in Korean (source text) and English.

| input | action |
|---|---|
| `W` `A` `S` `D` or arrow keys, gamepad D-pad or left stick | walk (two keys walk diagonally) |
| `1` `2` `3`, gamepad `X` `Y` `RB` | pick the first, second or third level-up card |
| `P` or `Esc`, gamepad `Start` or `B` | pause during a run (`Esc` and `B` go back on other screens) |
| mouse click, `Enter` or `Space`, gamepad `A` | press a button or card |

## Status

Made with the open-game-works loop and played on macOS during development. The open defects are in the loop end
records (`records/loops/*/end.md`). It has not been built for release yet: the `build` command has not been run on it.

## Change it with AI

Give these commands in a Claude Code or Codex session opened in `open-game-works-core/`:

- `update game: open-game-works-game-iso-survivors <request>` changes the game through the loop.
- `build: open-game-works-game-iso-survivors DEV` hardens the code, builds the macOS app and deploys the DEV server.

The judge agent of `update game` needs the reference gameplay video, which is not in the repository. Fetch it first,
from `open-game-works-core/` (needs `yt-dlp`). It is saved as `eqiqu3fliak.mp4`, the name
[`reference.md`](records/setup/reference/reference.md) already expects:

```sh
tools/bin/ogw game reference open-game-works-game-iso-survivors https://youtu.be/eqiqu3fliak
```

<details><summary>Before the first DEV build</summary>

- `settings.json` does not hold the build values yet.
  `tools/bin/ogw game check open-game-works-game-iso-survivors --build` lists the missing ones, and the `build` agent
  asks you for them. A DEV build without `signing.macos` makes an ad-hoc signed, not notarized macOS app.
- Secret values go into the secret store of your host, never into `settings.json`:
  `tools/bin/ogw secret generate open-game-works-game-iso-survivors DEV` for generated values, and
  `tools/bin/ogw secret set open-game-works-game-iso-survivors <DEV|signing> <name>` (value from stdin) for the
  others, such as the deploy SSH key.
- The terms document URLs in `settings.json` are placeholders (`.invalid` hosts). Replace them with your own.

</details>

## How it is built

The client (Godot) runs the whole run. The server (TypeScript) checks the result, grants the gold and keeps the record
and the shrine upgrades. Gameplay values are rows of the CSV tables in `data/`, not constants in code.

```
client (Godot)                         server (TypeScript)
run start  --- StartPlaySession ---->  prepare_run: seed, shrine upgrade levels
run end    --- FinishPlaySession --->  verify_run: bounds the result
           <-- gold, record ---------  apply_run: grants gold, counts the run
shrine buy --- BuyShopProduct ------>  validate_upgrade_step: next level only
```

It pins core `0.2.1` (`settings.json` `coreVersion`):
[core release v0.2.1](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.2.1).

| path | contents |
|---|---|
| [`brief.md`](brief.md) | the brief: player fantasy, the request, how it differs from the reference game |
| [`design.md`](design.md) | the design doc: core loop, screens, systems, economy, tuning |
| [`play-guide.md`](play-guide.md) | controls and flow for the play and judge agents |
| [`settings.json`](settings.json) | game settings: core version, engine, core modules, platform, languages |
| [`contract/`](contract) | client-server messages (protobuf) |
| [`data/`](data) | CSV tables, translations and glossary |
| [`resource/`](resource) | art, models, sound, font, scenes and prefabs; listed in `resources.csv` |
| [`client/`](client) | Godot project |
| [`server/`](server) | TypeScript server |
| [`records/`](records) | setup, loop and core proposal records |

Made with the [open-game-works](https://github.com/wnsrn3436/open-game-works-core) harness.

## License

| part | license |
|---|---|
| The content of this repository | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) ([`LICENSE`](LICENSE)) |
| `client/core/`, `server/core/` (copies of an open-game-works core release) | Apache-2.0 ([`LICENSES/Apache-2.0.txt`](LICENSES/Apache-2.0.txt)) |
| `resource/font/main.ttf` (Noto Sans KR) | SIL Open Font License 1.1 ([`LICENSES/OFL-1.1-NotoSansKR.txt`](LICENSES/OFL-1.1-NotoSansKR.txt)) |

[`resource/resources.csv`](resource/resources.csv) lists every resource key. For the final resources made by a
generation method or taken from a pinned catalog, it also gives the method and license, and for the font the source
and attribution:

| resources | method | license |
|---|---|---|
| `app_icon/main`, `splash/main`, `background/*`, `texture/ground`, `nine_slice/ui/*`, `icon/*`, `image/ui/logo_emblem` | `flux2-klein` | Apache-2.0 |
| `image/lobby/hero` | `flux2-klein` | Apache-2.0 and game-owned |
| `model/*` | `blender` | game-owned |
| `particle/*` | `procedural` | game-owned |
| `bgm/lobby`, `bgm/run` | `ace-step` | MIT |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `font/main` | `font-catalog` | OFL-1.1 |

Game-owned (`LicenseRef-game-owned` in `resources.csv`) resources were made by the game's own scripts and fall under
the license of the content of this repository. The license manifest of the game, `client/generated/licenses.json`,
lists the third-party components, such as the Godot Engine, with their licenses and notices.
