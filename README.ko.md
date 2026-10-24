# open-game-works-game-iso-survivors

[English](README.md)

**아이소 서바이버즈**(`Iso Survivors`)는 뱀파이어 서바이버즈 스타일의 macOS용 아이소메트릭 3D 호드 서바이벌 게임으로,
등불을 든 한 사람이 밤새 몰려오는 적 무리를 버틴다. AI 에이전트가
[open-game-works](https://github.com/wnsrn3436/open-game-works-core)로 만들었다.

<p align="center"><img src=".github/media/iso-survivors.gif" alt="iso-survivors gameplay" width="640"></p>

## 현재 상태

이 게임은 open-game-works의 `create game` 루프(반복 3회)와 UI를 다듬은 `update game` 루프(반복 1회)로 만들었고,
개발하는 동안 macOS에서 플레이하며 확인했다. 두 루프 모두 사람이 멈췄고, 아직 열려 있는 결함은 각 루프 종료
기록(`records/loops/*/end.md`)에 있다. 출시용 빌드는 아직 없다. `build` 명령을 한 번도 실행하지 않았다.

## 어떤 게임인가

등불을 든 사람 하나가 끝없는 밤의 묘지 들판을 걷는다. 플레이어는 움직이기만 하고, 무기는 알아서 공격한다. 쓰러진
적은 파란 경험치 보석을 떨어뜨리고, 레벨이 오를 때마다 카드 3장 중 하나를 고르며, 적 무리는 1분마다 커진다. 15분을
버티면 새벽이 밝아 적 무리가 빛 속에 무너지고 원정은 승리로 기록된다. 새벽을 맞았든 못 맞았든, 원정에서 번 금화로
야영지의 등불 제단에서 영구 강화를 산다.

이 게임은 한국어와 영어로 된 macOS용 뱀파이어 서바이버즈 같은 아이소메트릭 3D 게임을 만들어 달라고 하네스에 준 한 줄짜리
요청에서 시작했다. `brief.md`의 `## request`에 그 요청과, 요청에 없어서 콘텐츠 에이전트가 정한 항목이 있고, 레퍼런스
게임과 무엇이 다른지도 적혀 있다. 레퍼런스 게임은 사람이 요청에서 지명했고, 그 플레이 영상은 `setup game`에서 주었다.

| | |
|---|---|
| 플레이어 | 한 명 |
| 플랫폼 | macOS (`settings.json` `buildPlatforms`) |
| 입력 | 키보드, 게임패드 |
| 화면 | 가로, 기준 해상도 1920x1080 |
| 언어 | 한국어(원문), 영어 |
| 클라이언트 / 서버 | Godot / TypeScript |
| core 버전 | `0.1.0` (`settings.json` `coreVersion`) |

### 원정 흐름

1. 출발: 야영지에서 `원정 시작`을 한 번 누르면 원정이 로드된다. 서버가 플레이 세션을 열 때까지 HUD에
   `원정 준비 중`이 나오고 아무것도 움직이지 않는다. 그다음 원정 타이머가 0:00에서 시작하고, 무기는 등불 탄환 하나다.
2. 이동과 수집: 박쥐와 구울이 화면 밖에서 다가온다. 파란 보석 가까이 걸어가면 보석이 끌려와 경험치 바가 찬다.
   쓰러진 적이 가끔 체력을 회복하는 수프 그릇을 떨어뜨린다.
3. 레벨 업: 경험치 바가 차면 원정이 멈추고 카드 3장이 열린다. 새 무기, 가진 무기의 다음 레벨, 패시브 중 하나다.
   고른 카드는 바로 적용되고 원정이 이어진다. 무기와 패시브는 각각 4개까지 가질 수 있고, 각각 레벨 5까지 오른다.
   더 고를 카드가 없으면 레벨 업은 카드 대신 체력을 회복한다.
4. 웨이브: 1분마다 새 웨이브가 적의 생성 속도, 구성, 체력을 올린다(`data/tables/wave.csv`). 해골, 망령, 무덤
   거한이 합류한다. 4:00, 8:00, 12:00에는 뼈 기사가 빨간 경고 배너와 포효와 함께 나타나고, 쓰러뜨리면 상자를
   떨어뜨린다. 상자는 카드 3장 고르기를 한 번 더 연다.
5. 원정 종료: 체력이 0이 되면 들판이 핏빛으로 물들고, 주인공이 쓰러지며 `등불이 꺼졌다…`가 나온다. 15:00에는
   새벽이 밝아 모든 적이 사라지고 결과 제목이 `새벽이 밝았다!`가 된다. 일시 정지 팝업의 `원정 포기`로도 원정이
   끝난다. 서버가 원정 금화를 주고 원정을 기록하며, 결과 화면에 생존 시간, 처치 수, 레벨, 금화가 나온다.
   `다시 출발`을 한 번 누르면 다음 원정이 시작되고, `야영지로`를 누르면 야영지로 돌아간다.

처음 하는 플레이어는 약관 팝업을 한 번 보고, 그다음 첫 원정을 권하는 문구와 함께 야영지가 열린다. 앱이 꺼지며
남은 원정은 다음에 게임을 켤 때 일시 정지된 채로 이어진다. 원정 사이에 남는 것은 금화, 제단 강화, 기록(원정 수,
새벽 맞이 수, 최고 생존, 최다 처치, 누적 처치)이다. 캐릭터 선택, 스테이지 선택, 무기 진화는 없고, 광고, 결제,
에너지 타이머도 없다.

무기는 `등불 탄환`, `회전 낫`, `성화 오라`, `투척 도끼`, `낙뢰`다(`data/tables/weapon.csv`, 레벨별 값은
`weapon_level.csv`). 패시브는 피해, 최대 체력, 줍는 범위, 이동 속도를 올리거나 무기 재사용 시간을 줄인다
(`data/tables/passive.csv`).

### 야영지와 등불 제단

야영지에는 금화, 기록 카드 `나의 기록`, 모닥불 곁의 주인공, 금화로 살 수 있는 강화 수를 보여 주는 배지가 달린 제단
버튼, 그리고 아래에 목표 문구가 있는 `원정 시작`이 있다. `등불 제단`은 영구 강화 6가지를 판다. 한 번에 한 레벨씩,
레벨 순서대로만 살 수 있다.

| 강화 | 레벨마다 효과 | 레벨 |
|---|---|---|
| `힘` | 모든 피해 +5% | 5 |
| `생명력` | 최대 체력 +15 | 5 |
| `서두름` | 무기 재사용 시간 −4% | 3 |
| `자력` | 줍는 범위 +20% | 3 |
| `신속` | 이동 속도 +5% | 3 |
| `탐욕` | 원정 금화 +10% | 3 |

효과는 `data/tables/upgrade.csv`에, 레벨별 가격은 `data/tables/shop_product.csv`에 있다(첫 레벨은 30~100 금화).
제단 강화를 가지고 시작한 원정에는 `등불 제단의 가호가 함께합니다`가 나오고, HUD에 그 원정에 적용되는 강화별 효과
판이 나온다.

### 조작

| 입력 | 동작 |
|---|---|
| `W` `A` `S` `D` 또는 방향키, 게임패드 방향 패드 또는 왼쪽 스틱 | 누르는 동안 그 화면 방향으로 걷기, 두 키를 함께 누르면 대각선 |
| `1` `2` `3`, 게임패드 `X` `Y` `RB` | 레벨 업 팝업의 첫째, 둘째, 셋째 카드 고르기 |
| `P`, 게임패드 `Start` | 원정 중 일시 정지 |
| `Esc`, 게임패드 `B` | 원정 중 일시 정지, 다른 화면에서는 뒤로 |
| 마우스 클릭, `Enter` 또는 `Space`, 게임패드 `A` | UI 버튼이나 카드 누르기 (`Enter`, `Space`, `A`는 포커스된 것) |

공격 입력은 없다.

### 그래픽과 소리

손으로 칠한 질감의 스타일라이즈드 로우폴리 3D를 직교 아이소메트릭 카메라로 비춘다. 팔레트는 밤(`#1B1A2E`),
이끼(`#3E5C3A`), 등불 금색(`#C9A227`), 핏빛 빨강(`#8E1F2F`), 뼈(`#E8E1D0`)다. 플레이어 둘레의 따뜻한 금빛 조명이
어둠을 밀어내고, 들판에는 차가운 달빛과 안개가 깔리며, 경험치 보석은 적 무리와 구별되도록 짙은 파란빛으로 빛난다.
무기가 적을 맞히면 불꽃이 튀는 타격 섬광과 피해 숫자가 나오고, 등불은 쏠 때마다 번쩍이며, 걸음마다 먼지가 인다.
적에게 닿으면 화면이 빨갛게 번쩍이고 짧게 흔들리며, 체력이 낮으면 체력 바가 깜박인다. 패널 제목은 금색 리본 위에
놓이고, 주요 버튼은 큰 금색 판이다. 원정에서는 타격음 아래로 북과 낮은 현악이 흐르고, 야영지에서는 잔잔한 모닥불
곡이 흐르며, 타이틀에는 음악이 없다. 무기마다 발사음이 따로 있고, 레벨 업, 상자, 엘리트 등장, 새벽, 쓰러짐, 제단
구매에도 각각 소리가 있다.

## 동작 방식

원정은 클라이언트가 돌리고, 서버는 결과를 검사해 금화를 주고 기록과 제단 강화를 보관한다.

```
client/ (Godot)                                server/ (TypeScript)
features/run/run_world.gd                      server core modules play-session, item-ledger, shop
  player, horde, weapons and gems in
  meters on the ground, one tick every 50 ms

run start   --- StartPlaySession ------------> hooks/play_session.ts
            <-- PlaySessionLoadout ----------    prepare_run
                (seed, upgrade_ids,
                 upgrade_levels)
run end     --- FinishPlaySession -----------> hooks/play_session.ts
                PlaySessionResult                verify_run
                (survived_ms, kills,             apply_run
                 level, dawn)
            <-- gold, updated RunRecordUserState  runs, dawns, best_survived_ms, best_kills, total_kills
shrine buy  --- BuyShopProduct --------------> hooks/shop.ts
            <-- gold spent, upgrade level +1     validate_upgrade_step
```

- `prepare_run`은 `level_id`가 0일 때만 받아들이고(아니면 `GAME_ERROR_LEVEL_NOT_FOUND`), 시뮬레이션 시드와 사용자가
  가진 제단 강화별 레벨을 돌려준다.
- `verify_run`은 생존 시간이 `[run_duration]` 이하이면서 플레이 세션 시간에 `[run_time_slack]`을 더한 값 이하이고,
  `dawn`이 생존 시간이 정확히 `[run_duration]`일 때만 켜져 있고, 처치 수가 생존한 1분마다 `[max_kills_per_minute]`
  이하이고, 레벨이 `[max_level]` 이하일 때만 결과를 받아들인다. 원정을 다시 시뮬레이션하지 않고 결과의 범위만 검사한다.
- `apply_run`은 공유 공식 `run.gold_reward`의 금화를 주고 `RunRecordUserState`에 원정을 더한다. 금화는 생존 10초마다
  1, 처치 하나마다 4분의 1, 새벽 보너스를 더한 값에 `Greed`(탐욕) 강화를 반영하며, 나눗셈은 모두 버림이다.
  클라이언트는 같은 공식으로 지금까지 번 금화를 보여 준다(`client/features/run/run_gold.gd`,
  `server/common/run_reward.ts`, 사례는 `data/fixtures/run.gold_reward.json`). 결과 화면에는 서버가 준 금화가 나온다.
- `validate_upgrade_step`은 제단 레벨을 그 강화의 다음 레벨로만 살 수 있게 한다(아니면 `GAME_ERROR_UPGRADE_ORDER`).
  레벨별 가격, 금화 확인, 레벨당 한 번 구매 제한은 `shop` core 모듈이 `data/tables/shop_product.csv`로 처리한다.
- 게임플레이 값(원정 길이, 틱, 플레이어, 줍기, 웨이브, 적, 무기, 패시브, 금화)은 코드 속 상수가 아니라
  `data/system/game_setting.csv`와 `data/tables/`의 테이블 행이다.
- 게임이 따로 정의한 요청은 없다. `contract/service.proto`의 `service Game`은 비어 있고, 이 파일에는
  `PlaySessionLoadout`과 `PlaySessionResult`가 있다. `contract/user_state.proto`에는 `RunRecordUserState`가,
  `contract/error.proto`에는 게임 오류 두 가지가 있다.
- 게임이 고른 core 모듈(`settings.json` `coreModules`): 클라이언트 `CameraCore`, `PoolCore`, `TweenCore`,
  `ScreenEffectCore`, `InputCore`, `SoundCore`, `QualityCore`, `NativeUiCore`, 서버 `play-session`, `item-ledger`,
  `shop`.

## open-game-works로 제작

[open-game-works](https://github.com/wnsrn3436/open-game-works-core)는 AI 에이전트가 서버-클라이언트 게임을 만드는
하네스다. 여러 게임이 되풀이하는 기능은 core로 미리 만들어 두고, 에이전트는 게임플레이만 content code로 쓴다. 게임은
루프를 돌며 만든다. 콘텐츠 에이전트가 고치고, 플레이 에이전트가 인스턴스를 실제 입력으로 플레이하고, 판정 에이전트가
그 인스턴스를 기준 게임과 비교하고 레퍼런스 게임의 플레이 영상과도 비교하며, 하네스 도구가 저지 결과와 자동 검사로
성공을 판정한다. 최종 리소스는 리소스 서브 에이전트가, 번역은 번역 서브 에이전트가 만든다.

`client/core/`와 `server/core/`는
[core 릴리스 v0.1.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.1.0)의 사본이고, 엔진
버전도 그 릴리스가 정한다(Godot 4.7.2). `update game`은 시작할 때 `coreVersion`을 이 게임이 쓸 수 있는 가장 새로운
core 릴리스로 올린다.

| 저장소 | 내용 |
|---|---|
| [open-game-works-core](https://github.com/wnsrn3436/open-game-works-core) | 하네스: 에이전트 규칙, 스킬, 모듈 스펙, CLI `ogw` |
| [open-game-works-core-impl](https://github.com/wnsrn3436/open-game-works-core-impl) | core 구현. core 릴리스는 이 저장소의 GitHub Releases |
| [open-game-works-game-mana-clash](https://github.com/wnsrn3436/open-game-works-game-mana-clash) | 같은 하네스로 만든 다른 게임: 1대1 카드 배틀 게임 |
| [open-game-works-game-pong](https://github.com/wnsrn3436/open-game-works-game-pong) | 같은 하네스로 만든 다른 게임: CPU와 겨루는 패들과 공 아케이드 게임 |
| open-game-works-game-iso-survivors | 이 게임 |

## 저장소 구성

| 경로 | 내용 |
|---|---|
| `brief.md` | 브리프: 플레이어 판타지, 감정, 기억에 남을 순간, 장르 관습, 금지 사항, 실패 페널티, 예측, 레퍼런스 게임, 요청과 콘텐츠 에이전트가 정한 항목 |
| `design.md` | 디자인 문서: 코어 루프, 조작, 화면, 시스템(들판과 이동, 적과 웨이브, 무기와 패시브, 경험치와 카드 고르기, 원정과 기록, 등불 제단), 성장, 경제, 신규 사용자, 감각과 튜닝 목표, 아트와 오디오 방향, 용어, core 사용 |
| `play-guide.md` | 플레이 에이전트와 판정 에이전트가 받는 플레이 가이드: 목표, 조작, 게임 흐름, 실패, 입력 잠금 구간, 가장 빠른 시작 경로, 장면별 플레이 모드 |
| `settings.json` | 게임 설정: core 버전, 엔진, core 모듈, 빌드 플랫폼, 언어, 해상도, UI 검사 화면, 환경별 값(관리 운영자, 시크릿은 이름만), 약관 문서, 동의 |
| `contract/` | contract(protobuf): `service.proto`, `user_state.proto`, `error.proto` |
| `data/` | CSV 테이블(`tables/`, `wave.csv`, `enemy.csv`, `weapon.csv`, `weapon_level.csv`, `passive.csv`, `upgrade.csv`, `shop_product.csv` 포함), 시스템 테이블(`system/`, `game_setting.csv` 포함), 공유 공식 픽스처(`fixtures/`), 번역(`translations/`), 용어집(`glossary.csv`), enum과 invariant |
| `resource/` | 리소스 키별 리소스: 앱 아이콘, 스플래시, 배경, 바닥 텍스처, 3D 모델, UI 프레임, 아이콘, 이미지, 파티클, 폰트, BGM, 효과음, 장면, 프리팹, 트윈 프리셋. `resources.csv`에 모든 리소스 키와, 생성하거나 카탈로그에서 가져온 리소스의 제작 방법과 라이선스(폰트는 출처도)가 있음 |
| `client/` | Godot 프로젝트. content code는 `boot/`, `common/`, `features/`(`title`, `lobby`, `run`), 회귀 테스트는 `tests/`, DEV 코드는 `dev/`(봇 플레이테스트 시나리오 `dev/bot/scenario.json`, 세이브 픽스처 `dev/bot/fixtures/`). `core/`와 `generated/`는 하네스 도구가 씀. `resource`는 `../resource`로의 링크 |
| `server/` | TypeScript 서버. `main.ts`가 `hooks/play_session.ts`와 `hooks/shop.ts`의 훅을 등록, 원정 금화 공식은 `common/run_reward.ts`, 회귀 테스트는 `tests/`, DEV 코드는 `dev/`. `core/`와 `generated/`는 하네스 도구가 씀 |
| `records/` | 에이전트와 도구가 쓰는 작업 기록: `setup/`(저장한 요청, 게임 이름, 아트 방향, 호스트 확인, `reference/reference.md`), `loops/`(루프마다 루프 반복 기록, 플레이와 판정 결과, 결함 목록, 루프 종료 기록), `core-proposals/`(core 제안 하나, `LocalizationCore`의 폰트 굵기) |
| `LICENSE`, `LICENSES/` | 라이선스 전문 |

`id-registry` 브랜치에는 ID 레지스트리(`id_registry.json`)만 있다. 이 브랜치에는 데이터 도구만 쓰고, 다른 브랜치와
병합하지 않는다. 빌드 결과물(`builds/`), 데이터 바이너리(`client/build/`, `server/build/`), 캡처, 루프 증거 자료,
레퍼런스 게임 영상은 커밋하지 않는다.

### 언어

원문은 한국어다. `settings.json`에 `sourceLanguage`가 없으므로 기본값 `ko`가 적용되고, `supportedLanguages`는 `ko`와
`en`이다. 영어 텍스트는 `data/translations/en.csv`에 있고, 게임 제목, 무기, 패시브, 강화 같은 이름의 번역은
`data/glossary.csv`가 고정한다. 문서(`brief.md`, `design.md`, `play-guide.md`, `reference.md`)는 영어로 썼고, 게임 속
한국어 텍스트는 코드 스팬으로 남겼다.

## 요구 사항

- 하네스 [README](https://github.com/wnsrn3436/open-game-works-core)대로 하네스를 준비한 open-game-works 작업 공간
  (Node 24 이상, Git, GitHub CLI, buildx가 있는 Docker, uv와 Python, Claude Code 또는 Codex)
- Godot 4.7.2. 이 게임이 고정한 core 릴리스가 정한 엔진 버전이고, `update env`가 `<workspace>/.ogw/`에 설치한다
- macOS 앱을 빌드하려면 Xcode 27(core 릴리스 0.1.0의 `engine.json`이 지정)이 있는 Apple silicon Mac이 필요하다.
  macOS는 이 게임의 유일한 빌드 플랫폼이다
- Windows: `client/resource`는 심볼릭 링크다. 클론하기 전에 개발자 모드를 켜고
  `git config --global core.symlinks true`를 실행해야 한다. 그러지 않으면 링크가 일반 텍스트 파일로 체크아웃된다.
  플레이 에이전트와 판정 에이전트는 macOS와 Linux에서만 실행되므로, Windows에서는 루프와 빌드를 돌릴 수 없다

## 설치

작업 공간의 `games/` 아래에 저장소를 클론하고, 원격 브랜치에서 로컬 `id-registry` 브랜치를 만든다. 클론하면 로컬
브랜치는 `main`만 생기는데, 데이터 도구는 로컬 `id-registry` 브랜치에서 ID 레지스트리를 읽는다.

```
<workspace>/
  open-game-works-core/
  open-game-works-core-impl/
  games/open-game-works-game-iso-survivors/
```

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-iso-survivors.git games/open-game-works-game-iso-survivors
git -C games/open-game-works-game-iso-survivors branch id-registry origin/id-registry
```

폴더 이름이 명령에서 쓰는 게임 이름이다. 그다음 `open-game-works-core/`에서 Claude Code나 Codex를 열고
`update env`를 실행한다. 이 명령은 이 게임의 빌드 도구를 확인하고 core 버전에 맞는 엔진을 설치한다.

### 레퍼런스 게임 영상

`records/setup/reference/reference.md`에는 `setup game`에서 사람이 고른 레퍼런스 게임, 그 플레이 영상의 출처 URL,
판정 에이전트가 비교하는 영상 속 순간이 기록되어 있다. 영상 파일은 저장소에 없지만(`.gitignore`가
`records/setup/reference/`에서 `reference.md`를 뺀 모든 파일을 제외) `update game`의 판정 에이전트에게 필요하다.
루프를 돌리기 전에 `open-game-works-core/`에서 다음 명령을 실행해 받아 온다(`yt-dlp` 필요).

```sh
tools/bin/ogw game reference open-game-works-game-iso-survivors https://youtu.be/eqiqu3fliak
```

영상은 `records/setup/reference/`에 `<video id>.mp4`로 저장된다. 이 영상은 `eqiqu3fliak.mp4`로 저장되는데, 이미
`reference.md`의 `## video`에 적힌 이름과 같다.

## 사용법

`open-game-works-core/`에서 연 Claude Code나 Codex 세션에 아래 명령을 준다. 명령을 받은 에이전트가 끝까지 진행하고
결과를 보고한다.

| 명령 | 하는 일 |
|---|---|
| `update game: open-game-works-game-iso-survivors <request>` | 루프로 게임을 고친다. 요청은 사람의 피드백이나 고칠 PROD 문제다. 루프가 멈추면, 그사이 main이 바뀌지 않았을 때 도구가 고른 커밋을 main에 병합하고 루프 종료 기록으로 보고한다 |
| `build: open-game-works-game-iso-survivors DEV` | 서버와 클라이언트 content code를 하드닝하고, PostgreSQL로 검사를 다시 돌리고, macOS 앱을 `builds/`에 빌드하고, 커밋에 `dev-<version>` 태그를 붙이고, DEV 서버를 배포한다. `--version`이 없으면 첫 빌드는 `0.1.0`이다 |

STG와 PROD 빌드는 서명된 결과물까지 만든다. STG는 서버도 배포하고, PROD 배포는 사람이 한다.

### 인스턴스 실행

인스턴스는 게임을 개발용으로 실행한 것으로, 자기 DB를 가진 로컬 서버 하나와 화면을 그리는 클라이언트로 이루어진다.
`ogw`는 하네스 저장소의 `tools/bin/ogw`이고, `open-game-works-core/`에서 실행한다.

```sh
tools/bin/ogw instance start open-game-works-game-iso-survivors   # 인스턴스 id와 주소를 출력
tools/bin/ogw instance stop <id>
```

클라이언트는 개발용 계정으로 로그인하고 약관 팝업 없이 시작한다. `--db postgresql`을 주지 않으면 DB는 SQLite이고,
`--commit <sha>`를 주면 다른 커밋으로 인스턴스를 시작하며, `--fixture <file>`을 주면 부팅 뒤 세이브 픽스처를 실행한다
(이 게임의 픽스처는 `client/dev/bot/fixtures/`에 있다). `ogw capture <id>`는 화면을 캡처하고, `ogw log <id>`는 오류
로그를 보여 주고, `ogw command <id> list_commands`는 게임의 content command 목록을 보여 준다.

### 첫 DEV 빌드 전에

아래 명령은 `open-game-works-core/`에서 실행한다.

- `settings.json`에는 아직 빌드용 값이 없다.
  `tools/bin/ogw game check open-game-works-game-iso-survivors --build`가 빠진 값을 보여 준다. `appId`,
  `serverImage`, 그리고 환경별 `serverUrl`, `trustedProxyCount`, `secrets`(이름), `adapters`, DEV와 STG의 `deploy`,
  PROD의 `cdnR2`, STG와 PROD용 `signing.macos`다. `build` 명령은 그 환경의 값이 빠져 있으면, 명령을 받은 에이전트가
  값을 물어 채우고 그 환경의 `ogw secret generate`를 실행한다. `signing.macos` 없이 만든 DEV 빌드의 macOS 앱은
  애드혹 서명만 하고 공증하지 않는다.
- 시크릿 값은 `settings.json`이 아니라 호스트의 시크릿 저장소에 넣는다. 생성할 수 있는 값은
  `tools/bin/ogw secret generate open-game-works-game-iso-survivors DEV`로, 배포 SSH 키 같은 나머지는
  `tools/bin/ogw secret set open-game-works-game-iso-survivors <DEV|signing> <name>`으로 넣는다. `secret set`은 값을
  표준 입력으로 받는다.
- `settings.json`의 약관 문서 URL은 자리 표시용 값(`.invalid` 호스트)이다. 직접 쓸 값으로 바꾼다.

## 라이선스

| 대상 | 라이선스 |
|---|---|
| 이 저장소의 콘텐츠 | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) (`LICENSE`) |
| `client/core/`, `server/core/` (open-game-works core 릴리스의 사본) | Apache-2.0 (`LICENSES/Apache-2.0.txt`) |
| `resource/font/main.ttf` (Noto Sans KR) | SIL Open Font License 1.1 (`LICENSES/OFL-1.1-NotoSansKR.txt`) |

`resource/resources.csv`에는 모든 리소스 키가 있다. 생성 방법으로 만들었거나 고정된 카탈로그에서 가져온 최종
리소스에는 제작 방법과 라이선스도 적혀 있고, 폰트에는 출처와 저작권 표시도 적혀 있다. 그 리소스는 다음과 같다.

| 리소스 | 방법 | 라이선스 |
|---|---|---|
| `app_icon/main`, `splash/main`, `background/*`, `texture/ground`, `nine_slice/ui/*`, `icon/*`, `image/ui/logo_emblem` | `flux2-klein` | Apache-2.0 |
| `image/lobby/hero` | `flux2-klein` | Apache-2.0, 게임 소유 |
| `model/*` | `blender` | 게임 소유 |
| `particle/*` | `procedural` | 게임 소유 |
| `bgm/lobby`, `bgm/run` | `ace-step` | MIT |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `font/main` | `font-catalog` | OFL-1.1 |

게임 소유(`resources.csv`의 `LicenseRef-game-owned`) 리소스는 게임이 직접 작성한 스크립트로 만든 것으로, 이 저장소
콘텐츠의 라이선스를 따른다. 게임의 라이선스 매니페스트 `client/generated/licenses.json`에 Godot Engine 같은 서드파티
구성 요소와 그 라이선스, 고지문이 있다.
