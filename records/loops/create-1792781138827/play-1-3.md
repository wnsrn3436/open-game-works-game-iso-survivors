## coverage

- unknown: dawn at 15:00 (the run ended by fall at 43s; no second run was played)
- unknown: pause popup (`P`/`Esc`), `원정 포기`, `다시 출발` restart flow (result panel was left through `야영지로` only)
- unknown: gold purchase at the lantern shrine (14 gold, cheapest row costs 30; the one buy press was sent with key `upgrade_magnet` without brackets and the input was rejected, so the not-enough-gold press was not tested)
- unknown: soup, bone knight chest, blue gem pickup (no gem was ever identified on screen), settings button, gamepad input
- played in one direction only (held `D`, no dodging); movement in other directions was not tested
- play ms: 617972
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/lobby/lobby
- fail: 1
- restart: 0

## observations

- 0 | scene/title/title | none | the terms popup showed placeholder art: the buttons are filled with the text `BUTTON`, the row frames are stretched | the screen is readable but looks unfinished | minor | captures/mvle1gaxa545f2-1792785268717.png
- 12000 | scene/lobby/lobby | tap_anchor terms_agree_all, terms_confirm | camp opened; gold 0, three buttons shown. The big `LOBBY` block letters, `PLATE`/`BUTTON_PRIMARY` texts and a stretched gold label are placeholder art. The `원정 시작` label overlaps the `BUTTON_PRIMARY` text | labels hard to read on the start button | minor | captures/mvle1gaxa545f2-1792785280268.png
- 15000 | scene/run/run | tap_anchor lobby_play | the run opened at 0:00 with the move hint `WASD 로 움직이세요. 공격은 자동이에요`; HP 100/100, Lv 1, kills 0. HUD panels show placeholder `LATE`/`BAR_FRAME` art. The `GROUND` text tiles the floor | the hint is clear; the HUD looks unfinished | minor | captures/mvle1gaxa545f2-1792785295621.png
- 20000 | scene/run/run | key_down D, step 200 x25 | at 0:05 the player had killed 3 enemies on its own and a damage number `12` showed; the player's position stays at screen center while the world scrolls | auto-attack and the movement work | none | captures/mvle1gaxa545f2-1792785345647.png
- 40000 | scene/run/run | held D | at 0:17 kills 12, gold 4. Enemies and scenery are all lavender boxes of similar color, so enemies cannot be told from scenery; no blue XP gem can be picked out | cannot tell what to avoid or collect | major | captures/mvle1gaxa545f2-1792785452962.png
- 60000 | scene/run/run | held D | at 0:25 kills 20, Lv 1 still. The XP bar at the top is a placeholder-stretched strip and its fill cannot be read | no readable progress toward the level-up | major | captures/mvle1gaxa545f2-1792785524072.png
- 80000 | scene/run/run | held D | the level-up popup opened at 0:27 (Lv 2) after about 23 kills; three cards `거인의 심장`, `회전 낫`, `분노의 불씨` with the hint `1 2 3 로도 고를 수 있어요`. Card names and descriptions are drawn over a stretched white placeholder frame; the `회전 낫` description wraps and runs across the frame | the text can be read but with effort | minor | captures/mvle1gaxa545f2-1792785628954.png
- 82000 | scene/run/run | key 2 | the card `회전 낫` was picked; the popup closed and the run continued, and the weapon slot showed a second weapon icon | the card pick works | none | captures/mvle1gaxa545f2-1792785637468.png
- 100000 | scene/run/run | held D | at 0:39 HP fell from 100 to 45 within 12 seconds after the level-up while the player walked straight; kills 37, gold 12. The player is surrounded by enemies with a hit number `9` shown | the damage grew fast; I did not see which contact took the health | minor | captures/mvle1gaxa545f2-1792785739698.png
- 110000 | scene/run/run | held D | the run ended at 43 seconds; the result panel `어둠에 쓰러졌다` shows survived 43s, kills 41, level 2, gold +14, with `다시 출발` and `야영지로`. The stretched `PANEL_FRAME` art covers the stats rows; the `다시 출발` label overlaps `BUTTON_PRIMARY` text | the numbers are readable but the panel looks unfinished | minor | captures/mvle1gaxa545f2-1792785813095.png
- 115000 | scene/lobby/lobby | tap_anchor result_lobby, lobby_upgrades | the shrine panel showed gold 14 and six rows with the costs 50, 40, 100, 30, 60, 80, each with `금화가 부족해요`. Cost numbers are red and overlap the placeholder button art; every buy button reads `강화` over `BUTTON_PRIMARY` | the costs are clear; with 14 gold from a 43s run, the cheapest upgrade (30) needs about two runs of this length | minor | captures/mvle1gaxa545f2-1792785829745.png
- 116000 | scene/lobby/lobby | tap_anchor upgrade_buy upgrade_magnet | the input was rejected with `the anchor key is not an ID name or an integer of at least 1` | my input error (key given without brackets); not a game defect | none | -
- 117000 | scene/lobby/lobby | tap_anchor upgrade_close | the shrine closed back to the camp; no error log in the whole play | works | none | -

## reproduce

- 40000 observation (enemies not distinguishable from scenery, no gem visible): new user → `tap_anchor terms_agree_all` → `tap_anchor terms_confirm` → `tap_anchor lobby_play` → `ogw step-mode on` → `key_down D` → `ogw step 200` repeated until 0:17 → capture
- 60000 observation (XP progress unreadable): same inputs as above, capture at 0:25 (Lv 1, 20 kills) and compare the top bar with the capture at 0:05
