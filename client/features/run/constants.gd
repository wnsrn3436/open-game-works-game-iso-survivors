class_name RunConstants
extends RefCounted
## Structure values of the run feature: buffer sizes, units, the isometric axes and drawing values. Gameplay values
## are in `game_setting` and the run tables.

## Permille of a whole.
const PERMILLE: int = 1000 # unit conversion, not a tunable value
const PERMILLE_F: float = 1000.0 # unit conversion, not a tunable value
## Milliseconds of one second, to turn speeds per second into moves per tick.
const MS_PER_SECOND_F: float = 1000.0 # unit conversion, not a tunable value
const MS_PER_SECOND: int = 1000 # unit conversion, not a tunable value
## Seconds of a minute and the base of a decimal digit, to write the run timer as m:ss.
const SECONDS_PER_MINUTE: int = 60 # unit conversion, not a tunable value
const DECIMAL_BASE: int = 10 # digit split of the timer text, not a tunable value
## Percent of a whole, to show a rise as percent.
const PERCENT: float = 100.0 # unit conversion, not a tunable value
## Buffer sizes of the simulation. They are sized once; the wave rows keep the live counts below them.
const MAX_ENEMIES: int = 480 # buffer size, above every wave max_alive
const MAX_GEMS: int = 720 # buffer size; past it a new gem adds its XP to an old one
const MAX_PROJECTILES: int = 160 # buffer size, above every weapon count times its lifetime
const MAX_PICKUPS: int = 24 # buffer size of chests and soups on the field
const MAX_WEAPONS: int = 8 # buffer size, at least the weapon table rows
const MAX_PASSIVES: int = 8 # buffer size, at least the passive table rows
## Enemies one projectile remembers having hit, so it does not hit the same enemy twice.
const PROJECTILE_HIT_SLOTS: int = 8 # buffer size, at least the highest weapon pierce
## Event buffers the view reads after the ticks of a frame.
const MAX_HIT_EVENTS: int = 64 # buffer size per frame
const MAX_DEATH_EVENTS: int = 64 # buffer size per frame
const MAX_STRIKE_EVENTS: int = 16 # buffer size per frame
## Spatial grid of enemies around the player: cells per side and the side of one cell in m.
const GRID_CELLS: int = 40 # buffer size; covers more than the despawn radius
const GRID_CELL_SIZE: float = 2.0 # grid geometry, not a gameplay value
## Most simulation ticks one frame runs, so a long frame does not freeze the game.
const MAX_TICKS_PER_FRAME: int = 8 # frame budget, not a gameplay value
## Ticks one frame of the DEV fast forward runs.
const FAST_FORWARD_TICKS_PER_FRAME: int = 240 # DEV frame budget; no game rule reads it
## Screen directions on the ground of the isometric camera: right and up on screen, and the camera offset from the
## followed player along the view axis.
const ISO_RIGHT: Vector3 = Vector3(0.70710678, 0.0, -0.70710678) # isometric projection axis, not a tunable value
const ISO_UP: Vector3 = Vector3(-0.70710678, 0.0, -0.70710678) # isometric projection axis, not a tunable value
const CAMERA_OFFSET: Vector3 = Vector3(30.0, 30.0, 30.0) # isometric projection axis, not a tunable value
## Field props: chunk side in m, props per chunk, chunks drawn around the player per side, and the hash primes.
const PROP_CHUNK: float = 12.0 # layout of the drawing only; no rule reads it
const PROPS_PER_CHUNK: int = 2 # layout of the drawing only; no rule reads it
## Hash slots of each prop kind out of the total: gravestone, rock, the rest lantern post.
const PROP_WEIGHT_TOTAL: int = 10 # layout of the drawing only; no rule reads it
const PROP_WEIGHT_GRAVE: int = 5 # layout of the drawing only; no rule reads it
const PROP_WEIGHT_ROCK: int = 4 # layout of the drawing only; no rule reads it
const PROP_CHUNKS: int = 7 # layout of the drawing only; no rule reads it
## Chunk value before the first prop placement: no real chunk.
const NO_CHUNK: Vector2i = Vector2i(-1000000, -1000000) # sentinel, not a gameplay value
const PROP_HASH_X: int = 73856093 # hash constant of the prop layout, not a tunable value
const PROP_HASH_Z: int = 19349663 # hash constant of the prop layout, not a tunable value
const PROP_HASH_MOD: int = 1000003 # hash constant of the prop layout, not a tunable value
const PROP_HASH_SHIFT: int = 13 # hash constant of the prop layout, not a tunable value
## Most damage numbers drawn at once, started in one frame, and hits of a frame tried for a number (biggest first).
const MAX_DAMAGE_NUMBERS: int = 18 # drawing budget; no rule reads it
const DAMAGE_NUMBERS_PER_FRAME: int = 3 # drawing budget; no rule reads it
const NUMBER_TRIES_PER_FRAME: int = 8 # drawing budget; no rule reads it
## Most hit effects started in one frame.
const HIT_EFFECTS_PER_FRAME: int = 6 # drawing budget; no rule reads it
## Most death effects started in one frame.
const DEATH_EFFECTS_PER_FRAME: int = 6 # drawing budget; no rule reads it
## Sounds of one kind started at most per frame.
const SOUNDS_PER_FRAME: int = 1 # drawing budget; no rule reads it
## Enemy tint while its hit flash lasts, the normal tint, and the elite tint.
const ENEMY_FLASH_COLOR: Color = Color(1.0, 0.45, 0.4, 1.0) # color of the drawing only; no rule reads it
const ENEMY_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0) # color of the drawing only; no rule reads it
## Tint of the field props: darker than the horde, so the enemies stand out from the gravestones and rocks.
const PROP_COLOR: Color = Color(0.42, 0.42, 0.52, 1.0) # color of the drawing only; no rule reads it
## Glow over the player model while it is invulnerable after a hit: blood red #8E1F2F, half see-through.
const PLAYER_HURT_COLOR: Color = Color(0.557, 0.122, 0.184, 0.6) # color of the drawing only; no rule reads it
## HUD health text while health is low: a lighter blood red that reads over the dark plate, and the normal bone.
const LOW_HEALTH_TEXT_COLOR: Color = Color(0.95, 0.36, 0.4, 1.0) # color of the drawing only; no rule reads it
const HEALTH_TEXT_COLOR: Color = Color(0.91, 0.882, 0.816, 1.0) # color of the drawing only; no rule reads it
## Height of drawn things over the ground in m: projectiles, gems, the damage numbers.
const PROJECTILE_HEIGHT: float = 0.8 # layout of the drawing only; no rule reads it
const GEM_HEIGHT: float = 0.25 # layout of the drawing only; no rule reads it
const NUMBER_HEIGHT: float = 1.6 # layout of the drawing only; no rule reads it
## Least distance in m on the ground between two living damage numbers, so their text does not overlap.
const NUMBER_GAP: float = 1.8 # layout of the drawing only; no rule reads it
## Scale of a drawn lantern bolt: wider and much longer along its flight, a streak of light.
const BOLT_STRETCH: Vector3 = Vector3(1.6, 1.6, 2.8) # look of the drawing only; no rule reads it
## Glow of the gem model under the bloom: dimmer, so the gems keep their blue instead of washing out to white.
const GEM_EMISSION_SCALE: float = 0.45 # look of the drawing only; no rule reads it
## Gap in px between the player's feet on screen and the top of the player health bar.
const PLAYER_BAR_GAP: float = 14.0 # layout of the drawing only; no rule reads it
## Enemy bob while walking: height in m and the speed of the bob in radians per m walked.
const ENEMY_BOB: float = 0.08 # look of the drawing only; no rule reads it
const ENEMY_BOB_RATE: float = 4.0 # look of the drawing only; no rule reads it
## Gem size: the XP value counted at most, and the size added per XP point.
const GEM_SIZE_CAP: int = 6 # look of the drawing only; no rule reads it
const GEM_SIZE_STEP: float = 0.12 # look of the drawing only; no rule reads it
## Spin of gems and axes in radians per second.
const GEM_SPIN: float = 2.5 # look of the drawing only; no rule reads it
const AXE_SPIN: float = 14.0 # look of the drawing only; no rule reads it
## HUD bar colors: health and XP. The bars also differ by place and by their labels.
const HEALTH_COLOR: Color = Color(0.557, 0.122, 0.184, 1.0) # color of the drawing only; no rule reads it
const XP_COLOR: Color = Color(0.42, 0.72, 0.98, 1.0) # color of the drawing only; no rule reads it
## Night ambient light and the lantern light of the player.
const AMBIENT_COLOR: Color = Color(0.32, 0.3, 0.5, 1.0) # color of the drawing only; no rule reads it
## Values of the result panel the DEV screen command opens for the UI check.
const PREVIEW_SURVIVED_MS: int = 421000 # DEV preview text only; no game rule reads it
const PREVIEW_KILLS: int = 1234 # DEV preview text only; no game rule reads it
const PREVIEW_LEVEL: int = 23 # DEV preview text only; no game rule reads it
const PREVIEW_GOLD: int = 187 # DEV preview text only; no game rule reads it
## Frames a DEV screen command waits for the run to start or a popup to open.
const DEV_WAIT_FRAMES: int = 600 # DEV command time limit; no game rule reads it
## The DEV bot keeps away from enemies inside this distance and walks to gems inside the second one, in m.
const BOT_DANGER_RADIUS: float = 4.0 # DEV bot play style; no game rule reads it
const BOT_GEM_RADIUS: float = 14.0 # DEV bot play style; no game rule reads it
## How much more the DEV bot weighs keeping away from enemies than walking to a gem.
const BOT_AWAY_WEIGHT: float = 1.5 # DEV bot play style; no game rule reads it
## The DEV bot holds a move key when the wanted direction leans this far along that screen axis.
const BOT_KEY_THRESHOLD: float = 0.38 # DEV bot play style; no game rule reads it
## Format version of the saved run state; a saved state of another version starts a new run.
const SAVE_VERSION: int = 1 # save format version, not a tunable value
