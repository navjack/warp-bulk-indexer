#!/usr/bin/env bash
set -euo pipefail

# Warp Bulk Indexer - Main Script
# Opens all indexable repositories in Warp tabs for bulk indexing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="${1:-$PWD}"
DRY_RUN="${DRY_RUN:-false}"
DELAY="${DELAY:-0.3}"

usage() {
    cat << EOF
Usage: $0 [DIRECTORY]

Opens all indexable repositories in Warp tabs for bulk indexing.

Arguments:
    DIRECTORY    Directory containing repositories (default: current directory)

Environment Variables:
    DRY_RUN      Set to 'true' to scan without opening tabs (default: false)
    DELAY        Delay between opening tabs in seconds (default: 0.3)
    MAX_FILES    Maximum files per repository (default: 10000)

Requirements:
    - macOS with Warp or WarpPreview installed
    - Accessibility permissions granted to Terminal

This script will:
1. Scan the directory for indexable Git repositories
2. Open each repository in a new Warp tab
3. Warp will automatically begin indexing the codebases

EOF
}

check_accessibility() {
    # Test if we can send keystrokes
    if ! osascript -e 'tell application "System Events" to return' 2>/dev/null; then
        echo "❌ Error: Accessibility permissions required"
        echo ""
        echo "To fix this:"
        echo "1. Go to System Preferences → Security & Privacy → Privacy → Accessibility"
        echo "2. Add Terminal to the allowed applications"
        echo "3. Re-run this script"
        echo ""
        exit 1
    fi
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
    
    check_accessibility
    
    echo "🔍 Scanning for indexable repositories in $BASE_DIR..."
    echo ""
    
    # Run scan and capture output
    scan_output=$("$SCRIPT_DIR/scan_repos.sh" "$BASE_DIR")
    echo "$scan_output"
    echo ""
    
    # Count indexable repositories
    indexable_repos=$(echo "$scan_output" | grep -c "^OK " || true)
    
    if [ "$indexable_repos" -eq 0 ]; then
        echo "❌ No indexable repositories found."
        echo "💡 Repositories need: Git repo + source files + < $(MAX_FILES=10000; echo $MAX_FILES) files"
        exit 0
    fi
    
    if [ "$DRY_RUN" = "true" ]; then
        echo "🔍 Dry run complete. Found $indexable_repos indexable repositories."
        echo "💡 Run without DRY_RUN=true to open them in Warp"
        exit 0
    fi
    
    echo "🚀 Opening $indexable_repos indexable repositories in Warp..."
    echo "⏱️  Using ${DELAY}s delay between tabs"
    echo ""
    
    opened=0
    while read -r status repo rest; do
        [ "$status" = "OK" ] || continue
        path="$BASE_DIR/$repo"
        echo "Opening $repo..."
        
        if ! osascript "$SCRIPT_DIR/open_dir_in_warp.scpt" "$path"; then
            echo "⚠️  Failed to open $repo" >&2
        else
            opened=$((opened + 1))
        fi
        
        sleep "$DELAY"
    done < <(QUIET=false "$SCRIPT_DIR/scan_repos.sh" "$BASE_DIR" | grep "^OK ")
    
    echo ""
    echo "✅ Opened $opened repositories in Warp"
    echo "💡 Check Warp's Settings → Code → Codebase Index to monitor indexing progress"
    echo "📊 Indexing may take several minutes for large codebases"
}

main "$@"
