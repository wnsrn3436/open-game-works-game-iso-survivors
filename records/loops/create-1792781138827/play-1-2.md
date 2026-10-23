## coverage

- unknown: dawn at 15:00 (never survived past 0:39)
- unknown: soup, bone knight chest, XP gem pickup visuals (no blue gem seen on screen)
- unknown: buying a lantern shrine upgrade (gold was 0 on the first visit; the 11 gold earned was not spent)
- unknown: camp -> options screen; a second level-up; the weapon-card and chest card flows
- unknown: pause popup contents were captured but not inspected in detail
- play ms: 753296
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

0 | terms | none | Terms popup shows over title. Button textures show stretched placeholder "BUTTON" text over the real labels | labels hard to read but legible; looks unfinished | minor | captures/mvle10cgbb9f15-1792785254995.png
3000 | lobby | tap_anchor terms_agree_all, terms_confirm | Camp opens with gold 0, title, three buttons. Start button text overlaps the "BUTTON PRIMARY" placeholder texture, and the right-hand LOBBY / GROUND / PLATE texts are placeholder art | start label is hard to read | minor | captures/mvle10cgbb9f15-1792785272955.png
9000 | lobby shrine | tap_anchor lobby_upgrades | Six rows show Lv, effect and cost, and each reads `금화가 부족해요` at 0 gold. The buy button text overlaps the placeholder texture | information is complete; button label is hard to read | minor | captures/mvle10cgbb9f15-1792785281441.png
20000 | run | tap_anchor lobby_play | Run starts at 0:00 with the move hint at the bottom. HP 100/100, weapon slot 1. The HUD panel and XP bar use placeholder textures | readable enough | minor | captures/mvle10cgbb9f15-1792785293198.png
22000 | run | key_down D, 10 steps of 200ms | Timer 0:02, the player moved and enemies (grey-blue boxes) approached | movement is responsive | none | captures/mvle10cgbb9f15-1792785322467.png
42000 | run | key_down W, 100 steps | Timer 0:22, 14 kills, 5 gold, Lv 1, HP still 100/100. No blue gem was visible on the field | the weapon kills on its own with no damage taken; gems not seen | minor | captures/mvle10cgbb9f15-1792785500025.png
50000 | run | idle | At 0:28 the level-up popup opened at Lv 2 with 3 cards (wind feather, spark of rage, giant's heart), each with a placeholder texture over the text; the hint reads `1 2 3 로도 고를 수 있어요` | the card effect text is overlapped by the placeholder art and hard to read | minor | captures/mvle10cgbb9f15-1792785682231.png
55000 | run | key 2 | Card picked, play resumed with the next step | none | none | captures/mvle10cgbb9f15-1792785693333.png
70000 | result | idle for about 30 game seconds | Fell at 39s. The panel shows survived time 39s, kills 32, level 2, gold +11. Only 3 hits in about 11s of standing still took the HP from 100 to 0, so the fall comes fast | stats are readable, but the placeholder frame text sits behind them; standing still dies quickly | minor | captures/mvle10cgbb9f15-1792785944077.png
75000 | restart | tap_anchor result_again | A new run started after about 3s | none | none | captures/mvle10cgbb9f15-1792785958680.png
76000 | pause | key P | Pause popup opened and `pause_resume` closed it | none | none | captures/mvle10cgbb9f15-1792785965320.png

## reproduce

None. No blocker or major observations.
