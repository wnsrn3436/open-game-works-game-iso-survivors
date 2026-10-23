## coverage

- unknown: dawn at 15:00 (longest run reached 1:14)
- unknown: pause popup (`P`/`Esc`, `pause_resume`, `pause_give_up`)
- unknown: bone knight chest, soup heal, settings (`lobby_options`), terms `보기` buttons
- unknown: successful shrine purchase of any row other than vitality (might was pressed with 0 gold)
- unknown: `result_again` (went `result_lobby` and `lobby_play` instead), fall title skip by key press, `등불 제단의 가호가 함께합니다` banner (not seen in captures taken 2s and 6s after the start)
- unknown: gamepad input, mouse click on level-up cards (used keys `1` `2`)
- play ms: 905164
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 1
- restart: 1

## observations

0 | scene/title/title | tap_anchor terms_agree_all | terms popup shown; both checkboxes turned on, `확인` button enabled after | clear, hint line `두 항목에 모두 동의하면 시작할 수 있어요` explains the disabled confirm | none | captures/mvllov46c1f92d-1792798112920.png
5000 | scene/lobby/lobby | tap_anchor terms_confirm | camp shown with gold 0 and three buttons, `원정 시작` highlighted | readable, clear first focus | none | captures/mvllov46c1f92d-1792798117307.png
9000 | scene/lobby/lobby | tap_anchor lobby_upgrades then upgrade_buy [upgrade_might] with 0 gold | shrine panel with six rows; the press showed a `금화가 부족해요` toast as a dark full-width band across the middle that overlaps the 서두름/자력 rows | buy buttons stay bright yellow although every row says not enough gold, so the unaffordable state is carried only by small red text; the toast band covers row text | minor | captures/mvllov46c1f92d-1792798129035.png
20000 | scene/run/run | tap_anchor lobby_play | run starts at 0:01; player at centre, 100/100 HP, one lantern weapon, move hint `WASD 로 움직이세요. 공격은 자동이에요` | hint is clear; screen is very dark so gravestones and enemies are low contrast | none | captures/mvllov46c1f92d-1792798146440.png
38000 | scene/run/run | key_down D / W held, stepped 200ms | at 0:06, 2 kills, damage number 12, blue gems on the ground, enemies approach from the left | the lantern weapon works without input, movement responds | none | captures/mvllov46c1f92d-1792798186029.png
50000 | scene/run/run | key_down D+S, stepped | level-up popup at 0:06 (Lv 2) with 2 kills; cards 낙뢰, 성화 오라, 등불 탄환 and hint `1 2 3 로도 고를 수 있어요` | popup is clear. Lv 2 came after only 2 kills and the XP bar looked almost empty in the capture just before, so the XP bar did not show how close the level-up was | minor | captures/mvllov46c1f92d-1792798277303.png
52000 | scene/run/run | key 1 | card picked, run resumed; lightning icon with level 1 appears under the health bar, lightning strike seen at 0:14 with damage 20 | pick is acknowledged at once | none | captures/mvllov46c1f92d-1792798338662.png
170000 | scene/run/run | walking in a square, key 1 each 2.4s | 1:05, Lv 7, 130 kills, HP 32/100; many gems left on the ground (about 25 on screen), nothing pulling them in while the player is away from them | HP fell from 100 to 32 between 0:14 and 1:05 while I steered blindly, which is what the guide says happens; the screen holds many enemies and the gems are easy to see | none | captures/mvllov46c1f92d-1792798836544.png
190000 | scene/run/run | standing still, stepped | 1:10, HP 28/100, `체력이 위험해요!` under the player, numbers red, player glows red, about 8 zombies and bats touching the player | warning is visible and readable; it is hard to see which enemy is the hit source in the crowd | none | captures/mvllov46c1f92d-1792798877213.png
210000 | scene/run/run | stepped | 1:14, HP 4/100 and a level-up popup opened (Lv 8) with cards 분노의 불씨, 회전 낫, 질풍 장화 | the popup stops the run at 4 HP, so the player can read it safely; the HP number is red behind the popup | none | captures/mvllov46c1f92d-1792798911505.png
215000 | scene/run/run | key 2, stepped 2400ms | run ended, result panel `어둠에 쓰러졌다`: survived 1분 14초, kills 167, level 8, gold +48; buttons `다시 출발` (first focus) and `야영지로` | the panel matches the guide; the card pick at 4 HP was followed by death within 2.4s | none | captures/mvllov46c1f92d-1792798934335.png
225000 | scene/lobby/lobby | result_lobby, lobby_upgrades, upgrade_buy [upgrade_vitality] with 48 gold, upgrade_close | purchase went through, panel closed to camp | no problem seen | none | captures/mvllov46c1f92d-1792798951082.png
232000 | scene/run/run | lobby_play | new run at 0:02 shows max HP 115/115 and a plate `등불 제단의 가호` with `최대 체력 +15` under the weapon icons; the `등불 제단의 가호가 함께합니다` banner was not in the capture | purchase carried into the run as the guide says | none | captures/mvllov46c1f92d-1792798956799.png
236000 | scene/run/run | none | at 0:06, 1 kill, a fireball flies at an enemy, enemies come from several sides | no problem seen | none | captures/mvllov46c1f92d-1792798960975.png

## reproduce

No observation is `blocker` or `major`.
