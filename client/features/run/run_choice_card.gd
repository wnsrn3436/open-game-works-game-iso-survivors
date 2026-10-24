class_name RunChoiceCard
extends Button
## One card of the level-up popup: the icon, the name, a "new" tag or the level it gives, and what it does. The name
## and the text wrap only between words, so a Korean line does not end with a word cut off.

@export var icon_rect: TextureRect
@export var tag_label: Label
@export var name_label: Label
@export var desc_label: Label
@export var click: UIButton
@export var anchor: UIAnchor

var _format_args: FormatArgs = FormatArgs.new()


## Draws `choice`. `texture` is its icon.
func show_choice(choice: RunChoice, texture: Texture2D) -> void:
	icon_rect.texture = texture
	anchor.set_anchor_key(choice.id)
	match choice.kind:
		RunChoice.Kind.WEAPON:
			var weapon: GameData.WeaponRow = GameData.WeaponTable.get_row(choice.id)
			name_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(weapon.name))
			desc_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(weapon.desc) if choice.level == 1 \
				else RunChoiceCard.weapon_change_text(choice.id, choice.level, _format_args))
		RunChoice.Kind.PASSIVE:
			var passive: GameData.PassiveRow = GameData.PassiveTable.get_row(choice.id)
			name_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(passive.name))
			_format_args.clear()
			_format_args.set_int("value", CommonStatText.shown_value(passive.stat, passive.per_level))
			desc_label.text = CommonWordWrap.keep_words(LocalizationCore.format(passive.desc, _format_args))
		RunChoice.Kind.HEAL:
			name_label.text = CommonWordWrap.keep_words(LocalizationCore.get_text(ReservedString.levelup_heal_name()))
			_format_args.clear()
			_format_args.set_int("amount", GameSetting.levelup_heal())
			var heal: String = LocalizationCore.format(ReservedString.levelup_heal_desc(), _format_args)
			desc_label.text = CommonWordWrap.keep_words(heal)
	if choice.kind == RunChoice.Kind.HEAL or choice.level == 1:
		tag_label.text = LocalizationCore.get_text(ReservedString.levelup_new())
		tag_label.visible = choice.kind != RunChoice.Kind.HEAL
	else:
		_format_args.clear()
		_format_args.set_int("level", choice.level)
		tag_label.text = LocalizationCore.format(ReservedString.levelup_level(), _format_args)
		tag_label.visible = true


## The lines of what weapon `weapon_id` gains from level `to` − 1 to `to`.
static func weapon_change_text(weapon_id: int, to: int, args: FormatArgs) -> String:
	var before: GameData.WeaponLevelRow = RunWorld.weapon_level_row(weapon_id, to - 1)
	var after: GameData.WeaponLevelRow = RunWorld.weapon_level_row(weapon_id, to)
	var lines: PackedStringArray = PackedStringArray()
	RunChoiceCard._add_line(lines, ReservedString.stat_damage_up(), after.damage - before.damage, args)
	RunChoiceCard._add_line(lines, ReservedString.stat_count_up(), after.count - before.count, args)
	RunChoiceCard._add_line(lines, ReservedString.stat_pierce_up(), after.pierce - before.pierce, args)
	RunChoiceCard._add_line(lines, ReservedString.stat_cooldown_down(),
		RunChoiceCard._percent_drop(before.cooldown, after.cooldown), args)
	RunChoiceCard._add_line(lines, ReservedString.stat_area_up(),
		RunChoiceCard._percent_rise(before.area, after.area), args)
	RunChoiceCard._add_line(lines, ReservedString.stat_speed_up(),
		RunChoiceCard._percent_rise(before.speed, after.speed), args)
	return "\n".join(lines)


static func _add_line(lines: PackedStringArray, key: String, value: int, args: FormatArgs) -> void:
	if value <= 0:
		return
	args.clear()
	args.set_int("value", value)
	lines.append(LocalizationCore.format(key, args))


static func _percent_rise(before: float, after: float) -> int:
	if before <= 0.0 or after <= before:
		return 0
	return roundi((after - before) / before * RunConstants.PERCENT)


static func _percent_drop(before: int, after: int) -> int:
	if before <= 0 or after >= before:
		return 0
	return roundi(float(before - after) / float(before) * RunConstants.PERCENT)
