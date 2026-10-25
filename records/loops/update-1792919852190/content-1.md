## defects

| id | result | note |
|---|---|---|

## unverified

- Core 0.2.1 fatal screen font: the fatal screen is shown only by a core init failure or `BootstrapCore.report_fatal`. Content code does not call `report_fatal`, and there is no automation command that triggers the fatal screen, so it was not captured
- Core 0.2.1 requirement watches: content code does not use `RequirementCore` or `RequirementWatch` directly. Only the regression and static checks cover it, and both passed
- Step mode level-ups on core 0.2.1 were checked on one instance: three cards were picked in step mode (200 ms steps), with no error log line. When the fourth level-up popup opened in the middle of a step, `ogw step` stopped that step early with `game time is paused` and exited with code 0, as `instance.md` describes. A bot playtest (`ogw check --loop`) was not run in this iteration

## requests

none

## assumptions

- Where does the `three_levelups` save fixture leave the instance?
