## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) was not reached. The longest run was 0:33 of run time
- unknown: bone knight chest, soup heal, the level-up auto-heal at max level
- unknown: the shrine purchase flow and the run start with `등불 제단의 가호` plate. Gold was 0 at the first shrine visit and the gold earned in run 1 (16) did not cover the cheapest upgrade (30), so no buy was tried
- unknown: pause `원정 포기`. Only the pause popup open and `계속하기` were tried
- unknown: gamepad input, `Escape` and mouse-click card pick. Cards were picked with key `1` only
- unknown: terms `보기` buttons
- play ms: 335411
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

0 | scene/title/title | none | Terms popup shows 3 checkboxes, `확인` dimmed with `두 항목에 모두 동의하면 시작할 수 있어요` | Clear what to do | none | captures/mvnghsz640ed6e-1792910307586.png
6000 | scene/title/title | tap_anchor terms_agree_all, terms_confirm | Consent was accepted, camp opened within 3s | Smooth | none | captures/mvnghsz640ed6e-1792910318854.png
12000 | scene/lobby/lobby | none | Camp shows title, gold 0, `나의 기록` with first-run message, hero, `등불 제단`, `원정 시작` | Readable; the primary button stands out | none | captures/mvnghsz640ed6e-1792910318854.png
22000 | scene/lobby/lobby | tap_anchor lobby_upgrades | Shrine opens with six rows, costs 30 to 100, every row shows `금화가 부족해요` over a dimmed buy button | Clear why a buy is unavailable | none | captures/mvnghsz640ed6e-1792910328006.png
23000 | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_might] with 0 gold | Nothing bought, gold stays 0 | As the guide says | none | captures/mvnghsz640ed6e-1792910328006.png
37000 | scene/run/run | tap_anchor lobby_play | Run starts at 0:00 within ~1s. The move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom | Clear. The field is very dark; graves and rocks are barely visible | minor | captures/mvnghsz640ed6e-1792910336565.png
~100000 | scene/run/run | key_down D then S, ogw step 200 | The first level-up popup opened at 0:06, 4 kills. Three cards with labels `새로 얻기` or `Lv 2`, description and the hint `1 2 3 로도 고를 수 있어요`. The step call stopped with `the command went over its time limit` instead of the popup-change stop message | First level-up came very fast, 6 seconds in. The cards read well. The step failure message hides the real reason | minor | captures/mvnghsz640ed6e-1792910396448.png
~118000 | scene/run/run | key 1 | The `성화 오라` card was picked. A yellow ring appeared around the player and the weapon icon shows in the top left, run continued at once | Clear feedback that the pick took effect | none | captures/mvnghsz640ed6e-1792910419548.png
~125000 | scene/run/run | key P | The pause popup opened | | none | captures/mvnghsz640ed6e-1792910431163.png
~141000 | scene/run/run | tap_anchor pause_resume, key_up S, ogw step 500 ×10 | The run continued after resume | | none | captures/mvnghsz640ed6e-1792910431163.png
~147000-228000 | scene/run/run | ogw step 500 --count 10, then key 1 | 3 of 6 step calls (at about 147s, 187s, 228s play ms) failed with `the command went over its time limit` after 1 to 8 steps. The step output after the failure shows game time did advance past it (play ms 147519 → 184969). The key `1` after each call picked a card when one was open | Every level-up in step mode stops the step run with a failure rather than the normal stop reason. This makes step play of a run clumsy | minor | captures/mvnghsz640ed6e-1792910559106.png
~265000 | scene/run/run | idle, no input | At 0:30, level 5, health 16/100. The red numbers and `체력이 위험해요!` show under the player. About 12 enemies (ghouls, bats) are near. Kills 47, gold 14 | The low-health warning is easy to see | none | captures/mvnghsz640ed6e-1792910559106.png
~278000 | scene/run/run | idle | Health reached 0 at 0:33. The Fail mark was added, the field turned red and `등불이 꺼졌다…` showed | Clear fall feedback | none | captures/mvnghsz640ed6e-1792910577504.png
~288000 | scene/run/run | ogw step 500 | The result panel opened ~1.6s after the fall: `어둠에 쓰러졌다`, survival 33s, kills 55, level 5, gold +16, buttons `다시 출발` and `야영지로` | The panel matches the guide | none | captures/mvnghsz640ed6e-1792910587841.png
~300000 | scene/run/run | tap_anchor result_again | A new run started within 3s. Time 0:03, level 1, health 100/100, the move hint shows again | Restart is quick | none | captures/mvnghsz640ed6e-1792910600323.png
0-300000 | scene/run/run | idle in run 1, 0:00 to 0:33 | Player died at 0:33 without moving. Level 5 was reached in 33s with 4 card picks (the shown HUD has 4 weapon or passive icons) | Early difficulty is high enough to kill an idle player in half a minute. Whether a moving player lives longer was not tested at length | none | captures/mvnghsz640ed6e-1792910559106.png

## reproduce

None. No observation has severity `blocker` or `major`.

For the `minor` step failure:

1. Start a run and `ogw step-mode <instance> on`
2. `ogw step <instance> 200 --count 15` until the first level-up opens at about 0:06
3. The call ends with `the command went over its time limit` rather than the stop reason
