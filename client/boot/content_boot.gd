class_name ContentBoot
extends ContentEntry
## Content entry of the game. The game registers no core hook. The first scene after login is the run scene when a run
## the app left can still resume, otherwise the camp (lobby) of game settings `firstScene`.


func _init() -> void:
	CommonVariantParser.warm()


func content_init() -> bool:
	return true


func content_release() -> void:
	pass


func select_first_scene() -> String:
	if CommonRunSave.is_resumable():
		return ResourceKey.SCENE__RUN__RUN
	return BootstrapCore.get_first_scene()
