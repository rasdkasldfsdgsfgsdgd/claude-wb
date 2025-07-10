#!/bin/bash
# Git History Rewriter - Distribute 3 commits across 12 months
# Generated for wg repository

set -e

echo "========================================="
echo "Rewriting Git History - 3 commits over 12 months"
echo "========================================="
echo ""

# Backup current branch
git branch -f backup-before-rewrite HEAD 2>/dev/null || true
echo "✓ Backup branch created: backup-before-rewrite"
echo ""

# Calculate timestamps (12 months = 365 days)
END_TIMESTAMP=$(date +%s)
START_TIMESTAMP=$((END_TIMESTAMP - 365*24*60*60))

# Generate 3 evenly distributed timestamps with realistic work hours
# Commit 1: ~12 months ago (start of project)
COMMIT_1_BASE=$START_TIMESTAMP
COMMIT_1_HOUR=10  # 10 AM
COMMIT_1_MIN=23
COMMIT_1_SEC=15
COMMIT_1=$((COMMIT_1_BASE + COMMIT_1_HOUR*3600 + COMMIT_1_MIN*60 + COMMIT_1_SEC))

# Commit 2: ~6 months ago (middle)
COMMIT_2_BASE=$((START_TIMESTAMP + 182*24*60*60))
COMMIT_2_HOUR=14  # 2 PM
COMMIT_2_MIN=47
COMMIT_2_SEC=33
COMMIT_2=$((COMMIT_2_BASE + COMMIT_2_HOUR*3600 + COMMIT_2_MIN*60 + COMMIT_2_SEC))

# Commit 3: ~1 week ago (recent)
COMMIT_3_BASE=$((END_TIMESTAMP - 7*24*60*60))
COMMIT_3_HOUR=16  # 4 PM
COMMIT_3_MIN=12
COMMIT_3_SEC=48
COMMIT_3=$((COMMIT_3_BASE + COMMIT_3_HOUR*3600 + COMMIT_3_MIN*60 + COMMIT_3_SEC))

echo "Timestamp distribution:"
echo "  Commit 1: $(date -d "@$COMMIT_1" '+%Y-%m-%d %H:%M:%S %A' 2>/dev/null || date -r "$COMMIT_1" '+%Y-%m-%d %H:%M:%S %A')"
echo "  Commit 2: $(date -d "@$COMMIT_2" '+%Y-%m-%d %H:%M:%S %A' 2>/dev/null || date -r "$COMMIT_2" '+%Y-%m-%d %H:%M:%S %A')"
echo "  Commit 3: $(date -d "@$COMMIT_3" '+%Y-%m-%d %H:%M:%S %A' 2>/dev/null || date -r "$COMMIT_3" '+%Y-%m-%d %H:%M:%S %A')"
echo ""

# Export timestamps for filter-branch
export COMMIT_1 COMMIT_2 COMMIT_3

echo "Running git filter-branch..."
echo ""

# Rewrite history
COUNTER=0
git filter-branch -f --env-filter '
COUNTER=$((COUNTER + 1))

case $COUNTER in
    1)
        NEW_DATE="'$COMMIT_1'"
        ;;
    2)
        NEW_DATE="'$COMMIT_2'"
        ;;
    3)
        NEW_DATE="'$COMMIT_3'"
        ;;
esac

export GIT_AUTHOR_DATE="@$NEW_DATE +0000"
export GIT_COMMITTER_DATE="@$NEW_DATE +0000"

' --tag-name-filter cat -- --all

echo ""
echo "========================================="
echo "✓ History rewrite complete!"
echo "========================================="
echo ""
echo "Verification:"
git log --pretty=format:'%h %ai %ci %s'
echo ""
echo ""
echo "Next steps:"
echo "  1. Verify dates look good above"
echo "  2. Force push: git push --force origin main"
echo ""
echo "To restore backup: git reset --hard backup-before-rewrite"
echo ""
