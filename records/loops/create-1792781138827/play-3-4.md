## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!` result) not reached; the resumed run fell at 11:21 on the one try
- unknown: level-up popup with cards never appeared (Lv 56→58 passed with every weapon and passive at level 5, so no popup; no soup heal was seen on screen)
- unknown: chest from bone knight, soup pickup, shrine, terms, title, lobby (the instance started from the save fixture at the pause popup)
- unknown: whether the player moved on the restarted run (key D held 3000ms of game time; the screen showed no clear baseline to compare)
- play mode `step` was used for the run. The elapsed ms below are game time of the run
- play ms: 348353
- scenes: scene/title/title, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

0 | run (pause popup, resumed at 10:00) | none | pause popup over the horde field; Lv 56, 200/200 HP, 8 icons all at 5, kills 5,006, gold 1,311 | resumes at the stated moment, matches the moment description | none | captures/mvllp1sqffedcb-1792798116454.png
1200 | run 10:01 | tap pause_resume, key_down D, step 200+1000 | run continues; ~50 enemies (ogres, hooded, bats) on screen, dozens of XP gems, damage numbers 27~63, weapons visible | dense horde reads clearly, the weapon effects show, HP 200/200 | none | captures/mvllp1sqffedcb-1792798131246.png
25000 | run 10:25 | held A/S/D/W in turn, 6000ms per key | HP 104/200, Lv 57 reached with no popup, kills 5,218 | the HP fell by about 96 in 25s while moving; the player is surrounded and the gems pile up unused on the left side | minor | captures/mvllp1sqffedcb-1792798190239.png
65000 | run 11:05 | held A/W/D/S in turn, 5000ms per key | HP 49/200, `체력이 위험해요!` under the player, numbers red; Lv 58 | the low-health warning shows as written; the bolts and the ring of weapons are hard to tell apart from the enemy colours at this density | minor | captures/mvllp1sqffedcb-1792798291328.png
81000 | run 11:21 | held A/S/D/W in turn | the run fell; result `어둠에 쓰러졌다`, survived 11m21s, kills 5,803, Lv 58, gold +1,518, buttons `다시 출발` and `야영지로` | the result panel shows the four facts; the player found no soup and no way out of the horde in 16s after 49 HP | none | captures/mvllp1sqffedcb-1792798389835.png
0 | result → run | step-mode off, tap_anchor result_again | new run started in about 3s, 0:00 timer, HP 100/100, one weapon at 1 | restart works with no error in `ogw log` | none | captures/mvllp1sqffedcb-1792798419544.png
7000 | run 0:07 (new run) | key_down D, step 3000 | Lv 1, kills 3, gold 0, an XP bar already around half full at 0:07 | the XP bar is half full after 3 kills, so the first level-up comes very early; could not check the move direction | none | captures/mvllp1sqffedcb-1792798419544.png

## reproduce

No blocker or major observation.
