## coverage

- unknown: death (fall) flow, `다시 출발`, dawn at 15:00 (`새벽이 밝았다!`), bone knight chest, soup heal, shrine purchase success (29 gold covered no upgrade; cheapest is 30), run with shrine bonus plate. Only 51 s of run time was played, ended with `원정 포기`. At 30/120 HP the player did not die within the ~9 s played while standing still.
- The fall flow was not reached, so the failure restart check is unknown.
- play ms: 714114
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby
- fail: 1
- restart: 0

## observations

0 | terms | capture | terms popup shown over title screen; behind it a placeholder logo (olive box, black pixel text `LOGO_EMBLEM`) | placeholder art visible on the first screen | minor | captures/mvloaop21e0bc6-1792802479560.png
5000 | terms | tap_anchor terms_agree_all, terms_confirm | both ticked, confirm went to camp in about 500 ms | none | none | captures/mvloaop21e0bc6-1792802491339.png
8000 | lobby | capture | camp: hero is a flat magenta box labelled `HERO`; `TITLE_RIBBON` placeholder plate under `나의 기록`; `UI_SHRINE` placeholder icon on the shrine button; gear icon is a placeholder square; top band has overlapping `LOGO_EMBLEM` and Korean title text; top HUD has white placeholder blocks | camp looks unfinished, text over the placeholder ribbon is hard to read | major | captures/mvloaop21e0bc6-1792802491339.png
12000 | lobby | tap_anchor lobby_play | run loaded in about 500 ms, timer 0:00, move hint `WASD 로 움직이세요. 공격은 자동이에요` | clear start | none | captures/mvloaop21e0bc6-1792802502007.png
13000 | run | key_down D + step | player is a small figure in a dim dark field; the first weapon fires without input | the field is very dark and plain at the start | minor | captures/mvloaop21e0bc6-1792802515692.png
20000 | run | step to 0:07 | first level-up popup at 0:07 with 3 cards, each with icon, name and effect; `1 2 3 로도 고를 수 있어요` hint | readable and quick to reach; title ribbon is a placeholder plate with Korean text drawn over `TITLE_RIBBON` | minor | captures/mvloaop21e0bc6-1792802590751.png
25000 | run | key 3 | card 3 (axe) taken, run resumed | none | none | captures/mvloaop21e0bc6-1792802697908.png
40000 | run | step to 0:18 | HP 78/100, Lv 3 popup; 2 of 3 cards were new picks, the same `분노의 불씨` card was offered at every popup | the same offer repeats, little variety | minor | captures/mvloaop21e0bc6-1792802697908.png
60000 | run | step to 0:31 | 51 kills, many enemies and blue gems on screen; damage numbers and weapon effects readable | combat reads well | none | captures/mvloaop21e0bc6-1792802810019.png
62000 | run | key P | pause popup opened with `계속하기` and `원정 포기`; title plate is a placeholder; time stayed 0:31 | works | none | captures/mvloaop21e0bc6-1792802819871.png
63000 | run | tap_anchor pause_resume | run resumed | none | none | captures/mvloaop21e0bc6-1792802894773.png
80000 | run | key 3 | Lv 5 popup at 0:32, lightning picked; HP 30/120 with `체력이 위험해요!` shown under player | warning is visible | none | captures/mvloaop21e0bc6-1792802955683.png
100000 | run | step standing still, 0:41 to 0:47 | many blue gems left uncollected around the player (about 20 on screen) while standing still | gems pile up when the player stays still, which is expected for pick-up radius | none | captures/mvloaop21e0bc6-1792802998289.png
110000 | run | key 2, P, tap_anchor pause_give_up | result panel `원정을 포기했다`: survived 51 s, 99 kills, Lv 6, `금화 +29`; the level icon shows a `UI_LEVEL` placeholder | the numbers match the HUD; one placeholder icon | minor | captures/mvloaop21e0bc6-1792803136065.png
115000 | result | tap_anchor result_lobby | camp reached | none | none | captures/mvloaop21e0bc6-1792803149715.png
118000 | shrine | tap_anchor lobby_upgrades | shrine panel with six rows; `힘` and `생명력` are `Lv 0/5`, the other four `Lv 0/3`; pips are placeholder squares with tiny text; `TITLE_RIBBON` plate behind the heading | guide says `Lv 1/3` format; pips are not readable | minor | captures/mvloaop21e0bc6-1792803152677.png
119000 | shrine | tap_anchor upgrade_buy [upgrade_might] | 50 gold needed, 29 held; a faint `금화가 부족해요` strip appeared across the middle of the panel; nothing bought; no error log | the toast overlaps the 서두름 and 자력 rows and is very small | minor | captures/mvloaop21e0bc6-1792803152677.png
0 | run | step | stepping 200 ms at a time takes about 1.5 to 2 s of real time per call and a level-up popup interrupts a batch | slow to test | minor | none

## reproduce

(no blocker or major observations reproduced beyond the camp placeholder art)
- camp placeholder art: start a new user, `tap_anchor terms_agree_all`, `tap_anchor terms_confirm`, capture the camp.
