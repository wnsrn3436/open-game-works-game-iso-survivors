## coverage

- unknown: run time 0:16~0:30 of the moment (not played; stopped at 0:16)
- unknown: level-up popup (Lv 1 through 0:16), taking a hit, health below 100, soup, failure and restart flow (the instance was a resumed run, so the second-run flow and the effect of the bought upgrade were not checked)
- unknown: terms, title, camp, lantern shrine, result panel
- The run moved right 1s, then down about 15s, in step mode (200ms steps)
- play ms: 206937
- scenes: scene/title/title, scene/run/run
- fail: 0
- restart: 0

## observations

0 | run (pause popup, fixture start) | none | The run opens on the pause popup at 0:00 with `계속하기` and `원정 포기`. Button labels sit over large placeholder text ("BUTTON_PRIMARY", "BUTTON") and the Korean labels are hard to read | placeholder art text covers the button labels | major | captures/mvle2d7h36f4d1-1792785316961.png
0 | run HUD | none | The health bar shows "BAR_FRAME", the weapon slot and the kills/gold panel show a large "PLATE" in the middle, and the weapon icon shows tiny debug text | unfinished placeholder art on the HUD | major | captures/mvle2d7h36f4d1-1792785316961.png
23808 | pause popup | tap_anchor pause_resume | Resumed. The timer started at 0:00 | worked as the guide says | none |
1000 | run | key_down D, step 5x200ms | Timer 0:01. The player held its place on the screen (the camera follows) and the ground moved. The player looks like a glowing white block with a red glow | movement reads clearly, but the player is a plain block | minor | captures/mvle2d7h36f4d1-1792785338268.png
6000 | run | key_down S held | Timer 0:06, 2 kills, gold 0, health 100/100, a damage number "12" shows. Small cubes (enemies) are around | auto attack works and the damage number shows | none | captures/mvle2d7h36f4d1-1792785392418.png
11000 | run | key_down S held | Timer 0:11, 5 kills, gold 2, health 100/100 | gold rises during the run; there was no pressure yet | none | captures/mvle2d7h36f4d1-1792785436070.png
16000 | run | key_down S held | Timer 0:16, 9 kills, gold 3, Lv 1, health 100/100. The XP bar at the top does not visibly change, and no blue gem is seen on screen | the XP gain and the gem drops cannot be told apart on screen | minor | captures/mvle2d7h36f4d1-1792785479597.png
0-16000 | run | step ms | One `ogw step` of 200ms takes about 1.7s real time | slow to play, but not a game defect | none |
0-16000 | run | none | The ground is covered by repeated "GROUND" text and the obstacle blocks are all one color | placeholder look; the ground text is as bright as the enemies and makes them harder to find | minor | captures/mvle2d7h36f4d1-1792785479597.png
0-16000 | run | none | Error log empty | none | none |

## reproduce

- Observation at 0 (placeholder text over the pause buttons) and the HUD placeholders: start the instance with the save fixture `second_run_after_meta_upgrade` and capture the first screen
