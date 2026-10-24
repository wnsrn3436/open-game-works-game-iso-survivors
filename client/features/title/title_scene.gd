class_name TitleScene
extends SceneBase
## Title scene of the boot: the game name on its gold crest and the tagline over the night graveyard backdrop while the
## game signs in.

@export var title_label: Label
@export var tagline_label: Label
@export var backdrop: TextureRect
@export var emblem: TextureRect


func on_preload(preload_request: PreloadRequest, _prefill_items: Array[PrefillItem]) -> void:
	preload_request.add_item(ResourceKey.BACKGROUND__TITLE, ResourceCore.BaseKind.TEXTURE_2D)
	preload_request.add_item(ResourceKey.IMAGE__UI__LOGO_EMBLEM, ResourceCore.BaseKind.TEXTURE_2D)


func _ready() -> void:
	LocalizationCore.bind_text(title_label, ReservedString.title_name())
	LocalizationCore.bind_text(tagline_label, ReservedString.title_tagline())


func on_start() -> void:
	if ResourceCore.is_loaded(ResourceKey.BACKGROUND__TITLE, ResourceCore.BaseKind.TEXTURE_2D):
		backdrop.texture = ResourceCore.get_loaded(ResourceKey.BACKGROUND__TITLE, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
	if ResourceCore.is_loaded(ResourceKey.IMAGE__UI__LOGO_EMBLEM, ResourceCore.BaseKind.TEXTURE_2D):
		emblem.texture = ResourceCore.get_loaded(ResourceKey.IMAGE__UI__LOGO_EMBLEM, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
