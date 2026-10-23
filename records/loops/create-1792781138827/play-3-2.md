## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) not reached. The longest run was 1:19
- unknown: pause popup (`pause_resume`, `pause_give_up`). `P` was pressed while a level-up popup was open, so the pause popup did not show; `tap_anchor pause_resume` failed with "the anchor is not there or not visible"
- unknown: terms popup. The first capture was not viewed before the consent taps. Both taps returned ok and the camp followed
- unknown: soup, bone knight chest, options screen, gamepad input, the fall title popped by a move key or `Esc`, and level 5 weapon/passive maxing
- unknown: the `다시 출발` (`result_again`) restart. Only the `야영지로` (`result_lobby`) route back to camp was played
- play ms: 1135001
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 1
- restart: 1

## observations

1 | 0 | scene/lobby/lobby | tap_anchor terms_agree_all, terms_confirm | camp shows gold 0, the three buttons and the title, `원정 시작` highlighted | none | captures/mvlloojn2e78c5-1792798098091.png
2 | 4000 | scene/run/run | tap_anchor lobby_play | run starts at 0:00 in about 500ms (telemetry run scene 504ms); `WASD 로 움직이세요. 공격은 자동이에요` hint shows | none | captures/mvlloojn2e78c5-1792798108337.png
3 | 9000 | scene/run/run | key_down D, step 200 x45 | first enemies and a gem drop by 0:09, 4 kills, auto weapon (fireball) fires with no input. The player stays at screen center while the field scrolls. Readable and clear | none | captures/mvlloojn2e78c5-1792798171495.png
4 | 17000 | scene/run/run | key_down S then A, step | Level 2 popup at 0:17: three `새로 얻기` cards, with icons, names and a one-line effect. The `1 2 3 로도 고를 수 있어요` hint is shown. Time stops while it is open | none | captures/mvlloojn2e78c5-1792798275999.png
5 | 17000 | scene/run/run | key 2 | pick of the thrown axe works; the axe icon shows in the top-left weapon row with `1`. The run resumes | none | captures/mvlloojn2e78c5-1792798330700.png
6 | 33000 | scene/run/run | step | Level 3 popup at 0:33, then Level 4 at 0:36 and Level 5 at 0:44. Level-ups arrive every 3~8 seconds and the player stops to pick each time. Card pool repeats cards (`투척 도끼 Lv 2`, `낙뢰`, `질풍 장화` offered in several popups) | minor: frequent interruptions early in the run; cards show only the generic effect, not the number after the pick | minor | captures/mvlloojn2e78c5-1792798423151.png
7 | 36000 | scene/run/run | key 3 | health 76/100 at 0:36 after enemy contact while moving; the health bar and the number match | none | captures/mvlloojn2e78c5-1792798838803.png
8 | 79000 | scene/run/run | standing still, key 1 x60, step 1000 | health reached 0 at 1:19. The result panel `어둠에 쓰러졌다` shows survived time `1분 19초`, kills 181, level 7, gold +52 and both buttons. The background has turned red | none | captures/mvlloojn2e78c5-1792799125241.png
9 | 79000 | scene/run/run | key 1 pressed every step while the player stood still | a held-down card key press gave no problem. The player was not killed until 1:19 even though the player stood still with 3~4 weapons from 0:44 on. It is not clear whether standing still was punished at all before then | unknown | none | captures/mvlloojn2e78c5-1792799125241.png
10 | 82000 | scene/lobby/lobby | tap_anchor result_lobby, tap_anchor lobby_upgrades | shrine panel with six rows, level, effect, cost, and `금화가 부족해요` on rows over 52 gold | none | captures/mvlloojn2e78c5-1792799140741.png
11 | 83000 | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_vitality] | purchase works: gold 52 → 12, row Lv 1/5, next cost 40 → 100. The toast `생명력 강화 완료!` is small text on a thin dark band in the middle of the panel, over the row text, and is easy to miss | minor: toast is tiny and overlaps the row text | minor | captures/mvlloojn2e78c5-1792799153942.png
12 | 83000 | scene/lobby/lobby | upgrade panel | every `강화` button keeps the same bright yellow whether the row is affordable or not; only the cost number and the small red `금화가 부족해요` line differ | minor: an unaffordable button looks pressable | minor | captures/mvlloojn2e78c5-1792799153942.png
13 | 90000 | scene/run/run | tap_anchor upgrade_close, tap_anchor lobby_play | new run shows health 115/115 and the plate `등불 제단의 가호 / 최대 체력 +15` under the weapon row. The run starts after about 4s of waiting in the capture | none | captures/mvlloojn2e78c5-1792799161511.png
14 | 97000 | scene/run/run | key P (during level-up) | the level-up popup opened at 0:11 while the player had not moved since the run start; `P` had no visible effect with the popup open (consistent with the guide). The hint `WASD 로 움직이세요` is still behind the popup | none | captures/mvlloojn2e78c5-1792799177300.png

## reproduce

None. No blocker or major observation.
