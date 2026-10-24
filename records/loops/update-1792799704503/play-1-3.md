## coverage

- unknown: fall by health 0 (`등불이 꺼졌다…`, red field, result after ~1.6s). Not reached; the player stood inside the ring weapon and health never dropped below 36/100 (the 30% danger warning was never seen). The restart flow was not played after a fall
- unknown: dawn at 15:00 (`새벽이 밝았다!`). The run was given up at 3:19
- unknown: soup, bone knight chest, shrine-boosted run (`등불 제단의 가호` plate), `원정 시작`/`다시 출발` after the first run, `체력이 위험해요!`
- Level-up popup was answered with key `1` each time; cards 2 and 3 and clicking a card were not tried
- Step mode was used in the run. Time was advanced in 500~1000 ms steps instead of the guide's 200 ms
- play ms: 1254996
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby
- fail: 1
- restart: 0

## observations

3000 | scene/title/title (terms popup) | none (capture) | Terms popup over the title. The title logo behind it is a olive rectangle with black pixel text `L…EM` | Placeholder art on the title | major | captures/mvlob2pjfd7137-1792802503151.png
8000 | scene/title/title | tap_anchor terms_agree_all, then terms_confirm | Both checkboxes were checked and the camp loaded in 503 ms | Flow works as written | none | captures/mvlob2pjfd7137-1792802513898.png
11000 | scene/lobby/lobby | none (capture) | The top-left logo is a placeholder (olive box, `LOGO_EMBLEM` text) with the Korean title overprinted. The top band shows white placeholder bars. The hero is a flat magenta rectangle with the black text `HERO`. The `나의 기록` header is a tan plate reading `TITLE_RIBBON` under the Korean text. The shrine icon is a green box `UI_SHRINE`. The settings button icon is a pink square | The camp reads as unfinished. Texts overlap and are hard to read, and the hero is not recognizable | major | captures/mvlob2pjfd7137-1792802513898.png
20000 | scene/lobby/lobby → scene/run/run | tap_anchor lobby_play | The run scene loaded in 510 ms. The timer showed 0:00 and the move hint `WASD 로 움직이세요. 공격은 자동이에요` showed | Clear, no wait problem | none | captures/mvlob2pjfd7137-1792802527180.png
30000 | scene/run/run | key_down D, 15 steps of 1000 ms | At 0:10, 5 kills and Lv 2, the level-up popup opened with 3 cards (투척 도끼, 거인의 심장, 분노의 불씨), each with an icon and text, and the run time stopped | Cards read clearly. The first level-up came after only 10 s | none | captures/mvlob2pjfd7137-1792802588361.png
30000 | scene/run/run (level-up popup) | none | The popup title is a tan plate with `TITLE_RIBBON` placeholder text behind `레벨 업!` | Overprinted text is hard to read | minor | captures/mvlob2pjfd7137-1792802588361.png
100000 | scene/run/run | key_down D, key 1 each second | At 0:49, Lv 4, 48 kills, 16 gold, the player is in a yellow ring weapon, health 96/100, three owned items in the top left. Gems drop and enemies come | Weapon feedback visible | none | captures/mvlob2pjfd7137-1792802780202.png
400000 | scene/run/run | stood still, key 1 each second | At 2:40, Lv 14, 714 kills, health 36/100. Hundreds of blue gems lie on the field and the player does not collect them while standing still | Screen is crowded with gems and effects. Standing still in the ring still survived 2+ minutes with health holding at 36 | minor | captures/mvlob2pjfd7137-1792803391180.png
550000 | scene/run/run | stood still, key 1 each 500 ms | At 2:59, Lv 16, 875 kills, health stayed at 36/100 over 20 s of game time | Passive play with no movement is enough to hold the field at this time, so the move input has little effect | minor | captures/mvlob2pjfd7137-1792803518547.png
650000 | scene/run/run | key_down Left, 20 s | At 3:19, Lv 18, 972 kills, health 61/100, a thick wave of enemies on the right, lightning bolts hit enemies. Health rose from 36 to 61 during the walk | Heal source not seen on screen | none | captures/mvlob2pjfd7137-1792803666883.png
660000 | scene/run/run | key P | `P` opened the pause popup and `ogw step` answered `game time is paused` as written | Matches the guide | none | captures/mvlob2pjfd7137-1792803679307.png
665000 | scene/run/run | tap_anchor pause_give_up | The field turned red and `원정을 포기했다…` showed over it. The result panel came after two more steps | Matches the guide | none | captures/mvlob2pjfd7137-1792803683820.png
668000 | result panel | none (capture) | The result shows survived time 3분 19초, kills 972, level 18, gold +262. The title is a tan `TITLE_RIBBON` plate with the Korean text overprinted, and the level row icon is a green box `UI_LEVEL` | Numbers match the run HUD. Placeholder art remains | minor | captures/mvlob2pjfd7137-1792803693456.png
675000 | scene/lobby/lobby → shrine panel | tap_anchor result_lobby, lobby_upgrades, upgrade_buy [upgrade_vitality] | The six upgrade rows show. Vitality went to Lv 1/5 and gold went from 262 to 222. A small dim toast `생명력 강화 완료!` was drawn over the middle of the rows. Pips are purple placeholder squares with tiny text, and the title plate is the `TITLE_RIBBON` placeholder | The buy works. The toast sits over row text and is nearly unreadable. The guide says `Lv 1/3` style for the rows, while here the maximums are 5 for 힘 and 생명력 and 3 for the others | minor | captures/mvlob2pjfd7137-1792803709230.png

## reproduce

- Title and camp placeholder art: start a new instance, wait about 3 s for login. The terms popup shows the placeholder title logo behind it. Press `terms_agree_all`, `terms_confirm`. The camp shows the placeholder logo, hero, shrine icon and ribbon
