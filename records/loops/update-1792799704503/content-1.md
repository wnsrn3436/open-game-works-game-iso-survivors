## defects

| id | result | note |
|---|---|---|

## unverified

- The final look of the new camp and shrine: the hero figure, crest, top band, ribbon, badge, pips, shrine/option/record icons and the camp embers are still placeholders (requested this iteration). Their final sizes against the layout were not seen
- `PoolCore` error `a borrowed instance of prefab/run/fire_effect was destroyed outside PoolCore` (and a `TweenCore` completion-callback error right after it) was logged once on a DEV path (`lobby.open_option` → `run.open_result` → `title.open_title` → `run.open_pause` → `run.open_levelup`). It did not come back in two re-runs (same path on this tree, and result → title on the pre-change commit `afff96e`). Cause not checked; not fixed
- The bot playtest (`ogw check --loop`) was not run this iteration; only `--static` and `--regression` were run (both pass)
- `en` translations of the new camp strings are missing (translation runs in the background); the `en` layout of the camp was not seen

## requests

- records/loops/update-1792799704503/resource-requests/1792800120765.md (`image/lobby/hero`)
- records/loops/update-1792799704503/resource-requests/1792800130812.md (top band, title ribbon, badge, option/shrine/runs/dawn/level icons, level pips, logo crest)
- records/loops/update-1792799704503/resource-requests/1792800136910.md (`particle/lobby/embers`)
- records/core-proposals/1792800900000-font-weight.md (LocalizationCore font weights)

## assumptions

- How to make the camp and the shrine read as a commercial game when the request names no layout
- How to draw bold text when core applies one font weight per language
- Whether the game name on the title screen and the camp becomes a logo image
- Whether a shrine step the gold does not cover keeps its buy button pressable
