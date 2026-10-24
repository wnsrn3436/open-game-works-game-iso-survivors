## commit

- instance: e2595083c3152966c287cf4330728d6bd27cc0ce
- baseline: dbf19b500a441cb8dffb9929139a9a90bfac0cc0
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/update-1792799704503/check-1.json |
| static check | pass | records/loops/update-1792799704503/check-1.json |
| no blocker | pass | records/loops/update-1792799704503/check-1.json |
| full flow | pass | records/loops/update-1792799704503/check-1.json |
| performance | fail | records/loops/update-1792799704503/check-1.json |
| UI quality | fail | records/loops/update-1792799704503/check-1.json |
| no placeholder | fail | records/loops/update-1792799704503/check-1.json |
| row simulation | pass | records/loops/update-1792799704503/check-1.json |

## judge

### records/loops/update-1792799704503/judge-1-1.md

- kind: main
- status: done
- A: e2595083c3152966c287cf4330728d6bd27cc0ce
- B: dbf19b500a441cb8dffb9929139a9a90bfac0cc0
- vs baseline: better
- vs reference: fail
- omitted moments: none

#### moments

- Indistinguishable at `first 30000ms`. Reason: both start with the same terms popup and reach the run with one tap. Telemetry from 0 to 30000 ms gives idle_span 0 / 0 and goal_input_count 23 / 23.
- Indistinguishable at `core action`. Reason: the run field, starting weapon (lantern bolt), enemies and damage numbers are the same in both. Telemetry for the first 30 s of the run is input_latency 0 / 0 and feedback_per_input 1 / 1.
- `B` is better at `first reward`. Reason: reward_interval_ms is B 6451 and A 7050. Both popups have three drawn-icon cards. A's popup title `레벨 업!` sits on a `TITLE_RIBBON` placeholder.
- `A` is better at `first failure`. Reason: both show the same red field and fall title. A's result panel puts each stat (time, kills, level) in a framed row with an icon. B shows four plain centered text lines.
- Indistinguishable at `restart`. Reason: `다시 출발` restarts at 0:00 in both, with restart_delay_ms A 2050 and B 2000.
- `A` is better at `camp_returning_player`. Reason: A's camp shows a record card with an icon per stat (best survival 2분 30초, kills, runs, dawns) and a count badge on `등불 제단`. In A's shrine, buttons the gold cannot cover are dimmed. In B's shrine they stay bright yellow under a small red `금화가 부족해요`. Fixture telemetry: feedback_per_input A 3 vs B 2 (A decisive).

#### loser better

- B's camp shows the full camp art (tents, fire, trees) without blocks over it, and the title, record line and three buttons sit in one centered column. A's camp currently covers the centre and top-left with placeholder blocks.
- B's reward interval was slightly shorter (6451 ms vs 7050 ms).
- In B's level-up popup and shrine, the titles (`레벨 업!`, `등불 제단`) are drawn directly on the panel, so no title text sits on another element.

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/update-1792799704503/play-1-1.md | 0 | 1 | 8 | 9 |
| records/loops/update-1792799704503/play-1-2.md | 0 | 6 | 5 | 6 |
| records/loops/update-1792799704503/play-1-3.md | 0 | 2 | 5 | 7 |
| records/loops/update-1792799704503/play-1-4.md | 0 | 1 | 6 | 2 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| run-hud-flat-boxes | major | client content | run HUD | The HP panel and the kill/gold panel are flat single-color navy boxes with a thin outline, not art frames | `presentation` looks for engine-default or code-made boxes, and the reference HUD is drawn in one art style | mvlo9ook21cea5-1792802515070.png, mvlo9ook21cea5-1792802515070.png`, `mvloa1tsa32ef5-1792802793036-video/frame-00007.png`; `frames-rIONeL/000015000.png, records/loops/update-1792799704503/judge-1-1.md | judge | open |
| shrine-buy-button-clipped | major | client content | scene/lobby/lobby | clipped UICore/Panel/SafeAreaRoot/UpgradePanel/Frame/Box/Grid/Entry1/Row/Side/Buy in prefab/lobby/upgrade_panel (ko, macbook_air_13, lobby.open_upgrades, text scale 1000) | UI quality requires no clipping on every supported screen and language | records/loops/update-1792799704503/check-1.json#UI quality, records/loops/update-1792799704503/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0002-ko-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0011-ko-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0020-ko-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0029-ko-ultrawide_21_9-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0038-en-macbook_air_13-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0047-en-macbook_pro_14_notch-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0056-en-display_16_9-lobby.open_upgrades-1000.json, records/loops/update-1792799704503/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.png, records/loops/update-1792799704503/evidence/check-1/ui-macos/0065-en-ultrawide_21_9-lobby.open_upgrades-1000.json | check | open |
| run-fps-below-target | major | client content | scene/run/run | fps 5 percentile 51 is below targetFps 60 (1 samples) | the run must hold targetFps; the 5th percentile is 51 | records/loops/update-1792799704503/check-1.json#performance, records/loops/update-1792799704503/evidence/check-1/performance-macos/samples.json | check | open |
| low-pressure-early | minor | data | scene/run/run | none (standing still), key 1 → At 1:05 HP is 46/100 as before. Kills 130, gold 38. The gem ring has grown to over 80 gems and the XP bar is about 15% full. Several large zombies are near the top of the screen | standing still for 24 seconds cost no health, so the horde never reaches the player here; there is no pressure to move | captures/mvloavi1854f73-1792803122873.png, records/loops/update-1792799704503/play-1-2.md:25, captures/mvloavi1854f73-1792803301267.png, records/loops/update-1792799704503/play-1-2.md:26, captures/mvlob2pjfd7137-1792803391180.png, records/loops/update-1792799704503/play-1-3.md:22, captures/mvlob2pjfd7137-1792803518547.png, records/loops/update-1792799704503/play-1-3.md:23 | play | open |
| run-field-too-dark | minor | client content | run | key_down D + step → player is a small figure in a dim dark field; the first weapon fires without input | the field is very dark and plain at the start | captures/mvloaop21e0bc6-1792802515692.png, records/loops/update-1792799704503/play-1-1.md:16, mvlo9ook21cea5-1792802515070.png`, `mvlo9ook21cea5-1792802805302.png | play | open |
| shrine-toast-small-overlap | minor | client content | shrine | tap_anchor upgrade_buy [upgrade_might] → 50 gold needed, 29 held; a faint `금화가 부족해요` strip appeared across the middle of the panel; nothing bought; no error log | the toast overlaps the 서두름 and 자력 rows and is very small | captures/mvloaop21e0bc6-1792803152677.png, records/loops/update-1792799704503/play-1-1.md:28, captures/mvlob9mo8cdb5c-1792802536277.png, records/loops/update-1792799704503/play-1-4.md:18, mvloa1tsa32ef5-1792802793036-video/frame-00007.png | play | open |
| upgrade-cost-curve-steep | minor | data | scene/lobby/lobby | tap_anchor upgrade_buy [upgrade_vitality] → The buy worked. 생명력 went to Lv 1/5 and its first pip changed colour. Gold went 54 → 14, and the next cost rose to 100 (the guide's 40 → 100 jump is steep). The toast `생명력 강화 완료!` showed at mid-screen, a thin dark bar across the panel | the purchase feedback is immediate; the jump from 40 to 100 for level 2 is large | captures/mvloavi1854f73-1792803376086.png, records/loops/update-1792799704503/play-1-2.md:31, captures/mvlob9mo8cdb5c-1792802536277.png, records/loops/update-1792799704503/play-1-4.md:19 | play | open |
| levelup-offer-repeats | minor | data | run | step to 0:18 → HP 78/100, Lv 3 popup; 2 of 3 cards were new picks, the same `분노의 불씨` card was offered at every popup | the same offer repeats, little variety | captures/mvloaop21e0bc6-1792802697908.png, records/loops/update-1792799704503/play-1-1.md:19 | play | open |
| shrine-buy-feedback-weak | minor | client content | shrine | tap_anchor upgrade_buy [upgrade_vitality], then [upgrade_might] → Both buys worked: gold 147 → 57, 생명력 and 힘 went to Lv 1/5, and the first pip turned tan | Buying feels immediate; the pip change is the only sign that something was bought, there was no other visible reaction | captures/mvlob9mo8cdb5c-1792802533178.png, records/loops/update-1792799704503/play-1-4.md:17 | play | open |
| camp-layout-shift | minor | client content | camp | tap_anchor upgrade_close → Back at the camp, gold 57, the `6` badge and the hint line are gone, the shrine button sits lower (y≈695, was ≈640) and the start button stayed in place | Badge gone because nothing is affordable matches the guide. The shrine button shifts down when the hint line disappears | captures/mvlob9mo8cdb5c-1792802544389.png, records/loops/update-1792799704503/play-1-4.md:20 | play | open |
| meta-upgrade-hint-missing | minor | client content | run | tap_anchor lobby_play → Run began after about 1.5 s of loading. At 0:05: health 115/115 (100 + 15 from the vitality upgrade), the plate `등불 제단의 가호` lists `피해 +5%`, `최대 체력 +15`, `줍는 범위 +20%`, the move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom, enemies (ghouls, bats) are already on screen around the player | The plate matches the three bought upgrades, including the one bought earlier (자력). The text `등불 제단의 가호 가 함께합니다` from the guide was not seen in the captures taken at about 1.5 s and 5 s | captures/mvlob9mo8cdb5c-1792802551797.png, records/loops/update-1792799704503/play-1-4.md:21 | play | open |
| gem-drawn-over-hud | minor | client content | scene/run/run | key_down D, step 200 x50 → At 0:10 the player had walked right. Kills 4, gold 2, a blue gem was nearby, a floating damage number `12` showed, and zombies and a bat approached from the screen edges. One blue gem icon draws inside the top-left HUD panel | the first 10 seconds show hits and a kill count right away; the gem inside the panel is a small layering oddity | captures/mvloavi1854f73-1792802581019.png, records/loops/update-1792799704503/play-1-2.md:20 | play | open |
| play-guide-upgrade-max-mismatch | minor | design | shrine | tap_anchor lobby_upgrades → shrine panel with six rows; `힘` and `생명력` are `Lv 0/5`, the other four `Lv 0/3`; pips are placeholder squares with tiny text; `TITLE_RIBBON` plate behind the heading | guide says `Lv 1/3` format; pips are not readable | captures/mvloaop21e0bc6-1792803152677.png, records/loops/update-1792799704503/play-1-1.md:27, captures/mvlob2pjfd7137-1792803709230.png, records/loops/update-1792799704503/play-1-3.md:28 | play | open |
| lobby-fps-below-target | minor | client content | scene/lobby/lobby | fps 5 percentile 54 is below targetFps 60 (4 samples) | the camp must hold targetFps; the 5th percentile is 54 | records/loops/update-1792799704503/check-1.json#performance, records/loops/update-1792799704503/evidence/check-1/performance-macos/samples.json | check | open |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 99 | 0..100 | in |
| no_response_permille | 0 | 0..150 | in |
| scene_load_ms | 517 | 0..3000 | in |
| restart_delay_ms | none | 2000..60000 | unknown |
| feedback_per_input | 27 | 1..1000 | in |
| first_reward_ms | 41035 | 5000..60000 | in |
| reward_interval_ms | 9750 | 8000..45000 | in |
| goal_interval_ms | 122831 | 60000..960000 | in |

## load

| platform | hostLoad |
|---|---|
| macos | {"cpuMaxPercent":76.8,"memoryMaxPercent":99.9,"instancesMax":3} |
