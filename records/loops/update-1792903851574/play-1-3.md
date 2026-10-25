## coverage

- unknown: dawn (15:00) and `새벽이 밝았다!` result, never reached (longest run 0:18)
- unknown: natural death (health 0, `체력이 위험해요!`, `등불이 꺼졌다…`). Failure was tested only through the pause `원정 포기`
- unknown: shrine purchase (gold 0 when the panel was open) and the `등불 제단의 가호` plate on the next run
- unknown: soup, bone knight chest, the second run past its first seconds, `야영지로`, the options popup, terms `보기` buttons
- play ms: 255066
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

- 0 | scene/title/title | tap_anchor terms_agree_all, terms_confirm | terms popup closed and the camp opened within 3s | none | none | captures/mvndm82y4aad51-1792905484478.png
- 7000 | scene/lobby/lobby | tap_anchor lobby_upgrades | shrine panel shows six rows with Lv, pips, effect, cost (30 to 100) and `금화가 부족해요` over each. `upgrade_close` returned to the camp | clear and readable | none | captures/mvndm82y4aad51-1792905491760.png
- 12000 | scene/run/run | tap_anchor lobby_play | run started at 0:01 with the move hint `WASD 로 움직이세요. 공격은 자동이에요`. The lantern weapon fired by itself | the first seconds are clear. The field is very dark, so the player and the props are low contrast | minor | captures/mvndm82y4aad51-1792905503212.png
- 12000 | scene/run/run | ogw step 200 --count 5 | each 200ms step advanced `play ms` by about 350 to 1300ms (34114, 34917, 35265, 36082, 37372), and the same happened in later steps | step time does not match the requested 200ms. It could be the harness clock and not the game | minor | captures/mvndm82y4aad51-1792905503212.png
- 20000 | scene/run/run | key_down D, step x15 | player walked right, 1 kill and a blue gem with damage number `12` shown at 0:04 | movement and auto-attack read clearly | none | captures/mvndm82y4aad51-1792905522701.png
- 30000 | scene/run/run | key_down D+S, step x40 | at 0:11, level 2, the level-up popup opened while stepping, and `ogw step` failed with `the command went over its time limit` (step 13/40) instead of stopping with a popups-changed reason | the popup itself was fine. The step failure was handled only by capturing again | minor | captures/mvndm82y4aad51-1792905605250.png
- 31000 | scene/run/run | key 3 | the third card (`성화 오라`) was picked and the run resumed. The aura ring showed around the player and the weapon icon was added at the top left | the `1 2 3 로도 고를 수 있어요` hint is accurate | none | captures/mvndm82y4aad51-1792905641294.png
- 33000 | scene/run/run | key_down A, step x12 | at 0:18 health 96/100, 13 kills, 4 gold, Lv 2, with about 10 enemies (zombies and bats) closing in from the right | the pressure rises as expected | none | captures/mvndm82y4aad51-1792905641294.png
- 36000 | scene/run/run | key P | the pause popup opened with `계속하기` and `원정 포기`. `pause_resume` continued the run | none | none | captures/mvndm82y4aad51-1792905649786.png
- 38000 | scene/run/run | key Escape, then tap_anchor pause_give_up at once | the tap was `ok` but the run did not end, and the next capture showed the field still running at 0:18 | the tap landed before the pause popup was up, or Escape did not open it. After a second Escape and a wait, give up worked | minor | captures/mvndm82y4aad51-1792905657917.png
- 40000 | scene/run/run | key Escape, tap_anchor pause_give_up | the field turned red, `원정을 포기했다…` showed, and the result panel opened about 1.6s later | as the guide says | none | captures/mvndm82y4aad51-1792905672712.png
- 41000 | scene/run/run | wait | result panel: survival 18s, kills 13, level 2, gold +4. The gold of 4 matches the HUD | clear, with `다시 출발` focused | none | captures/mvndm82y4aad51-1792905686284.png
- 42000 | scene/run/run | tap_anchor result_again | a new run started (telemetry: restart 1, fail 1) | none | none | captures/mvndm82y4aad51-1792905696511.png

## reproduce

None. There is no blocker or major.
