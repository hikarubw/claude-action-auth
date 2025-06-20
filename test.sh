#!/bin/bash
# Claude Action Auth - Test Suite
# Verifies installation and functionality

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Claude Action Auth Test Suite${NC}"
echo "============================"
echo ""

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
    local test_name=$1
    local test_command=$2
    
    echo -n "Testing $test_name... "
    if eval "$test_command" >/dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAIL${NC}"
        ((TESTS_FAILED++))
    fi
}

# Core file tests
run_test "claude-auth CLI exists" "[ -f claude-auth ]"
run_test "claude-auth is executable" "[ -x claude-auth ]"
run_test "installer script exists" "[ -f install.sh ]"
run_test "installer is executable" "[ -x install.sh ]"
run_test "OAuth workflow template exists" "[ -f templates/claude-advanced.yml ]"
run_test "API workflow template exists" "[ -f templates/claude-advanced-api.yml ]"
run_test "README exists" "[ -f README.md ]"
run_test "LICENSE exists" "[ -f LICENSE ]"
run_test "VERSION exists" "[ -f VERSION ]"
run_test "CHANGELOG exists" "[ -f CHANGELOG.md ]"

# Syntax verification
run_test "claude-auth syntax" "bash -n claude-auth"
run_test "installer syntax" "bash -n install.sh"

# Version check
run_test "version consistency" "grep -q '2.1.0' VERSION && grep -q 'VERSION=\"2.1.0\"' claude-auth"

# Command validation
run_test "help command" "./claude-auth help | grep -q 'Claude Action Auth'"
run_test "version flag" "./claude-auth --version | grep -q 'v2.1.0'"
run_test "init command in help" "./claude-auth help | grep -q 'init'"
run_test "init shows in quick start" "./claude-auth help | grep -q 'Quick Start'"

# Dependency checks in script
run_test "gh dependency check" "grep -q 'command -v gh' claude-auth"
run_test "jq dependency check" "grep -q 'command -v jq' claude-auth"
run_test "git dependency check" "grep -q 'command -v git' claude-auth"

# Installation URL check
run_test "correct repo URL" "grep -q 'hikarubw/claude-action-auth' install.sh"

# Old structure should not exist
run_test "no commands directory" "[ ! -d commands ]"
run_test "no tools directory" "[ ! -d tools ]"

# Summary
echo ""
echo "============================"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi