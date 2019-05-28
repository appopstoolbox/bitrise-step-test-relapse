#!/bin/bash
set -ex

TestCount=$(/usr/libexec/PlistBuddy -c "Print :TestsCount" $xcresultPath/Info.plist)
TestFailedCount=$(/usr/libexec/PlistBuddy -c "Print :TestsFailedCount" $xcresultPath/Info.plist)
TestErrorCount=$(/usr/libexec/PlistBuddy -c "Print :ErrorCount" $xcresultPath/Info.plist)
TestWarningCount=$(/usr/libexec/PlistBuddy -c "Print :WarningCount" $xcresultPath/Info.plist)

echo "Test Count: $TestCount"
echo "Test Failed Count: $TestFailedCount"
echo "Test Error Count: $TestErrorCount"
echo "Test Warning Count: $TestWarningCount"

./relapse "TestCount_relapse_$BITRISE_SCHEME" "$TestCount" ">" ".ci/ci.sqlite3"
./relapse "TestFailedCount_relapse_$BITRISE_SCHEME" "$TestFailedCount" "<" ".ci/ci.sqlite3"
./relapse "TestErrorCount_relapse_$BITRISE_SCHEME" "$TestErrorCount" "<" ".ci/ci.sqlite3"
./relapse "TestWarningCount_relapse_$BITRISE_SCHEME" "$TestWarningCount" "<" ".ci/ci.sqlite3"
