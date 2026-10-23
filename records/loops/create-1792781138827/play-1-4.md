## coverage

- Started from the save fixture moment `late_run_horde`: resumed run with the pause popup open at 10:00, Lv 45, 200/200 health, 8 icons in the weapon/passive tray (all level 5)
- unknown: terms popup, title, camp (lobby), lantern shrine, `원정 시작` flow (the fixture skipped them)
- unknown: level-up popup (none appeared in the ~6s of game time played after resuming), chest card pick, soup heal
- unknown: dawn at 15:00 (the run was given up at 10:08)
- Failure flow played through the pause `원정 포기` (give up), not by health reaching 0. Health 0 fall and its 1.6s delay: unknown
- Run again (`result_again`) reached a fresh run at 0:05 with Lv 1. `야영지로` (`result_lobby`) not pressed: unknown
- play ms: 118748
- scenes: scene/title/title, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

10000 | scene/run/run | none (capture on resume) | pause popup over the late-run field. Title `일시 정지`, buttons `계속하기` and `원정 포기`, note that gold is kept on giving up | the button labels are overprinted by placeholder texture text `BUTTON_PRIMARY` / `BUTTON`; `계속하기` is hard to read. Gauge frame shows `BAR_FRAME` and the tray shows `PLATE` as stretched placeholder text | major | captures/mvle1uqt3a7cf4-1792785300179.png
15600 | scene/run/run | tap_anchor pause_resume, key_down D, step 200 | run resumed, timer 10:04, kills 4,385, gold 1,156. A bright player box sits at the centre of a lit platform | resume worked at once. Wide floor text `GROUND` repeats across the field | minor | captures/mvle1uqt3a7cf4-1792785315783.png
15600 | scene/run/run | step 200 (D held) | many damage numbers (19, 27, 30, 63) stacked at the same spots around the player | numbers overlap into unreadable blobs, e.g. `3019`, `2719`. Enemies (pink/red tall boxes) look much like the lavender building blocks around them, so which blocks are enemies is hard to tell | major | captures/mvle1uqt3a7cf4-1792785315783.png
40500 | scene/run/run | step 200 x10 (D held), key_up D | timer 10:06, health 168/200 (down 32), kills 4,403 | the horde is dense and fills the screen, but the framerate and input still held up and no error was logged (`ogw log`: no error log). The player stays at screen centre, so a move to the right cannot be read from the player; only the field shifts | minor | captures/mvle1uqt3a7cf4-1792785340665.png
40500 | scene/run/run | step 200 x10 | no level-up popup in 2s of step time at Lv 45 | not enough time to judge how often the popup comes at this level | none |
58700 | scene/run/result | key P, tap_anchor pause_give_up | result panel `어둠에 쓰러졌다` after about 3s: survived 10분 8초, kills 4,420, level 45, gold +1,165 | the panel opens fine, but a big `PANELFRAME` placeholder text covers the middle lines (kills, level) and the two buttons carry `BUTTON_PRIMARY` text over `다시 출발` / `야영지로`. A deliberate give-up is titled `어둠에 쓰러졌다` (fell in the dark), which does not say it was a give-up | major | captures/mvle1uqt3a7cf4-1792785358888.png
66000 | scene/run/run | tap_anchor result_again | new run at 0:05 after about 500ms of loading, Lv 1, health 100/100, kills 1, gold 0, one weapon (`WEAPON_LANTERN_BOLT` 1). Move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom | restart is quick and the reset is clean. The weapon and passive icons show their ID names in tiny text (`WEAPON_LANTERN_BOLT`) instead of art | minor | captures/mvle1uqt3a7cf4-1792785366185.png

## reproduce

- Placeholder text over buttons and panels (pause popup and result panel): start the instance with the `late_run_horde` fixture → the pause popup shows `BUTTON_PRIMARY` over `계속하기`. Press `P` during a run, then `tap_anchor pause_give_up` → the result panel shows `PANELFRAME` over the stats and `BUTTON_PRIMARY` over `다시 출발`
- Damage numbers and enemies hard to tell from scenery: start with the fixture → `tap_anchor pause_resume` → `key_down D` → `ogw step 200` a few times → capture. Stacked numbers overlap around the player and the red boxes blend with the blocks
