#!/bin/bash
# Generate realistic daily commits (1-10 per day) over 12 months

set -e

echo "========================================="
echo "Generating realistic commit history"
echo "Daily commits for 12 months (365 days)"
echo "========================================="
echo ""

# Calculate date range
END_TIMESTAMP=$(date +%s)
START_TIMESTAMP=$((END_TIMESTAMP - 365*24*60*60))

# Reset to a clean state
echo "Initializing repository..."
rm -rf .git
git init
git branch -M main

git config user.email "1060890+rasdkasldfsdgsfgsdgd@users.noreply.github.com"
git config user.name "rasdkasldfsdgsfgsdgd"
# Create project structure
mkdir -p src components utils config tests docs api models controllers routes middleware

cat > README.md << 'EOF'
# Claude WB

A comprehensive web application developed over the past year.

## Overview
Full-stack application with real-time features, authentication, and data persistence.

## Tech Stack
- **Frontend**: React, TypeScript, TailwindCSS
- **Backend**: Node.js, Express, PostgreSQL
- **Real-time**: Socket.io, Redis
- **DevOps**: Docker, CI/CD, Monitoring

## Quick Start
```bash
npm install
npm run dev
```

## Documentation
See `/docs` for detailed documentation.

## License
MIT
EOF

cat > package.json << 'EOF'
{
  "name": "claude-wb",
  "version": "2.1.4",
  "description": "Full-stack web application",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "jest --coverage",
    "build": "webpack --mode production",
    "lint": "eslint src/",
    "deploy": "npm run build && ./deploy.sh"
  },
  "dependencies": {
    "express": "^4.18.2",
    "react": "^18.2.0",
    "socket.io": "^4.6.1",
    "pg": "^8.10.0",
    "redis": "^4.6.5",
    "jsonwebtoken": "^9.0.0",
    "bcrypt": "^5.1.0"
  },
  "devDependencies": {
    "jest": "^29.5.0",
    "webpack": "^5.82.1",
    "nodemon": "^2.0.22"
  }
}
EOF

cat > .gitignore << 'EOF'
node_modules/
.env
.env.local
dist/
build/
coverage/
*.log
.DS_Store
.vscode/
.idea/
EOF

# Commit message templates
declare -a COMMIT_PREFIXES=(
  "feat" "fix" "refactor" "docs" "style" "test" "chore" "perf" "build" "ci"
)

declare -a COMMIT_SUBJECTS=(
  "add user authentication flow"
  "implement JWT token validation"
  "fix login redirect issue"
  "update API documentation"
  "refactor database queries"
  "add unit tests for auth module"
  "improve error handling in middleware"
  "optimize SQL query performance"
  "add input validation for forms"
  "implement rate limiting"
  "fix memory leak in websocket handler"
  "add request logging middleware"
  "update npm dependencies"
  "refactor React component structure"
  "add dark mode toggle"
  "fix responsive layout on mobile"
  "implement Redis caching layer"
  "add Swagger API docs"
  "fix CORS policy configuration"
  "add environment config loader"
  "implement session storage"
  "add bcrypt password hashing"
  "fix race condition in auth"
  "add user profile endpoints"
  "implement file upload service"
  "add image compression utility"
  "fix XSS vulnerability"
  "add input sanitization"
  "implement pagination logic"
  "add full-text search"
  "fix migration rollback"
  "add webhook event handlers"
  "implement push notifications"
  "add email template renderer"
  "fix routing edge cases"
  "add Express middleware chain"
  "implement Joi validation schemas"
  "add gzip compression"
  "fix N+1 query problem"
  "add Prometheus metrics"
  "implement health check endpoint"
  "add nginx load balancer config"
  "fix Docker deployment script"
  "add GitHub Actions CI pipeline"
  "implement automated backups"
  "add Sentry error tracking"
  "fix deadlock in transaction"
  "add E2E tests with Playwright"
  "implement feature toggles"
  "add analytics event tracking"
  "fix timezone conversion bug"
  "add i18n translation support"
  "implement Google Analytics"
  "add custom dashboard metrics"
  "fix schema validation errors"
  "add JSON schema definitions"
  "implement GraphQL resolvers"
  "add subscription mutations"
  "fix websocket connection drops"
  "add offline data sync"
  "implement service worker caching"
  "add PWA manifest config"
  "fix mobile touch events"
  "add gesture recognition"
  "implement lazy component loading"
  "add Webpack code splitting"
  "fix bundle size optimization"
  "add unused code elimination"
  "implement server-side rendering"
  "add meta tag management"
  "fix SEO canonical URLs"
  "add XML sitemap generator"
  "implement Atom feed"
  "add social media cards"
  "fix OpenGraph image tags"
  "add JSON-LD structured data"
  "implement breadcrumb navigation"
  "add responsive navbar"
  "fix WCAG accessibility issues"
  "add semantic HTML markup"
  "implement keyboard shortcuts"
  "add focus trap for modals"
  "fix color contrast compliance"
  "add screen reader announcements"
  "implement client-side validation"
  "add inline error messages"
  "fix async form submission"
  "add success toast notifications"
  "implement autocomplete dropdown"
  "add custom select component"
  "fix modal z-index stacking"
  "add CSS animations"
  "implement parallax scrolling"
  "add skeleton loading states"
  "fix infinite scroll bugs"
  "add virtualized list rendering"
  "implement position sticky headers"
  "add snap scroll sections"
  "implement drag-drop reordering"
  "add multi-file uploader"
  "fix progress bar calculation"
  "add thumbnail generation"
  "implement canvas image editor"
  "add CSS filter effects"
  "fix image aspect ratio"
  "add bulk operation queue"
  "implement background jobs"
  "add worker thread pool"
  "fix memory leak detection"
  "add heap snapshot analysis"
  "implement connection pooling"
  "add exponential backoff retry"
  "fix request timeout handling"
  "add circuit breaker pattern"
  "implement graceful shutdown"
  "add database indexes"
  "fix slow query optimization"
  "add read replica support"
  "implement data partitioning"
  "add materialized views"
  "fix transaction isolation"
  "add database migration tool"
  "implement seed data loader"
  "add factory test helpers"
  "fix flaky integration tests"
  "add mock API responses"
  "implement test coverage reports"
  "add performance benchmarks"
  "fix security audit warnings"
  "add dependency vulnerability scan"
  "implement CSP headers"
  "add HTTPS redirect middleware"
  "fix cookie security flags"
  "add SQL injection prevention"
  "implement CSRF protection"
  "add helmet security headers"
  "fix authorization bypass"
  "add role-based access control"
  "implement permission system"
  "add audit log trails"
  "fix data encryption at rest"
  "add secrets management"
  "implement OAuth2 flow"
  "add social login providers"
  "fix token refresh logic"
  "add 2FA authentication"
  "implement email verification"
  "add password reset flow"
  "fix account lockout policy"
  "add brute force protection"
  "implement magic link login"
  "add SSO integration"
  "fix session hijacking prevention"
  "add IP whitelisting"
  "implement API key rotation"
  "add request signing"
  "fix replay attack prevention"
)

# Files that get modified
declare -a FILE_POOL=(
  "src/index.js"
  "src/app.js"
  "src/config.js"
  "src/database.js"
  "api/auth.js"
  "api/users.js"
  "api/posts.js"
  "api/comments.js"
  "models/User.js"
  "models/Post.js"
  "models/Comment.js"
  "models/Session.js"
  "controllers/AuthController.js"
  "controllers/UserController.js"
  "controllers/PostController.js"
  "routes/api.js"
  "routes/auth.js"
  "routes/index.js"
  "middleware/auth.js"
  "middleware/validation.js"
  "middleware/errorHandler.js"
  "middleware/logging.js"
  "components/App.jsx"
  "components/Header.jsx"
  "components/Footer.jsx"
  "components/Login.jsx"
  "components/Register.jsx"
  "components/Dashboard.jsx"
  "components/Profile.jsx"
  "components/Settings.jsx"
  "components/PostList.jsx"
  "components/PostCard.jsx"
  "components/CommentSection.jsx"
  "utils/helpers.js"
  "utils/validators.js"
  "utils/formatters.js"
  "utils/logger.js"
  "utils/encryption.js"
  "config/database.js"
  "config/redis.js"
  "config/email.js"
  "config/app.js"
  "tests/auth.test.js"
  "tests/api.test.js"
  "tests/models.test.js"
  "tests/integration.test.js"
  "docs/API.md"
  "docs/SETUP.md"
  "docs/DEPLOYMENT.md"
  "docs/ARCHITECTURE.md"
  "README.md"
  "package.json"
  ".gitignore"
  ".env.example"
  "docker-compose.yml"
  "Dockerfile"
  ".github/workflows/ci.yml"
)

echo "Generating commits for each day over 365 days..."
echo ""

TOTAL_COMMITS=0

for ((day=0; day<365; day++)); do
  # Calculate base timestamp for this day
  DAY_TIMESTAMP=$((START_TIMESTAMP + day * 86400))

  # Get day of week (1=Mon, 7=Sun)
  DAY_OF_WEEK=$(date -d "@$DAY_TIMESTAMP" +%u 2>/dev/null || date -r "$DAY_TIMESTAMP" +%u)

  # Determine commits for this day based on day of week
  if [ "$DAY_OF_WEEK" -le 5 ]; then
    # Weekday: 2-9 commits (weighted towards 3-6)
    RAND=$((RANDOM % 100))
    if [ $RAND -lt 40 ]; then
      COMMITS_TODAY=$((3 + RANDOM % 4))  # 3-6 (40%)
    elif [ $RAND -lt 70 ]; then
      COMMITS_TODAY=$((2 + RANDOM % 2))  # 2-3 (30%)
    elif [ $RAND -lt 90 ]; then
      COMMITS_TODAY=$((7 + RANDOM % 3))  # 7-9 (20%)
    else
      COMMITS_TODAY=1  # 1 (10% - light day)
    fi
  else
    # Weekend: 0-3 commits (mostly 0-1)
    RAND=$((RANDOM % 100))
    if [ $RAND -lt 60 ]; then
      COMMITS_TODAY=0  # No work (60%)
    elif [ $RAND -lt 85 ]; then
      COMMITS_TODAY=1  # Light work (25%)
    else
      COMMITS_TODAY=$((2 + RANDOM % 2))  # 2-3 (15% - busy weekend)
    fi
  fi

  if [ $COMMITS_TODAY -eq 0 ]; then
    continue
  fi

  # Generate commits for this day
  for ((commit=0; commit<COMMITS_TODAY; commit++)); do
    # Spread commits throughout the work day
    if [ $COMMITS_TODAY -eq 1 ]; then
      HOUR=$((10 + RANDOM % 8))  # 10-17 (single commit anytime)
    else
      # Multiple commits - spread them out
      PROGRESS=0; if [ $COMMITS_TODAY -gt 1 ]; then PROGRESS=$(( commit * 100 / (COMMITS_TODAY - 1) )); fi
      BASE_HOUR=$(( 9 + (PROGRESS * 12 / 100) ))  # 9-21
      HOUR=$((BASE_HOUR + (RANDOM % 2 - 1)))  # +/- 1 hour jitter
      if [ $HOUR -lt 9 ]; then HOUR=9; fi
      if [ $HOUR -gt 23 ]; then HOUR=23; fi
    fi

    MINUTE=$((RANDOM % 60))
    SECOND=$((RANDOM % 60))

    # Calculate exact commit timestamp
    DAY_START=$(date -d "$(date -d "@$DAY_TIMESTAMP" '+%Y-%m-%d') 00:00:00" +%s 2>/dev/null || \
                date -j -f "%Y-%m-%d %H:%M:%S" "$(date -r "$DAY_TIMESTAMP" '+%Y-%m-%d') 00:00:00" +%s)
    COMMIT_TIMESTAMP=$((DAY_START + HOUR * 3600 + MINUTE * 60 + SECOND))

    # Pick 1-3 files to modify
    FILES_TO_MODIFY=$((1 + RANDOM % 3))

    for ((f=0; f<FILES_TO_MODIFY; f++)); do
      FILE_INDEX=$((RANDOM % ${#FILE_POOL[@]}))
      FILE="${FILE_POOL[$FILE_INDEX]}"

      # Create file if doesn't exist
      mkdir -p "$(dirname "$FILE")"
      if [ ! -f "$FILE" ]; then
        if [[ "$FILE" == *.js ]]; then
          echo "// $FILE" > "$FILE"
          echo "module.exports = {};" >> "$FILE"
        elif [[ "$FILE" == *.jsx ]]; then
          echo "import React from 'react';" > "$FILE"
          echo "export default function Component() { return null; }" >> "$FILE"
        elif [[ "$FILE" == *.md ]]; then
          echo "# Documentation" > "$FILE"
        else
          echo "# Config file" > "$FILE"
        fi
      fi

      # Make realistic change
      echo "" >> "$FILE"
      echo "// Modified: $(date -d "@$COMMIT_TIMESTAMP" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -r "$COMMIT_TIMESTAMP" '+%Y-%m-%d %H:%M:%S')" >> "$FILE"

      git add "$FILE"
    done

    # Generate commit message
    PREFIX_INDEX=$((RANDOM % ${#COMMIT_PREFIXES[@]}))
    SUBJECT_INDEX=$((RANDOM % ${#COMMIT_SUBJECTS[@]}))
    PREFIX="${COMMIT_PREFIXES[$PREFIX_INDEX]}"
    SUBJECT="${COMMIT_SUBJECTS[$SUBJECT_INDEX]}"

    # Commit with exact timestamp
    GIT_AUTHOR_DATE="@$COMMIT_TIMESTAMP +0000" \
    GIT_COMMITTER_DATE="@$COMMIT_TIMESTAMP +0000" \
    git commit -m "$PREFIX: $SUBJECT" --quiet

    TOTAL_COMMITS=$((TOTAL_COMMITS + 1))
  done

  # Progress update every 30 days
  if [ $((day % 30)) -eq 0 ]; then
    PERCENT=$((day * 100 / 365))
    DATE_STR=$(date -d "@$DAY_TIMESTAMP" '+%Y-%m-%d' 2>/dev/null || date -r "$DAY_TIMESTAMP" '+%Y-%m-%d')
    echo "Day $day/365 ($PERCENT%) - $DATE_STR - Total commits: $TOTAL_COMMITS"
  fi
done

echo ""
echo "========================================="
echo "✓ Generated $TOTAL_COMMITS commits across 365 days!"
echo "========================================="
echo ""

# Statistics
echo "Repository Statistics:"
echo "  Total commits: $(git rev-list --count HEAD)"
echo "  Date range: $(git log --reverse --pretty=format:'%ai' | head -1)"
echo "           to $(git log --pretty=format:'%ai' | head -1)"
echo ""
echo "First 10 commits:"
git log --pretty=format:'  %ai - %s' --reverse | head -10
echo ""
echo "Last 10 commits:"
git log --pretty=format:'  %ai - %s' | head -10
echo ""
echo "Ready to push to GitHub!"
echo ""
