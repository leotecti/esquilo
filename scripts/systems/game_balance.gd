extends Resource
## Perfil único de balanceamento. E16 mantém níveis de dificuldade adiados.

const PLAYER_MAX_HEALTH := 3
const INITIAL_LIVES := 3
const MAX_LIVES := 99
const NUTS_PER_LIFE := 100

const TICO_MOVE_SPEED := 300.0
const TICO_JUMP_VELOCITY := -560.0
const PIPO_JUMP_VELOCITY := -500.0
const DAMAGE_INVULNERABILITY := 1.5
const GLIDE_DURATION := 2.0

const SLUG_SPEED := 45.0
const BEETLE_SPEED := 72.0
const BEETLE_ALERT_SPEED := 125.0
const COMMON_ENEMY_HITS := 1

const BOSS_HEALTH := 3
const BOSS_WARNING := [1.25,1.10,1.0]
const BOSS_ATTACK := [0.45,0.55,0.65]
const BOSS_TIRED := [4.0,3.8,3.6]
const BOSS_WAITING := [1.4,1.15,0.95]
const BOSS_REACH := [220.0,270.0,320.0]
const REGION_BOSS_REACH := [[260.0,320.0,380.0],[180.0,230.0,280.0],[160.0,180.0,200.0]]

const FIRST_LEVEL_TARGET_SECONDS := Vector2i(300,480)
const FIRST_LEVEL_CHECKPOINT_FRACTION := Vector2(0.55,0.68)
const FIRST_LEVEL_MIN_HEARTS := 7
const FIRST_LEVEL_MIN_FOODS := 30

const VILLAGE_FOOD_THRESHOLDS := [20,75]

static func boss_value(values: Array, hit_points: int) -> float:
	return float(values[clampi(BOSS_HEALTH-hit_points,0,values.size()-1)])
