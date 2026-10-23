## coverage

- Played only the moment `second_run_after_meta_upgrade`: the first 30s of the second run (0:00 to 0:30), in step mode. Played from the resumed pause popup.
- unknown: the title, lobby, shrine purchase, first run, death and results (the moment skipped them)
- unknown: the run after 0:30, the dawn at 15:00, the chest, the soup, the fall and the restart flow
- unknown: the move hint at the bottom. It was not visible in the captures taken after resume
- unknown: the in-run shrine plate for upgrades other than the magnet (only one was bought)
- play ms: 325339
- scenes: scene/title/title, scene/run/run
- fail: 0
- restart: 0

## observations

- 0 | run (pause popup) | none | Resumed run opened with the pause popup over a 0:00 field. The plate `등불 제단의 가호` already shows with `줍는 범위 +20%` | Matches guide step 9 and step 10 | none | captures/mvllpcfbb96863-1792798134969.png
- 0 | run | tap_anchor pause_resume, step 200 | The popup closed and `등불 제단의 가호가 함께합니다` showed. The player stood with the lantern icon at weapon slot 1 and 100/100 health | The bought upgrade is acknowledged clearly | none | captures/mvllpcfbb96863-1792798143828.png
- 200 | run | none | After resume and 200ms of step, the timer still read 0:00 and no enemy was in view | Fits the run start lock | none | captures/mvllpcfbb96863-1792798143828.png
- 2200 | run | key_down D, 2s | Timer 0:02. The player moved right. The first enemy (a ghoul) showed at the bottom. No move hint was visible at the bottom | The hint the guide describes was not seen. It may have been gone already or may be missing | minor | captures/mvllpcfbb96863-1792798162815.png
- 5000 | run | key_up D, key_down W, 3s | Timer 0:05, kills 2, two blue gems dropped, and a damage number `12` showed. Health 100/100 | The weapon killed on its own and the feedback was readable | none | captures/mvllpcfbb96863-1792798183408.png
- 7000 | level-up | key_down A, 2s | The level-up popup opened at 0:07 (Lv 2) with 3 new cards: magnet charm, gale boots, spinning scythe. The popup text and the `1 2 3` hint were readable | The cards were clear. The 3 cards were all new items, so there was no upgrade choice | none | captures/mvllpcfbb96863-1792798204410.png
- 7000 | level-up | key 3 | The scythe card was picked, the popup closed, and the scythe icon appeared in the top-left slot at level 1 | Key selection works | none | captures/mvllpcfbb96863-1792798241561.png
- 12000 | run | key_down S, 5s | Timer 0:12, kills 9, gold 3. Two scythe blades orbited the player. The XP bar was filled to about 30%. Health 100/100 | Weapon and gem feedback read well | none | captures/mvllpcfbb96863-1792798241561.png
- 15000 | level-up | key_down D + W, 3s | The level-up popup opened at 0:15 (Lv 3). Health 88/100. Cards: magnet, lightning, ember | The magnet card was offered again although a magnet shrine bonus already exists. This is not a defect | none | captures/mvllpcfbb96863-1792798328291.png
- 15000 | level-up | key 2 | The lightning card was picked and its icon appeared in slot 3 | Key selection works | none | captures/mvllpcfbb96863-1792798424835.png
- 30000 | run | key_down A, 15s | Timer 0:30, kills 38, gold 12, Lv 3, health 76/100. Several enemies close in and the XP bar is near full | Pressure was rising from 0:15 to 0:30 and health was never close to danger | none | captures/mvllpcfbb96863-1792798424835.png
- 30000 | run | none | No error log lines during the whole play | Stable | none | captures/mvllpcfbb96863-1792798424835.png

## reproduce

No blocker or major observations.
