#!/bin/bash
set -ex

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
TestCount=$(/usr/libexec/PlistBuddy -c "Print :TestsCount" $xcresultPath/Info.plist)
TestFailedCount=$(/usr/libexec/PlistBuddy -c "Print :TestsFailedCount" $xcresultPath/Info.plist)
TestErrorCount=$(/usr/libexec/PlistBuddy -c "Print :ErrorCount" $xcresultPath/Info.plist)
TestWarningCount=$(/usr/libexec/PlistBuddy -c "Print :WarningCount" $xcresultPath/Info.plist)

echo "Test Count: $TestCount"
echo "Test Failed Count: $TestFailedCount"
echo "Test Error Count: $TestErrorCount"
echo "Test Warning Count: $TestWarningCount"

$SCRIPTPATH/relapse "TestCount_relapse_$BITRISE_SCHEME" "$TestCount" ">" ".ci/ci.sqlite3"
$SCRIPTPATH/relapse "TestFailedCount_relapse_$BITRISE_SCHEME" "$TestFailedCount" "<" ".ci/ci.sqlite3"
$SCRIPTPATH/relapse "TestErrorCount_relapse_$BITRISE_SCHEME" "$TestErrorCount" "<" ".ci/ci.sqlite3"
$SCRIPTPATH/relapse "TestWarningCount_relapse_$BITRISE_SCHEME" "$TestWarningCount" "<" ".ci/ci.sqlite3"

git add .ci/ci.sqlite3
git commit -am "Update Test Count database"
git push origin $BITRISE_GIT_BRANCH
