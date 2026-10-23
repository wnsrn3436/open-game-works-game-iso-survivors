## coverage

- unknown: dawn at 15:00 (the longest run reached was 1:14)
- unknown: shrine purchase and the run started after it (gold was 0 at the shrine; 47 gold was earned only after the first run)
- unknown: pause popup (`P`, `Esc`) and `원정 포기`
- unknown: `야영지로` (To camp) from the result panel
- unknown: options screen, the terms `보기` (view) buttons, soup, bone knight chest
- unknown: movement keys during real-time play (movement was only tried in step mode with `key_down`/`ogw step`)
- play ms: 573365
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

Elapsed ms are approximate run or game time. 0 = before the run started.

0 | terms popup | none (first capture) | `이용약관 동의` popup shows over a placeholder `TITLE` text | The popup buttons and checkboxes are stretched placeholder textures (`BUTTON` letters smeared across each button). Labels stay readable but overlap the smear. Layout is usable | minor | captures/mvlheodhb1819c-1792790908131.png
0 | terms popup | tap_anchor terms_agree_all, tap_anchor terms_confirm | Both checkboxes turned on and the camp opened | Smooth, no problems | none | captures/mvlheodhb1819c-1792790919131.png
0 | camp | none | Camp shows the title `아이소 서바이버즈`, gold 0, and three buttons. A giant black `LOBBY` placeholder fills the background. The `원정 시작` label is drawn over a `BUTTON PRIMARY` texture, which makes it hard to read | Placeholder art still on screen. The primary button label is hard to read | minor | captures/mvlheodhb1819c-1792790919131.png
0 | shrine | tap_anchor lobby_upgrades | Six rows with Lv 0/N, effect, cost (30 to 100) and `금화가 부족해요`. The `BUTTON PRIMARY` texture overlaps the `강화` label and the not-enough-gold text. `서두름` effect text wraps and runs under a white placeholder bar | Information is complete, but the overlapping text is hard to read | minor | captures/mvlheodhb1819c-1792790926015.png
0 | shrine | tap_anchor upgrade_close | Returned to camp | Works | none | n/a
0 | camp to run | tap_anchor lobby_play (step mode on) | The run scene loaded in about 500ms (telemetry). Timer 0:00, move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom. HUD frames carry placeholder `BAR_FRAME` and `PLATE` text | Run starts quickly. HUD shows the health bar, kill and gold counters | minor | captures/mvlheodhb1819c-1792790935210.png
5000 | run | key_down D, 25 steps of 200ms | The player walked right and enemies came in. Kills 3. A small health bar sits under the player and damage numbers show | Auto attack and enemy spawn work as the guide says. Enemies are plain blue cubes | none | captures/mvlheodhb1819c-1792790973932.png
10000 | level-up | W, A, S, D held in turn (3s each) | Level-up popup at Lv 2 with 3 cards: spinning blade (new), lantern bolt Lv 2, gale boots (new). Card art is a flat colour square with the ID text. The description text overlaps a large white `CARD` placeholder frame and the 2-line text is partly unreadable | Popup works and the run is held. Card text is hard to read | major | captures/mvlheodhb1819c-1792791087654.png
10000 | level-up | key 1 | The first card was picked and the run continued. The weapon icon appeared in the HUD | Works | none | n/a
22000 | level-up | not moving, steps of 200ms | Lv 3 popup. Health was 56/100 after about 12s of standing still, so health fell from 100 to 56 | Steady damage while standing still. Cards are readable only partly (same placeholder overlap) | minor | captures/mvlheodhb1819c-1792791208529.png
36000 | level-up | key 3, steps of 1000ms | Lv 4 popup. Health was 4/120, so it fell from 56 to 4 in about 14s. A new `투척 도끼` (throwing axe) card was offered | Damage comes fast when the player does not move. The run still lasted past 0:36 | none | captures/mvlheodhb1819c-1792791302750.png
41000 | run, low health | key 3, 10 steps of 500ms | Health stayed at 4/120. The `체력이 위험해요!` warning shows under the player, the health number is red, and 75 kills with a large burst of cubes around the player | Low-health warning appears as written. 4 hp held for at least 5s with many enemies around | none | captures/mvlheodhb1819c-1792791325016.png
74000 | fall | step mode off, real time | Health 0/120. The field turned red and `등불이 꺼졌다…` showed at 1:14 with 160 kills, 47 gold and Lv 4 | Fall presentation matches the guide | none | captures/mvlheodhb1819c-1792791422541.png
74000+ | result | wait about 3s | Result panel `어둠에 쓰러졌다`: survived 1m14s, kills 160, level 4, gold +47, with `다시 출발` and `야영지로`. A large `PANEL_FRAME` placeholder strip runs behind the stats text. The `다시 출발` label overlaps the `BUTTON PRIMARY` texture | Result data is complete. Placeholder art on screen | minor | captures/mvlheodhb1819c-1792791431310.png
74000+ | result to run | tap_anchor result_again | New run started within 4s at 0:03, with health 100/100, level 1, kills 0, gold 0, one weapon, and the move hint shown again | Restart works and state is reset | none | captures/mvlheodhb1819c-1792791436979.png
n/a | run, step mode | ogw step while the level-up popup is open (loop kept stepping) | The timer did not advance, as the guide says. A long loop of steps with the popup open produced no progress | An agent that steps without checking the popup gets nothing | none | n/a
n/a | all | ogw log | `no error log` after the full play | No errors | none | n/a

## reproduce

- Level-up card text overlap (major): terms `terms_agree_all` then `terms_confirm`, then `lobby_play`. In step mode, hold `D` for 5s of game time, then `W`, `A`, `S` for 3s each. Level-up popup opens at about 0:10 and the card descriptions sit over a white `CARD` placeholder frame.
