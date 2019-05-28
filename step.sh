#!/bin/bash
set -ex

TestCount=$(/usr/libexec/PlistBuddy -c "Print :TestsCount" ${BITRISE_XCRESULT_PATH}/Info.plist)
TestFailedCount=$(/usr/libexec/PlistBuddy -c "Print :TestsFailedCount" ${BITRISE_XCRESULT_PATH}/Info.plist)
TestErrorCount=$(/usr/libexec/PlistBuddy -c "Print :ErrorCount" ${BITRISE_XCRESULT_PATH}/Info.plist)
TestWarningCount=$(/usr/libexec/PlistBuddy -c "Print :WarningCount" ${BITRISE_XCRESULT_PATH}/Info.plist)

echo "Test Count: $TestCount"
echo "Test Failed Count: $TestFailedCount"
echo "Test Error Count: $TestErrorCount"
echo "Test Warning Count: $TestWarningCount"

./relapse "TestCount_relapse_$BITRISE_SCHEME" "$TestCount" ">" ".ci/ci.sqlite3"
./relapse "TestFailedCount_relapse_$BITRISE_SCHEME" "$TestFailedCount" "<" ".ci/ci.sqlite3"
./relapse "TestErrorCount_relapse_$BITRISE_SCHEME" "$TestErrorCount" "<" ".ci/ci.sqlite3"
./relapse "TestWarningCount_relapse_$BITRISE_SCHEME" "$TestWarningCount" "<" ".ci/ci.sqlite3"
