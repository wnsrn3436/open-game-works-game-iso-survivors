## coverage

- Moment `titles_and_buttons` started on the camp (title already passed). Played: camp → lantern shrine open/close → run → level-up popup → pause popup → continue → give up → result panel → `다시 출발` (new run started).
- unknown: the fall (health 0) path and its `등불이 꺼졌다…` title; the dawn result (`새벽이 밝았다!`); the shrine buy path (gold was 0, every row showed `금화가 부족해요`); the shrine badge on the camp button; the `등불 제단의 가호` plate (no purchase made); the soup, chest and low-health warning; the second run after restart was only started, not played.
- play ms: 223845
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run, scene/run/run
- fail: 1
- restart: 1

## observations

0 | scene/lobby/lobby | none | Camp shown with the game title in a winged gold banner, `나의 기록` card with the first-run line, `등불 제단` and a large yellow `원정 시작` | headings are in a bold gold/white display face and readable; the title text is bigger than the other headings | none | captures/mvngi7et550e80-1792910327834.png
8000 | scene/lobby/lobby | tap_anchor lobby_upgrades | Shrine panel opened with six rows (힘 Lv 0/5, 생명력 Lv 0/5, 서두름, 자력, 신속, 탐욕 Lv 0/3), costs 50/40/100/30/60/80, `금화가 부족해요` over each dimmed buy button, gold 0 | heading `등불 제단` in a ribbon, row names clear; the rows show 0 of 5 pips but the guide's example `Lv 1/3` differs only as an example | none | captures/mvngi7et550e80-1792910335732.png
16000 | scene/lobby/lobby | tap_anchor upgrade_close | Shrine closed and the camp came back | responded at once | none | captures/mvngi7et550e80-1792910343741.png
22000 | scene/run/run | tap_anchor lobby_play | After loading the run opened at 0:00, 100/100 health, one lantern weapon icon, hint `WASD 로 움직이세요. 공격은 자동이에요` | the field is very dark; the player is small at the screen centre and almost nothing else is visible at 0:00 | minor | captures/mvngi7et550e80-1792910349763.png
35000 | scene/run/run | key_down D then ogw step | First step after run start took about 5 s of real time before the run time moved (a `Response` mark came at play ms 46985) | matches the run-start lock window only loosely; the 0:00 hold lasted ~10 steps (2 s of step time) with nothing happening on screen | minor | captures/mvngi7et550e80-1792910361128.png
59000 | scene/run/run | hold D | At 0:05 the XP bar was about half full, kills 2, a gem near the player; bats and zombies are dark purple/grey on a dark navy field | enemies and gems are hard to tell from the field and the gravestones; the damage number `12` floats alone | minor | captures/mvngi7et550e80-1792910377039.png
75000 | scene/run/run | hold D | At 0:08 five kills, one gold; blue gems visible and easy to see | gems stand out well | none | captures/mvngi7et550e80-1792910393750.png
85000 | scene/run/run | hold A+W, ogw step 500ms x12 | The third step failed with `the command went over its time limit` while the level-up popup opened | the step tool did not report the popup change (it normally stops on `popups` change); I had to capture to find the popup | minor | captures/mvngi7et550e80-1792910435022.png
85000 | scene/run/run | (level-up popup) | Popup `레벨 업!` with `하나를 고르세요`, three cards (`회전 낫`, `투척 도끼`, `분노의 불씨`) all marked `새로 얻기`, and the line `1 2 3 로도 고를 수 있어요`; run held at 0:09, level 2 | heading ribbon is large and clear; card titles and descriptions read well; the card text area has empty space under the descriptions | none | captures/mvngi7et550e80-1792910435022.png
126000 | scene/run/run | key 1 | The first card was picked (scythe icon showed next to the lantern in the HUD), the popup closed and the run went on | picked at once | none | captures/mvngi7et550e80-1792910448750.png
128000 | scene/run/run | key P | Pause popup `일시 정지` with `계속하기` (yellow) and `원정 포기` (wood), and `포기해도 지금까지 번 금화는 받아요` | the heading ribbon and the two buttons match the camp style | none | captures/mvngi7et550e80-1792910448750.png
138000 | scene/run/run | tap_anchor pause_resume, then key P, tap_anchor pause_give_up in the same moment | Resume worked and the run moved to 0:10. Pressing `P` then tapping `pause_give_up` right away made the pause popup show but the give-up tap produced no visible change in the next capture (the capture still showed the popup dimmed over 0:10) | in step mode the capture right after the tap looked unchanged; only after `ogw step` did the Fail mark arrive (play ms 168345) | minor | captures/mvngi7et550e80-1792910478489.png
168000 | scene/run/run | ogw step 200 | Fail mark at play ms 168345, the run stopped | give-up took effect only when time advanced | none | captures/mvngi7et550e80-1792910487017.png
178000 | scene/run/run | ogw step 200 | Result panel opened (`Goal` mark at play ms 178327) | about 1.6 s of waiting, within the guide | none | captures/mvngi7et550e80-1792910496661.png
180000 | scene/run/run | none | Result panel `원정을 포기했다` with `생존 시간 10초`, `처치 7`, `도달 레벨 2`, `금화 +2`, and the buttons `다시 출발` (yellow) and `야영지로` (wood); the field behind is tinted red | all the values match what was seen in the HUD (7 kills, level 2, 2 gold); the title ribbon and buttons are clear | none | captures/mvngi7et550e80-1792910499539.png
195000 | scene/run/run | tap_anchor result_again | A new run started (restart count 1) | worked | none | captures/mvngi7et550e80-1792910510870.png

## reproduce

No blocker or major observation.
