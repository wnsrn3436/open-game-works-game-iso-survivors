## coverage

- unknown: dawn at 15:00 (`새벽이 밝았다!`) was not reached; the longest run ended by fall at 2:59
- unknown: bone knight chest, soup card, gamepad input, settings (`lobby_options`), terms `보기` buttons
- unknown: the text `등불 제단의 가호가 함께합니다` was not seen at 0:02 of the run after a purchase (only the icon plate with levels was visible); it may have already faded
- unknown: manual movement was only checked at the run start (D held ~1s); moving later in the run was not played, so the fall came from standing still
- the shrine buy was played with key `[upgrade_vitality]`; the key without brackets was rejected by `tap_anchor` with `the anchor key is not an ID name or an integer of at least 1`
- play ms: 763434
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run, scene/lobby/lobby, scene/run/run
- fail: 2
- restart: 2

## observations

1 | 0 | title | tap_anchor terms_agree_all, terms_confirm | terms popup opened. Buttons show a stretched placeholder texture ("BUTTON" letters smear across the rows), the confirm button is dim until both are on, and a large "TITLE" placeholder text sits behind the popup | art is a placeholder; labels are still readable | minor | captures/mvlhegsqd9f446-1792790902636.png
2 | ~14000 | lobby | (after confirm) | the camp shows the title `아이소 서바이버즈`, the gold, and 3 buttons. Large "LOBBY" placeholder letters fill the background and the `원정 시작` label overlaps the stretched "BUTTON PRIMARY" texture | works, but the label is hard to read over the texture | minor | captures/mvlhegsqd9f446-1792790914568.png
3 | ~30000 | run | tap_anchor lobby_play, key_down D | the run loaded in about 0.5s and the HUD appeared: health 100/100, a weapon icon, kills, gold, a timer. The ground has "GROUND" placeholder text tiled across it, and the HUD frames show "PLATE" and "BAR_FRAME" placeholder text | readable and the weapon fires on its own (kills 1 at 0:04) | minor | captures/mvlhegsqd9f446-1792790933395.png
4 | ~110000 | run | stand still after releasing D | level-up came at 0:13 (Lv 2) and 0:25 (Lv 3), the run stopped with the 3-card popup, and the timer did not advance until a card was picked with key `2` or `1`. Cards show `새로 얻기` or `Lv N`, an icon and a description. The icons are plain colored squares with the ID text, and the frame art behind the descriptions is garbled so the lines are hard to read | works as the guide says; a description such as `낫이 몸 주위를...` is cut by the frame texture | minor | captures/mvlhegsqd9f446-1792791127181.png
5 | ~190000 | run | standing still, picking card 1 each time | at 2:21 it reached Lv 4 with 417 kills and 30/100 health. `체력이 위험해요!` showed under the player and the number turned red | the warning matches the guide, a mass of cubes covers the player so the player is hard to see | minor | captures/mvlhegsqd9f446-1792791373125.png
6 | ~270000 | run | standing still | the run survived with 14/100 at 2:50 (Lv 5, 541 kills) and the fall came at 2:59; the result `어둠에 쓰러졌다` showed 2분 59초, 처치 581, 레벨 6, 금화 +162 with `다시 출발` and `야영지로`. The panel frame texture ("PANEL_FRAME") covers the stat lines and the primary button label `다시 출발` is overprinted by "BUTTON PRIMARY" | results are right but the button label is nearly unreadable | major | captures/mvlhegsqd9f446-1792791545521.png
7 | ~300000 | lobby | tap_anchor result_lobby, lobby_upgrades | the shrine opened with 6 rows, gold 162, levels and costs (50, 40, 100, 30, 60, 80). Each `강화` button is overprinted by "BUTTON PRIMARY" | rows are complete; the buy button label is hard to read | minor | captures/mvlhegsqd9f446-1792791557494.png
8 | ~310000 | lobby | tap_anchor upgrade_buy upgrade_vitality (no brackets) | `ok:false`, the key was rejected; the guide wrote the key as `[upgrade_vitality]`, and with brackets it worked | the guide text and the tool disagree on the key form, so the first three presses bought nothing | minor | none
9 | ~340000 | lobby | tap_anchor upgrade_buy [upgrade_vitality], [upgrade_might], [upgrade_haste] | gold went 162 → 74, might and vitality at Lv 1/5, and the haste press (cost 100) showed a small `금화가 부족해요` strip over the middle of the panel; costs rose to 120 and 100. Rows without enough gold show red cost and `금화가 부족해요` | works as written; the toast sits on top of the row text | none | captures/mvlhegsqd9f446-1792791612111.png
10 | ~350000 | run | tap_anchor upgrade_close, lobby_play | the new run showed health 115/115 (+15 from vitality) and a small plate under the weapon row with 2 icons marked 1 and 1 | the purchase carried over; `등불 제단의 가호가 함께합니다` was not visible at 0:02 | minor | captures/mvlhegsqd9f446-1792791618749.png
11 | ~320000 | run | key P, tap_anchor pause_resume, key Escape, tap_anchor pause_give_up | pause opened and closed with both keys, give up ended the run with `원정을 포기했다` at 10초, 처치 7, 금화 +2 (the +2 was granted) | works as the guide says | none | captures/mvlhegsqd9f446-1792791592080.png
12 | ~30000-300000 | run | step mode, `ogw step` | game time advanced about 1 ms of run time per 1 ms of real time (a 10000 ms step took about 10s), so a long run needs minutes of waiting | tedious for a tester; not a game defect | none | none
13 | ~190000 | run | standing still for 2:50 | the player survived 2:59 with no movement at all, killing 581 enemies with the auto weapons | a run with no input lasting nearly 3 minutes means danger is low at the start; whether the horde grows enough to need movement before 15:00 is unknown | minor | captures/mvlhegsqd9f446-1792791449787.png

## reproduce

6. the unreadable button label on the result panel: in the camp tap `lobby_play`, wait about 3s, do not press any key, press `1` at each level-up popup, wait until the fall (about 3 minutes of run time), then look at the result panel's `다시 출발` button
