## coverage

- unknown: the 15:00 dawn and its `새벽이 밝았다!` result. The longest run reached 0:30 of run time
- unknown: the lantern shrine after a purchase (0 gold at the first visit, so no buy succeeded), the shrine plate at run start, the bone knight chest, soup, and the pause popup while a level-up is open
- unknown: the `체력이 위험해요!` low-health state. It was not captured; the fall in run 2 happened between two captures
- unknown: the fall title (`등불이 꺼졌다…`), because the fall was not captured in the 1.6s before the result panel
- unknown: the `원정 준비 중` loading text and the camp record card after a run. Neither was captured; the second run was started with `result_again`, not through the camp
- played in step mode: run 1 (levels 1→4, give-up at 0:29). Played in free mode: run 2 (standing still, fall at 0:30)
- play ms: 434840
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 2
- restart: 1

## observations

0 | scene/title/title | none | The terms popup opens with both checkboxes empty and `확인` dimmed under the hint `두 항목에 모두 동의하면 시작할 수 있어요` | The hint explains why the button is disabled | none | captures/mvndluaa2c140e-1792905455127.png
9000 | scene/title/title | tap_anchor terms_agree_all, terms_confirm | The camp opened about 3s after confirm. It shows the game name, gold 0, `나의 기록` with `첫 원정을 떠나 새벽까지 버텨 보세요`, the hero by the fire, `등불 제단` and a large yellow `원정 시작` | The camp is readable and the start button is the clear main action | none | captures/mvndluaa2c140e-1792905464722.png
12000 | scene/lobby/lobby | tap_anchor lobby_upgrades | The shrine shows six rows with Lv 0/5 or 0/3, empty pips, the effect text, costs 50/40/100/30/60/80, and `금화가 부족해요` over every buy button | Clear. Every cost is higher than 0 gold, so a new player cannot buy anything before the first run | none | captures/mvndluaa2c140e-1792905467572.png
17000 | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_might] | With 0 gold the press bought nothing and the panel stayed open | Matches the guide | none | captures/mvndluaa2c140e-1792905476310.png
33000 | scene/run/run | tap_anchor lobby_play | The run started at 0:03 about 3s after the tap. Health 100/100, one weapon, and the move hint `WASD 로 움직이세요. 공격은 자동이에요` | The hint is clear. The screen is dark, and enemies at the screen edge are small and low-contrast | minor | captures/mvndluaa2c140e-1792905484329.png
44000 | scene/run/run | key_down D, ogw step 200 x10 | The player walked right and the lantern projectile fired on its own at 0:05. The hint was gone | Moving and the auto attack feel clear | none | captures/mvndluaa2c140e-1792905498554.png
55000 | scene/run/run | ogw step 200 x25 | A step call returned `the command went over its time limit` at the 8th step of a 25-step call. Later calls also hit this limit (about 4 times in the run, at play ms 220137 for one) | Step calls get slow once many enemies and gems are on screen. This may be a frame-rate drop with many sprites, or only the step tool. It was not isolated | major | none
103000 | scene/run/run | (auto) | A level-up popup opened at 0:06 with 2 kills. Cards: `분노의 불씨` (new), `등불 탄환` (Lv 2), `질풍 장화` (new). The hint `1 2 3 로도 고를 수 있어요` shows. The timer froze at 0:06 | Clear. The first level-up comes within 6s | none | captures/mvndluaa2c140e-1792905553536.png
103000 | scene/run/run | key 2 | The card was taken at once, the weapon counter went from 1 to 2, and the run resumed | Works | none | none
173000 | scene/run/run | (auto) | Level-up 3 at 0:15 with 17 kills and 94/100 health. Cards: `투척 도끼`, `거인의 심장`, `낙뢰`, all new | Level 3 arrives 9s after level 2, at about 8 to 9s per level | none | captures/mvndluaa2c140e-1792905624598.png
251000 | scene/run/run | (auto) | Level-up 4 at 0:29 with 52 kills and 15 gold. Cards: `자석 부적`, `질풍 장화`, `바람의 깃털`, all new. The slots show lantern 2, lightning 1 | Level-ups come about every 7 to 9s and each one stops the run | none | captures/mvndluaa2c140e-1792905699979.png
252000 | scene/run/run | key P, tap_anchor pause_resume, key Escape | `P` opened the pause popup with `계속하기`, `원정 포기` and `포기해도 지금까지 번 금화는 받아요`. Resume and `Escape` both worked | Clear | none | captures/mvndluaa2c140e-1792905710060.png
275000 | scene/run/run | tap_anchor pause_give_up, ogw step | After the give-up tap, the next capture 3s later still showed the run screen at 0:29 with step mode on. The result opened only after stepping about 1.8s of game time (Fail mark at play ms 279569, Goal mark and result panel at 288671) | The give-up needs game time to pass in step mode, so the result did not open at once. In free mode it was not tested | minor | captures/mvndluaa2c140e-1792905718681.png
290000 | scene/run/run | (result) | The result panel was titled `원정을 포기했다` with survival 29s, 52 kills, level 4 and gold +15. Buttons `다시 출발` and `야영지로` | The numbers match the HUD and the gold matches the gold counter | none | captures/mvndluaa2c140e-1792905737750.png
300000 | scene/run/run | tap_anchor result_again | A new run began at 0:04 with 100/100 health, one weapon, and the move hint again. About 4s passed between the tap and the capture | The restart works. Run 2 started without the shrine plate because no upgrade was bought | none | captures/mvndluaa2c140e-1792905749411.png
398000 | scene/run/run | key 1 every 15s while standing still | Standing still, the player fell at 30s of survival with 50 kills and level 4. The result panel was titled `어둠에 쓰러졌다`, with `최고 기록!`, gold +15 and the line `야영지의 등불 제단에서 금화로 강화하세요` | Standing still lasts about the same 30s as the walking run (29s). Dying that early with 100 health, with no hit capture, is not explained. Gold +15 was identical in both runs | minor | captures/mvndluaa2c140e-1792905844968.png

## reproduce

- Step calls over the time limit (major): `ogw instance` at the camp → `tap_anchor lobby_play` → `ogw step-mode <id> on` → `key_down D` → `ogw step <id> 200 --count 25 --capture` several times, picking a card with `key 1` or `key 2` at each level-up. The `the command went over its time limit` failure showed up within the first 60s of run time, at the 8th of 25 steps in one call
