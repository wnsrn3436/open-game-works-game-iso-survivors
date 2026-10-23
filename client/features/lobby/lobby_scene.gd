class_name LobbyScene
extends SceneBase
## Camp (lobby) scene after sign-in. Its root panel holds the gold, the run record, the start, shrine and option
## buttons. It plays the camp BGM and receives the pending UserState changes when it starts.

@export var backdrop: TextureRect


func on_preload(preload_request: PreloadRequest, _prefill_items: Array[PrefillItem]) -> void:
	preload_request.add_item(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ResourceKey.BGM__LOBBY, ResourceCore.BaseKind.AUDIO_STREAM)
	preload_request.add_item(ResourceKey.ICON__GOLD, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ReservedSound.upgrade_buy(), ResourceCore.BaseKind.AUDIO_STREAM)
	preload_request.add_item(ReservedSound.upgrade_refuse(), ResourceCore.BaseKind.AUDIO_STREAM)
	for row: GameData.UpgradeRow in GameData.UpgradeTable.all_rows():
		preload_request.add_item(row.icon, ResourceCore.BaseKind.TEXTURE_2D)
	var tween_kind: int = TweenCore.get_preset_kind()
	preload_request.add_item(ResourceKey.TWEEN__LOBBY__UPGRADE_BOUGHT, tween_kind)
	preload_request.add_item(ResourceKey.TWEEN__LOBBY__PLAY_PULSE, tween_kind)


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D):
		backdrop.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__LOBBY, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	SoundCore.play_bgm(ResourceKey.BGM__LOBBY, scope)
	NetworkCore.resync()
