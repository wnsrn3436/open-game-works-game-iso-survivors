## coverage

- Started from the `three_levelups` fixture: a resumed run at 0:00 with the pause popup open. I played to the third level-up pick (Lv 4, run time 0:57) and stopped there
- unknown: the camp, lantern shrine, terms popup and title screen (the fixture skipped them)
- unknown: failing (health 0), the result panel, `다시 출발`, `야영지로`, pause → `원정 포기`, dawn at 15:00, the chest and soup. Health never went below 120/120, so the low-health state was not seen
- unknown: the `등불 제단의 가호` plate (no shrine purchase in this fixture)
- play ms: 325331
- scenes: scene/title/title, scene/run/run
- fail: 0
- restart: 0

## observations

0 | run (paused, resumed) | tap_anchor pause_resume | Pause popup showed `계속하기` and `원정 포기`, with the note `포기해도 지금까지 번 금화는 받아요`. The run continued from 0:00 | clear | none | captures/mvnneons3b5716-1792921924000.png
2000 | run | key_down D, step 200ms x10 | Run time 0:02. Skull counter 1. The player walked right and a blue gem was near. The first enemy was killed within 2 seconds of the start, before any move input mattered | the opening is fast, with no empty wait | none | captures/mvnneons3b5716-1792921939995.png
4000 | run | step | The first level-up popup opened at 0:04 (Lv 2, 2 kills) and paused the run. Its 3 cards are all passives (`바람의 깃털`, `거인의 심장`, `자석 부적`), all marked `새로 얻기`. The starting lantern weapon showed no upgrade card and no new weapon was offered | the first pick has no weapon choice, so a pick has less weight | minor | captures/mvnneons3b5716-1792921949832.png
4000 | level-up popup | key 2 | Picked `거인의 심장`. The popup closed. Max health went 100 → 120 and a heart icon (1) appeared in the top-left panel | the effect showed at once | none | captures/mvnneons3b5716-1792921988634.png
12000 | run | key_down A+S, step 200ms | Run time 0:12, 8 kills, 3 gold. Several blue gems lay on the ground behind the player. I did not pick them up while walking right and they did not fly in on their own | the XP bar filled only 15% in 8 seconds of play, so level 2 → 3 needed careful chasing | none | captures/mvnneons3b5716-1792921988634.png
18000 | level-up popup | step | The second popup opened at 0:18 (Lv 3, 15 kills). Cards: `낙뢰` (new weapon), `분노의 불씨` (new passive), `등불 탄환` Lv 2 (+1 count). A weapon and an upgrade were both offered | a clear choice between a new weapon, a passive and a weapon upgrade | none | captures/mvnneons3b5716-1792922022345.png
18000 | level-up popup | key 1 | Picked `낙뢰`. The popup closed. A lightning icon (1) appeared in the weapon list and lightning bolts started striking enemies with damage numbers (20) | the new weapon was visible on screen right away | none | captures/mvnneons3b5716-1792922094113.png
34000 | run | key_down W then A+S, step 200ms | Run time 0:34, 40 kills, 13 gold. Many enemies (zombies, bats) were on screen. The player was at full health, not hit once | the early wave is easy, with no pressure to move | minor | captures/mvnneons3b5716-1792922094113.png
54000 | run | step | Run time 0:54, 64 kills, XP bar about 65%. Lv 3 → Lv 4 took 39 seconds of run time, against 14 seconds for Lv 2 → Lv 3 and 4 seconds for Lv 1 → Lv 2 | the level-up pace slows quickly after the first two picks | minor | captures/mvnneons3b5716-1792922181428.png
57000 | level-up popup | step | The third popup opened at 0:57 (Lv 4, 70 kills, 22 gold). Cards: `거인의 심장` Lv 2, `바람의 깃털` (new), `분노의 불씨` (new). `낙뢰` and `등불 탄환` upgrades were not offered | two of the three cards are passives again | none | captures/mvnneons3b5716-1792922201218.png
57000 | level-up popup | key 3 | Picked `분노의 불씨`. The popup closed and the run continued. No error log | the number keys 1 2 3 worked every time | none | captures/mvnneons3b5716-1792922211748.png

## reproduce

None. No observation was `blocker` or `major`.
