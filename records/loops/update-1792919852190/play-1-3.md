## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) not reached; the longest run ended by fall at 2:57
- unknown: chest from the bone knight, soup heal, and the level-5 full-slot soup case not seen
- unknown: the line `등불 제단의 가호가 함께합니다` at run start was not seen in captures taken about 2s and 4s after the start (only the plate was seen)
- unknown: gamepad input, mouse click on level-up cards, `Esc` pause, and the `보기` terms buttons were not tried
- unknown: the `나의 기록` card after a run (camp was entered after runs but the card was not captured)
- played with the new-user terms flow, 3 runs (fall at 0:49, give-up at 0:05, fall at 2:57), 5 shrine screens
- play ms: 552515
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 3
- restart: 3

## observations

0 | scene/title/title | none (boot) | terms popup shows with both checkboxes empty and `확인` dimmed under the hint `두 항목에 모두 동의하면 시작할 수 있어요` | clear, the next step is obvious | none | captures/mvnneh65d2f69c-1792921910691.png
8000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | camp opened within 3s | smooth | none | captures/mvnneh65d2f69c-1792921922932.png
13000 | scene/lobby/lobby | none | camp shows the game name, gold 0, `설정`, the empty `나의 기록` card, `등불 제단`, large yellow `원정 시작` | `원정 시작` stands out as the main button; the record card text is small and wraps to 2 lines | none | captures/mvnneh65d2f69c-1792921922932.png
19000 | scene/lobby/lobby | tap_anchor lobby_upgrades | shrine panel with 6 rows, all buy buttons dimmed with `금화가 부족해요` at 0 gold, costs 30 to 100 | easy to read; what each upgrade does is clear | none | captures/mvnneh65d2f69c-1792921929603.png
25000 | scene/run/run | tap_anchor lobby_play | the run began, timer 0:01 after about 3s; hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom | the start was quick; the first screen was dark and nearly empty, with only the hero, a lantern flame and tombstones | none | captures/mvnneh65d2f69c-1792921944875.png
35000 | scene/run/run | key_down D | the player walked right; the camera kept the player at the center; the first enemies (ghoul, bat) came from the edges around 0:03; the autofire flame effect showed at the hero | readable; the play area is dark but the enemies are still visible | none | captures/mvnneh65d2f69c-1792921959745.png
63000 | scene/run/run | wait | at 0:11 kills 6, gold 2, XP bar about 50%; blue gems on the ground and damage numbers (`12`) float up | the damage numbers are small and low contrast against the dark field | minor | captures/mvnneh65d2f69c-1792921978080.png
75000 | scene/run/run | key_down A, S | at 0:12 the level-up popup opened with `낙뢰`, `거인의 심장`, `분노의 불씨` (all `새로 얻기`); the step stopped on its own with the popup change | the hint `1 2 3 로도 고를 수 있어요` is clear; the first level-up came at 0:12, which is quick | none | captures/mvnneh65d2f69c-1792921989802.png
85000 | scene/run/run | key 1 | the pick took effect (lightning icon in the weapon list); the pause popup opened with P; `계속하기` and `원정 포기` plus the line that gold is kept | clear | none | captures/mvnneh65d2f69c-1792922001155.png
110000 | scene/run/run | tap_anchor pause_resume, standing still | the level-up popup came again about every 10 to 20 seconds (Lv 5 at 0:49) | the card pace is high at first; a new card choice about every 10s early on | none | n/a
191000 | scene/run/run | standing still | health reached 0 at 0:49; field turned red, `등불이 꺼졌다…` showed; in step mode the fall title stayed on screen across 3 steps (600 ms of game time) and the result panel came after step mode was turned off | works as written; the 1.6s wait only runs in real time | none | captures/mvnneh65d2f69c-1792922101584.png
200000 | scene/run/run | wait | result panel `어둠에 쓰러졌다`: 49s, 94 kills, Lv 5, gold +27, `다시 출발` and `야영지로` | clear, numbers match the HUD (94 kills, 27 gold) | none | captures/mvnneh65d2f69c-1792922110861.png
210000 | scene/run/run | tap_anchor result_again, key P, tap_anchor pause_give_up | a new run started; give-up after 5s gave result `원정을 포기했다`, 1 kill, Lv 1, gold +0 | works; gold +0 matches the line that gold so far is kept | none | captures/mvnneh65d2f69c-1792922128565.png
225000 | scene/lobby/lobby | tap_anchor result_lobby, lobby_upgrades, upgrade_buy [upgrade_magnet] | gold 27 against cost 30: the press did not buy and a thin toast `금화가 부족해요` showed over the middle of the panel | correct behaviour; the toast text is very small and sits on a narrow dark band across the rows, so it is easy to miss | minor | captures/mvnneh65d2f69c-1792922143377.png
490000 | scene/run/run | key_down W (held for the whole run), pick card 1 at each level-up | the run lasted 2:57 with 412 kills, Lv 10, gold +120, `최고 기록!` shown | the long run was reached by walking up only; no stall, no crash | none | captures/mvnneh65d2f69c-1792922397019.png
520000 | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_vitality] | bought: gold 147 to 107, `Lv 1/5`, one lit pip, next cost 100, toast `생명력 강화 완료!`; the other buy buttons turned bright where affordable | clear feedback; the toast is small as above | minor | captures/mvnneh65d2f69c-1792922411133.png
530000 | scene/run/run | tap_anchor lobby_play | the run started with HP 115/115 and the plate `등불 제단의 가호` with `최대 체력 +15` under the weapon icons | works as in the guide | none | captures/mvnneh65d2f69c-1792922416959.png
530000 | scene/run/run | none | the vitality-bought row cost went 40 to 100 for level 2 (more than doubled) | a big price jump, felt steep for a first upgrade | minor | captures/mvnneh65d2f69c-1792922411133.png

## reproduce

(no blocker or major observations)
