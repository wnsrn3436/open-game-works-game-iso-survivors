## coverage

- unknown: dawn at 15:00 (best run ended by a fall at 2:28)
- unknown: bone knight chest (pick of 3), soup heal card, gamepad input, level-5 weapon/passive maxed heal
- unknown: moving during a fall (A/D key press during the 1.6s wait), options screen
- not as the guide says: the first run used step mode until Lv4 (0:24 game time), then step mode was turned off because each `ogw step` took about 1s of real time. The rest of that run was played in free mode, standing still, with `1` pressed every 8 s
- the run after the shrine purchase was only watched for its start (0:04)
- elapsed ms below are approximate, counted from the start of play
- play ms: 630446
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 2
- restart: 2

## observations

0 | title | none | Terms popup shows 3 unchecked boxes and a greyed `확인` button | Clear; the hint `두 항목에 모두 동의하면 시작할 수 있어요` explains the grey button | none | captures/mvllohojba6a6b-1792798084715.png
14000 | terms | tap_anchor terms_agree_all, terms_confirm | Camp opens with title `아이소 서바이버즈`, gold 0 and 3 buttons, `원정 시작` highlighted | Reads clearly | none | captures/mvllohojba6a6b-1792798095614.png
25000 | shrine | tap_anchor lobby_upgrades, upgrade_buy [upgrade_vitality] with 0 gold | Six rows show level, effect and cost. The press buys nothing. A dim full-width toast band with tiny text `금화가 부족해요` sits across the middle of the panel and overlaps the row text | The row already shows `금화가 부족해요` in red, so the toast is redundant. It is small and covers the row text | minor | captures/mvllohojba6a6b-1792798105561.png
35000 | run | tap_anchor lobby_play, then step 1000 and 200 ms x10 | The run starts at 0:00. Health 100/100, a weapon icon and enemies come in from the right edge | Starts quickly. The move hint was not seen at the time of the capture | none | captures/mvllohojba6a6b-1792798136230.png
80000 | run | key_down A, 40 steps of 200 ms | Level-up popup at 0:10 (Lv2): aura, lightning, giant's heart, all labelled `새로 얻기`. The popup holds the run | A first level-up after 10 s is fast and gives a quick reward. The bottom hint `1 2 3 로도 고를 수 있어요` is helpful | none | captures/mvllohojba6a6b-1792798219536.png
90000 | levelup | key 1 | The card is picked and the run continues | Works | none |
150000 | levelup | key 2 at Lv3 (0:21) | Next level-up (scythe, hatchet, feather) comes about 3 s later, at Lv4 0:24 | Level-ups are very frequent early. Several popups interrupt the run within 15 s | minor | captures/mvllohojba6a6b-1792798420448.png
200000 | run | step mode on, 200 ms steps | Each `ogw step 200` took about 1 s of real time. 25 steps took about 30 s | Slow for the play tool, not for a player | minor |
300000 | run | standing still, no movement from 0:24 to 1:40 | At 1:40 Lv12, kills 319, gold 89, health 74/100. 8 passives and weapons owned; enemies crowd around the player; aura ring and scythe kill them. Many blue gems lie uncollected within view | A player who never moves has lost only 26 health in 1:40 after taking one weapon of each kind. Early difficulty is low, and moving does not seem needed | major | captures/mvllohojba6a6b-1792798535402.png
345000 | run end | no input, standing still | Fall at 2:28: the field turns red and the result panel `어둠에 쓰러졌다` shows time 2분 28초, kills 649, level 16, gold +176 | The result panel is clear. It shows the numbers the guide lists. The fall came suddenly after the stable 1:40 reading, with no capture in between | none | captures/mvllohojba6a6b-1792798612410.png
350000 | result | tap_anchor result_again, then key P | A new run starts and `P` opens the pause popup | Works | none | captures/mvllohojba6a6b-1792798627693.png
360000 | pause | tap_anchor pause_resume, key P, tap_anchor pause_give_up | Resume continues. Give up ends the run: result `원정을 포기했다`, time 6s, kills 0, gold +0 | Matches the guide. Gold +0 because nothing was earned in 6 s | none | captures/mvllohojba6a6b-1792798636075.png
370000 | shrine | tap_anchor result_lobby, lobby_upgrades, upgrade_buy [upgrade_vitality], upgrade_buy [upgrade_might] | With 176 gold both buy. Panel in the next run shows `등불 제단의 가호` with `피해 +5%` and `최대 체력 +15` | Purchase and carry-over work. Health 115/115 | none | captures/mvllohojba6a6b-1792798677200.png
375000 | run | tap_anchor lobby_play | Run at 0:04 shows the move hint `WASD 로 움직이세요. 공격은 자동이에요` | Hint is clear | none | captures/mvllohojba6a6b-1792798677200.png
all | all | all | `ogw log` showed no error log. Input response latency 16-17 ms in telemetry for the taps I checked | No crashes or stuck input found | none |

## reproduce

- Standing still survives long: terms accept, `lobby_play`, pick card `1` at every level-up, press no move key. At 1:40 the player has Lv12, 319 kills and 74/100 health, and the run lasts 2:28 before the fall.
