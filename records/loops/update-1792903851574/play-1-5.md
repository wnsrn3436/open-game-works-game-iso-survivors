## coverage

- unknown: dawn (15:00) win and the `새벽이 밝았다!` result. The longest run reached 0:35
- unknown: buying a shrine upgrade. Gold stayed at 11 after two runs, below the cheapest cost (30, `자력`), so the buy path, the red badge on `등불 제단`, and the `등불 제단의 가호` plate on a run start were not seen
- unknown: soup, bone knight chest, the soup card at level 5, gamepad input, `Esc` or move key during the fall wait
- unknown: the `원정 준비 중` text. The run loaded and started at 0:00 within about 3 s after `lobby_play`, and I did not capture the loading screen
- weapon level-ups were not tried. I picked passives (feather, boots, magnet) and the lantern stayed at Lv 1 for the whole run
- play ms: 318816
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title/title | none | terms popup `이용약관 동의` showed with `확인` greyed until both boxes were checked | clear, the hint line `두 항목에 모두 동의하면 시작할 수 있어요` explains it | none | captures/mvnghmee7268b5-1792910298514.png
~7000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | both boxes were set and the camp loaded within 5 s | smooth | none | captures/mvnghmee7268b5-1792910310986.png
~15000 | scene/lobby/lobby | none | camp showed the game name, gold 0, `설정`, the `나의 기록` card with the first-run line, `등불 제단` and `원정 시작` | readable and the start button stands out as the main action | none | captures/mvnghmee7268b5-1792910310986.png
~22000 | scene/lobby/lobby | tap_anchor lobby_upgrades | shrine listed 6 rows, costs 30 to 100, all `금화가 부족해요` with 0 gold | the effect text and the cost are clear | none | captures/mvnghmee7268b5-1792910318138.png
~30000 | scene/run/run | tap_anchor lobby_play | the run started at 0:00. The field is very dark, with the player lit by a small glow and the move hint `WASD 로 움직이세요. 공격은 자동이에요` at the bottom | the hint is useful, but enemies and gems are hard to see away from the player | minor | captures/mvnghmee7268b5-1792910326173.png
0:02 | scene/run/run | key_down D | the player moved right. Zombies, bats and a werewolf-like enemy closed in from the screen edges. The red HP bar shows under the player | movement felt responsive | none | captures/mvnghmee7268b5-1792910341550.png
0:10 | scene/run/run | key_down D held | 6 kills and 2 gold. Blue gems dropped, damage number `12` floated | auto-attack worked with no input. The XP bar is a thin strip at the top edge and fills very little at first | none | captures/mvnghmee7268b5-1792910358967.png
0:12 | scene/run/run | W+A held | 9 kills, 3 gold. Several enemies approached from the left and top | the pace is brisk | none | captures/mvnghmee7268b5-1792910372804.png
0:15 | scene/run/run | D+S held | the level-up popup opened with 3 cards: `바람의 깃털` (new), `등불 탄환` (Lv 2), `자석 부적` (new). Footer `1 2 3 로도 고를 수 있어요` | the cards are readable, the run stopped, and the HUD stayed visible behind | none | captures/mvnghmee7268b5-1792910416753.png
0:15 | scene/run/run | `ogw step 200 --count 15` | the step call failed with `the command went over its time limit` at the moment the popup opened. It was not reported as a stop for the popup, as it was in later calls (`popups changed`) | this is a harness quirk of step mode and may not be a game defect | minor | captures/mvnghmee7268b5-1792910416753.png
0:15 | scene/run/run | key 1 | the card was applied at once: a feather icon with `1` appeared in the HUD, the run resumed, kills 12 | the response was immediate | none | captures/mvnghmee7268b5-1792910432087.png
0:15 to 0:35 | scene/run/run | no keys held | the player stood still, got swarmed and went from 100 to 4 HP while a second level-up popup opened at Lv 3 and another at Lv 4. Level-ups came about every 10 s | the swarm stacks on the player, so a still player dies in about 35 s. The `체력이 위험해요!` text was not seen in the captures taken | none | captures/mvnghmee7268b5-1792910506626.png
0:35 | scene/run/run | key 3 (card at Lv 4) | HP 0/100, the field turned red and `등불이 꺼졌다…` showed over a pile of enemies on the player | the fall feedback is clear | none | captures/mvnghmee7268b5-1792910518472.png
0:35 | scene/run/run | none | the result panel opened about 1.6 s after the fall: `어둠에 쓰러졌다`, survived 35 s, kills 33, level 4, gold +11, buttons `다시 출발` and `야영지로` | the figures match the HUD | none | captures/mvnghmee7268b5-1792910520923.png
0:00 | scene/run/run | tap_anchor result_again | a new run started at 0:00 in about 3 s with full HP, level 1 and no weapons but the lantern | restart is quick | none | captures/mvnghmee7268b5-1792910538529.png
0:01 | scene/run/run | key P | the pause popup opened: `일시 정지`, `계속하기`, `원정 포기`, line `포기해도 지금까지 번 금화는 받아요` | clear | none | captures/mvnghmee7268b5-1792910543144.png
0:01 | scene/run/run | tap_anchor pause_resume | the run continued and the timer advanced | works | none | no capture
0:02 | scene/run/run | key Escape, tap_anchor pause_give_up | the result panel opened about 1.6 s later with `원정을 포기했다`, 1 s, 0 kills, level 1, gold +0 | works as written | none | captures/mvnghmee7268b5-1792910563909.png
0:02 | scene/lobby/lobby | tap_anchor result_lobby | the camp loaded with gold 11 and the record card: best survival 35s, most kills 33, runs 2, dawns 0 | the record updated and counts the given-up run | none | captures/mvnghmee7268b5-1792910575764.png
all | scene/run/run | none | no entries in `ogw log` at any check, and no fail marks other than the two ended runs | none | none | no capture

## reproduce

None. There are no blocker or major observations.
