# Warp Bulk Indexer

🚀 **Bulk index multiple Git repositories in Warp terminal for enhanced AI coding assistance**

Warp's [Codebase Context](https://docs.warp.dev/code/codebase-context) feature provides AI agents with deep understanding of your code, but setting it up for dozens of repositories can be tedious. This tool automates the process by intelligently scanning directories and opening indexable repositories in Warp tabs, triggering automatic indexing.

## ✨ Features

- **Smart Repository Detection**: Automatically identifies Git repositories with source code
- **Warp Compatibility**: Works with both Warp stable and preview versions
- **File Count Validation**: Respects Warp's 10,000 file limit per repository
- **Comprehensive Language Support**: Detects 20+ programming languages
- **Dry Run Mode**: Preview what will be indexed before opening tabs
- **Configurable**: Customize file limits, delays, and output verbosity

## 🔧 Requirements

- **macOS** (Warp is macOS-only)
- **Warp Terminal** (stable or preview version)
- **Accessibility Permissions** for Terminal app

## 🚀 Quick Start

1. **Clone and navigate to the project:**
   ```bash
   git clone https://github.com/navjack/warp-bulk-indexer.git
   cd warp-bulk-indexer
   ```

2. **Make scripts executable:**
   ```bash
   chmod +x *.sh
   ```

3. **Grant accessibility permissions:**
   - Go to System Preferences → Security & Privacy → Privacy → Accessibility
   - Add Terminal to the allowed applications

4. **Run on a directory containing Git repositories:**
   ```bash
   ./warp-bulk-open.sh /path/to/your/projects
   ```

## 📖 Usage

### Basic Usage

```bash
# Index repositories in current directory
./warp-bulk-open.sh

# Index repositories in specific directory
./warp-bulk-open.sh ~/coding-projects

# Dry run to see what would be indexed
DRY_RUN=true ./warp-bulk-open.sh ~/coding-projects
```

### Advanced Configuration

```bash
# Custom file limit and delay
MAX_FILES=15000 DELAY=0.5 ./warp-bulk-open.sh ~/projects

# Scan only (no tab opening)
./scan_repos.sh ~/projects

# Quiet scan output
QUIET=true ./scan_repos.sh ~/projects
```

## 🔍 How It Works

The tool follows Warp's documented requirements for codebase indexing:

1. **Git Repository Check**: Verifies each directory contains a `.git` folder
2. **Source Code Detection**: Scans for files with programming language extensions
3. **File Count Validation**: Ensures repository has fewer than 10,000 files (configurable)
4. **Automatic Opening**: Opens qualifying repositories in new Warp tabs
5. **Indexing Trigger**: Warp automatically begins indexing when you navigate to Git repositories

### Supported Languages

- **Web**: JavaScript, TypeScript, JSX, TSX, Vue, Svelte
- **Mobile**: Swift, Kotlin, Dart, Objective-C
- **Systems**: C, C++, Rust, Go
- **Backend**: Python, Java, C#, PHP, Ruby, Scala
- **Functional**: Haskell, Clojure, ML, Elm
- **And more...**

## 📊 Example Output

```
🔍 Scanning for indexable repositories in /Users/dev/projects...

Scanning repositories in /Users/dev/projects for Warp indexability...
Criteria: Git repo + source files + < 10000 files

OK   my-react-app (1,247 files)
OK   backend-service (856 files)
SKIP old-project – no git repo
SKIP massive-monolith – 15,432 files (> 10000)
OK   mobile-app (2,103 files)

Summary: 3/5 directories are indexable by Warp

🚀 Opening 3 indexable repositories in Warp...

Opening my-react-app...
Opening backend-service...
Opening mobile-app...

✅ Opened 3 repositories in Warp
💡 Check Warp's Settings → Code → Codebase Index to monitor indexing progress
```

## ⚙️ Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MAX_FILES` | `10000` | Maximum files per repository |
| `DRY_RUN` | `false` | Preview mode without opening tabs |
| `DELAY` | `0.3` | Seconds between opening tabs |
| `QUIET` | `false` | Minimal output from scan |

## 🛠️ Components

- **`warp-bulk-open.sh`**: Main script that orchestrates the process
- **`scan_repos.sh`**: Repository scanner and validator
- **`open_dir_in_warp.scpt`**: AppleScript for opening directories in Warp

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and enhancement requests.

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Warp Terminal](https://warp.dev) for creating an amazing AI-enhanced terminal
- The Warp team's excellent [documentation](https://docs.warp.dev/code/codebase-context) on codebase indexing
