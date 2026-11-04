# 웹 폴더와 의존 방향

새 웹 코드는 아래 단수 폴더 이름을 사용한다. 경로의 앱 루트는 프로젝트 구조에 맞게 정한다.

```text
src/
  ui/                 Button, Input, Dialog 등 도메인 없는 시각 요소
  component/          신청 폼, 검색 필터 등 기능·도메인 컴포넌트
    application/
      ApplicationForm.tsx
  screen/             URL 단위 화면의 조합과 화면 데이터 연결
    application/
      ApplicationScreen.tsx
  api/                HTTP 클라이언트와 도메인별 요청 함수
  hook/               공유할 근거가 있는 재사용 훅
  lib/                프레임워크 연결과 순수 공통 함수
  type/               실제로 공유되는 타입
```

`hook`, `lib`, `type`은 필요할 때 만든다. 컴포넌트 전용 타입·훅·스타일·테스트는 해당 컴포넌트 곁에 둔다. 비즈니스 로직을 `lib` 한 곳에 모으지 않는다.

## 각 계층의 책임

| 계층 | 책임 | 의존 규칙 |
|---|---|---|
| 라우트 | URL 연결, 라우트 경계의 로딩·오류, 메타데이터·프레임워크 진입 | screen과 하위 계층 참조 가능 |
| screen | 화면 조합, 화면 단위 데이터·상태 연결, 행동 전달 | component와 ui 참조 가능; 다른 screen 직접 참조 금지 |
| component | 재사용 가능한 기능·도메인 조각, 명확한 props와 이벤트 | ui와 낮은 계층 참조 가능; screen·라우트 참조 금지 |
| ui | 도메인에 독립적인 표현과 기본 상호작용 | 다른 ui·표현 유틸 참조 가능; 도메인 API·screen·component 참조 금지 |

주 의존 방향은 `route → screen → component → ui`다. 상위 계층이 ui를 직접 쓰는 것은 허용한다. 역방향 데이터 전달은 props·콜백·합의된 상태 소유자를 사용한다.

## React와 Next.js

- React: 라우터 설정이나 `App.tsx`에서 screen을 연결한다. URL마다 라우터를 추가할 필요는 없다.
- Next.js App Router: `src/app/**/page.tsx`가 screen을 불러온다. 페이지의 도메인 UI는 screen에 둔다. `layout`, `loading`, `error` 등 프레임워크 경계 파일은 app에 유지한다.
- Next.js Pages Router: `src/pages`는 예약된 라우팅 디렉터리로만 쓰고 화면 구현은 screen에 둔다.
- 서버에서만 쓸 모듈과 비밀 값은 클라이언트 의존 그래프에 넣지 않는다. 공유 barrel export가 서버 모듈을 클라이언트에 끌어들이지 않는지 확인한다.

```tsx
// src/app/applications/page.tsx (Next.js 예시)
import { ApplicationScreen } from '@/screen/application/ApplicationScreen';

export default function Page() {
  return <ApplicationScreen />;
}
```

API 호출은 화면 데이터 연결이나 기능 훅에서 시작하고 `api/`의 요청 함수를 사용한다. 단일 기능에만 필요한 요청 코드는 기능 곁에 둘 수 있다. ui는 요청을 직접 수행하지 않는다.

기존 폴더명과 충돌하면 적용 범위를 기록하고 새 기능부터 점진적으로 맞춘다. 폴더를 맞추기 위해 동작과 관계없는 대규모 리팩터링을 하지 않는다.
