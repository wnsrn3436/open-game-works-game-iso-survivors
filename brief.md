## player fantasy

The player is a lone lantern bearer who turns a hopeless night siege on a haunted field into a whirlwind of light, and keeps walking through an ever-thickening horde until dawn breaks.

## emotion

Core emotion: rising power against overwhelming odds (from dread to dominance).

Curve of one run (15 minutes of run time):

1. 0:00~2:00: a few bats and ghouls, one lantern bolt. The player learns to keep moving and to walk into the blue gems. Low tension, curiosity
2. 2:00~5:00: the first picks build a kit (a second weapon, a passive). Skeletons join and the horde starts to close in. Tension rises, then each level-up card releases it a little
3. 4:00, 8:00, 12:00: a bone knight arrives with a roar and a red banner. Dread peaks; beating it drops a chest whose pick is the strongest reward of the minute
4. 8:00~14:00: a dense ring of wraiths and grave brutes. With raised weapons the player carves a lit circle through them: the power fantasy at its height, with health as the only worry
5. 14:00: the "dawn is coming" banner. A last push of the strongest wave
6. 15:00: dawn breaks, the whole horde crumbles in light. Release and pride. A fall before that ends with regret and the gold to spend at the shrine

## memorable moment

Around the tenth minute, a solid ring of skeletons and grave brutes closes on the player from every side; the four weapons at their top level (spinning scythes, the holy flame, lightning and lantern bolts) burn a clean circle of light into the horde, damage numbers bloom everywhere, and the player walks straight through the gap as the bone knight roars in.

## genre conventions

| convention | decision | reason |
|---|---|---|
| The player only moves; weapons attack on their own | accept | It is the identity of the genre and keeps the hands on movement |
| Enemies drop XP gems; each level-up offers a pick of 3 weapons or passives | accept | The rhythm of small rewards is the core of the genre |
| Waves grow every minute, with elite enemies at set times | accept | It gives the run its escalating curve |
| A run lasts 30 minutes and ends with an unbeatable reaper | twist | A run lasts 15 minutes and ends with dawn: the horde crumbles in light and the run counts as a win. Shorter runs make "one more run" easy, and the end is a reward instead of a forced death |
| Top-down 2D pixel art | twist | An isometric low-poly 3D field with a lantern light around the player, so the night and the horde have depth |
| Treasure chests from elites give random upgrades | twist | The chest opens the same pick of 3 cards as a level-up: the player chooses instead of a roulette |
| Gold buys permanent upgrades between runs | accept | It turns every fall into progress and is the second judge moment |
| Many characters, stages and unlocks to choose before a run | reject | One lantern bearer and one field. The run starts with one press from the camp |
| Weapon evolutions that merge a maxed weapon with a passive | reject | Kept out of the first version so each card's effect is clear; the top levels of 5 weapons and 5 passives are the build |
| Revive by watching an ad, paid currency | reject | A premium macOS game without ads or payments |

## prohibitions

- No character select, stage select or unlock tree before a run (drops a genre-standard feature). The camp has one start button
- No ads, no payments, no energy or stamina timers
- No aim or attack input. The player only moves and picks cards
- No elite arrives without its warning banner and sound
- No pick that removes a weapon or makes the player weaker

## failure penalty

- Share of progress lost per mistake: a contact hit costs health only, 0‰ of the run progress (level, weapons, time and kills stay). A fall (health 0) ends the run: its in-run levels and weapons are lost (1000‰ of the run's in-run build), while the gold of that run is still granted and the permanent shrine upgrades stay (0‰ of meta progress)
- Duration limit of the loss state: 3000ms. It is the fall effect wait `[run_end_delay]` (1600ms) plus the result save
- Delay limit from the end of the loss until control is possible again: 4000ms. One press of `다시 출발` (Run again), which has the first focus on the result panel, loads a new run that plays as soon as the server starts its play session

## prediction

If it works, after the first fall the player will spend the gold of that run at the lantern shrine and start a second run within 60 seconds of the result panel appearing.

## reference game

Vampire Survivors

records/setup/reference/reference.md

How this game differs from the reference game:

- An isometric low-poly 3D night field instead of top-down 2D pixel art
- A run lasts 15 minutes and ends with dawn as a win, instead of 30 minutes ending with a reaper
- One hero and one field, no character or stage select; the camp starts a run with one press
- Elite chests open a pick of 3 instead of a random roulette
- No weapon evolutions in this version; 5 weapons and 5 passives up to level 5
- No ads or revives; a premium macOS game in Korean and English
- A run the app left resumes, paused, the next time the game starts

## request

'isometric view 3d game like Vampire Survivors for MacOS, in Korean and English', 'reference: https://youtu.be/eqiqu3fliak?si=zPQ8TVL8FGoxyJdr'

Items the content agent decided because the request did not have them:

- One lantern bearer on one endless night field, viewed by an orthographic isometric camera
- A run lasts 15 minutes (`[run_duration]`); dawn at that time is the win
- 5 weapons (lantern bolt, spinning scythe, holy aura, throwing axe, lightning) and 5 passives, each up to level 5; 4 weapon slots and 4 passive slots
- Gold from each run buys 6 permanent upgrades at the lantern shrine of the camp
- The target platform is macOS of game settings `buildPlatforms`. Controls are keyboard (WASD or arrow keys) and gamepad
- The screen is landscape, base resolution 1920x1080
- The source language is Korean; English comes from the translation work
- The game name is `아이소 서바이버즈` (Iso Survivors) from `records/setup/name.md`
