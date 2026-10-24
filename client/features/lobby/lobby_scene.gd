class_name LobbyScene
extends SceneBase
## Camp (lobby) scene after sign-in. Its root panel holds the gold, the run record, the start, shrine and option
## buttons. Embers rise from the campfire of the backdrop. It plays the camp BGM and receives the pending UserState
## changes when it starts.

@export var backdrop: TextureRect
@export var embers: GPUParticles2D


func on_preload(preload_request: PreloadRequest, _prefill_items: Array[PrefillItem]) -> void:
	preload_request.add_item(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ResourceKey.BGM__LOBBY, ResourceCore.BaseKind.AUDIO_STREAM)
	for key: String in [ResourceKey.ICON__GOLD, ResourceKey.ICON__TIMER, ResourceKey.ICON__KILLS, ResourceKey.ICON__UI_RUNS,
			ResourceKey.ICON__UI_DAWN, ResourceKey.ICON__UI_SHRINE, ResourceKey.ICON__UI_OPTIONS, ResourceKey.ICON__UI_PIP_ON,
			ResourceKey.ICON__UI_PIP_OFF, ResourceKey.IMAGE__LOBBY__HERO, ResourceKey.IMAGE__UI__LOGO_EMBLEM]:
		preload_request.add_item(key, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ReservedSound.upgrade_buy(), ResourceCore.BaseKind.AUDIO_STREAM)
	preload_request.add_item(ReservedSound.upgrade_refuse(), ResourceCore.BaseKind.AUDIO_STREAM)
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		preload_request.add_item(row.icon, ResourceCore.BaseKind.TEXTURE_2D)
	var tween_kind: int = TweenCore.get_preset_kind()
	preload_request.add_item(ResourceKey.TWEEN__LOBBY__UPGRADE_BOUGHT, tween_kind)
	preload_request.add_item(ResourceKey.TWEEN__LOBBY__PLAY_PULSE, tween_kind)
	preload_request.add_item(ResourceKey.TWEEN__LOBBY__PANEL_IN, tween_kind)


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D):
		backdrop.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	embers.emitting = true
	SoundCore.play_bgm(ResourceKey.BGM__LOBBY, scope)
	NetworkCore.resync()
