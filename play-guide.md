## goal

The player walks the night field and survives the growing horde until dawn at 15:00 of run time. Weapons attack on their own; the player moves, collects the blue XP gems that defeated enemies drop, and picks one card at each level-up. A run ends when health reaches 0 or at dawn. The gold of each run buys permanent upgrades at the lantern shrine of the camp.

## controls

- While `W` `A` `S` `D` or the arrow keys (key names `W`, `A`, `S`, `D`, `Up`, `Left`, `Down`, `Right`) are held: the player walks up, left, down, right on the screen. Two keys together walk diagonally. Releasing all keys stops the player
- gamepad: D-pad or left stick works the same as above
- There is no attack input. The weapons fire on their own at nearby enemies
- `P` (key name `P`) or gamepad `Start`, and `Esc` (key name `Escape`) or gamepad `B`: open the pause popup during a run
- On the level-up popup: click a card, or press `1` `2` `3` (key names `1`, `2`, `3`) for the first, second, third card. Gamepad `X` `Y` `RB`, or move the focus and press `A`
- Buttons on screen are pressed by click (tap)
- Walking near a blue gem pulls it in; the XP bar at the top fills. A steaming bowl (soup) heals; a chest dropped by the bone knight opens a pick of 3 cards

## game flow

1. Terms consent popup (new user only): `모두 동의합니다` (anchor `terms_agree_all`) turns on both consent checkboxes, then confirm (anchor `terms_confirm`)
2. Camp (lobby): gold at the top right, record, and three buttons: `원정 시작` (Start run, anchor `lobby_play`, first focus), `등불 제단` (Lantern shrine, anchor `lobby_upgrades`), `설정` (Options, anchor `lobby_options`)
3. Lantern shrine panel: six upgrade rows with level, effect and the gold cost of the next level. The buy button of a row is anchor `upgrade_buy` with the upgrade ID name as key (`[upgrade_might]`, `[upgrade_vitality]`, `[upgrade_haste]`, `[upgrade_magnet]`, `[upgrade_swiftness]`, `[upgrade_greed]`). `닫기` (Close, anchor `upgrade_close`) goes back to the camp. A row without enough gold shows `금화가 부족해요` (Not enough gold) and its press does not buy
4. Run: `원정 준비 중` (Getting the run ready) shows briefly, then the run timer starts at 0:00. The move hint shows at the bottom until the player first moves. Enemies come from outside the screen
5. Level-up popup: three cards (anchor `levelup_choice`, key = the weapon or passive ID name of the card, e.g. `[weapon_spinning_blade]`, `[passive_might]`; the soup card has no key). The run is held until a card is picked
6. When health reaches 0, the run ends after about 1.6 seconds and the result panel opens: survived time, kills, level, gold earned. `다시 출발` (Run again, anchor `result_again`, first focus) starts a new run; `야영지로` (To camp, anchor `result_lobby`) goes to the camp
7. At 15:00 dawn breaks, every enemy vanishes, and the result panel opens with `새벽이 밝았다!` (Dawn has broken!)
8. Pause popup: `계속하기` (Continue, anchor `pause_resume`) continues; `원정 포기` (Give up, anchor `pause_give_up`) ends the run as a fall, and the gold of the run so far is still granted
9. An instance started with a save fixture opens on a resumed run with the pause popup open. Press `계속하기` (anchor `pause_resume`) to continue from that moment

## failure

- Contact with an enemy takes health (the red bar at the top left, `현재/최대`). After a hit the player cannot be hit again for 0.4 seconds
- Fall: health 0 ends the run; the result panel opens after about 1.6 seconds. Restart: `다시 출발` (anchor `result_again`) starts a new run, or `야영지로` then `원정 시작`

## input lock window

- boot and title: input is not accepted until login finishes (about 1000ms~3000ms)
- scene change (camp ↔ run): input is not accepted during the loading screen (about 300ms~2000ms)
- run start: nothing moves until the server answers (about 100ms~500ms)
- level-up popup: while it is open, game time and the run stop; only the cards take input
- pause popup: while it is open, game time and the run stop. In step mode during this time `ogw step` does not advance the run. Close it with `tap_anchor pause_resume`
- run end: from the fall until the result panel, about 1600ms plus the save response; movement does nothing
- move keys in step mode: the ms of `ogw input <id> key D <ms>` is real time and game time does not pass, so the player does not move. Move with `key_down D` → `ogw step <id> <ms>` → `key_up D`

## fastest start path

1. (new user) terms popup `tap_anchor terms_agree_all` → `tap_anchor terms_confirm`
2. Camp: `tap_anchor lobby_play`
3. About 300ms~2000ms of loading, then the run starts at 0:00

## play mode

| scene | mode | step ms |
|---|---|---|
| `scene/title/title` | `free` | |
| `scene/lobby/lobby` | `free` | |
| `scene/run/run` | `step` | 200 |
