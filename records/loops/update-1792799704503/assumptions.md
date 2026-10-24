## How to make the camp and the shrine read as a commercial game when the request names no layout

- decision: follow the lobby layout of commercial mobile and PC action games: a top band with the game name, the currency and a gear option button; a record card on the left; the hero by the fire in the middle; the shrine button with a count badge and a large start button with the run goal on the right; the shrine rows with level pips and the cost on the buy button; gold ribbon titles on every panel and popup; icon rows for stats
- evidence: genre convention of commercial survivors-like and action RPG lobbies (currency top right, settings as a gear, notice badge with a count on a menu that has something to do, main action bottom right); `## art direction` of `design.md`

## How to draw bold text when core applies one font weight per language

- decision: faux bold with an outline in the text color and a dark shadow outline as the rim; core proposal `records/core-proposals/1792800900000-font-weight.md`
- evidence: `localization-core.md` `### font` (content does not set a font on an element; decorative lettering is an image); the font catalog of harness settings holds only the variable `NotoSansKR[wght]` for Korean text

## Whether the game name on the title screen and the camp becomes a logo image

- decision: keep the name as translated text and put a letterless crest image (`image/ui/logo_emblem`) behind it, so the name stays translated for `en`
- evidence: `localization-core.md` `### font` (decorative lettering is an image resource); a lettered image would show Korean letters to `en` players

## Whether a shrine step the gold does not cover keeps its buy button pressable

- decision: it stays pressable and is dimmed with the `금화가 부족해요` line, so a press still plays the refuse sound and toast that `design.md` `## screens` sets; only a step whose upgrade is at its top level is disabled (`최대`)
- evidence: `design.md` `## screens` shrine line (a refused press plays the refuse sound and shows a toast)
