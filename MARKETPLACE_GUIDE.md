# Claude Code 마켓플레이스 작동 원리 가이드

> dev-assistant 플러그인의 마켓플레이스 배포 및 사용 방법 완벽 가이드

## 목차
1. [마켓플레이스 개념](#마켓플레이스-개념)
2. [설치 프로세스](#설치-프로세스)
3. [제작자 vs 사용자 관점](#제작자-vs-사용자-관점)
4. [업데이트 방법](#업데이트-방법)
5. [파일 구조](#파일-구조)
6. [FAQ](#faq)

---

## 마켓플레이스 개념

### 핵심 이해

Claude Code의 마켓플레이스는 **분산형 시스템**입니다:

- ❌ **중앙 집중식 앱스토어 아님** (App Store, npm registry 같은 게 아님)
- ✅ **Git 저장소 기반 배포 시스템** (GitHub/GitLab 저장소를 직접 참조)
- ✅ **사용자가 명시적으로 마켓플레이스를 추가**해야 함

### 마켓플레이스 종류

#### 1. 공식 마켓플레이스 (Anthropic 관리)
```bash
/plugin marketplace list
```
출력:
```
• claude-code-plugins        ← Anthropic 공식 플러그인
• anthropic-agent-skills     ← Anthropic 공식 스킬
```
- 모든 Claude Code 사용자에게 **기본 제공**
- Anthropic이 직접 관리
- 자동으로 등록됨

#### 2. 개인/팀 마켓플레이스 (사용자 추가)
```bash
• dev-assistant-marketplace  ← 사용자가 직접 추가한 마켓플레이스
```
- GitHub/GitLab 저장소
- **각 사용자가 직접 추가**해야 사용 가능
- 자동으로 모든 사람에게 보이지 않음

---

## 설치 프로세스

### 전체 흐름도

```
GitHub 저장소              내 PC                  사용 가능
    │                       │                       │
    │  1. marketplace add   │                       │
    ├──────────────────────>│                       │
    │   (마켓플레이스 등록)   │                       │
    │                       │                       │
    │  2. plugin install    │                       │
    ├──────────────────────>│                       │
    │   (코드 다운로드)       │                       │
    │                       │                       │
    │                       │  3. 재시작             │
    │                       ├──────────────────────>│
    │                       │                       │
    │                       │  /build 사용!         │
```

---

### 단계별 상세 설명

#### 1️⃣ 마켓플레이스 등록

```bash
/plugin marketplace add picpal/dev-assistant
```

**Claude Code가 내부적으로 하는 일:**

1. **GitHub 접근**
   ```
   https://github.com/picpal/dev-assistant 접속
   ```

2. **marketplace.json 읽기**
   ```
   .claude-plugin/marketplace.json 파일 찾기
   ```

3. **마켓플레이스 정보 파싱**
   ```json
   {
     "name": "dev-assistant-marketplace",
     "owner": { ... },
     "plugins": [
       {
         "name": "dev-assistant",
         "source": "./",  ← 현재 저장소가 플러그인!
         ...
       }
     ]
   }
   ```

4. **로컬 캐시에 저장**
   ```
   ~/.claude/marketplaces/dev-assistant-marketplace/
   ```

**결과:**
- ✅ 마켓플레이스가 내 PC에 등록됨
- ✅ 이제 이 마켓플레이스의 플러그인을 설치할 수 있음
- ❌ 아직 플러그인 코드는 다운로드되지 않음

---

#### 2️⃣ 플러그인 설치

```bash
/plugin install dev-assistant@dev-assistant
```

형식: `/plugin install <플러그인이름>@<마켓플레이스이름>`

**Claude Code가 내부적으로 하는 일:**

1. **마켓플레이스에서 플러그인 찾기**
   ```
   dev-assistant 마켓플레이스에서
   dev-assistant 플러그인 검색
   ```

2. **source 경로 확인**
   ```json
   "source": "./"  ← 저장소 루트가 플러그인
   ```

3. **GitHub에서 코드 다운로드**
   ```
   git clone https://github.com/picpal/dev-assistant
   또는
   git fetch (이미 있으면 업데이트)
   ```

4. **로컬에 설치**
   ```
   ~/.claude/plugins/dev-assistant/
   ├── .claude-plugin/
   │   ├── marketplace.json
   │   └── plugin.json
   ├── agents/
   ├── skills/
   ├── commands/
   └── ...
   ```

5. **plugin.json 검증**
   ```
   필수 필드 확인 (name, version, author 등)
   스키마 검증 (bugs 같은 미지원 필드 제거)
   ```

**결과:**
- ✅ 플러그인 코드가 내 PC에 다운로드됨
- ✅ 설치 완료
- ⚠️ 아직 Claude Code가 플러그인을 인식하지 못함

---

#### 3️⃣ Claude Code 재시작

```bash
# Claude Code를 재시작하면
```

**Claude Code가 내부적으로 하는 일:**

1. **플러그인 디렉토리 스캔**
   ```
   ~/.claude/plugins/ 디렉토리의 모든 플러그인 탐색
   ```

2. **plugin.json 로드**
   ```
   각 플러그인의 메타데이터 읽기
   ```

3. **명령어 등록**
   ```
   commands/ 디렉토리의 .md 파일들을 명령어로 등록
   /build, /debug, /test, /doc, /quality, /perf
   ```

4. **에이전트/스킬 로드**
   ```
   agents/ 와 skills/ 디렉토리 로드
   ```

**결과:**
- ✅ 플러그인 활성화
- ✅ 명령어 사용 가능!

---

#### 4️⃣ 사용!

```bash
/build "새로운 기능 만들기"
/debug "에러 수정"
/test UserService.java
```

---

## 제작자 vs 사용자 관점

### 👨‍💻 제작자 (플러그인 개발자) - 당신

#### 개발 단계

```bash
# 1. 로컬 디렉토리를 마켓플레이스로 등록
/plugin marketplace add /Users/picpal/Desktop/workspace/dev-assistant

# 2. 로컬 플러그인 설치
/plugin install dev-assistant@dev-assistant-marketplace

# 3. 테스트
/build "테스트 기능"

# 4. 코드 수정 후 마켓플레이스 업데이트
/plugin marketplace update dev-assistant-marketplace
```

#### 배포 단계

```bash
# 1. 필수 파일 확인
.claude-plugin/marketplace.json  ✓
.claude-plugin/plugin.json       ✓
LICENSE                          ✓
README.md                        ✓

# 2. Git 커밋 & 푸시
git add .
git commit -m "Release v1.0.0"
git push origin main

# 3. (선택) GitHub Release 생성
gh release create v1.0.0
```

#### 사용자에게 공유

```markdown
# README.md에 추가
## 설치 방법

1. 마켓플레이스 추가:
\`\`\`bash
/plugin marketplace add picpal/dev-assistant
\`\`\`

2. 플러그인 설치:
\`\`\`bash
/plugin install dev-assistant@dev-assistant
\`\`\`
```

---

### 👥 사용자 (플러그인 사용자)

#### 설치

```bash
# 1. GitHub 저장소를 마켓플레이스로 추가
/plugin marketplace add picpal/dev-assistant

# 2. 플러그인 설치
/plugin install dev-assistant@dev-assistant

# 3. Claude Code 재시작

# 4. 사용!
/build "내 기능 만들기"
```

#### 확인

```bash
# 마켓플레이스 목록
/plugin marketplace list

# 설치된 플러그인 목록
/plugin list
```

---

## 업데이트 방법

### 📤 제작자: 새 버전 배포

#### 1. 코드 수정
```bash
# agents, skills, commands 등 수정
vim agents/tactical/debugger.md
```

#### 2. 버전 업데이트 (권장)
```bash
# plugin.json
{
  "version": "1.0.0" → "1.1.0"
}

# marketplace.json
{
  "plugins": [{
    "version": "1.0.0" → "1.1.0"
  }]
}

# CHANGELOG.md
## [1.1.0] - 2025-01-15
### Changed
- Enhanced debugger agent
```

#### 3. Git 푸시
```bash
git add .
git commit -m "Release v1.1.0: Enhanced debugger"
git tag v1.1.0
git push origin main --tags
```

**그게 전부입니다!** GitHub에 푸시하면 끝!

---

### 📥 사용자: 업데이트 받기

```bash
# 1. 마켓플레이스 업데이트 (최신 버전 확인)
/plugin marketplace update dev-assistant

# 2. 플러그인 재설치 (필요한 경우)
/plugin install dev-assistant@dev-assistant

# 또는 플러그인만 업데이트
/plugin update dev-assistant
```

**자동 업데이트:**
- Claude Code가 주기적으로 마켓플레이스를 체크할 수도 있음 (버전에 따라 다름)
- 수동으로 `/plugin marketplace update` 실행하는 것이 확실

---

## 파일 구조

### GitHub 저장소 구조

```
picpal/dev-assistant/
├── .claude-plugin/
│   ├── marketplace.json     ← 마켓플레이스 정의
│   └── plugin.json          ← 플러그인 메타데이터
│
├── agents/                  ← 에이전트 파일들
│   ├── tactical/
│   │   ├── debugger.md
│   │   ├── tester.md
│   │   └── ...
│   └── workflow/
│       ├── code-architect.md
│       └── ...
│
├── skills/                  ← 스킬 (지식 베이스)
│   ├── architecture-patterns/
│   ├── debugging-patterns/
│   └── ...
│
├── commands/                ← 명령어 정의
│   ├── build.md            ← /build 명령어
│   ├── debug.md            ← /debug 명령어
│   └── ...
│
├── hooks/                   ← 훅 설정
│   ├── hooks.json
│   └── scripts/
│
├── LICENSE                  ← 라이선스
├── README.md                ← 설치 방법 포함
├── CHANGELOG.md             ← 버전 이력
└── MARKETPLACE_SETUP.md     ← 설정 가이드
```

### 사용자 PC 구조

```
~/.claude/
├── marketplaces/            ← 등록된 마켓플레이스
│   └── dev-assistant-marketplace/
│       └── marketplace.json (캐시)
│
├── plugins/                 ← 설치된 플러그인
│   └── dev-assistant/      ← GitHub에서 다운로드된 코드
│       ├── .claude-plugin/
│       ├── agents/
│       ├── skills/
│       ├── commands/
│       └── ...
│
└── settings.json            ← Claude 설정
```

---

## 핵심 파일 설명

### 1. marketplace.json

```json
{
  "name": "dev-assistant-marketplace",
  "owner": {
    "name": "Picpal",
    "email": "picpal@users.noreply.github.com"
  },
  "plugins": [
    {
      "name": "dev-assistant",
      "source": "./",           ← 핵심! 현재 저장소가 플러그인
      "version": "1.0.0",
      "category": "productivity"
    }
  ]
}
```

**역할:**
- Claude Code에게 "이 저장소는 마켓플레이스야!"라고 알림
- 어떤 플러그인들이 있는지 정의
- `source: "./"` → 현재 저장소 전체가 하나의 플러그인

---

### 2. plugin.json

```json
{
  "name": "dev-assistant",
  "version": "1.0.0",
  "author": {
    "name": "Picpal",
    "email": "picpal@users.noreply.github.com"
  },
  "repository": "https://github.com/picpal/dev-assistant",
  "homepage": "https://github.com/picpal/dev-assistant",
  "hooks": "./hooks/hooks.json"
}
```

**역할:**
- 플러그인 메타데이터
- 버전 정보
- 작성자 정보
- hooks 파일 경로

**주의:**
- ❌ `bugs` 필드는 지원 안 됨 (제거해야 함)
- ✅ `repository`, `homepage`는 선택이지만 권장

---

## FAQ

### Q1: 다른 사람이 자동으로 내 플러그인을 볼 수 있나요?

**A:** ❌ **아니요**

- GitHub에 공개했어도 자동으로 모든 사람에게 보이지 않음
- 각 사용자가 **명시적으로** 마켓플레이스를 추가해야 함:
  ```bash
  /plugin marketplace add picpal/dev-assistant
  ```

---

### Q2: Anthropic 공식 마켓플레이스에 등록되나요?

**A:** ❌ **자동으로는 안 됨**

- `claude-code-plugins` 같은 공식 마켓플레이스는 Anthropic이 관리
- 자동으로 등록되지 않음
- 등록하려면 별도 신청 필요 (Anthropic에 문의)

---

### Q3: 코드를 수정하면 사용자들이 자동으로 업데이트되나요?

**A:** ⚠️ **반자동**

1. **제작자 (당신)**:
   ```bash
   git push origin main  ← 그냥 푸시만 하면 됨
   ```

2. **사용자**:
   ```bash
   /plugin marketplace update dev-assistant  ← 수동 실행 필요
   ```

- Claude Code가 주기적으로 체크할 수도 있지만
- 확실한 방법은 사용자가 직접 업데이트 명령 실행

---

### Q4: 로컬 마켓플레이스 vs GitHub 마켓플레이스 차이?

**A:**

| 항목 | 로컬 마켓플레이스 | GitHub 마켓플레이스 |
|------|-----------------|-------------------|
| 추가 명령어 | `/plugin marketplace add /path/to/dir` | `/plugin marketplace add picpal/dev-assistant` |
| 위치 | 내 PC의 디렉토리 | GitHub 저장소 |
| 용도 | 개발/테스트 | 배포/공유 |
| 업데이트 | 코드 수정 → 마켓플레이스 업데이트 | Git push → 사용자가 업데이트 |
| 공유 | 불가능 | 누구나 접근 가능 |

---

### Q5: marketplace.json의 source: "./" 의미는?

**A:**

```json
{
  "plugins": [
    {
      "name": "dev-assistant",
      "source": "./"     ← 현재 저장소 루트 = 플러그인
    }
  ]
}
```

- `"./"` = 현재 저장소 전체가 하나의 플러그인
- `"./plugins/foo"` = plugins/foo 디렉토리가 플러그인
- `{"source": "github", "repo": "other/plugin"}` = 다른 저장소

**우리의 경우:**
- 저장소 자체가 플러그인이므로 `"./"`
- marketplace.json과 plugin.json이 같은 저장소에 있음

---

### Q6: 버전 관리는 어떻게 하나요?

**A:** SemVer 사용 권장

```
MAJOR.MINOR.PATCH
  │     │     │
  │     │     └─ 버그 수정: 1.0.0 → 1.0.1
  │     └─────── 새 기능: 1.0.0 → 1.1.0
  └───────────── Breaking change: 1.0.0 → 2.0.0
```

**업데이트 체크리스트:**
1. `plugin.json`: `"version": "1.1.0"`
2. `marketplace.json`: `plugins[0].version: "1.1.0"`
3. `CHANGELOG.md`: 변경사항 기록
4. Git tag: `git tag v1.1.0`

---

### Q7: 여러 플러그인을 하나의 마켓플레이스에 담을 수 있나요?

**A:** ✅ **가능합니다**

```json
{
  "name": "my-marketplace",
  "plugins": [
    {
      "name": "plugin-1",
      "source": "./plugins/plugin-1"
    },
    {
      "name": "plugin-2",
      "source": "./plugins/plugin-2"
    },
    {
      "name": "external-plugin",
      "source": {
        "source": "github",
        "repo": "other/plugin"
      }
    }
  ]
}
```

---

### Q8: Private 저장소도 가능한가요?

**A:** ✅ **가능하지만 제한적**

- GitHub private 저장소 사용 가능
- 단, 사용자가 해당 저장소에 접근 권한 있어야 함
- Git credentials 설정 필요
- Public 저장소가 더 간편

---

## 요약

### 🔑 핵심 개념

1. **마켓플레이스 = Git 저장소 참조**
   - 중앙 앱스토어가 아님
   - GitHub/GitLab 저장소를 직접 참조

2. **명시적 추가 필요**
   - 자동으로 모든 사람에게 보이지 않음
   - 각 사용자가 직접 추가해야 함

3. **업데이트 = Git Push**
   - 제작자: Git push
   - 사용자: marketplace update 실행

---

### 📝 단계 요약

#### 제작자 (한 번만)
```bash
1. marketplace.json + plugin.json 생성
2. git push origin main
3. README에 설치 방법 추가
```

#### 사용자 (첫 설치)
```bash
1. /plugin marketplace add picpal/dev-assistant
2. /plugin install dev-assistant@dev-assistant
3. Claude Code 재시작
```

#### 업데이트 (제작자)
```bash
1. 코드 수정
2. git push origin main
```

#### 업데이트 (사용자)
```bash
1. /plugin marketplace update dev-assistant
```

---

## 관련 문서

- **설치 가이드**: [MARKETPLACE_SETUP.md](./MARKETPLACE_SETUP.md)
- **README**: [README.md](./README.md)
- **설치 상세**: [INSTALLATION.md](./INSTALLATION.md)
- **변경 이력**: [CHANGELOG.md](./CHANGELOG.md)
- **공식 문서**: https://code.claude.com/docs/ko/plugin-marketplaces

---

**마지막 업데이트**: 2025-01-01
**작성자**: Picpal
**저장소**: https://github.com/picpal/dev-assistant
