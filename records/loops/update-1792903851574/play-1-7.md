## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!` result, every enemy vanishing). The longest run reached 2:10 of run time; dawn was not reached
- unknown: pause popup (`P`/`Esc`, `계속하기`, `원정 포기`) was not opened
- unknown: `체력이 위험해요!` seen once at 12/140 health; the soup heal, the bone knight chest and a level-5 weapon/passive were not seen
- unknown: the `등불 제단의 가호가 함께합니다` toast of the second run was not seen (the capture came about 2 s after the run start); the plate `등불 제단의 가호` was seen
- unknown: the options (`설정`) popup, the terms `보기` buttons, a save fixture / moment (none given)
- unknown: playing with a gamepad
- Run 1 was played in step mode with `D`+`S` held for about the first 1:13 and then standing still until the fall. Run 2 was only started, not played
- play ms: 828694
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 1
- restart: 1

## observations

- 0 | scene/title/title | none | The terms popup shows 3 checkboxes, `확인` is dimmed and the line `두 항목에 모두 동의하면 시작할 수 있어요` is shown | clear | none | captures/mvnghzx2c2cea7-1792910315929.png
- 10000 | scene/lobby/lobby | tap_anchor terms_agree_all, tap_anchor terms_confirm | After 3 s the camp shows. Gold 0, `나의 기록` says `첫 원정을 떠나 새벽까지 버텨 보세요`, hero by the fire, `원정 시작` is the largest yellow button | The first screen is readable and the next step is obvious | none | captures/mvnghzx2c2cea7-1792910326142.png
- 20000 | scene/lobby/lobby | tap_anchor lobby_upgrades | Six upgrade rows with `Lv 0/5` or `Lv 0/3`, empty pips, effect lines, costs 30~100, and `금화가 부족해요` over every buy button at 0 gold | Clear. `닫기` is easy to find | none | captures/mvnghzx2c2cea7-1792910334523.png
- 32000 | scene/run/run | tap_anchor lobby_play | The run started at 0:00 after loading; the move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom, health 100/100, one weapon icon (lantern flame) | The goal and the controls are told at once | none | captures/mvnghzx2c2cea7-1792910346074.png
- 53000 | scene/run/run | key_down D | The player walks right; the lantern fireball shoots on its own at an enemy. 0:03, no kills yet, enemies (zombies, a bat) enter from the screen edges | Auto attack reads clearly | none | captures/mvnghzx2c2cea7-1792910363356.png
- 60000 | scene/run/run | key_down D, key_down S | At 0:06 with 5 kills the level-up popup opens. `ogw step` did not stop with a reason: it ended with `step failed: "the command went over its time limit"` at step 20 of 40, and the next step said `game time is paused` | The first level-up comes 6 s into the run. The popup is clear (three cards, `1 2 3 로도 고를 수 있어요`). The step tool gave no popup reason this time, so the player agent only found the popup by capturing | minor | captures/mvnghzx2c2cea7-1792910423761.png
- 80000 | scene/run/run | key 1 | The card press picks the first card (`회전 낫`) and the run goes on; the weapon list shows the sickle icon | The card pick answers at once | none | captures/mvnghzx2c2cea7-1792910490165.png
- 200000 | scene/run/run | key_down D, key_down S | 1:13: Lv 4, 74 kills, health 62/100, four icons in the list (lantern, sickle, fire passive, magnet), about 15 enemies on screen | Pressure is rising at a pace that feels fair for the first 1~2 minutes | none | captures/mvnghzx2c2cea7-1792910649028.png
- 380000 | scene/run/run | key_up D, key_up S (standing still) | 1:16: Lv 5, 79 kills, health 76/120 while standing still in a crowd of about 25 enemies; 1:21: health 42/120; Lv 6 | A player who does not move still gets to 2 minutes and Lv 12, so a moving player is not rewarded much in the first 2 minutes | minor | captures/mvnghzx2c2cea7-1792910762378.png
- 690000 | scene/run/run | standing still | 1:55: Lv 11, 311 kills, health 12/140. The ring flame weapon surrounds the player, `체력이 위험해요!` shows under the player, the health numbers are red | The danger text and red numbers are clear. The screen is crowded: with 25+ enemies, damage numbers and the ring, the player is hard to see | minor | captures/mvnghzx2c2cea7-1792910992989.png
- 700000 | scene/run/run | none | Between 1:55 and 2:10 the level-up popup opened 2 more times (Lv 11 and Lv 12); the step tool stopped with `popups changed: [] -> [prefab/run/levelup_popup]` once, and with `time limit` several times (each in the same place as a level-up) | The level-up flow works. The step tool reports the popup in only some cases | minor | captures/mvnghzx2c2cea7-1792911028082.png
- 750000 | scene/run/run | none | At 2:10 health 0/140: the field turns red, `등불이 꺼졌다…` shows, skeletons (new enemy type) around the player. The step stopped on the mark `Fail` | The fall is easy to read | none | captures/mvnghzx2c2cea7-1792911056936.png
- 760000 | scene/run/run | step-mode off | About 9 s later the result panel `어둠에 쓰러졌다` shows: survive time 2분 10초, kills 396, level 12, gold +112, `다시 출발` (yellow) and `야영지로` | The result lists the facts of the run and both next steps | none | captures/mvnghzx2c2cea7-1792911065745.png
- 770000 | scene/lobby/lobby | tap_anchor result_lobby | The camp shows gold 112, `나의 기록` (best 2분 10초, kills 396, runs 1회, dawns 0회), a red badge `6` on the shrine and the line `금화로 살 수 있는 강화가 있어요` | The badge and the line tell what to do with the gold | none | captures/mvnghzx2c2cea7-1792911077106.png
- 780000 | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_vitality], [upgrade_magnet] | Both bought: gold 112 → 42, `Lv 1/5` and `Lv 1/3` with one lit pip, the next costs went from 40 → 100 and 30 → 90, and the toast `자력 강화 완료!` shows over the middle of the panel | The purchase answers at once. The cost of the next level is 2.5~3 times the first, which makes the second level far from the gold of one short run | minor | captures/mvnghzx2c2cea7-1792911082188.png
- 790000 | scene/run/run | tap_anchor upgrade_close, tap_anchor lobby_play | Run 2 starts: health 115/115 (100 + 15), the plate `등불 제단의 가호` with `최대 체력 +15` and `줍는 범위 +20%`, 2 kills at 0:05 | The bought upgrades show in the run | none | captures/mvnghzx2c2cea7-1792911100036.png

## reproduce

None. There is no `blocker` or `major` observation.
