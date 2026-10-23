## coverage

- unknown: dawn at 15:00 (only reached 10:06 of game time; moment ran ~6200ms of game time after resume)
- unknown: level-up popup (none appeared in the ~6s played)
- unknown: fall / result panel / `다시 출발` restart flow (health went 100 → 68, never reached 0)
- unknown: title, camp, lantern shrine, terms (instance started from save fixture)
- play ms: 99716
- scenes: scene/title/title, scene/run/run
- fail: 0
- restart: 0

## observations

0 | scene/run/run | none (instance start) | Opens on pause popup at 10:00, Lv 46, 100/100 HP, 4,466 kills, 1,176 gold; popup text `일시 정지`, `계속하기`, `원정 포기` | Placeholder art shows: buttons render debug text "BUTTON_PRIMARY", HUD panel shows stretched "PLATE", bar shows "BAR_FRAME", ground shows "GROUND" tiles; the button labels are hard to read over it | major | captures/mvlhf2mp000630-1792790936129.png
1 | scene/run/run | tap_anchor pause_resume | Popup closed, run continued | Resume works | none | captures/mvlhf2mp000630-1792790944655.png
2 | scene/run/run | key_down D, step 200 x2 | After 400ms game time timer still 10:00, HP 84/100 (lost 16 in 400ms), kills 4,475 | Dense ring of enemies hugging the player; damage taken at once on resume | minor | captures/mvlhf2mp000630-1792790948641.png
3 | scene/run/run | hold D 3200ms then hold W 3000ms in steps | Timer 10:06, HP 68/100, kills 4,514, gold 1,188 | Damage numbers (19/27/30/63) stack and overlap near the player, hard to read; enemies are plain boxes, tough to tell enemies from gems and scenery (blue and lilac cubes of the same palette) | major | captures/mvlhf2mp000630-1792790995592.png
4 | scene/run/run | steps | `ogw log` showed no error log | No errors in the horde scene | none | n/a
5 | scene/run/run | steps | Weapon/passive icons all level 5 and drawn with tiny unreadable debug labels (`WEAPON_LANTERN_BOLT` etc.) | Cannot tell weapons apart except by colour | minor | captures/mvlhf2mp000630-1792790995592.png

## reproduce

- 0: start the instance with the save fixture `late_run_horde` and capture the pause popup
- 3: tap `pause_resume`, turn step mode on, `key_down D`, step 200ms x16, `key_up D`, `key_down W`, step 200ms x15, capture
