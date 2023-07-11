### Pre-commit hook
---
### In the current context two implementation methods of pre-commit hooks are used: 
- one based solely on gitleaks
- another also built on top of gitleaks by using the pre-commit framework tool.
---
#### Gitleaks is a SAST tool for **detecting** and **preventing** hardcoded secrets like passwords, api keys, and tokens in git repos. 

```
┌─○───┐
│ │╲  │
│ │ ○ │
│ ○ ░ │
└─░───┘ gitleaks
```
### Installing
```bash
# OS Linux/MacOS/Windows
# ARCH x32/amd64/arm64/armv7/armv6

# The hook directory stores all the scripts and subscripts, so just copy it to your repo
# Go to the root / of your repo and install the pre-commit file from the hook directory to the directory containing your hooks - by default it's .git/hooks

➜  ~/app-code(master) cp ./hook/pre-commit ./.git/hooks

# Congratulations! All is done now!
# When you commit the pre-commit hook will automatically verify your system (OS and ARCH), install gitleaks package if it's not already installed, run it, and **detect** hardcoded secrets in your staging area and the repo by **preventing** you from the **faulty** commit   
# It will also advise you on future steps such as enabling or disabling the hook if required
```
---
### Let's move to the second realization of a pre-commit hook which is also built on top of gitleaks by using the pre-commit framework tool

### Installing
```bash
# For the current implementation, you will need a .pre-commit-config.yaml file that will configure your hook
# The pre-configured file is located in the root directory of the repo, so just copy and paste it into your root / :
```
```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.17.0
    hooks:
      - id: gitleaks
        entry: bash -c "gitleaks detect --source . --redact -v && gitleaks protect --staged" 
        stages: [pre-commit]
```
```bash
# From the root of your repo go to the ./hook/pre-web-hooks folder and run the following commands:

➜  ~/app-code(master) chmod+x pre-commit
➜  ~/app-code(master) python gl-runner.py

# Congratulations! All is done now! The script will install the pre-commit framework and all necessary dependencies
# It will also advise you on future steps such as enabling or disabling the hook if required 
# So, now you commit the pre-commit hook will automatically **detect** hardcoded secrets in your staging area and the repo by **preventing** you from the **faulty** commit
# Use the **python gl-runner.py** command for turning the pre-commit hook on/off or use advised internal **git config** commands suggested by gl-runner for this:

➜  ~/app-code(master) python gl-runner.py

```
---
### The short demo is here:
[![asciicast](https://asciinema.org/a/596014.svg)](https://asciinema.org/a/596014)
---

> For a more detailed understanding, you can familiarize yourself with the following resources:<br>
> - [gitleaks intro](https://github.com/gitleaks/gitleaks/tree/master) <br>
> - [pre-commit framework intro](https://pre-commit.com/#intro)


