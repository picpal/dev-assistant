# dev-assistant Installation Guide

Complete installation and setup guide for the dev-assistant Claude Code plugin.

---

## Prerequisites

### Required

- **Claude Code CLI** (version ≥1.0.0)
- **Git** (for cloning and updates)

### Recommended Formatters

For auto-format hooks to work, install language-specific formatters:

#### Java
```bash
# Option 1: google-java-format (recommended)
brew install google-java-format

# Option 2: Use Gradle Spotless (project-specific)
# Add to build.gradle:
plugins {
    id 'com.diffplug.spotless' version '6.x.x'
}
```

#### Python
```bash
# Install black and isort
pip install black isort

# Or using pipx (isolated installation)
pipx install black
pipx install isort
```

#### TypeScript/JavaScript
```bash
# Install prettier globally
npm install -g prettier

# Or install locally in your project
npm install --save-dev prettier
```

---

## Installation Methods

### Method 1: Permanent Installation (Recommended)

Install once, use in all Claude sessions.

```bash
# 1. Clone the plugin to your home directory
cd ~
git clone <repository-url> dev-assistant

# 2. Configure Claude Code to load the plugin
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# 3. Restart Claude Code
```

**If settings.json already exists:**

Edit `~/.claude/settings.json` manually and add the plugin directory:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/other-plugin"
  ]
}
```

### Method 2: Temporary Load

Load the plugin for a specific session only.

```bash
# Clone the plugin
git clone <repository-url> ~/dev-assistant

# Run Claude with the plugin
claude --plugin-dir ~/dev-assistant
```

---

## Verification

### 1. Check Plugin Loaded

After restarting Claude Code, verify the plugin is loaded:

```bash
# The following commands should be available:
/build
/debug
/test
/doc
/quality
/perf
```

### 2. Verify Auto-Format

Create a test file and edit it:

```bash
# Python test
echo "def test():x=1" > test.py
# Edit the file - it should auto-format if black is installed

# JavaScript test
echo "const x={a:1,b:2}" > test.js
# Edit the file - it should auto-format if prettier is installed
```

### 3. Test Utility Scripts

```bash
# Test language detection
cd ~/dev-assistant
./utils/language-detection.sh .

# Test framework detection
./utils/framework-detection.sh .
```

---

## Configuration

### Formatter Configuration Files

The auto-format scripts respect existing formatter configurations:

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

### Disable Auto-Format (Optional)

To temporarily disable auto-format:

```bash
# Edit hooks.json
vim ~/dev-assistant/hooks/hooks.json

# Comment out the PostToolUse section
```

---

## Team Installation

### For Team Leaders: Share the Plugin

```bash
# 1. Push plugin to team repository
cd ~/dev-assistant
git remote add origin <your-team-repo>
git push -u origin main

# 2. Share installation instructions with team
```

### For Team Members: Install Team Plugin

```bash
# 1. Clone team plugin
git clone <team-repo-url> ~/dev-assistant

# 2. Configure Claude
mkdir -p ~/.claude
cat >> ~/.claude/settings.json << 'EOF'
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
EOF

# 3. Restart Claude Code
```

### Updating Team Plugin

```bash
# Pull latest updates
cd ~/dev-assistant
git pull

# Restart Claude Code to apply changes
```

---

## Troubleshooting

### Plugin Not Loading

**Issue**: Commands like `/build`, `/debug` not available

**Solutions**:

1. Check plugin directory path:
```bash
cat ~/.claude/settings.json
# Verify pluginDirectories includes ~/dev-assistant
```

2. Check plugin.json exists:
```bash
ls -la ~/dev-assistant/.claude-plugin/plugin.json
```

3. Try loading manually:
```bash
claude --plugin-dir ~/dev-assistant
```

### Auto-Format Not Working

**Issue**: Files not formatting after Edit/Write

**Solutions**:

1. Check formatter installation:
```bash
# Java
which google-java-format

# Python
which black
which isort

# TypeScript
which prettier
```

2. Install missing formatters (see Prerequisites)

3. Check script permissions:
```bash
ls -l ~/dev-assistant/hooks/scripts/auto-format.sh
# Should show: -rwxr-xr-x

# If not:
chmod +x ~/dev-assistant/hooks/scripts/auto-format.sh
```

4. Test formatter manually:
```bash
# Python
black test.py

# TypeScript
prettier --write test.ts

# Java
google-java-format --replace Test.java
```

### Utility Scripts Not Working

**Issue**: Language/framework detection fails

**Solutions**:

1. Check script permissions:
```bash
chmod +x ~/dev-assistant/utils/*.sh
```

2. Run scripts manually to see errors:
```bash
cd ~/dev-assistant
./utils/language-detection.sh .
./utils/framework-detection.sh .
```

### Git Clone Fails

**Issue**: Permission denied or repository not found

**Solutions**:

1. Check repository URL
2. Verify Git credentials/SSH keys
3. Try HTTPS instead of SSH:
```bash
git clone https://github.com/user/dev-assistant.git
```

---

## Multiple Plugins

You can use dev-assistant alongside other Claude Code plugins:

```json
{
  "pluginDirectories": [
    "~/dev-assistant",
    "~/document-skills",
    "~/other-plugin"
  ]
}
```

**Note**: If plugins have overlapping commands, the last one in the list takes precedence.

---

## Uninstallation

### Remove Plugin

```bash
# 1. Remove from Claude settings
# Edit ~/.claude/settings.json and remove ~/dev-assistant from pluginDirectories

# 2. Delete plugin directory (optional)
rm -rf ~/dev-assistant

# 3. Restart Claude Code
```

---

## Advanced Setup

### Project-Specific Plugin Configuration

Create `.claude/settings.local.json` in your project root:

```json
{
  "pluginDirectories": [
    "~/dev-assistant"
  ]
}
```

This overrides global settings for that project only.

### Custom Utility Scripts

You can customize utility scripts for your team's needs:

```bash
# Edit language detection to add new languages
vim ~/dev-assistant/utils/language-detection.sh

# Edit framework detection to add custom frameworks
vim ~/dev-assistant/utils/framework-detection.sh
```

After editing, commit and push to team repository.

---

## System Requirements

### Operating Systems
- macOS (tested)
- Linux (should work)
- Windows with WSL (should work)

### Disk Space
- ~10 MB for plugin files
- Additional space for formatter tools (varies)

### Network
- Required for initial Git clone
- Required for `/doc` command (online documentation search)
- Not required for offline plugin functionality

---

## Getting Help

### Documentation
- Main README: [README.md](./README.md)
- Usage examples: [EXAMPLES.md](./EXAMPLES.md) (coming soon)
- Architecture docs: See plan file

### Support
- Report issues on GitHub Issues
- Check existing issues for solutions
- Contact plugin maintainer (see plugin.json)

---

## Next Steps

After installation:

1. **Try the quick start examples** in [README.md](./README.md)
2. **Run `/build` to see the full workflow**
3. **Test individual commands**: `/debug`, `/test`, `/doc`, `/quality`, `/perf`
4. **Customize formatter configs** for your team's code style
5. **Share with your team** using the Team Installation guide

---

Happy coding with dev-assistant! ⚡
