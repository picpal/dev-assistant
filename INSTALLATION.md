# dev-assistant 설치 가이드

dev-assistant Claude Code 플러그인의 완전한 설치 및 설정 가이드입니다.

---

## 사전 요구사항

### 필수

- **Claude Code CLI** (버전 ≥1.0.0)
- **Git** (클론 및 업데이트용)

### 권장 포맷터

자동 포맷 훅이 작동하려면 언어별 포맷터를 설치하세요:

#### Java
```bash
# 옵션 1: google-java-format (권장)
brew install google-java-format

# 옵션 2: Gradle Spotless 사용 (프로젝트별)
# build.gradle에 추가:
plugins {
    id 'com.diffplug.spotless' version '6.x.x'
}
```

#### Python
```bash
# black과 isort 설치
pip install black isort

# 또는 pipx 사용 (격리된 설치)
pipx install black
pipx install isort
```

#### TypeScript/JavaScript
```bash
# prettier 전역 설치
npm install -g prettier

# 또는 프로젝트에 로컬 설치
npm install --save-dev prettier
```

---

## 설치 방법

### 방법 1: 영구 설치 (권장)

한 번 설치하면 모든 Claude 세션에서 사용할 수 있습니다.

```bash
# 1. 플러그인을 홈 디렉토리에 클론
cd ~
git clone <repository-url> dev-assistant

# 2. 플러그인을 로드하도록 Claude Code 구성
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# 3. Claude Code 재시작
```

**settings.json이 이미 존재하는 경우:**

`~/.claude/settings.json`을 수동으로 편집하여 플러그인 디렉토리를 추가하세요:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/other-plugin"
  ]
}
```

### 방법 2: 임시 로드

특정 세션에서만 플러그인을 로드합니다.

```bash
# 플러그인 클론
git clone <repository-url> ~/dev-assistant

# 플러그인과 함께 Claude 실행
claude --plugin-dir ~/dev-assistant
```

---

## 검증

### 1. 플러그인 로드 확인

Claude Code를 재시작한 후 플러그인이 로드되었는지 확인하세요:

```bash
# 다음 명령어들이 사용 가능해야 합니다:
/build
/debug
/test
/doc
/quality
/perf
```

### 2. 자동 포맷 검증

테스트 파일을 생성하고 편집하세요:

```bash
# Python 테스트
echo "def test():x=1" > test.py
# 파일 편집 - black이 설치되어 있으면 자동 포맷됩니다

# JavaScript 테스트
echo "const x={a:1,b:2}" > test.js
# 파일 편집 - prettier가 설치되어 있으면 자동 포맷됩니다
```

### 3. 유틸리티 스크립트 테스트

```bash
# 언어 감지 테스트
cd ~/dev-assistant
./utils/language-detection.sh .

# 프레임워크 감지 테스트
./utils/framework-detection.sh .
```

---

## 구성

### 포맷터 구성 파일

자동 포맷 스크립트는 기존 포맷터 구성을 존중합니다:

#### Python - `pyproject.toml`
```toml
[tool.black]
line-length = 88
target-version = ['py39']

[tool.isort]
profile = "black"
```

#### TypeScript - `.prettierrc`
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
```

#### Java - Gradle Spotless
```gradle
spotless {
    java {
        googleJavaFormat()
        removeUnusedImports()
    }
}
```

### 자동 포맷 비활성화 (선택사항)

자동 포맷을 일시적으로 비활성화하려면:

```bash
# hooks.json 편집
vim ~/dev-assistant/hooks/hooks.json

# PostToolUse 섹션 주석 처리
```

---

## 팀 설치

### 팀 리더용: 플러그인 공유

```bash
# 1. 플러그인을 팀 저장소에 푸시
cd ~/dev-assistant
git remote add origin <your-team-repo>
git push -u origin main

# 2. 팀과 설치 지침 공유
```

### 팀 멤버용: 팀 플러그인 설치

```bash
# 1. 팀 플러그인 클론
git clone <team-repo-url> ~/dev-assistant

# 2. Claude 구성
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# 3. Claude Code 재시작
```

### 팀 플러그인 업데이트

```bash
# 최신 업데이트 가져오기
cd ~/dev-assistant
git pull

# 변경사항 적용을 위해 Claude Code 재시작
```

---

## 문제 해결

### 플러그인이 로드되지 않음

**문제**: `/build`, `/debug` 같은 명령어를 사용할 수 없음

**해결방법**:

1. 플러그인 디렉토리 경로 확인:
```bash
cat ~/.claude/settings.json
# pluginDirectories에 ~/dev-assistant가 포함되어 있는지 확인
```

2. plugin.json 존재 확인:
```bash
ls -la ~/dev-assistant/.claude-plugin/plugin.json
```

3. 수동 로드 시도:
```bash
claude --plugin-dir ~/dev-assistant
```

### 자동 포맷이 작동하지 않음

**문제**: Edit/Write 후 파일이 포맷되지 않음

**해결방법**:

1. 포맷터 설치 확인:
```bash
# Java
which google-java-format

# Python
which black
which isort

# TypeScript
which prettier
```

2. 누락된 포맷터 설치 (사전 요구사항 참조)

3. 스크립트 권한 확인:
```bash
ls -l ~/dev-assistant/hooks/scripts/auto-format.sh
# 다음과 같이 표시되어야 함: -rwxr-xr-x

# 그렇지 않은 경우:
chmod +x ~/dev-assistant/hooks/scripts/auto-format.sh
```

4. 포맷터를 수동으로 테스트:
```bash
# Python
black test.py

# TypeScript
prettier --write test.ts

# Java
google-java-format --replace Test.java
```

### 유틸리티 스크립트가 작동하지 않음

**문제**: 언어/프레임워크 감지 실패

**해결방법**:

1. 스크립트 권한 확인:
```bash
chmod +x ~/dev-assistant/utils/*.sh
```

2. 스크립트를 수동으로 실행하여 오류 확인:
```bash
cd ~/dev-assistant
./utils/language-detection.sh .
./utils/framework-detection.sh .
```

### Git 클론 실패

**문제**: 권한 거부 또는 저장소를 찾을 수 없음

**해결방법**:

1. 저장소 URL 확인
2. Git 자격 증명/SSH 키 확인
3. SSH 대신 HTTPS 시도:
```bash
git clone https://github.com/user/dev-assistant.git
```

---

## 여러 플러그인 사용

dev-assistant를 다른 Claude Code 플러그인과 함께 사용할 수 있습니다:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/document-skills",
    "~/other-plugin"
  ]
}
```

**참고**: 플러그인에 중복되는 명령어가 있는 경우, 목록의 마지막 플러그인이 우선합니다.

---

## 제거

### 플러그인 제거

```bash
# 1. Claude 설정에서 제거
# ~/.claude/settings.json을 편집하고 pluginDirectories에서 ~/dev-assistant 제거

# 2. 플러그인 디렉토리 삭제 (선택사항)
rm -rf ~/dev-assistant

# 3. Claude Code 재시작
```

---

## 고급 설정

### 프로젝트별 플러그인 구성

프로젝트 루트에 `.claude/settings.local.json`을 생성하세요:

```json
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
```

이것은 해당 프로젝트에 대해서만 전역 설정을 재정의합니다.

### 커스텀 유틸리티 스크립트

팀의 필요에 맞게 유틸리티 스크립트를 커스터마이징할 수 있습니다:

```bash
# 새로운 언어를 추가하기 위해 언어 감지 편집
vim ~/dev-assistant/utils/language-detection.sh

# 커스텀 프레임워크를 추가하기 위해 프레임워크 감지 편집
vim ~/dev-assistant/utils/framework-detection.sh
```

편집 후 팀 저장소에 커밋하고 푸시하세요.

---

## 시스템 요구사항

### 운영 체제
- macOS (테스트됨)
- Linux (작동할 것으로 예상)
- Windows with WSL (작동할 것으로 예상)

### 디스크 공간
- 플러그인 파일용 ~10 MB
- 포맷터 도구용 추가 공간 (다양함)

### 네트워크
- 초기 Git 클론에 필요
- `/doc` 명령어에 필요 (온라인 문서 검색)
- 오프라인 플러그인 기능에는 필요하지 않음

---

## 도움 받기

### 문서
- 메인 README: [README.md](./README.md)
- 사용 예제: [EXAMPLES.md](./EXAMPLES.md) (출시 예정)
- 아키텍처 문서: plan 파일 참조

### 지원
- GitHub Issues에 문제 보고
- 해결책을 위해 기존 이슈 확인
- 플러그인 관리자에게 문의 (plugin.json 참조)

---

## 다음 단계

설치 후:

1. **[README.md](./README.md)의 빠른 시작 예제 시도**
2. **전체 워크플로우를 확인하기 위해 `/build` 실행**
3. **개별 명령어 테스트**: `/debug`, `/test`, `/doc`, `/quality`, `/perf`
4. **팀의 코드 스타일에 맞게 포맷터 구성 커스터마이징**
5. **팀 설치 가이드를 사용하여 팀과 공유**

---

dev-assistant와 함께 즐거운 코딩 되세요! ⚡
