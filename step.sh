#!/bin/bash
set -ex

# Get the number of warnings
test_name=$(/usr/libexec/PlistBuddy -c "Print :TestableSummaries:0:TestName" ${BITRISE_XCRESULT_PATH}/TestSummaries.plist)

# Trim all spaces
test_count=$(/usr/libexec/PlistBuddy -c "Print :TestsCount" ${BITRISE_XCRESULT_PATH}/Info.plist)


# Test regression
./relapse "test_relapse_${test_name}" "$warning_number" ">" ".ci/ci.sqlite3"
