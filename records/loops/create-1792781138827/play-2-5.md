## coverage

- unknown: the shrine-purchase plate and the `등불 제단의 가호가 함께합니다` text (game flow 10). I never saw them: the fixture opened on a paused run, and the first capture already showed the pause popup over 0:00
- unknown: the failure flow (fall, result panel, `다시 출발`). I did not die within about 26s of run time at 75-100 HP
- unknown: the camp, the shrine panel and the title, since the fixture skipped them
- unknown: dawn at 15:00, soup, chest and bone knight
- I played the first 26s of run time in step mode with D held; that included 2 level-up popups (the 2nd card was picked once; the popup at 0:26 was left open)
- play ms: 188597
- scenes: scene/title/title, scene/run/run
- fail: 0
- restart: 0

## observations

0 | run (paused, resumed) | none | Pause popup over the field, run timer 0:00. HUD frames and plates are placeholder art. The text `BAR_FRAME`, `PLATE`, `BUTTON_PRIMARY` and `GROUND` is stretched and blurred over the HP bar, the plates and the pause buttons. The `계속하기` label is overprinted by `BUTTON_PRIMARY` | Hard to read the buttons; the popup looks unfinished | major | captures/mvlhfe9d7ab951-1792790951876.png
~6000 | run | tap_anchor pause_resume | The popup closed and the run continued. The player appeared at the center with a red glow, and a red bar under it | Resume works | none | captures/mvlhfe9d7ab951-1792790958534.png
~6600 | run | key_down D, step 600ms | The player moved on the field and the timer stayed 0:00. The ground is covered with the repeated word `GROUND` | Movement responds; the ground texture is a placeholder and distracts | minor | captures/mvlhfe9d7ab951-1792790963763.png
~12000 | run | key_down D held | Timer 0:12, kills 8, gold 3, HP 100/100, damage number `12` and enemy cubes on screen | Weapon fires on its own and kills are counted | none | captures/mvlhfe9d7ab951-1792790993258.png
~14000 | levelup | none | Level-up popup at 0:14 with 3 cards (거인의 심장, 투척 도끼, 질풍 장화). The run stopped, and the card art is the ID text on a flat color square. The card name and description are overprinted by a large stretched `ABILITY_CARD`-like placeholder. The description text is partly hidden, e.g. `움직이는 방향으로 도끼를…` is cut | The cards cannot be read well | major | captures/mvlhfe9d7ab951-1792791042458.png
~14000 | levelup | key 2 | The throwing axe was added and the popup closed | Key selection works | none | -
~26000 | levelup | none | Second popup at 0:26, Lv 3, HP 75/100, kills 32, gold 10. The cards are 등불 탄환 Lv2, 바람의 깃털, 성화 오라. The `기수 +1` description on the first card is nearly invisible against the placeholder overlay | The same overprint problem; the description contrast is low | major | captures/mvlhfe9d7ab951-1792791106772.png
whole | run | none | Error log is empty. A damage number and the HP drop 100→75 were visible. Telemetry shows an idle span of about 15.8s before my first input, because the fixture opened paused | No crash or error | none | -

## reproduce

- Pause popup text overprint: start from the fixture and capture at once. No input is needed
- Level-up cards unreadable: from the resumed run, press `pause_resume` → hold `D` → in step mode advance about 14s of game time → the popup opens at Lv 2 (again at about 0:26, Lv 3)
