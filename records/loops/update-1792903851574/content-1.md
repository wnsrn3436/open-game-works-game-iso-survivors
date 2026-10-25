## defects

| id | result | note |
|---|---|---|

## unverified

- The title screen of the `titles_and_buttons` moment passes during boot before the judge receives the instance (the runner restarts the client after the fixture steps); the title was checked with `title.open_title` on the instance
- The English (`en`) language screens were not captured; both languages use the same `font/main` chain, so the weights apply the same way
- Core system popup buttons (`SystemPopupButton` of `UICore`, used by the option and upgrade confirm popups) are core UI and were not given the heading text style
- `run/damage_number` is a `Label3D`, not a UI text element; it keeps its own dark outline and was not changed

## requests

none

## assumptions

- Which UI text is drawn in the heading text style, and at which weights?
- Where does the `titles_and_buttons` save fixture leave the instance?
