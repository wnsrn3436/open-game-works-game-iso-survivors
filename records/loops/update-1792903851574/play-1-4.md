## coverage

- unknown: the terms popup (the fixture starts on the camp), buying a shrine upgrade (0 gold, so every buy button showed `금화가 부족해요`), the shrine plate `등불 제단의 가호` on a run start, the fall (health 0) and its result panel, dawn at 15:00 and `새벽이 밝았다!`, low-health warning, the chest and soup pickups, the gamepad
- the failing flow was only partly gone through: after giving up I pressed `다시 출발` once and a new run started. The fall itself was not reached
- the moment `titles_and_buttons` was reached in order: camp → shrine → close → run → level-up → pause → give up → result
- play ms: 183364
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

0 | scene/lobby/lobby | none | camp shown: game name at top left in gold winged title, gold `0`, gear `설정`, `나의 기록` card with the first-run line, hero by the fire, `등불 제단` and the large yellow `원정 시작` with `새벽까지 15분 버티면 승리` | headings share one gold-on-dark style and read clearly. The `나의 기록` card body is mostly empty space | none | captures/mvndmflbac0bb7-1792905487859.png
8000 | scene/lobby/lobby | tap_anchor lobby_upgrades | shrine panel opened with six rows (힘 Lv 0/5 50, 생명력 Lv 0/5 40, 서두름 Lv 0/3 100, 자력 Lv 0/3 30, 신속 Lv 0/3 60, 탐욕 Lv 0/3 80), `금화가 부족해요` in red over each buy button, `닫기` at the bottom | title banner, row names, level and cost are all legible. Rows are dense but not overlapping. The red `금화가 부족해요` text is small next to the large buy buttons | none | captures/mvndmflbac0bb7-1792905495208.png
15000 | scene/lobby/lobby | tap_anchor upgrade_close | panel closed and the camp came back at once | none | none | captures/mvndmflbac0bb7-1792905502899.png
22000 | scene/run/run | tap_anchor lobby_play | the loading passed and the run started at 0:00 with the hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom | HUD (health 100/100, timer, Lv 1, kills, gold) is readable. The field is very dark and the hero is small, so enemies and gems are hard to tell at a glance | minor | captures/mvndmflbac0bb7-1792905512395.png
30000 | scene/run/run | key_down D then ogw step 200 | the player walked right, 3 kills by 0:09, enemies (zombies, a bat) came from the screen edges | the hint line was gone after the first move. Kill count rose without any visible attack effect in the captures I saw | none | captures/mvndmflbac0bb7-1792905551080.png
45000 | scene/run/run | ogw step 200 --count 60 | the level-up popup opened at 0:12 while stepping, and the step call ended with `step failed: "the command went over its time limit"` at step 16 instead of the usual stop reason for a popup change | the level-up popup itself is fine, but the step tool failed instead of reporting the popup | minor | captures/mvndmflbac0bb7-1792905592166.png
46000 | scene/run/run | (level-up popup shown) | `레벨 업!` banner, `하나를 고르세요`, three `새로 얻기` cards (자석 부적, 투척 도끼, 낙뢰) with icon, name and effect, and the line `1 2 3 로도 고를 수 있어요` | the card text and icons are legible. The hint line at the bottom is small and sits on the panel border | minor | captures/mvndmflbac0bb7-1792905592166.png
52000 | scene/run/run | key 2 | the second card (투척 도끼) was taken and shown in the weapon row of the HUD (the lantern 1 and the axe 1); the run continued | none | none | captures/mvndmflbac0bb7-1792905601775.png
55000 | scene/run/run | key P | the pause popup opened: `일시 정지`, `계속하기` (yellow, focus), `원정 포기`, `포기해도 지금까지 번 금화는 받아요`. `ogw step` failed with `game time is paused`, as written in the guide | heading and buttons match the other screens in style | none | captures/mvndmflbac0bb7-1792905608431.png
60000 | scene/run/run | tap_anchor pause_give_up | after about 4 seconds the result panel showed `원정을 포기했다`, survival time 12초, kills 6, level 2, `금화 +2`, buttons `다시 출발` and `야영지로`, on a red field | the numbers match the run (12 s, 6 kills, Lv 2, 2 gold on the HUD). Panel is clear | none | captures/mvndmflbac0bb7-1792905620656.png
70000 | scene/run/run | tap_anchor result_again | a new run started from 0:00 within 4 seconds (the timer already showed 0:04 at capture), health 100/100, only the lantern weapon | restart works and the previous weapons were reset | none | captures/mvndmflbac0bb7-1792905632151.png

## reproduce

None. No observation is `blocker` or `major`.
