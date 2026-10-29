# open-game-works-game-iso-survivors

[English](README.md)

**아이소 서바이버즈**(`Iso Survivors`)는 뱀파이어 서바이버즈 스타일의 macOS용 아이소메트릭 3D 호드 서바이벌 게임으로,
AI 에이전트가 [open-game-works](https://github.com/wnsrn3436/open-game-works-core)로 만들었다.

<p align="center"><img src=".github/media/iso-survivors.gif" alt="iso-survivors gameplay" width="640"></p>

## 직접 플레이하기

하네스 README의 [빠른 시작](https://github.com/wnsrn3436/open-game-works-core/blob/main/README.ko.md#빠른-시작)대로
준비한 open-game-works 작업 공간이 필요하다.

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-iso-survivors.git games/open-game-works-game-iso-survivors
git -C games/open-game-works-game-iso-survivors branch id-registry origin/id-registry

cd open-game-works-core
tools/bin/ogw instance start open-game-works-game-iso-survivors   # 인스턴스 id와 주소를 출력
tools/bin/ogw instance stop <id>
```

클론한 뒤 `open-game-works-core/`에서 연 Claude Code나 Codex 세션에서 `update env`를 한 번 실행한다. 이 명령이 이
게임의 엔진을 설치한다. 클라이언트는 개발용 계정으로 로그인하고 약관 팝업 없이 시작한다.

## 게임 소개

등불을 든 사람 하나가 끝없는 밤의 묘지 들판을 걷는다. 플레이어는 움직이기만 하고, 무기는 알아서 공격한다. 쓰러진
적은 파란 경험치 보석을 떨어뜨리고, 레벨이 오를 때마다 카드 3장(새 무기, 가진 무기의 다음 레벨, 패시브) 중 하나를
고르며, 적 무리는 1분마다 커진다. 4:00, 8:00, 12:00에는 뼈 기사가 나타나고, 쓰러뜨리면 카드 3장 고르기를 한 번 더
여는 상자를 떨어뜨린다. 체력이 0이 되면 원정이 끝나고, 15:00까지 버티면 새벽이 밝아 승리로 기록된다.

새벽을 맞았든 못 맞았든, 원정에서 번 금화로 야영지의 등불 제단에서 영구 강화를 사고, 한 번 눌러 다음 원정을 떠난다.
플레이어는 한 명, 입력은 키보드나 게임패드, 언어는 한국어(원문)와 영어다.

| 입력 | 동작 |
|---|---|
| `W` `A` `S` `D` 또는 방향키, 게임패드 방향 패드 또는 왼쪽 스틱 | 걷기 (두 키를 함께 누르면 대각선) |
| `1` `2` `3`, 게임패드 `X` `Y` `RB` | 레벨 업 카드 첫째, 둘째, 셋째 고르기 |
| `P` 또는 `Esc`, 게임패드 `Start` 또는 `B` | 원정 중 일시 정지 (`Esc`와 `B`는 다른 화면에서 뒤로) |
| 마우스 클릭, `Enter` 또는 `Space`, 게임패드 `A` | 버튼이나 카드 누르기 |

## 상태

open-game-works 루프로 만들었고, 개발하는 동안 macOS에서 플레이하며 확인했다. 열려 있는 결함은 루프 종료
기록(`records/loops/*/end.md`)에 있다. 출시용 빌드는 아직 없다. `build` 명령을 한 번도 실행하지 않았다.

## AI로 고치기

`open-game-works-core/`에서 연 Claude Code나 Codex 세션에 아래 명령을 준다.

- `update game: open-game-works-game-iso-survivors <request>`는 루프로 게임을 고친다.
- `build: open-game-works-game-iso-survivors DEV`는 코드를 하드닝하고, macOS 앱을 빌드하고, DEV 서버를 배포한다.

`update game`의 판정 에이전트에게는 레퍼런스 플레이 영상이 필요한데, 영상은 저장소에 없다. 먼저
`open-game-works-core/`에서 받아 온다(`yt-dlp` 필요). 영상은 [`reference.md`](records/setup/reference/reference.md)에
이미 적힌 이름인 `eqiqu3fliak.mp4`로 저장된다.

```sh
tools/bin/ogw game reference open-game-works-game-iso-survivors https://youtu.be/eqiqu3fliak
```

### 첫 DEV 빌드 전에

- `settings.json`에는 아직 빌드용 값이 없다.
  `tools/bin/ogw game check open-game-works-game-iso-survivors --build`가 빠진 값을 보여 주고, `build` 에이전트가
  그 값을 물어본다. `signing.macos` 없이 만든 DEV 빌드의 macOS 앱은 애드혹 서명만 하고 공증하지 않는다.
- 시크릿 값은 `settings.json`이 아니라 호스트의 시크릿 저장소에 넣는다. 생성할 수 있는 값은
  `tools/bin/ogw secret generate open-game-works-game-iso-survivors DEV`로, 배포 SSH 키 같은 나머지는
  `tools/bin/ogw secret set open-game-works-game-iso-survivors <DEV|signing> <name>`(값은 표준 입력)으로 넣는다.
- `settings.json`의 약관 문서 URL은 자리 표시용 값(`.invalid` 호스트)이다. 직접 쓸 값으로 바꾼다.

## 만든 방식

원정은 클라이언트(Godot)가 모두 돌리고, 서버(TypeScript)는 결과를 검사해 금화를 주고 기록과 제단 강화를 보관한다.
게임플레이 값은 코드 속 상수가 아니라 `data/`의 CSV 테이블 행이다.

```
client (Godot)                         server (TypeScript)
run start  --- StartPlaySession ---->  prepare_run: seed, shrine upgrade levels
run end    --- FinishPlaySession --->  verify_run: bounds the result
           <-- gold, record ---------  apply_run: grants gold, counts the run
shrine buy --- BuyShopProduct ------>  validate_upgrade_step: next level only
```

core `0.2.1`을 고정해 쓴다(`settings.json` `coreVersion`):
[core 릴리스 v0.2.1](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.2.1).

| 경로 | 내용 |
|---|---|
| [`brief.md`](brief.md) | 브리프: 플레이어 판타지, 요청, 레퍼런스 게임과 다른 점 |
| [`design.md`](design.md) | 디자인 문서: 코어 루프, 화면, 시스템, 경제, 튜닝 |
| [`play-guide.md`](play-guide.md) | 플레이 에이전트와 판정 에이전트가 받는 조작과 흐름 |
| [`settings.json`](settings.json) | 게임 설정: core 버전, 엔진, core 모듈, 플랫폼, 언어 |
| [`contract/`](contract) | 클라이언트-서버 메시지(protobuf) |
| [`data/`](data) | CSV 테이블, 번역, 용어집 |
| [`resource/`](resource) | 그림, 모델, 소리, 폰트, 장면, 프리팹. 목록은 `resources.csv` |
| [`client/`](client) | Godot 프로젝트 |
| [`server/`](server) | TypeScript 서버 |
| [`records/`](records) | 준비, 루프, core 제안 기록 |

[open-game-works](https://github.com/wnsrn3436/open-game-works-core) 하네스로 만들었다.

## 라이선스

| 대상 | 라이선스 |
|---|---|
| 이 저장소의 콘텐츠 | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) ([`LICENSE`](LICENSE)) |
| `client/core/`, `server/core/` (open-game-works core 릴리스의 사본) | Apache-2.0 ([`LICENSES/Apache-2.0.txt`](LICENSES/Apache-2.0.txt)) |
| `resource/font/main.ttf` (Noto Sans KR) | SIL Open Font License 1.1 ([`LICENSES/OFL-1.1-NotoSansKR.txt`](LICENSES/OFL-1.1-NotoSansKR.txt)) |

[`resource/resources.csv`](resource/resources.csv)에는 모든 리소스 키가 있다. 생성 방법으로 만들었거나 고정된
카탈로그에서 가져온 최종 리소스에는 제작 방법과 라이선스도 적혀 있고, 폰트에는 출처와 저작권 표시도 적혀 있다.

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
