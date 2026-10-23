class_name RunLevelupPopup
extends UIPopup
## Level-up and chest popup of the run: up to three cards to pick one from. A card is picked by click, by the focus
## and confirm, or by its `menu_pick_<n>` action. The run stays held until a card is picked; a back input does nothing.

@export var title_label: Label
@export var subtitle_label: Label
@export var hint_label: Label
@export var cards: Array[RunChoiceCard] = []

var _param: RunLevelupParam = null
var _picked: bool = false


func accepts_param(param: UIParam) -> bool:
	return param is RunLevelupParam


func prepare() -> bool:
	_param = popup_param as RunLevelupParam
	LocalizationCore.bind_text(title_label,
		ReservedString.levelup_chest_title() if _param.chest else ReservedString.levelup_title())
	LocalizationCore.bind_text(subtitle_label, ReservedString.levelup_subtitle())
	LocalizationCore.bind_text(hint_label, ReservedString.levelup_pick_hint())
	EventCore.subscribe(InputPromptChangedEvent, _on_input_prompt_changed)
	for i: int in cards.size():
		var card: RunChoiceCard = cards[i]
		card.visible = i < _param.choices.size()
		if not card.visible:
			continue
		var choice: RunChoice = _param.choices[i]
		card.show_choice(choice, _icon(choice))
		card.click.set_on_click(_on_card.bind(i))
	return true


## The cards of this popup.
func get_choices() -> Array[RunChoice]:
	return _param.choices if _param != null else [] as Array[RunChoice]


func on_opened() -> void:
	for card: RunChoiceCard in cards:
		if card.visible:
			TweenCore.play_preset(ResourceKey.TWEEN__RUN__CARD_IN, scope, card)


func on_back() -> void:
	pass


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


func _on_card(index: int) -> void:
	if _picked or index < 0 or index >= _param.choices.size():
		return
	_picked = true
	var choice: RunChoice = _param.choices[index]
	UICore.close_popup(self, _param.on_pick.bind(choice))


func _on_input_prompt_changed(_event: InputPromptChangedEvent) -> void:
	LocalizationCore.bind_text(hint_label, ReservedString.levelup_pick_hint())


func _icon(choice: RunChoice) -> Texture2D:
	var key: String = ResourceKey.ICON__HEAL_SOUP
	if choice.kind == RunChoice.Kind.WEAPON:
		key = GameData.WeaponTable.get_row(choice.id).icon
	elif choice.kind == RunChoice.Kind.PASSIVE:
		key = GameData.PassiveTable.get_row(choice.id).icon
	if not ResourceCore.is_loaded(key, ResourceCore.BaseKind.TEXTURE_2D):
		return null
	return ResourceCore.get_loaded(key, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
