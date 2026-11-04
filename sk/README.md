# 웹 서비스 개발 스킬셋

요구사항 구체화부터 React/Next.js·NestJS 구현, 코드 검토, 실행 검증, 설명과 문서화까지 연결하는 12개 스킬이다. 주요 결정은 사용자가 비교하고 선택한다. DB, ORM, 인증 제공자와 배포 환경은 서비스 요구에 맞춰 정한다.

## 설치

저장소를 clone한다. 12개 스킬은 `sk/` 아래에 있다.

```text
git clone https://github.com/ninaxlee/skills.git
cd skills
```

이미 clone했다면 해당 저장소 폴더에서 `git pull`로 갱신한다.

## 스킬별 역할

| 스킬 | 역할 | 주요 결과 |
|---|---|---|
| [sk-spec](sk-spec/SKILL.md) | 요구사항과 범위·제약 분석 | 요구 ID, 우선순위, 인수 조건, 미확정 사항 |
| [sk-grill](sk-grill/SKILL.md) | 답에 따라 후속 질문하며 모호함 해소 | 확정 답변, 가정, 보류 결정 |
| [sk-decision-review](sk-decision-review/SKILL.md) | 주요 제품·기술·설계 선택의 대안과 비용 검토 | 비교, 권고, 사용자 결정, 재검토 조건 |
| [sk-bootstrap](sk-bootstrap/SKILL.md) | 서비스에 맞는 초기 환경과 AI 작업 지침 준비 | 앱·서버 골격, 실행 명령, AGENTS.md, 역할 설정 |
| [sk-plan](sk-plan/SKILL.md) | 검증 가능한 기능 단위로 작업 분해 | 티켓, 의존성, 우선순위, 완료 조건 |
| [sk-ux](sk-ux/SKILL.md) | 사용자 흐름과 화면·상태 설계 | 화면 흐름, 입력·로딩·오류·완료 처리 |
| [sk-frontend](sk-frontend/SKILL.md) | React 또는 Next.js 화면과 API 연결 구현 | ui/component/screen 구조의 실제 동작 |
| [sk-backend](sk-backend/SKILL.md) | NestJS API·도메인·데이터 처리 구현 | 계약, 입력 검증, 권한, 저장·오류 처리 |
| [sk-code-review](sk-code-review/SKILL.md) | 실제 코드의 결함·복잡성·쿼리·요청 낭비 검토 | 위치·조건·근거·영향·수정안이 있는 발견 |
| [sk-verify](sk-verify/SKILL.md) | 실행 검증과 제한된 수정·재검증 | 조건별 통과·실패·미검증과 실제 증거 |
| [sk-docs](sk-docs/SKILL.md) | 실제 코드·결정·검증에 맞춰 문서 갱신 | README, 실행·구조·API·결정 설명 |
| [sk-explain](sk-explain/SKILL.md) | 구현 이유 설명과 예상 질문·반론 준비 | 근거 있는 답변, 한계, 꼬리 질문 |

설계 검토는 선택의 적절성, 코드 리뷰는 실제 구현의 문제, 실행 검증은 관찰한 동작을 다룬다. 한 단계의 통과가 다른 단계의 통과를 의미하지 않는다.

## 사용 흐름

항상 12개를 순서대로 실행할 필요는 없다. 새 서비스라면 요구사항·질문 → 주요 결정 → 초기화 → 작업 계획·화면 설계 → 기능별 구현·리뷰·검증 흐름이 기본이다. 문서와 설명은 관련 근거가 생길 때 갱신한다.

```text
$sk-spec 이 요구사항의 필수 범위와 완료 조건을 정리해줘.
$sk-grill 구현 방향에 영향을 주는 미결정부터 질문해줘.
$sk-decision-review 주요 선택의 대안과 비용을 비교해줘.
$sk-bootstrap 확정한 선택으로 앱과 서버를 초기화하고 AGENTS.md도 준비해줘.
$sk-plan 핵심 사용자 기능부터 구현·검증 가능한 티켓으로 나눠줘.
$sk-ux 첫 번째 티켓의 화면 흐름과 실패 상태를 설계해줘.
$sk-backend T-001의 API와 저장 처리를 구현해줘.
$sk-frontend T-001의 화면을 실제 API와 연결해줘.
$sk-code-review 현재 변경분의 불필요한 로직과 쿼리·요청 낭비까지 검토해줘.
$sk-verify T-001의 완료 조건을 검증하고 실패하면 예산 안에서 수정·재검증해줘.
$sk-docs 현재 코드와 검증 결과에 맞춰 실행·구조 문서를 갱신해줘.
$sk-explain 주요 선택에 대한 예상 질문과 근거 있는 답변을 만들어줘.
```

요구사항 `R-001` → 티켓 `T-001` → 코드 → 검증 증거를 연결한다. 문서는 기존 위치를 우선한다. 새 프로젝트에서는 필요에 따라 `docs/requirements.md`, `decisions.md`, `tasks.md`, `ux.md`, `verification.md`, `explanation.md`를 사용하며 작은 작업은 문서를 합칠 수 있다.

## 웹 폴더 구조

웹 앱의 `src/` 아래를 다음과 같이 분리한다. [상세 의존 규칙](sk-frontend/references/web-structure.md)

```text
src/
  ui/                  Button, Input 등 도메인 없는 시각 요소
  component/           신청 폼, 검색 필터 등 기능 컴포넌트
  screen/              화면 조합과 화면 데이터 연결
  api/                 HTTP 클라이언트와 요청 함수
```

의존 방향은 `route → screen → component → ui`다. 상위에서 ui를 직접 쓰는 것은 허용한다. ui는 도메인 API를 호출하지 않고, component는 screen·라우트를 참조하지 않는다. 다른 screen을 직접 가져와 화면을 재사용하지 않는다.

React는 라우터 또는 App에서 screen을 연결한다. Next.js는 `app/**/page.tsx` 또는 기존 `pages/`를 라우트 진입으로 유지하고 screen을 연결한다. 프레임워크의 layout/loading/error 경계는 예약된 위치에 둔다. 전용 훅·타입·스타일·테스트는 기능 곁에 두고 공용 폴더는 실제 필요가 있을 때 만든다.

## 모델·effort와 초기 설정

설치는 스킬을 복사한다. 프로젝트의 AGENTS.md와 역할별 에이전트 설정은 `$sk-bootstrap` 실행 때 기존 설정을 읽고 서비스에 맞춰 생성·보완한다. 예시 파일을 복사한 것만으로 모델이 실제 전환됐다고 보지 않는다.

| 역할 | 작업 | 교체 가능한 예시 |
|---|---|---|
| 도구 | 파일·종료 코드·형식·타입 검사 | 스크립트와 검사 도구 |
| sk-fast | 좁은 탐색, 확인된 사실 분류·정리 | gpt-6-luna / low |
| sk-worker | 명확한 계약과 완료 조건의 구현 | gpt-6.1-sol / medium |
| sk-deep | 설계 비교, 복잡한 결함·권한·정합성·성능 분석 | gpt-6.1-sol / high |

[모델 정책](sk-bootstrap/references/model-routing.md)과 [에이전트 예시](sk-bootstrap/assets/codex/agents/sk-fast.toml)를 제공한다. 초기화 시 런타임·계정에서 지원하는 모델·effort와 설정 방식을 확인하고 예시를 조정한다. 지원되는 환경에서는 `.codex/agents/*.toml` 또는 위임 도구의 모델·effort 인수를 사용한다. SKILL.md나 스킬 UI 메타데이터는 모델 전환 설정이 아니다. 역할 설정을 지원하지 않으면 현 모델로 처리하고 그 한계를 알린다. [공식 에이전트 설정](https://learn.chatgpt.com/docs/agent-configuration/subagents)

Astra는 사용하지 않는다. 검색 도구를 통한 웹 검색·문서 조회는 허용한다. 브라우저 화면 조작·Computer Use·브라우저 자동화 E2E는 사용하지 않고, UI는 사용자에게 확인 절차를 안내한다.

짧은 작업은 현재 에이전트에서 끝내고, 반복적인 좁은 작업만 묶어 위임한다. 필요 파일·완료 조건·예산만 전달하며 하위 역할이 다시 위임하지 않는다. 재시도와 위임을 포함한 전체 사용량으로 효과를 판단한다. 토큰 사용량을 얻지 못하면 절약 수치를 만들어내지 않는다.

AGENTS.md에는 실제 경로·명령, 웹 의존 규칙, 사용자 결정 범위, 검토 기준, 역할과 반복 예산을 기록한다. 기존 파일은 비교·병합한다. [템플릿](sk-bootstrap/assets/AGENTS.md.template), [공식 AGENTS.md 안내](https://learn.chatgpt.com/docs/agent-configuration/agents-md)

## 반복 검증과 종료 조건

`sk-verify`는 완료 조건 확인 → 검사 → 실패 재현 → 원인 가설 → 최소 수정 → 관련 재검증을 수행한다. 검증만 요청했으면 코드를 수정하지 않는다.

- 프로젝트·사용자가 정한 예산이 우선이다. 별도 설정이 없으면 티켓당 수정 사이클 최대 3회, 경과 시간 15분 중 먼저 도달하는 한도를 쓴다. 초기 검사부터 시간을 센다.
- 여러 티켓을 수행할 때는 전체 예산도 함께 정한다. 역할 변경이나 티켓 분할로 예산을 초기화하지 않는다.
- 같은 실패가 연속 2회이고 새 근거가 없으면 현재 접근을 멈추고 전략을 바꾼다. 전략 변경도 같은 예산을 사용한다.
- 통과한 검사는 관련 코드·계약·환경이 바뀌거나 회귀 우려가 생길 때만 반복한다. 완료 조건을 만족하면 종료한다.
- 예산 소진, 필요한 사용자 결정, 외부 조건으로 진행할 수 없으면 통과·실패·미검증과 마지막 증거·시도·재개 조건을 보고한다. 예산이 끝났다고 완료 처리하지 않는다.

추가 반복은 사용자나 프로젝트 정책에서 예산을 늘린 경우에 수행한다. [상세 루프 정책](sk-verify/references/verification-loop.md)

## 참고한 공개 지침

외부 스킬을 필수 의존성으로 설치하거나 원문 전체를 복제하지 않는다. 아래 자료의 질문 의존관계, 근거 중심 검토, 검증 후 완료 보고 원칙을 참고했다.

- [Matt Pocock: grilling](https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md)
- [Matt Pocock: code-review](https://github.com/mattpocock/skills/blob/main/skills/engineering/code-review/SKILL.md)
- [Superpowers: verification-before-completion](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md)

공식 설정 문서 확인일: 2026-11-04. 실제 프로젝트 초기화에서는 사용하는 도구 버전의 지원 여부를 확인한다.
