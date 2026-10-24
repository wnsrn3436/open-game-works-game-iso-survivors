class_name LobbyUpgradePanel
extends UIPanel
## The lantern shrine over the camp: one row per permanent upgrade with its level, effect, the cost of the next level
## and a buy button, and the gold. A buy is checked before it is sent by the rule the server checks: the step is the
## next level, it is not bought yet, and the gold covers it. A refused press plays the refuse sound and says why; a
## press while a purchase waits for the server is ignored. Back closes the panel.

@export var title_label: Label
@export var desc_label: Label
@export var gold_label: Label
@export var gold_icon: TextureRect
@export var close_button: Button
@export var close_click: UIButton
@export var entries: Array[LobbyUpgradeEntry] = []

var _format_args: FormatArgs = FormatArgs.new()
var _buying: bool = false


func prepare(_reason: UICore.PanelOpenReason, _cache: UIPanelCache) -> bool:
	LocalizationCore.bind_text(title_label, ReservedString.upgrade_title())
	desc_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(ReservedString.upgrade_desc()))
	LocalizationCore.bind_text(close_button, ReservedString.upgrade_close())
	close_click.set_on_click(_on_close)
	var gold: Texture2D = _texture(ResourceKey.ICON__GOLD)
	gold_icon.texture = gold
	var pip_on: Texture2D = _texture(ResourceKey.ICON__UI_PIP_ON)
	var pip_off: Texture2D = _texture(ResourceKey.ICON__UI_PIP_OFF)
	var rows: Array[GameData.UpgradeRow] = CommonUpgrades.upgrades()
	for i: int in entries.size():
		var entry: LobbyUpgradeEntry = entries[i]
		entry.visible = i < rows.size()
		if entry.visible:
			entry.show_upgrade(rows[i], _texture(rows[i].icon), gold, pip_on, pip_off)
			entry.click.set_on_click(_on_buy.bind(rows[i].id))
	EventCore.subscribe(UserStateChangedEvent, _on_user_state_changed)
	_write()
	return true


func _exit_tree() -> void:
	EventCore.unsubscribe_all(self)


## Whether a purchase waits for the server.
func is_buying() -> bool:
	return _buying


## Buys the next level of `upgrade_id` after the checks; `false` when a check refused it or a purchase waits.
func buy_next(upgrade_id: int) -> bool:
	if _buying:
		return false
	var step: GameData.UpgradeStepRow = CommonUpgrades.next_step(upgrade_id)
	if step.id == 0:
		_refuse(ReservedString.upgrade_maxed())
		return false
	if not CommonUpgrades.can_buy(step):
		_refuse(ReservedString.upgrade_not_enough())
		return false
	var reward: Array[CoreContract.ItemAmount] = GameData.ShopProductTable.get_row(step.id).reward
	for row: ItemAddPreviewRow in UserStateCore.preview_item_add(reward):
		if row.outcome == UserStateCore.ItemAddPreview.DISCARDED or row.outcome == UserStateCore.ItemAddPreview.MAILED:
			_confirm_loss(step.id, upgrade_id)
			return true
	_send(step.id, upgrade_id, false)
	return true


func _on_buy(upgrade_id: int) -> void:
	buy_next(upgrade_id)


func _send(product_id: int, upgrade_id: int, accept_loss: bool) -> void:
	_buying = true
	var request: CoreContract.BuyShopProductRequest = CoreContract.BuyShopProductRequest.new()
	request.product_id = product_id
	request.quantity = 1
	request.accept_loss = accept_loss
	NetworkCore.send(request, _on_bought.bind(upgrade_id), _on_buy_failed.bind(product_id, upgrade_id))


func _on_bought(_response: ContractMessage, upgrade_id: int) -> void:
	_buying = false
	SoundCore.play(ReservedSound.upgrade_buy(), SoundCore.SoundBus.UI, scope)
	_format_args.clear()
	_format_args.set_string("name", LocalizationCore.get_text(GameData.ItemTable.get_row(upgrade_id).name))
	MessageCore.show_toast(ReservedString.upgrade_bought(), _format_args)
	for entry: LobbyUpgradeEntry in entries:
		if entry.upgrade_id == upgrade_id:
			entry.pivot_offset = entry.size * 0.5
			TweenCore.play_preset(ResourceKey.TWEEN__LOBBY__UPGRADE_BOUGHT, scope, entry)
	_write()


func _on_buy_failed(failure: RequestFailure, product_id: int, upgrade_id: int) -> bool:
	_buying = false
	_write()
	if failure.kind == NetworkCore.FailureKind.SERVER_ERROR \
			and failure.error_code == CoreContract.CoreError.CORE_ERROR_SHOP_OVERFLOW_LOSS:
		_confirm_loss(product_id, upgrade_id)
		return true
	return false


func _confirm_loss(product_id: int, upgrade_id: int) -> void:
	var ok: SystemPopupButton = SystemPopupButton.new()
	ok.label = ReservedString.upgrade_buy()
	ok.callback = _send.bind(product_id, upgrade_id, true)
	var cancel: SystemPopupButton = SystemPopupButton.new()
	cancel.label = ReservedString.option_cancel()
	cancel.callback = Callable()
	var param: SystemPopupParam = SystemPopupParam.new()
	param.body = ReservedString.upgrade_overflow_warning()
	param.buttons = [ok, cancel]
	param.back_button = 1
	UICore.open_system_popup(param, Callable())


func _refuse(reason: String) -> void:
	SoundCore.play(ReservedSound.upgrade_refuse(), SoundCore.SoundBus.UI, scope)
	MessageCore.show_toast(reason)


func _on_user_state_changed(_event: UserStateChangedEvent) -> void:
	_write()


func _on_close() -> void:
	UICore.close_panel()


func _write() -> void:
	_format_args.clear()
	_format_args.set_int("gold", CommonUpgrades.gold())
	gold_label.text = LocalizationCore.format(ReservedString.lobby_gold(), _format_args)
	for entry: LobbyUpgradeEntry in entries:
		if entry.visible and entry.upgrade_id != 0:
			entry.refresh()


func _texture(key: String) -> Texture2D:
	if key.is_empty() or not ResourceCore.is_loaded(key, ResourceCore.BaseKind.TEXTURE_2D):
		return null
	return ResourceCore.get_loaded(key, ResourceCore.BaseKind.TEXTURE_2D, scope) as Texture2D
