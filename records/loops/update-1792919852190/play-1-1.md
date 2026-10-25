## coverage

- unknown: dawn (15:00) and the `새벽이 밝았다!` result panel. The longest run was 47 s
- unknown: pause popup (`계속하기`, `원정 포기`). My `P` press came while the level-up popup was open, so `pause_resume` and `pause_give_up` were "not there or not visible". The pause popup never opened
- unknown: `다시 출발` (`result_again`). I used `야영지로` (`result_lobby`) after the fall
- unknown: a bought shrine upgrade, the `등불 제단의 가호` plate and the `등불 제단의 가호가 함께합니다` line. The 25 gold from run 1 did not cover the cheapest row (`자력`, 30), so the buy was refused
- unknown: chest from the bone knight, soup, low-health warning (`체력이 위험해요!`), and the six-weapon / full-slot case
- unknown: Options panel (`설정`) and the terms `보기` buttons
- play ms: 218051
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 1
- restart: 1

## observations

- 0 | scene/title | none | Terms popup opened with three unchecked rows and a dimmed `확인` | clear; the logo behind it is half covered | none | captures/mvnne3ktdba3ac-1792921892273.png
- 6000 | scene/title | tap_anchor terms_agree_all, terms_confirm | Both consents turned on and the camp opened in about 3 s | no problem | none | captures/mvnne3ktdba3ac-1792921903748.png
- 12000 | scene/lobby | none | Camp shows gold 0, `나의 기록` with the first-run line, hero by the fire, `등불 제단` and a large yellow `원정 시작` | readable, clear main action | none | captures/mvnne3ktdba3ac-1792921903748.png
- 20000 | scene/lobby | tap_anchor lobby_upgrades, upgrade_buy [upgrade_might] | Shrine panel lists six rows with `금화가 부족해요` over each dimmed button. The press showed a toast, also reading `금화가 부족해요`, as a dark horizontal band across the middle two rows | the band cuts across the 서두름 and 자력 text for as long as it shows | minor | captures/mvnne3ktdba3ac-1792921913327.png
- 30000 | scene/run | tap_anchor lobby_play | Run started at 0:00. The first capture (play ms 45212) was already about 0:01. The move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom | start is quick, hint is clear | none | captures/mvnne3ktdba3ac-1792921930472.png
- 5000 | scene/run | none (stood still) | At 0:05 there were 1 kill, 8 or more enemies on screen and an XP gem at the left | the screen is dark and enemies are low contrast against the field | minor | captures/mvnne3ktdba3ac-1792921930472.png
- 7000 | scene/run | key_down A | Level-up popup opened at 0:07 (Lv 2), after 3 kills. Cards: `등불 탄환 Lv 2`, `낙뢰`, `투척 도끼`. Time stopped | the first level-up comes very fast, which feels good | none | captures/mvnne3ktdba3ac-1792921941731.png
- 7500 | scene/run | key 2 | Card chosen with the number key and the run resumed on the next step | works | none | captures/mvnne3ktdba3ac-1792921949040.png
- 47000 | scene/run | none (stood still from about 0:15) | Level-ups at about 0:30 and 0:40 were picked with `1`. At 0:47 health went to 0/140 at Lv 5, 87 kills. The field turned red, the player lay down and `등불이 꺼졌다…` showed | fall is clear. Max health was 140 and the passive icon `2` shows the max-health card was taken. The weapons only reached level 1 each, so the kills are probably mostly from the first weapon | none | captures/mvnne3ktdba3ac-1792922016407.png
- 49000 | scene/run | none | Result panel `어둠에 쓰러졌다`: 생존 시간 47초, 처치 87, 도달 레벨 5, 금화 +25, with `다시 출발` and `야영지로` | readable and matches the run | none | captures/mvnne3ktdba3ac-1792922025253.png
- 52000 | scene/lobby | tap_anchor result_lobby, lobby_upgrades | Camp gold showed 25 and the shrine showed 25 too. Prices are 50 힘, 40 생명력, 100 서두름, 30 자력, 60 신속, 80 탐욕 | one run earns less than most single upgrades, so only 자력 is within reach after about 1 min of play | minor | captures/mvnne3ktdba3ac-1792922040966.png
- 55000 | scene/run | tap_anchor lobby_play | The second run started at 0:00 with 100/100 health and no shrine plate, since nothing was bought | no problem | none | captures/mvnne3ktdba3ac-1792922049352.png
- 66000 | scene/run | key P | At 0:11 (Lv 2) the level-up popup was open, so `P` did nothing and the run stayed held. The cards offered were `질풍 장화`, `바람의 깃털`, `분노의 불씨`, all passives, with no weapon card | no weapon choice at that level-up | minor | captures/mvnne3ktdba3ac-1792922059054.png
- 75000 | scene/run | tap_anchor pause_give_up | The anchor was not found while the level-up popup was open (expected) | none | none | captures/mvnne3ktdba3ac-1792922067875.png

## reproduce

None. No blocker or major observation.
