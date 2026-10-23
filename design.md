## overview

- genre: horde survival action (survivors-like), single player
- one-line pitch: a lone lantern bearer walks an endless night field in isometric 3D while weapons fire on their own, gathers XP gems to build a kit of weapons and passives, and survives the growing horde until dawn at 15:00
- target platform: macOS (game settings `buildPlatforms`). Keyboard and gamepad
- screen orientation: landscape
- base resolution: 1920x1080. The run is a 3D field seen by an orthographic isometric camera (`[camera_size]` m of view height); the UI is drawn over it

## core loop

1. Camp (lobby): see the gold and the record; spend gold at the lantern shrine on permanent upgrades; press `원정 시작` (Start run)
2. Run: move; weapons attack the nearest or surrounding enemies on their own; defeated enemies drop XP gems; walking near a gem pulls it in
3. Level-up: when the XP bar fills, the run holds and a pick of 3 cards opens (a new weapon, a higher level of an owned weapon, a passive). The pick applies at once and the run continues
4. Each minute a new wave row raises the spawn rate, the enemy mix and their health; at 4:00, 8:00 and 12:00 a bone knight arrives and drops a chest that opens another pick of 3
5. The run ends when health reaches 0 (a fall) or at `[run_duration]` (dawn, the win). The server grants the run gold and counts the run; the result panel shows time, kills, level and gold
6. `다시 출발` (Run again) starts the next run at once; `야영지로` (To camp) goes to the camp to spend the gold

- Target duration of one level-up cycle (pick to pick): 10000ms~45000ms
- Target duration of one run: 90000ms~900000ms (a first fall within 1~4 minutes, a full run 15 minutes)

## controls

| input | action | result |
|---|---|---|
| `W` `A` `S` `D`, arrow keys, gamepad D-pad, left stick | `move_up`, `move_left`, `move_down`, `move_right` | While held, the player walks in that screen direction (up on screen is away from the camera on the ground). Two keys together walk diagonally |
| `P`, gamepad `Start` | `pause` | During a run, opens the pause popup |
| `Esc`, gamepad `B` | `back` | During a run, opens the pause popup. In a popup or panel, its back behavior |
| `1` `2` `3`, gamepad `X` `Y` `RB` | `menu_pick_1` ~ `menu_pick_3` | On the level-up popup, picks that card |
| mouse click, `Enter`/`Space` (focus), gamepad `A` (focus) | UI button | Buttons and cards on every screen |

- There is no attack input. Weapons fire on their own
- Per-platform differences: none (macOS is the only target)

## screens

| scene | contents | next |
|---|---|---|
| `scene/title/title` | Game name and tagline over the night graveyard backdrop during boot. Terms popup `prefab/common/terms_popup` for a new user | After login, `scene/run/run` when a run the app left can resume (`CommonRunSave`), otherwise `scene/lobby/lobby` |
| `scene/lobby/lobby` | Root panel `prefab/lobby/lobby_panel`: game name, gold, record, `원정 시작` (start run, first focus, breathing), `등불 제단` (lantern shrine) with a line when the gold covers an upgrade, `설정` (options). Shrine panel `prefab/lobby/upgrade_panel`. Options panel `prefab/lobby/option_panel` | Start run → `scene/run/run` |
| `scene/run/run` | The 3D field, the player with the lantern light, the horde, projectiles, gems, chests, soups and props. Root panel `prefab/run/hud_panel`: health bar and numbers, XP bar, level, timer, kills, run gold so far, weapon and passive icons with levels, the move hint (until the first move), the start status and warning banners. Level-up popup `prefab/run/levelup_popup`. Pause popup `prefab/run/pause_popup`. Result panel `prefab/run/result_panel` | Result `야영지로` → `scene/lobby/lobby`; result `다시 출발` → a new `scene/run/run` |

- Terms popup: the `모두 동의합니다` (I agree to all) checkbox turns both consent checkboxes on or off together; confirm is disabled until both are on, and the hint line above it says so
- Camp: pressing start twice changes the scene once. The back input on the root panel opens the quit confirmation; on the shrine and options panels it closes the panel
- Shrine: a buy press is checked before it is sent (the step is the next level, it is not bought yet, the gold covers it). A refused press plays the refuse sound and shows a toast with the reason; a row the gold does not cover shows its cost in blood red and the `금화가 부족해요` (not enough gold) line. A press while a purchase waits for the server is ignored. On success: coin sound, `<name> 강화 완료!` toast, the row swells with a gold glow. A purchase whose reward would be discarded or mailed asks first with a system popup
- Run start: until the server answers `StartPlaySession`, the HUD shows `원정 준비 중` (Getting the run ready) and nothing moves. On failure, core shows an error and the scene returns to the camp
- During a run: the back input and `pause` open the pause popup (`계속하기` continue, `원정 포기` give up). The HUD receives `pause` with `InputCore.is_just_pressed`, so a press in a frame where the world is stopped is not lost. While the pause or level-up popup is open, game time (`TimeCore.set_paused`), the world and the pooled effects stop. The pause popup does not open during a pick, the fall wait or the result
- Level-up popup: the back input does nothing; the run stays held until a card is picked. Pending picks (several level-ups at once, a chest) open one after another
- Run end: a fall plays the fall sound and shake; after `[run_end_delay]` the result is sent with `FinishPlaySession`. On success the result panel opens with the gold of the `ItemChange` of that response. When the play session expired or is unknown to the server, the gold line says `이번 원정은 기록하지 못했어요` (This run was not recorded) without a core error popup; other rejections keep the core error handling and show the same line
- Result panel: `다시 출발` has the first focus. Either button works once; a second press is ignored. The back input goes to the camp
- Resume: the run state is saved every `[run_save_interval]` of run time, after each pick and when the scene exits. A run the app left resumes on the next start with the pause popup open, as long as its play session can still finish (`play_session_mode.max_duration`)

## systems

### field and movement

- The simulation (`client/features/run/run_world.gd`) advances in fixed ticks of `[run_tick]` of game time with real-number positions in meters on the ground plane. It is not a deterministic simulation of `client-content`: the server does not recalculate it
- Player: speed `[player_speed]` × (1000 + swiftness bonus) ÷ 1000, body radius `[player_radius]`, health `[player_health]` + vitality bonus. A contact hit takes the enemy's `enemy.damage`, then the player is invulnerable for `[hurt_invuln]` and that enemy cannot hit again for `[contact_interval]`
- Camera: orthographic, view height `[camera_size]` m, following the player with smoothing `[camera_smooth]`

### enemies and waves

- `wave` rows by `order`, one per minute from `wave.start`. Every `wave.spawn_interval`, `wave.spawn_count` enemies spawn on a ring of `[spawn_radius]` around the player, picked by `wave.enemies` weights, while the live count is below `wave.max_alive`. Health = `enemy.health` × `wave.health_permille` ÷ 1000
- `wave.elite` arrives once at the wave start with the warning banner; an elite (`enemy.elite`) drops a chest
- Enemies walk to the player at `enemy.speed`, push apart by `[separation]`, take knockback reduced by `enemy.knockback_resist`; one farther than `[despawn_radius]` moves back onto the ring ahead of the player
- A defeated enemy drops a gem of `enemy.xp`; a non-elite drops a soup with `[heal_drop_permille]` chance (heals `[heal_amount]`)

### weapons and passives

- 5 weapons (`weapon`, `weapon_level` by level 1~5), up to `[weapon_slots]` owned. Start weapon: reserved ID `[start_weapon]` → `[weapon_lantern_bolt]`. Damage = `weapon_level.damage` × (1000 + might bonus) ÷ 1000. Cooldown = `weapon_level.cooldown` × (1000 − haste bonus) ÷ 1000, the cut at most 1000 − `[min_cooldown_permille]`
  - Bolt: `count` bolts at the nearest enemies within `[bolt_range]`, speed `speed`, radius `area`, `pierce` hits, life `lifetime`
  - Orbit: `count` scythes circle at radius `area`, `speed` rad/s; each enemy is hit at most once per `cooldown`, hit radius `[blade_radius]`
  - Aura: enemies within radius `area` take damage once per `cooldown` and are pushed `speed` m
  - Axe: `count` axes in the move direction spread by `[axe_spread]`, speed `speed`, radius `area`, `pierce` hits, life `lifetime`
  - Lightning: `count` strikes on random enemies within `[lightning_range]`, each hitting every enemy within `area`
- 5 passives (`passive`), up to `[passive_slots]` owned, level 1~5; `passive.per_level` × level of `passive.stat`
- Bonuses of the same `RunStat` from passives and the loadout upgrades add up

### XP and picks

- XP from level L to L+1 = `[xp_base]` + (L − 1) × `[xp_step]`. A gem within the pickup radius (`[pickup_radius]` × (1000 + magnet bonus) ÷ 1000) moves to the player at `[magnet_speed]`; it is taken within `[player_radius]` + `[gem_reach]`
- A level-up or an opened chest holds the run for a pick of `[levelup_choices]` (chest `[chest_choices]`) different cards from: owned weapons and passives below level 5, new weapons and passives while a slot is free. When none is left, the card is the soup (heals `[levelup_heal]`)

### run and record

- A run is one play session of `play-session`. The mode is reserved ID `[run_mode]` → `[mode_run]` of `play_session_mode`, `level_id` 0 (any other value is `GAME_ERROR_LEVEL_NOT_FOUND`). There is no choice before the run and no continue (`max_continue_count` 0)
- `prepare_play_session` puts in `PlaySessionLoadout` a simulation seed (ctx random) and the level of each upgrade the user has (item balances), in `upgrade` table order
- Result `PlaySessionResult`: `survived_ms`, `kills`, `level`, `dawn`. Upper bounds: `survived_ms` ≤ `game_setting.run_duration` and ≤ play session time + `game_setting.run_time_slack`; `kills` ≤ `survived_ms` × `game_setting.max_kills_per_minute` ÷ 60000; `level` ≤ `game_setting.max_level`; `dawn` exactly when `survived_ms` is `[run_duration]`
- `verify_play_session` checks those bounds. It does not recalculate the result. There is no ranking board that takes a result value as its score
- `apply_play_session` grants gold of shared formula `run.gold_reward` and counts the run in `RunRecordUserState` (runs, dawns, best survived time, best kills, total kills)
- shared formula `run.gold_reward`: gold = (⌊`survived_ms` ÷ `[gold_interval]`⌋ × `[gold_per_interval]` + ⌊`kills` × `[gold_per_kill_permille]` ÷ 1000⌋ + (`[dawn_bonus]` at dawn)) × (1000 + greed bonus) ÷ 1000, rounded down. The greed bonus is the `Greed` upgrade levels of the loadout × `upgrade.per_level`. The client shows the run gold so far on the HUD with the same formula; the result panel shows the gold the server granted
- The kill count and the level only bound the gold; a run's gold uses `kills` as a formula input that `verify_play_session` bounds but does not recalculate (see assumption in `records/loops/create-1792781138827/assumptions.md`)

### lantern shrine (permanent upgrades)

- 6 upgrades: items `[upgrade_might]`, `[upgrade_vitality]`, `[upgrade_haste]`, `[upgrade_magnet]`, `[upgrade_swiftness]`, `[upgrade_greed]` (`Goods`, `max_amount` = top level, overflow `Reject`), with the effect in extension table `upgrade` (`stat`, `per_level`)
- Each level is a `shop_product` (`cost` gold, `reward` 1 of the upgrade item, `max_quantity` 1, `limit_count` 1) with extension table `upgrade_step` (`upgrade`, `level`). `validate_shop_purchase` lets only the next step be bought (`GAME_ERROR_UPGRADE_ORDER`); the client checks the same before sending

## progression

- Within a run: levels and picks build the kit; the waves raise the pressure each minute; dawn at 15:00
- Between runs: run gold buys shrine levels in any order, cheapest first steps 30~50 gold, so a typical first run (1~3 minutes) buys one
- Tutorial steps: none. The HUD shows the move hint (`{action:move_up}…로 움직이세요`) until the first move of the first run on screen; level-up cards explain themselves

## economy

| item | sources | sinks |
|---|---|---|
| `[item_gold]` (Currency, max 9,999,999, overflow `Discard`) | `apply_play_session` of each finished run (`run.gold_reward`) | shrine steps (`shop_product.cost`) |
| upgrade items (6, Goods) | shrine steps, 1 per step | none |

- Purchase limits: each step once (`limit_count` 1, no reset), only in level order
- Product kinds: in-game shop products only. No store payment, ads or subscriptions

## new user

- Initial state: no item balances (0 gold, every upgrade at level 0) and no `RunRecordUserState`. No server request creates an initial state
- First run: after the terms popup (`모두 동의합니다`, confirm) the camp opens; the record line says `첫 원정을 떠나 새벽까지 버텨 보세요` (Try your first run and last until dawn); one press of the focused `원정 시작` starts the run

## feel targets

| metric | min | max | data |
|---|---|---|---|
| `input_latency_ms` | 0 | 100 | |
| `no_response_permille` | 0 | 150 | |
| `scene_load_ms` | 0 | 3000 | |
| `restart_delay_ms` | 2000 | 60000 | `game_setting.run_end_delay` |

## tuning targets

| metric | min | max | data |
|---|---|---|---|
| `first_reward_ms` | 5000 | 30000 | `game_setting.xp_base` |
| `reward_interval_ms` | 8000 | 45000 | `game_setting.xp_step` |
| `goal_interval_ms` | 60000 | 960000 | `wave.health_permille` |

## art direction

- style: stylized low-poly 3D with hand-painted textures; chunky, readable silhouettes for the isometric camera (`records/setup/art-direction.md`)
- hex palette: night `#1B1A2E` (background, panels), moss `#3E5C3A` (ground, cloak), lantern gold `#C9A227` (light, titles, primary buttons, gold), blood red `#8E1F2F` (health bar, hurt flash, warnings), bone `#E8E1D0` (text, skeletons)
- mood: a tense night siege that turns into a power fantasy; the warm lantern light around the player pushes back the dark (a gold omni light on the player, cool moonlight and fog on the field)
- outline: no 3D outline; UI text has a dark outline so it reads over the field
- proportions: player 0.8x1.8x0.8 m; bat 1.0x0.6, ghoul 0.8x1.5, skeleton 0.9x1.7, wraith 0.9x1.8, grave brute 1.6x2.4, bone knight 1.8x2.8 m. Field props stay low (gravestones, rocks, a few lantern posts) so they do not hide the player
- screen density: up to `wave.max_alive` enemies plus gems and effects on the field; the HUD keeps to the top band (health, XP, timer, kills, gold, weapon icons) and one hint line at the bottom
- representative resource keys: `model/hero`, `model/enemy_skeleton`, `model/enemy_bone_knight`, `texture/ground`, `nine_slice/ui/panel_frame`, `nine_slice/ui/card`, `icon/weapon_lantern_bolt`, `background/lobby`, `app_icon/main`, `splash/main`

## audio direction

- mood: dark-fantasy night; drums and low strings in the run that stay under the hit sounds; a quiet campfire tune at the camp
- BGM per scene: camp `bgm/lobby`; run `bgm/run`; title none
- events that play a sound: UI press `sfx/ui_click`; enemy hit `sfx/enemy_hit`; enemy defeated `sfx/enemy_die`; gem `sfx/gem_pickup`; level-up `sfx/level_up`; card pick `sfx/upgrade_pick`; player hit `sfx/player_hurt`; chest `sfx/chest_open`; elite arrival `sfx/elite_roar`; soup `sfx/heal`; dawn `sfx/dawn`; fall `sfx/player_death`; shrine buy `sfx/upgrade_buy`; refused buy `sfx/refuse`; weapon fire `weapon.sound` (`sfx/bolt_fire`, `sfx/blade_hit`, `sfx/aura_pulse`, `sfx/axe_throw`, `sfx/lightning`)

## terms

- words used: `원정` (run), `야영지` (camp), `등불 제단` (lantern shrine), `새벽` (dawn), `금화` (gold), `레벨 업` (level-up), the weapon names (`등불 탄환`, `회전 낫`, `성화 오라`, `투척 도끼`, `낙뢰`), the passive names and the upgrade names
- words not used: Vampire Survivors, `뱀파이어` (vampire), `리퍼` (reaper), `스테이지` (stage), `캐릭터 선택` (character select)
- glossary terms: `아이소 서바이버즈` (Iso Survivors), `등불 제단`, `원정`, `야영지`, `새벽`, `금화`, every weapon, passive and upgrade name, the input prompt names

## core usage

- client hook: none. `ContentBoot.select_first_scene` returns the run scene for a resumable run
- server hooks: `play-session` `prepare_play_session` (`server/hooks/play_session.ts` `prepare_run`), `verify_play_session` (`verify_run`), `apply_play_session` (`apply_run`); `shop` `validate_shop_purchase` (`server/hooks/shop.ts` `validate_upgrade_step`)
