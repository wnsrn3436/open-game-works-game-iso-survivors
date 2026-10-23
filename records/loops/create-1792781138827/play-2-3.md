## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) not reached; longest run was 26 s
- unknown: gold purchase at the lantern shrine (gold at most 18, cheapest row costs 30). The run-start plate for shrine upgrades (`등불 제단의 가호가 함께합니다`) not seen
- unknown: bone knight chest, soup heal, 30% health warning, options (`설정`), gamepad input
- the pressed `upgrade_buy` with key `upgrade_might` (without brackets) was rejected by the tool with "the anchor key is not an ID name or an integer of at least 1"; with `[upgrade_might]` it returned ok (no purchase, not enough gold)
- play ms: 558001
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

Elapsed ms are approximate, counted from the first capture.

0 | terms | capture | terms popup opens on a flat dark screen with a large grey "TITLE" placeholder text behind it. The three row buttons and `확인` show a stretched "BUTTON" placeholder image behind the labels, and `보기` is hardly readable on its "BUTTON" art | labels are readable but the button art is placeholder, looks broken | minor | captures/mvlhev4u85ad06-1792790920967.png
12000 | terms | tap_anchor terms_agree_all, then tap_anchor terms_confirm | both ok; camp opened within 3 s | none | none | captures/mvlhev4u85ad06-1792790932532.png
12500 | camp | capture | gold 0 at top right, title, `첫 원정을 떠나 새벽까지 버텨 보세요`, three buttons. A huge black "LOBBY" placeholder text sits behind the buttons; the primary button `원정 시작` shows the "BUTTON PRIMARY" placeholder art that overlaps its label so the label is hard to read | label of the main button is hard to read, background is placeholder | major | captures/mvlhev4u85ad06-1792790932532.png
19000 | shrine | tap_anchor lobby_upgrades | panel opens in under 1 s with six rows (level, effect, cost 50/40/100/30/60/80). Every row shows `금화가 부족해요` printed on top of the white placeholder frame and the "BUTTON PRIMARY" art, so the cost, the not-enough label and the buy label overlap. Row icons are plain colour squares with the ID text (UPGRADE_MIGHT etc.) | overlapping text, hard to tell which part is the button | major | captures/mvlhev4u85ad06-1792790939182.png
22000 | shrine | tap_anchor upgrade_buy upgrade_might | tool rejected the key without brackets; with `[upgrade_might]` ok and gold stayed 0 (no purchase) | expected: not enough gold | none | none
27000 | run | tap_anchor lobby_play | loading about 0.6 s per telemetry (scene/run/run 580 ms), run starts at 0:00. Move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom. Player is a glowing block with a red bar below. The ground is covered with tiled "GROUND" placeholder text and the HUD panels (top left, top right) show a stretched "PLATE" placeholder, with `100/100` health and kills/gold counters | readable and playable, but placeholder visuals fill the screen | minor | captures/mvlhev4u85ad06-1792790955189.png
45000 | run | key_down D, 15 steps of 200 ms, then W 25 steps | player kept moving, timer 0:10, kills 7, gold 2, a damage number `12` shown near the player, health 100/100 | auto attack is visible and kills come fast | none | captures/mvlhev4u85ad06-1792791015283.png
75000 | level-up | after 40 more steps with A held | popup opens at Lv 2, timer 0:15; three cards `새로 얻기` with `거인의 심장`, `투척 도끼`, `성화 오라`; hint `1 2 3 로도 고를 수 있어요`. Card art is a white "PRIMARY" frame placeholder and descriptions are partly covered by it (`몸 주위의 불꽃이 가까운 적을 계…`) | card descriptions are cut by the placeholder frame, hard to read | major | captures/mvlhev4u85ad06-1792791067982.png
90000 | level-up | key 2 | card taken, run continued, the weapon icon was added to the top-left panel | none | none | captures/mvlhev4u85ad06-1792791079963.png
175000 | level-up | 60 steps after the pick | second level-up at 0:24 with Lv 3, health 72/100, kills 27; cards `낙뢰`, `등불 탄환 Lv 2`, `질풍 장화`. The description of `낙뢰` wraps to `다` alone on a second line | consistent with the first popup; health already lost 28 in 24 s | minor | captures/mvlhev4u85ad06-1792791180545.png
195000 | pause | key 1, key P, tap_anchor pause_resume, key Escape, tap_anchor pause_give_up | P opened the pause popup, resume continued, Escape opened it again, give up ended the run (not inspected in detail) | none | none | captures/mvlhev4u85ad06-1792791190597.png
215000 | result (give up) | 12 steps after give up | title `원정을 포기했다`, survived 25 s, kills 32, level 3, gold +10. A large white "PANEL FRAME" placeholder is drawn across the middle of the panel behind the stat lines, and the `다시 출발` button shows "BUTTON PRIMARY" art over its label | stats readable but crossed by the placeholder frame | major | captures/mvlhev4u85ad06-1792791212879.png
240000 | run 2 | step mode off, tap_anchor result_again, step-mode on, 25-step captures | run 2 started; at 0:13 level-up appeared and the hint `WASD…` was still visible under the level-up popup. Health 92/100 | hint stays shown when the player did not move; fine | none | captures/mvlhev4u85ad06-1792791337038.png
245000 | run 2 | looped `ogw step` 150 times in step mode while the level-up popup was open | the run did not advance (expected: run is held until a card is picked) and each capture showed the same popup | none | none | captures/mvlhev4u85ad06-1792791337038.png
330000 | death | stood still in free mode, pressed 1 every 5 s for level-ups | run ended in about 26 s of survival. Result title `어둠에 쓰러졌다`, kills 24, level 3, gold +8, `최고 기록!`. I did not capture the fall moment itself (red field, `등불이 꺼졌다…`), only the result panel. Same placeholder "PANEL FRAME" and "BUTTON" art as in the give-up result | player at 100 HP dies in about 26 s when standing still, which is quick but expected without moving | minor | captures/mvlhev4u85ad06-1792791422169.png
340000 | camp | tap_anchor result_lobby | camp opened in about 3 s; gold 18 (10 + 8), `최고 생존 26초 · 최다 처치 32`, `원정 2회 · 새벽 맞이 0회` are shown, and the record line overlaps the black "LOBBY" placeholder | the numbers add up and save; record text partly sits on the placeholder letters | minor | captures/mvlhev4u85ad06-1792791432103.png
all | log | ogw log | no error log | none | none | none

## reproduce

- Placeholder art covers labels (camp `원정 시작`, shrine rows, level-up cards, result panel): new user → `tap_anchor terms_agree_all` → `tap_anchor terms_confirm` → capture the camp; `tap_anchor lobby_upgrades` → capture; `tap_anchor lobby_play` → hold `D` for some seconds in step mode until the level-up popup → capture; `tap_anchor pause_give_up` after `key P` → capture the result panel
