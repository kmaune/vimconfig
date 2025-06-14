# Aider AI Coding Assistant - Quick Reference Cheat Sheet

## 🚀 Starting Aider

### Basic Usage
```bash
aider                              # Start with files (will prompt to add)
aider file1.cpp file2.hpp          # Start with specific files
aider *.{cpp,hpp}                  # Start with file patterns
aider --model ollama/qwen2.5-coder:7b  # Use specific model
```

### Mode Options
```bash
aider --architect                  # Architect mode (plan then implement)
aider --chat                       # Chat-only mode (no file edits)
aider --watch-files file.cpp       # Watch mode (auto-detect changes)
aider --no-auto-add                # Disable automatic file inclusion
aider --dry-run                    # Preview changes without applying
```

### Your Custom Aliases
```bash
aider           # Default 14b model (balanced)
aider-quick     # 7b model (fast responses)
aider-heavy     # 32b model (complex tasks)
aider-alt       # devstral model (alternative)
```

## 🎛️ In-Session Commands

### File Management
```bash
/add filename.cpp                  # Add file to chat
/add *.hpp                         # Add multiple files
/drop filename.cpp                 # Remove file from chat
/ls                               # List current files in chat
```

### Mode Switching
```bash
/architect                        # Switch to architect mode
/code                            # Switch to regular coding mode
/chat                            # Switch to chat-only mode
```

### Settings
```bash
/set edit-format diff             # Show only changes (concise)
/set edit-format whole            # Show complete files (reliable)
/set model ollama/qwen2.5-coder:32b  # Switch models mid-session
/set auto-commits true            # Toggle auto-commits
/set map-tokens 2048              # Adjust repo context
/settings                         # Show all current settings
```

### Information
```bash
/help                            # Show all available commands
/tokens                          # Show token usage
/quit or /exit                   # Exit Aider
```

### Execution
```bash
/run command                     # Execute shell command
/test                           # Run tests (if configured)
```

## 💡 Best Practices

### Effective Prompting
```bash
# ✅ Good: Specific and clear
"Add error handling to the serialize() method for invalid data"

# ✅ Good: Context-aware
"Fix the compilation error in the thread test - missing include"

# ✅ Good: Architectural
"Refactor this class to use RAII for resource management"

# ❌ Avoid: Vague requests
"Make this better"
```

### File Inclusion Strategy
```bash
# For C++: Include headers + implementation
aider class.hpp class.cpp

# For complex changes: Include related files upfront
aider order_book.hpp order_book.cpp price_level.hpp price_level.cpp

# For focused work: Use --no-auto-add
aider --no-auto-add specific_file.cpp
```

### Model Selection Strategy
```bash
# Quick fixes, obvious bugs, simple implementations
aider-quick file.cpp --message "Fix the typo in line 42"

# Default for most development work
aider file.cpp --message "Add validation to the input parameters"

# Complex architecture, difficult debugging, performance optimization
aider-heavy --architect *.cpp --message "Redesign for thread safety"
```

## 🔧 Configuration Reference

### Your Config Location
```bash
~/.aider.conf.yml                 # Main config file
~/dotfiles/aider/aider.conf.yml   # Source (symlinked)
```

### Key Settings
```yaml
model: ollama/qwen2.5-coder:14b   # Default model
show-model-warnings: false        # Reduce noise
auto-commits: false               # Manual commit control
attribute-author: true            # Track AI contributions
map-tokens: 1024                  # Repo context size
auto-lint: true                   # Auto-formatting
```

### Environment Variables
```bash
export FORCE_COLOR=0              # Disable colors
export NO_COLOR=1                 # Alternative color disable
```

## 🛠️ Workflow Patterns

### Tmux + Neovim Integration
```bash
# Terminal 1: Start Aider
cd ~/project
aider file.cpp file.hpp

# Terminal 2: Editor + Build
nvim file.cpp
# In separate pane: cd build && make
```

### Debugging Workflow
```bash
# 1. Get compiler error
make 2>&1 | tee build.log

# 2. Feed to Aider
aider problematic_file.cpp
# Paste: "Fix this compilation error: [paste error]"

# 3. Test fix
make

# 4. Repeat if needed
```

### Test-Driven Development
```bash
# 1. Write tests first
aider test_file.cpp --message "Add tests for new feature X"

# 2. Implement feature
aider source_file.cpp --message "Implement feature X to pass the tests"

# 3. Iterate
make test
# Fix failures with Aider
```

### Architect Mode Workflow
```bash
# 1. Start with architectural planning
aider --architect *.cpp *.hpp

# 2. Give complex refactoring request
"Refactor to support feature X with requirements: 1) thread safety, 2) performance, 3) backward compatibility"

# 3. Review plan before implementation
# Note: No mid-process feedback - all-or-nothing

# 4. Apply or restart if plan needs changes
```

## ⚠️ Common Issues & Solutions

### File Management
```bash
# Problem: Repeated "add file?" prompts
# Solution: Include files upfront or use patterns
aider *.{cpp,hpp}

# Problem: Working on wrong files
# Solution: Check current files
/ls
```

### Performance
```bash
# Problem: Slow responses
# Solution: Use smaller model for simple tasks
aider-quick file.cpp

# Problem: Out of memory
# Solution: Reduce context or use smaller model
/set map-tokens 512
```

### Build Integration
```bash
# Problem: Can't build from Aider
# Solution: Use separate terminal or /run command
/run cd build && make

# Problem: Compilation errors
# Solution: Copy-paste error output to Aider with context
"Fix this compilation error: [full error output]"
```

### Version Control
```bash
# Problem: Want to review before committing
# Solution: Use manual commits (already configured)
git diff                          # Review changes
git add . && git commit -m "..."  # Commit when ready

# Problem: Want to track AI contributions
# Solution: Already configured with attribute-author: true
```

## 📚 Quick Reference Cards

### Essential Shortcuts
| Command | Action |
|---------|--------|
| `aider file.cpp` | Start with file |
| `/add file.hpp` | Add file to chat |
| `/architect` | Switch to architect mode |
| `/set edit-format diff` | Show only changes |
| `/help` | Show all commands |
| `/quit` | Exit Aider |

### Model Selection Guide
| Task Type | Command | Use Case |
|-----------|---------|----------|
| Quick fixes | `aider-quick` | Typos, simple bugs, obvious issues |
| Daily coding | `aider` | Most development work |
| Complex refactoring | `aider-heavy --architect` | Architecture changes, complex algorithms |
| Alternative perspective | `aider-alt` | When default model struggles |

### Edit Format Comparison
| Format | Pros | Cons | Best For |
|--------|------|------|----------|
| `whole` | Reliable, complete context | Verbose output | C++, complex changes |
| `diff` | Concise, git-like | Less reliable | Simple changes, review |

## 🎯 Pro Tips

1. **Start specific**: Include exact files you need rather than letting Aider guess
2. **Use compiler output**: Always paste full error messages for best results
3. **Model switching**: Don't hesitate to switch models mid-task if needed
4. **Watch-files**: Great for iterative development and real-time error fixing
5. **Architect mode**: Perfect for complex refactoring, but no mid-process changes
6. **Manual commits**: Review diffs before committing for learning and quality control
7. **Documentation**: Ask Aider to add comments and documentation as it codes