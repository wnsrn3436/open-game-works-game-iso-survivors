## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!` result, every enemy vanishing). Not reached; the longest run was 0:40 of run time
- unknown: the bone knight chest, soup healing, the weapon-at-level-5 full-slot heal, the 30%-health warning (`체력이 위험해요!`)
- unknown: a shrine purchase and the `등불 제단의 가호` plate on the next run (gold was 15, the cheapest row costs 30)
- unknown: the options (`설정`) popup, the 보기 (view terms) buttons
- unknown: fall-title skipping by a move key or `P` during the 1.6 s wait (not tried)
- play ms: 229634
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title/title | none (boot) | terms popup with three checkboxes and a disabled `확인` over the title logo, which shows through behind it | readable, the hint `두 항목에 모두 동의하면 시작할 수 있어요` is shown | none | captures/mvnnea7i16978e-1792921900630.png
10000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | the camp opened with 0 gold, the `나의 기록` card with the first-run line, `등불 제단` without a badge, and `원정 시작` | clear layout, the large yellow button is the obvious next step | none | captures/mvnnea7i16978e-1792921910574.png
30000 | scene/lobby/lobby | tap_anchor lobby_play | the run scene was reached within about 3 s, and the first step reported a server `Response` mark at 33980 | no stall past the written 2000 ms loading window | none | captures/mvnnea7i16978e-1792921920621.png
41967 | scene/run/run | key_down D, step 200 x10 | at 0:02 the field is very dark; the player is a small figure at the screen center with a small red bar. Enemies come in at the corners and edges. The `WASD` hint was not visible in this capture | the player and enemies are low-contrast on the dark ground and are hard to tell apart at a glance | minor | captures/mvnnea7i16978e-1792921932934.png
58381 | scene/run/run | step 200 x40, holding D | at 0:10: 7 kills, 2 gold, level 1 and an empty XP bar, with 3 blue gems lying on the left while the player walked right | the weapon (the lantern, level 1) kills on its own, but its attack effect is not visible in the capture; I could only see the kill count rise | minor | captures/mvnnea7i16978e-1792921950708.png
71804 | scene/run/run | key_up D, key_down A, step | the level-up popup opened at 0:13 (Lv 2); game time stopped and `ogw step` failed with "game time is paused", as the guide says | the popup is clear, with `1 2 3 로도 고를 수 있어요` shown | none | captures/mvnnea7i16978e-1792921963726.png
71804 | scene/run/run | none | all three level-up cards at Lv 2 were new passives (바람의 깃털, 거인의 심장, 분노의 불씨); no weapon card was offered | the first choice offers no new way to attack, so the choice feels like numbers only | minor | captures/mvnnea7i16978e-1792921963726.png
72000 | scene/run/run | key 3 | picked 분노의 불씨 and the run continued; the HUD later showed the lantern at 2 and two passives at 1 | the pick registered | none | captures/mvnnea7i16978e-1792921994336.png
150917 | scene/run/run | standing still after key_up A, key 1 at level-ups | health reached 0 at 0:40 after 45 kills and level 4; the field turned red, `등불이 꺼졌다…` showed, and about a dozen enemies surrounded the player | the fall is clear. The player is hard to see inside the crowd | none | captures/mvnnea7i16978e-1792922044192.png
162259 | scene/run/run | wait | the result panel `어둠에 쓰러졌다` opened with survival 40 s, 45 kills, level 4 and gold +15 (the gold in the HUD was 15) | the numbers match the HUD | none | captures/mvnnea7i16978e-1792922057255.png
168000 | scene/run/run | tap_anchor result_again | a new run started at 0:00 with level 1 and restart count 1 | restart works | none | captures/mvnnea7i16978e-1792922068740.png
172000 | scene/run/run | key P | the pause popup opened at 0:06 with `계속하기`, `원정 포기` and `포기해도 지금까지 번 금화는 받아요`. The move hint `WASD 로 움직이세요. 공격은 자동이에요` shows dimmed below it | clear | none | captures/mvnnea7i16978e-1792922072687.png
178000 | scene/run/run | tap_anchor pause_give_up | the result panel `원정을 포기했다` opened with 6 s, 3 kills, level 1 and gold +0 | matches the HUD (0 gold) | none | captures/mvnnea7i16978e-1792922078714.png
190000 | scene/lobby/lobby | tap_anchor result_lobby, tap_anchor lobby_upgrades | the shrine panel shows six rows with Lv, pips, effects and cost (50, 40, 100, 30, 60, 80). Gold is 15, so every row shows `금화가 부족해요` | clear; the cheapest upgrade costs 30, which is two of the 15-gold runs I made (a 40 s fall gave 15) | none | captures/mvnnea7i16978e-1792922090619.png

## reproduce

(no blocker or major observations)
