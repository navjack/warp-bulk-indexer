#!/usr/bin/env bash
set -euo pipefail

# Warp Bulk Indexer - Repository Scanner
# Scans directories for Warp-indexable codebases

# Configuration
BASE_DIR="${1:-$PWD}"
MAX_FILES="${MAX_FILES:-10000}"
QUIET="${QUIET:-false}"

# Supported source file extensions
EXTENSIONS=(
    "*.swift" "*.go" "*.ts" "*.js" "*.jsx" "*.tsx"
    "*.py" "*.c" "*.cpp" "*.cc" "*.cxx" "*.h" "*.hpp"
    "*.java" "*.kt" "*.rs" "*.rb" "*.php" "*.cs"
    "*.m" "*.mm" "*.scala" "*.clj" "*.hs" "*.ml"
    "*.elm" "*.dart" "*.vue" "*.svelte"
)

usage() {
    cat << EOF
Usage: $0 [DIRECTORY]

Scans directories for Warp-indexable codebases.

Arguments:
    DIRECTORY    Directory to scan (default: current directory)

Environment Variables:
    MAX_FILES    Maximum files per repository (default: 10000)
    QUIET        Set to 'true' for quiet output (default: false)

A repository is considered indexable if it:
1. Contains a .git directory
2. Has source code files
3. Has fewer than MAX_FILES files

EOF
}

has_source_files() {
    local dir="$1"
    local pattern=""
    
    # Build find pattern for all extensions
    for ext in "${EXTENSIONS[@]}"; do
        if [ -z "$pattern" ]; then
            pattern="-name \"$ext\""
        else
            pattern="$pattern -o -name \"$ext\""
        fi
    done
    
    # Check if any source files exist (search up to 3 levels deep)
    eval "find \"$dir\" -maxdepth 3 -type f \\( $pattern \\) -print -quit" | grep -q .
}

main() {
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        usage
        exit 0
    fi
    
    if [ ! -d "$BASE_DIR" ]; then
        echo "Error: Directory '$BASE_DIR' does not exist" >&2
        exit 1
    fi
    
    if [ "$QUIET" != "true" ]; then
        echo "Scanning repositories in $BASE_DIR for Warp indexability..."
        echo "Criteria: Git repo + source files + < $MAX_FILES files"
        echo ""
    fi
    
    local indexable_count=0
    local total_count=0
    
    for dir in "$BASE_DIR"/*; do
        [ -d "$dir" ] || continue
        repo="$(basename "$dir")"
        total_count=$((total_count + 1))
        
        # Check for git repository
        if [ ! -d "$dir/.git" ]; then
            [ "$QUIET" != "true" ] && echo "SKIP $repo – no git repo"
            continue
        fi
        
        # Count files
        file_count=$(find "$dir" -type f | wc -l | tr -d ' ')
        if (( file_count > MAX_FILES )); then
            [ "$QUIET" != "true" ] && echo "SKIP $repo – $file_count files (> $MAX_FILES)"
            continue
        fi
        
        # Check for source files
        if ! has_source_files "$dir"; then
            [ "$QUIET" != "true" ] && echo "SKIP $repo – no source files"
            continue
        fi
        
        if [ "$QUIET" = "true" ]; then
            echo "$repo"
        else
            echo "OK   $repo ($file_count files)"
        fi
        indexable_count=$((indexable_count + 1))
    done
    
    if [ "$QUIET" != "true" ]; then
        echo ""
        echo "Summary: $indexable_count/$total_count directories are indexable by Warp"
    fi
}

main "$@"
