class_name CommonWordWrap
extends RefCounted
## Text that a label wraps only between words, so a Korean line does not end with a word cut off.


## `text` with a word joiner between each two letters of a word, so the line breaking of the label breaks only at
## spaces and line ends; Korean text otherwise breaks between any two syllables.
static func keep_words(text: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for i: int in text.length():
		out.append(text[i])
		if i + 1 < text.length() and CommonWordWrap._is_letter(text[i]) and CommonWordWrap._is_letter(text[i + 1]):
			out.append(CommonConstants.WORD_JOINER)
	return "".join(out)


static func _is_letter(c: String) -> bool:
	return c != " " and c != "\n"
