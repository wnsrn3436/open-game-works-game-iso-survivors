## coverage

- unknown: playing a run past about 0:05 (movement, auto weapon fire, level-up popup, soup, chest, fall, result panel, dawn). I only started the run and looked at its first seconds
- unknown: failing and playing again (`result_again`, `result_lobby`), pause popup
- unknown: terms popup and title (the instance started at the camp moment)
- unknown: the buy buttons of `upgrade_swiftness`, `upgrade_greed`, `upgrade_magnet` (not pressed)
- play ms: 77301
- scenes: scene/title/title, scene/lobby/lobby, scene/run/run
- fail: 0
- restart: 0

## observations

0 | camp | none (start state) | Camp opens with gold 147, record card (best survival 2분 30초, most kills 649, runs 1회, dawns 0회), red badge `6` on the shrine, hint line `금화로 살 수 있는 강화가 있어요` | The returning-player state is readable and the badge matches the six rows that 147 gold can each pay for | none | captures/mvlob9mo8cdb5c-1792802515244.png
0 | camp | none | Placeholder art shows on screen: a magenta slab with the word `HERO` in place of the hero, `LOGO_EMBLEM`/`TITLE_RIBBON` text over the game name and the record title, `UI_RUNS`/`UI_DAWN`/`UI_SHRINE` text tiles as icons, a blurred white banner at the top, a tiny `6` badge drawn as a grey box with text beneath it | The hero by the fire is not recognisable, the title band is unreadable (Korean text drawn over English placeholder text) | major | captures/mvlob9mo8cdb5c-1792802515244.png
~7000 | shrine | tap_anchor lobby_upgrades | Panel opens at once with six rows, gold 147, close button. Rows show Lv, pips, effect and cost (힘 Lv 0/5 50, 생명력 Lv 0/5 40, 서두름 Lv 0/3 100, 자력 Lv 1/3 90, 신속 Lv 0/3 60, 탐욕 Lv 0/3 80) | Layout is clear and the effects are readable. The panel title `등불 제단` also sits over a `TITLE_RIBBON` placeholder text, and the pips are tiny grey-blue placeholder squares with text | minor | captures/mvlob9mo8cdb5c-1792802522520.png
~15000 | shrine | tap_anchor upgrade_buy [upgrade_vitality], then [upgrade_might] | Both buys worked: gold 147 → 57, 생명력 and 힘 went to Lv 1/5, and the first pip turned tan | Buying feels immediate; the pip change is the only sign that something was bought, there was no other visible reaction | minor | captures/mvlob9mo8cdb5c-1792802533178.png
~21000 | shrine | tap_anchor upgrade_buy [upgrade_haste] with 57 gold | Press did not buy. A faint small `금화가 부족해요` strip appeared mid-screen and every row now shows red `금화가 부족해요` over a dimmed button. This includes 신속, which costs 60 (3 short) | Not buying and the message agree with the guide. The mid-screen strip is very small and low-contrast | minor | captures/mvlob9mo8cdb5c-1792802536277.png
~21000 | shrine | (cost curve) | After one level, 힘 cost went 50 → 120 and 생명력 40 → 100 (about 2.4x per level), while the 147 starting gold covered about three first levels | A second level costs more than a whole earlier run's gold for a player at this stage; the next purchase is out of reach after a first run | minor | captures/mvlob9mo8cdb5c-1792802536277.png
~25000 | camp | tap_anchor upgrade_close | Back at the camp, gold 57, the `6` badge and the hint line are gone, the shrine button sits lower (y≈695, was ≈640) and the start button stayed in place | Badge gone because nothing is affordable matches the guide. The shrine button shifts down when the hint line disappears | minor | captures/mvlob9mo8cdb5c-1792802544389.png
~27000 | run | tap_anchor lobby_play | Run began after about 1.5 s of loading. At 0:05: health 115/115 (100 + 15 from the vitality upgrade), the plate `등불 제단의 가호` lists `피해 +5%`, `최대 체력 +15`, `줍는 범위 +20%`, the move hint `WASD 로 움직이세요. 공격은 자동이에요` shows at the bottom, enemies (ghouls, bats) are already on screen around the player | The plate matches the three bought upgrades, including the one bought earlier (자력). The text `등불 제단의 가호 가 함께합니다` from the guide was not seen in the captures taken at about 1.5 s and 5 s | minor | captures/mvlob9mo8cdb5c-1792802551797.png
~27000 | run | none | The top left box under the health bar holds one weapon icon with `1` and a lot of empty space, the kills and gold counters at the top right read 0 / 0 | Readable. At 0:05 no weapon shot was visible in the capture, so the auto attack is unverified | none | captures/mvlob9mo8cdb5c-1792802551797.png

## reproduce

- Placeholder art at the camp: the instance starts at the camp (save fixture `camp_returning_player`). Capture right away: the hero is a magenta `HERO` slab and the title band is overlaid text. Open the shrine with `tap_anchor lobby_upgrades` to see `TITLE_RIBBON` text over `등불 제단`
