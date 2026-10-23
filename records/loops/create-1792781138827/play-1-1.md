## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) not reached; longest run was 1분 13초
- unknown: bone knight chest, soup (heal) pickup not seen as such (health went 6/100 → 26/120 between 0:56 and 1:05, cause not identified)
- unknown: settings (`lobby_options`) not opened, terms `보기` buttons not opened
- unknown: save fixture moment (none given); gamepad input not tried
- unknown: whether the XP bar fills (see observations; top bar looked the same at every capture)
- play ms: 845079
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | terms popup | none | popup `이용약관 동의` opens with a huge `TITLE` placeholder text behind it and stretched `BUTTON` placeholder art on every button | placeholder art is still in place of final art; the label text is hard to read over it | minor | captures/mvle0pdkc59058-1792785234462.png
2000 | terms popup | tap_anchor terms_agree_all, terms_confirm | both checkboxes turned on, confirm went to the camp in under 3 s | worked as the guide says | none | captures/mvle0pdkc59058-1792785243971.png
5000 | camp | none | camp shows gold 0, the title `아이소 서바이버즈`, three buttons; a huge `LOBBY` placeholder fills the background; `원정 시작` label sits on top of stretched `BUTTON_PRIMARY` art | the buttons and the gold box are readable but look unfinished | minor | captures/mvle0pdkc59058-1792785251282.png
12000 | shrine | tap_anchor lobby_upgrades | six rows with level, effect and cost (might 50, vitality 40, haste 100, magnet 30, swiftness 60, greed 80), all showing `금화가 부족해요` at 0 gold; the buy buttons have the `BUTTON_PRIMARY` placeholder art over the label `강화` | clear what each row does; button labels are hard to read | minor | captures/mvle0pdkc59058-1792785261957.png
13000 | shrine | tap_anchor upgrade_buy upgrade_might | tool answered `the anchor key is not an ID name or an integer of at least 1` | the guide writes the key as `[upgrade_might]`; the key only worked with the square brackets (`[upgrade_magnet]`), so the key form in the guide is easy to get wrong | minor | none
20000 | run 0:00 | tap_anchor lobby_play | the run opened at 0:00 with the move hint `WASD 로 움직이세요. 공격은 자동이에요`, health 100/100, one weapon icon, `Lv 1`; the player is a lit pillar on a ground tiled with `GROUND` placeholder text | the load took under 2 s; the ground text pattern makes the field look busy | minor | captures/mvle0pdkc59058-1792785278012.png
30000 | run 0:10 | key_down D, 10 s of steps | player moved right; 4 kills, 2 gold; the enemies, gems and the player are all similar light-blue boxes | enemies and gems cannot be told apart at a glance | major | captures/mvle0pdkc59058-1792785312603.png
60000 | run 0:20-0:30 | key_down S then A | 13 kills at 0:20, 20 kills at 0:30, health stayed 100/100, still `Lv 1` | no danger for the first 30 s, then 40 s to the first level-up felt slow | minor | captures/mvle0pdkc59058-1792785564359.png
100000 | run 0:40 level-up | key_down A | level-up popup `레벨 업!` opened at 0:40 with three cards (낙뢰 new, 등불 탄환 Lv 2, 질풍 장화 new); game stopped behind it; card art shows an ID name as text (`WEAPON_LIGHTNING`) over a stretched `CARD` placeholder; the description text is cut by the placeholder art | the choice is readable by title; description of a card hard to read | minor | captures/mvle0pdkc59058-1792785675573.png
101000 | level-up | key 1 | card 1 taken, run went on, weapon list got a second icon | worked | none | captures/mvle0pdkc59058-1792785689288.png
140000 | run 0:56 | none (standing still) | health fell from 100 to 6/100 in about 16 s of standing still; second level-up popup (거인의 심장, 회전 낫, 낙뢰 Lv 2) | health dropped fast with no on-screen warning; the red bar frame is a placeholder and does not show the drop clearly (only the number 6/100) | major | captures/mvle0pdkc59058-1792785804824.png
150000 | run 1:05 | key 1 | vitality taken; health read 26/120 and kills 80; a damage number `12` floats near the enemies; about 25 enemies are on screen | health went up by 20 which fits the card's +20; enemies crowd around the player | none | captures/mvle0pdkc59058-1792785854508.png
195000 | fall | none | after 1:13 the result panel `어둠에 쓰러졌다` opened with survived time 1분 13초, kills 95, level 3, gold +30; a large `PANEL_FRAME` placeholder text sits in the middle of the panel and the numbers are drawn over it | the numbers are readable but the placeholder text is distracting; `다시 출발` text overlaps stretched art | minor | captures/mvle0pdkc59058-1792785922780.png
200000 | restart | tap_anchor result_again | new run started at 0:00 with health 100/100, Lv 1, kills 0, gold 0 | restart works and the state is reset | none | captures/mvle0pdkc59058-1792785943197.png
205000 | pause | key P then tap_anchor pause_give_up | P paused the run (step failed with `game time is paused`, as in the guide); give up ended the run, and in step mode the result panel did not show until time was stepped (tap on `result_lobby` failed with `anchor is not there or not visible`) | with step mode on the panel waits for game time; result panel showed `생존 시간 0초`, kills 0, gold +0 | minor | captures/mvle0pdkc59058-1792785970763.png
215000 | result panel | tap_anchor result_lobby | went to the camp | worked | none | captures/mvle0pdkc59058-1792785994065.png
220000 | shrine | tap_anchor upgrade_buy [upgrade_magnet] | the camp had 30 gold from the first fall; magnet went to Lv 1/3, its cost to 90, gold to 0; an extra press on a row with no gold shows `금화가 부족해요` as a toast across the screen | buying works and the gold carries over; the toast is a thin dark band with tiny text | minor | captures/mvle0pdkc59058-1792786013587.png

## reproduce

- 30000 enemies and gems look alike: terms_agree_all → terms_confirm → lobby_play → step-mode on → key_down D → step 200 x 50 → capture. All objects on screen are light-blue boxes of different size
- 140000 health 100 to 6 while standing still: start a run → no key input → step 500 x ~110 (until 0:56). Health read 6/100 at the second level-up popup
