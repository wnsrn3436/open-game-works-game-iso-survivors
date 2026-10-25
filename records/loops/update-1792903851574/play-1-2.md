## coverage

- unknown: death by health 0 (fall title, `등불이 꺼졌다…`, 30% health warning, red hit glow) — not reached; only give-up ended a run
- unknown: dawn at 15:00 (`새벽이 밝았다!`) — not reached; the run played reached 0:14
- unknown: `다시 출발` (`result_again`) — not pressed; went to camp with `result_lobby` instead
- unknown: run started after a shrine purchase (`등불 제단의 가호` plate) — no purchase was possible, gold was 0 then 3
- unknown: a successful shrine purchase, the red badge on the shrine button, soup, bone knight chest, level-up with 5/5 skip
- unknown: options popup (`설정`), terms `보기` buttons
- play ms: 214041
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby
- fail: 1
- restart: 0

## observations

- 0 | scene/title (terms popup) | capture | terms popup shows 3 checkboxes, `확인` is dimmed grey, hint `두 항목에 모두 동의하면 시작할 수 있어요` | clear, the disabled state reads well | none | captures/mvndm152ef36b2-1792905465372.png
- 5000 | terms | tap_anchor terms_agree_all, tap_anchor terms_confirm | terms passed, camp opened within about 3 s | smooth | none | captures/mvndm152ef36b2-1792905475299.png
- 10000 | scene/lobby/lobby | capture | camp shows game name, gold 0, `설정`, `나의 기록` with the first-run line, `등불 제단`, `원정 시작`, `새벽까지 15분 버티면 승리`; all as the guide says | readable; the hero and the buttons are clear | none | captures/mvndm152ef36b2-1792905475299.png
- 16000 | lobby (shrine panel) | tap_anchor lobby_upgrades, tap_anchor upgrade_buy [upgrade_vitality] | six rows with Lv, pips, effect and cost (50/40/100/30/60/80); a press with 0 gold only showed the toast `금화가 부족해요` and bought nothing | the toast is a thin small text strip over the middle rows (over the `서두름` and `자력` cards), small next to the row text; each row also already shows `금화가 부족해요` in red | minor | captures/mvndm152ef36b2-1792905484292.png
- 22000 | lobby → run | tap_anchor upgrade_close, tap_anchor lobby_play | the run opened after a loading screen of about 1 s | no stall | none | captures/mvndm152ef36b2-1792905492542.png
- 30000 | scene/run/run (0:06) | step 200 x5 | HUD has health 100/100, level, timer, kills 1, gold 0, the XP bar at the top; hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom; enemies (zombies, bats) around the player; the weapon already killed one | the field is very dark; the enemies and gems are low contrast against the ground, a gem and the weapon ring are the only bright things | minor | captures/mvndm152ef36b2-1792905501157.png
- 30000 | run | step 200 x5 --capture | the `play ms` between steps rose by 370~1270 ms per 200 ms step, not 200 ms | steps do not look like a steady 200 ms, but this was only measured from the tool output, not on screen | minor | captures/mvndm152ef36b2-1792905500343.png
- 50000 | run | key_down S, step 200 x6 | the player walked down; kills went on | movement responds in step mode as the guide says | none | captures/mvndm152ef36b2-1792905512642.png
- 64000 | run (0:10) | key_down D, step 200 x25 | `ogw step` stopped at step 12 with `the command went over its time limit` while the level-up popup was opening; the capture afterwards shows the level-up popup | the step command failed instead of the usual stop on a changed popup; the game itself was fine | minor | captures/mvndm152ef36b2-1792905551875.png
- 64000 | level-up popup (Lv 2) | capture | `레벨 업!` with 3 new cards: 자석 부적, 성화 오라, 바람의 깃털; each with icon and effect text; footer `1 2 3 로도 고를 수 있어요` | clear; the three cards are all `새로 얻기` and the first pick has no upgrade path to compare | none | captures/mvndm152ef36b2-1792905551875.png
- 70000 | level-up | key 2 | popup closed, the `성화 오라` ring appeared around the player at once and is listed in the weapon row with level 1 | the pick is visible at once; the golden ring is the strongest visual in the run | none | captures/mvndm152ef36b2-1792905577349.png
- 120000 | run (0:14) | key P, tap_anchor pause_resume | pause popup (`일시 정지`) opened with `계속하기`, `원정 포기` and the line `포기해도 지금까지 번 금화는 받아요`; continuing resumed time | clear | none | captures/mvndm152ef36b2-1792905600783.png
- 130000 | run | key P, wait 1 s, tap_anchor pause_give_up | after the first P I pressed P again and tapped `pause_give_up` in the same second; the screen stayed on the run at 0:14 with no popup and the capture showed no pause; a later P opened the popup again | possible that the second P closed the popup first (an input I sent), not confirmed as a defect | minor | captures/mvndm152ef36b2-1792905593357.png
- 150000 | pause popup | tap_anchor pause_give_up | in step mode the give-up ended the run only after stepping about 1.6 s of game time (`Fail` mark at 161375, panel opened at step 8, `Goal` mark at 169060); the result panel `원정을 포기했다` shows survived 14초, kills 8, level 2, gold +3 | the result matches the HUD (8 kills, 3 gold, Lv 2); the red field and the buttons `다시 출발`, `야영지로` read well | none | captures/mvndm152ef36b2-1792905629315.png
- 170000 | result → lobby | tap_anchor result_lobby | camp shows gold 3 and `나의 기록`: best survival 14초, most kills 8, runs 1, dawns 0 | the record and the gold are saved and shown right | none | captures/mvndm152ef36b2-1792905638390.png

## reproduce

(no blocker or major observation)
