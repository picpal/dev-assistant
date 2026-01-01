# dev-assistant

> Java/Spring Boot, Python, TypeScript/React를 위한 구조화된 기능 개발 워크플로우와 전술적 개발 도구를 결합한 AI 기반 개발 어시스턴트

## 개요

**dev-assistant**는 다음을 결합한 포괄적인 Claude Code 플러그인입니다:
- **구조화된 7단계 기능 개발 워크플로우** (병렬 agent 실행 및 사용자 승인 게이트 포함)
- **빠른 전술적 명령어들** (디버깅, 테스팅, 문서화, 품질 분석, 성능 프로파일링)
- **멀티언어 지원** (자동 감지 및 언어별 패턴 적용)

### 지원 언어 & 프레임워크

- **Java**: Spring Boot, Gradle, Maven, JUnit 5
- **Python**: Flask, FastAPI, Django, pytest
- **TypeScript/React**: Next.js, Jest, React Testing Library

---

## 주요 기능

### 🏗️ 메인 워크플로우: `/build`

기능 개발을 위한 포괄적인 7단계 워크플로우:

```
1. 발견 → 2. 탐색 → 3. 질문 → 4. 아키텍처 → 5. 구현 → 6. 리뷰 → 7. 요약
         (2-3 agents)  (게이트 #1)  (3 agents)    (게이트 #3)  (3 agents)
                                     (게이트 #2)                (게이트 #4)
```

#### 7단계 상세:

1. **발견 (Discovery)** - 요구사항 명확화 및 프로젝트 언어 감지
2. **탐색 (Exploration)** - 2-3개 code-explorer agents를 병렬로 실행하여 코드베이스 분석
3. **질문 (Questions)** - 명확화 질문으로 빈틈 채우기 (**사용자 승인 게이트 #1**)
4. **아키텍처 (Architecture)** - 3가지 접근법을 병렬로 설계: Minimal/Clean/Pragmatic (**사용자 선택 게이트 #2**)
5. **구현 (Implementation)** - 자동 포맷팅과 함께 기능 구축 (**사용자 승인 게이트 #3**)
6. **리뷰 (Review)** - 신뢰도 ≥80 필터링을 적용한 다관점 코드 리뷰 (**사용자 결정 게이트 #4**)
7. **요약 (Summary)** - 구축한 내용과 다음 단계 문서화

#### 핵심 역량:

- ⚡ **병렬 agent 실행**: 2, 4, 6단계에서 2.5x-3x 더 빠름
- 🎯 **신뢰도 기반 필터링**: 신뢰도 ≥80%인 발견사항만 표시 (노이즈 감소)
- 🚪 **4개의 사용자 승인 게이트**: 사용자 제어를 통한 신중하고 의도적인 개발
- 🎨 **자동 포맷 훅**: Java, Python, TypeScript 자동 포맷팅
- 🌍 **멀티언어 인식**: 프로젝트 언어 감지 및 적응
- 🏛️ **3가지 아키텍처 접근법**: Minimal (빠름), Clean (유지보수성), Pragmatic (균형) 중 선택

---

### ⚡ 빠른 명령어들

전체 워크플로우 오버헤드 없이 일상적인 개발 작업에 완벽합니다.

#### `/debug` - 에러 분석 & 수정
```bash
/debug "NullPointerException in UserService.java:42"
/debug <스택 트레이스 붙여넣기>
```
- 멀티언어 에러 분석 (Java/Python/TypeScript)
- 파일:라인 참조와 함께 스택 트레이스 해석
- 근본 원인 식별
- 수정 전/후 코드와 함께 즉시 수정 제안
- 예방 전략

#### `/test` - 테스트 생성 & 실행
```bash
/test UserService.java
/test LoginForm.tsx
```
- 프레임워크 인식 테스트 생성 (JUnit 5, pytest, Jest)
- AAA 패턴 (Arrange-Act-Assert)
- 모킹과 픽스처
- 커버리지 리포팅
- 테스트 자동 실행

#### `/doc` - 문서 검색
```bash
/doc "Spring Boot connection pooling"
/doc "React useEffect cleanup"
```
- 로컬 문서 검색 (README, docstring)
- 온라인 공식 문서 (spring.io, python.org, react.dev)
- API 시그니처와 예제
- 빠른 결과 (속도를 위한 haiku 모델)

#### `/quality` - 코드 품질 분석
```bash
/quality src/services/
/quality UserController.java
```
- SOLID 원칙 검사
- 코드 스멜 감지
- 순환 복잡도 계산
- 리팩토링 제안
- 우선순위가 정해진 개선 로드맵

#### `/perf` - 성능 프로파일링
```bash
/perf database queries
/perf React component rendering
```
- 언어별 프로파일링 (JVM, cProfile, React DevTools)
- 병목 지점 식별 (N+1 쿼리, 재렌더링, 메모리 누수)
- 영향도 추정과 함께 최적화 제안
- 모니터링 메트릭 권장사항

---

## 아키텍처

### 8개의 전문 Agents

#### 워크플로우 Agents (속도를 위한 병렬화)
- **code-explorer** - 코드베이스 발견 및 패턴 인식
  - 2단계에서 2-3개 병렬 실행
  - 읽어야 할 핵심 파일 5-10개 반환
  - 언어별 탐색 패턴

- **code-architect** - 다중 접근법 아키텍처 설계
  - 4단계에서 3개 병렬 실행 (Minimal/Clean/Pragmatic)
  - 구현 청사진 제공
  - 각 접근법의 트레이드오프 분석

- **code-reviewer** - 신뢰도 점수를 포함한 품질 리뷰
  - 6단계에서 3개 병렬 실행 (단순성/버그/규칙)
  - 신뢰도 기반 필터링 (≥80만)
  - 다관점 분석

#### 전술적 Agents (빠른 단일 인스턴스 실행)
- **debugger** - Java/Python/TypeScript 에러 분석 및 수정
- **tester** - 테스트 자동화 및 생성
- **doc-reference** - 문서 검색 (속도를 위해 haiku 사용)
- **code-quality** - 유지보수성 및 SOLID 분석
- **performance-analyzer** - 성능 프로파일링 및 최적화

### 6개의 Skills (지식 베이스)

모든 agents를 위한 포괄적인 참조 자료:

- **`architecture-patterns`** - 설계 접근법 (Minimal/Clean/Pragmatic), 트레이드오프 분석, 멀티언어 패턴
- **`debugging-patterns`** - 멀티언어 에러 패턴 및 디버깅 기법
- **`test-automation`** - 테스팅 프레임워크 모범 사례 (JUnit/pytest/Jest)
- **`documentation-guides`** - 문서화 표준 (Javadoc/Sphinx/JSDoc)
- **`quality-standards`** - SOLID 원칙 및 모범 사례
- **`performance-benchmarks`** - 최적화 기법 및 프로파일링

### 6개의 Commands

- **1개 메인 워크플로우**: `/build` (7단계 기능 개발)
- **5개 빠른 명령어**: `/debug`, `/test`, `/doc`, `/quality`, `/perf`

---

## 설치

### 사전 요구사항

- **Claude Code CLI** (버전 ≥1.0.0)
- **Git** (클론 및 업데이트용)
- **언어별 포맷터** (선택사항이지만 권장):
  - Java: `google-java-format` 또는 Gradle Spotless
  - Python: `black`, `isort`
  - TypeScript: `prettier`

### 플러그인 설치

```bash
# 플러그인을 홈 디렉토리에 클론
cd ~
git clone <repository-url> dev-assistant

# Claude가 플러그인을 사용하도록 설정
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# Claude Code 재시작
```

**`~/.claude/settings.json`이 이미 존재하는 경우:**

파일을 수동으로 편집하여 `pluginDirectories` 배열에 `~/dev-assistant`를 추가:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/other-plugin"
  ]
}
```

자세한 설치 지침, 문제 해결 및 팀 설정은 [INSTALLATION.md](./INSTALLATION.md)를 참조하세요.

---

## 빠른 시작

### 예제 1: 새 기능 구축

```bash
/build JWT 토큰을 사용한 사용자 인증 추가
```

**워크플로우 진행:**
1. ✅ 프로젝트 언어 감지 (Java/Python/TypeScript)
2. ⚡ 코드베이스 이해를 위해 2-3개 code-explorer agents를 병렬로 실행
3. ❓ 인증 요구사항에 대한 명확화 질문 (답변 대기)
4. 🏛️ 3가지 아키텍처 접근법 제시:
   - **Minimal**: 세션 스토리지를 사용한 빠른 JWT 구현 (2-3시간)
   - **Clean**: 전략 패턴을 적용한 완전한 인증 서비스 (2-3일)
   - **Pragmatic**: 쉬운 확장성을 가진 균형잡힌 접근법 (1-2일)
5. 🛠️ 선택한 접근법으로 자동 포맷팅과 함께 구현
6. 🔍  3개 병렬 리뷰어로 리뷰 (단순성/버그/규칙, 신뢰도 ≥80)
7. 📄 변경사항 요약 및 다음 단계 제안

### 예제 2: 빠른 디버깅

```bash
/debug "UserService.java:42에서 NullPointerException"
```

**결과:**
- 근본 원인 분석 (예: "빈 Optional에서 Optional.get() 호출")
- 수정 전/후 코드와 함께 즉시 수정
- 예방 전략 (예: "Optional.map() 또는 orElseThrow() 사용")
- 추가할 테스트 권장사항

### 예제 3: 테스트 생성

```bash
/test src/services/UserService.java
```

**결과:**
- @Test 어노테이션이 있는 JUnit 5 테스트
- Mockito를 사용한 모킹 설정
- AAA 패턴 (Arrange-Act-Assert)
- 엣지 케이스 커버리지
- 바로 실행 가능한 테스트

---

## 언제 무엇을 사용할까?

### `/build` 워크플로우를 사용할 때:
- ✅ 완전한 새 기능 구축
- ✅ 그린필드 프로젝트 초기화
- ✅ 아키텍처 결정이 필요한 복잡한 변경
- ✅ 구조화된 가이드와 코드 리뷰가 필요할 때
- ✅ 여러 접근법 평가가 필요할 때 (Minimal/Clean/Pragmatic)

### 빠른 명령어를 사용할 때:
- ⚡ 특정 에러 디버깅 (`/debug`)
- ⚡ 기존 코드에 테스트 추가 (`/test`)
- ⚡ 문서 검색 (`/doc`)
- ⚡ 특정 모듈 분석 (`/quality`)
- ⚡ 특정 성능 이슈 프로파일링 (`/perf`)

**경험 법칙**: 전략적 작업에는 `/build`, 전술적 작업에는 빠른 명령어 사용.

---

## 핵심 기능

### 🌍 멀티언어 지원

프로젝트를 자동으로 감지하고 적응:

**Java/Spring Boot:**
- 계층형 아키텍처 (Controller → Service → Repository)
- Spring 어노테이션 및 의존성 주입
- JUnit 5 + Mockito 테스트
- Google Java Format 또는 Spotless

**Python:**
- FastAPI/Flask/Django 패턴
- 타입 힌트 및 Pydantic 검증
- 픽스처를 사용한 pytest
- Black + isort 포맷팅

**TypeScript/React:**
- 훅을 사용한 함수형 컴포넌트
- TypeScript strict 모드
- Jest + React Testing Library
- Prettier 포맷팅

### ⚡ 병렬 Agent 실행

2, 4, 6단계에서 여러 agents를 동시에 실행:

```
2단계: 2-3개 code-explorer agents    → 2.5배 빠름
4단계: 3개 code-architect agents     → 3배 빠름
6단계: 3개 code-reviewer agents      → 3배 빠름
```

### 🎯 신뢰도 기반 필터링

코드 리뷰어가 발견사항을 0-100으로 점수 매김. 신뢰도 ≥80인 이슈만 표시:

```
0-25:  확신 없음 / 거짓 양성
25-50: 실제일 수 있음 / 사소한 지적
50-75: 실제이지만 중요하지 않음
75-90: 매우 확신 / 중요
90-100: 절대 확실 / 치명적
```

노이즈를 줄이고 실제 문제에 집중합니다.

### 🚪 사용자 승인 게이트

당신이 제어권을 유지하는 4개의 중요한 결정 지점:

1. **게이트 #1 (3단계)**: 명확화 질문에 답변
2. **게이트 #2 (4단계)**: 아키텍처 접근법 선택 (Minimal/Clean/Pragmatic)
3. **게이트 #3 (5단계)**: 구현 시작 승인
4. **게이트 #4 (6단계)**: 리뷰 발견사항에 대한 결정 (지금 수정/나중에/진행)

### 🎨 자동 포맷 훅

Edit/Write 작업 후 코드가 자동으로 포맷팅됨:

- **Java**: Spotless 또는 google-java-format
- **Python**: black + isort
- **TypeScript**: prettier

프로젝트 설정 파일(`.prettierrc`, `pyproject.toml` 등)을 통해 포맷터를 구성하세요.

---

## 템플릿

### 그린필드 프로젝트 템플릿

모범 사례로 새 프로젝트 시작:

- **Java/Spring Boot**: Gradle, JPA, Security, Flyway 마이그레이션
- **Python/FastAPI**: Poetry, SQLAlchemy, Alembic, async 지원
- **TypeScript/React**: Vite, React Router, TypeScript strict 모드

프로젝트 구조는 `templates/greenfield/`를 참조하세요.

### 기능 템플릿

멀티언어 예제를 포함한 일반적인 기능 패턴:

- CRUD 작업
- 인증 및 권한 부여
- 파일 업로드 및 저장
- 페이지네이션 및 필터링
- 백그라운드 작업
- 실시간 업데이트 (WebSocket/SSE)
- 검색 기능
- 캐싱 레이어
- 속도 제한
- 감사 로깅

구현 가이드는 `templates/feature-templates/`를 참조하세요.

---

## 개발 상태

### ✅ 완료 (v1.0)

- ✅ **Week 1**: 핵심 인프라 (훅, 유틸리티, 플러그인 설정)
- ✅ **Week 2-3**: 워크플로우 agents (code-explorer, code-architect, code-reviewer)
- ✅ **Week 4**: 전술적 agents (debugger, tester, doc-reference, code-quality, performance-analyzer)
- ✅ **Week 5**: Commands (`/build` 워크플로우 + 5개 전술적 명령어)
- ✅ **Week 6**: 템플릿 (그린필드 + 기능 템플릿)

### 🚧 진행 중

- 🚧 **Week 7**: 통합 테스팅 및 실제 검증
- 🚧 **Week 8**: 확장된 문서화 및 예제

### 📊 통계

- **46개 파일** 생성
- **11,435줄** 코드
- **8개 전문 agents** (3개 워크플로우 + 5개 전술)
- **6개 commands** (1개 메인 + 5개 빠른)
- **6개 포괄적 skills**
- **3개 언어** 완전 지원

---

## 주요 차별화 요소

### vs feature-dev 플러그인

- ✅ **멀티언어 지원**: Java/Python/TypeScript (feature-dev는 언어 무관)
- ✅ **빠른 전술적 명령어**: 일상 작업을 위한 5개 빠른 명령어
- ✅ **자동 포맷 훅**: 자동 코드 포맷팅
- ✅ **스킬 시스템**: 체계화된 지식 베이스
- ✅ **기능 템플릿**: 일반 기능을 위한 재사용 가능한 패턴

### vs chatops-plugin

- ✅ **구조화된 7단계 워크플로우**: 체계적인 기능 개발
- ✅ **병렬 agent 실행**: 핵심 단계에서 2.5x-3x 빠름
- ✅ **사용자 승인 게이트**: 신중한 개발을 위한 4개 결정 지점
- ✅ **그린필드 템플릿**: 모범 사례로 새 프로젝트 시작
- ✅ **신뢰도 기반 필터링**: ≥80 임계값으로 리뷰 노이즈 감소

### 두 세계의 장점

dev-assistant는 다음을 결합:
- **feature-dev의** 체계적인 워크플로우와 다관점 분석
- **chatops-plugin의** 멀티언어 전문성과 전술적 도구
- **새로운 혁신**: 병렬 실행, 신뢰도 필터링, 3가지 접근법 아키텍처

---

## 예제

### 예제 워크플로우: 사용자 관리 추가

```bash
/build 역할 기반 권한이 있는 사용자 CRUD 작업 추가
```

**1단계 (발견)**: Java/Spring Boot 프로젝트 감지

**2단계 (탐색)**: 3개 탐색기를 병렬로 실행:
- 탐색기 1: 유사한 CRUD 기능 찾기 (Product, Order)
- 탐색기 2: 보안 및 인증 패턴 매핑
- 탐색기 3: 테스팅 규칙 분석
- **반환**: 읽어야 할 핵심 파일 8개

**3단계 (질문)**: 다음을 질문:
- 기존 User 엔티티를 재사용할까요, 새로 만들까요?
- 어떤 역할이 필요한가요? (ADMIN, USER, GUEST?)
- RESTful API인가요, GraphQL인가요?
- 페이지네이션이 필요한가요?

**4단계 (아키텍처)**: 3가지 접근법 제시:
- **Minimal**: UserController 확장, CRUD 엔드포인트 추가 (3시간)
- **Clean**: 새 UserService + DTO + 검증 + 테스트 (2일)
- **Pragmatic**: 서비스 레이어 + 기본 DTO + 통합 테스트 (1일) ⭐ 권장

**5단계 (구현)**: Pragmatic 선택, 다음 구축:
- 비즈니스 로직을 포함한 `UserService.java`
- `CreateUserRequest.java`, `UserResponse.java` DTO
- 새 엔드포인트가 추가된 `UserController.java`
- 모킹을 사용한 `UserServiceTest.java`
- Spotless로 자동 포맷팅

**6단계 (리뷰)**: 3개 리뷰어가 발견:
- **단순성**: 신뢰도 ≥80 이슈 없음 ✅
- **버그**: update에서 null 체크 누락 (신뢰도 90) ⚠️
- **규칙**: DTO에 `@Valid` 사용해야 함 (신뢰도 85) ⚠️
- **사용자 결정**: 지금 수정 → 두 이슈 모두 해결

**7단계 (요약)**: 문서화:
- 4개 파일 생성, 2개 수정
- 역할 검증을 포함한 사용자 CRUD 추가
- Pragmatic 접근법 선택
- 다음 단계: 통합 테스트 추가, API 문서 업데이트

---

## 기여

기여를 환영합니다! 이 플러그인은 feature-dev와 chatops-plugin의 패턴을 결합합니다.

### 기여 가능 영역

- 추가 언어 지원 (Go, Rust 등)
- 더 많은 기능 템플릿
- 향상된 스킬 컨텐츠
- 통합 테스트
- 문서화 및 예제

---

## 라이선스

MIT License

---

## 지원

- **이슈**: [GitHub Issues](https://github.com/your-repo/dev-assistant/issues)
- **문서**: `INSTALLATION.md` 및 이 저장소의 파일들 참조
- **템플릿**: `templates/` 디렉토리 참조
- **스킬 참조**: `skills/` 디렉토리 참조

---

## 크레딧

다음의 최고 패턴들을 결합하여 구축 ⚡:
- **feature-dev**: 체계적인 워크플로우와 아키텍처 중심
- **chatops-plugin**: 멀티언어 전문성과 전술적 도구

다음으로 강화:
- 병렬 agent 실행
- 신뢰도 기반 필터링
- 다중 아키텍처 접근법
- 포괄적인 스킬 시스템
