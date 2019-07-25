#!/bin/bash
set -ex

DBPath=".ci/ci.sqlite3"
ScriptPath=$( cd "$(dirname "$0")" ; pwd -P )
TestCount=$(/usr/libexec/PlistBuddy -c "Print :TestsCount" $xcresultPath/Info.plist)
TestFailedCount=$(/usr/libexec/PlistBuddy -c "Print :TestsFailedCount" $xcresultPath/Info.plist)
TestErrorCount=$(/usr/libexec/PlistBuddy -c "Print :ErrorCount" $xcresultPath/Info.plist)
TestWarningCount=$(/usr/libexec/PlistBuddy -c "Print :WarningCount" $xcresultPath/Info.plist)

echo "Test Count: $TestCount"
echo "Test Failed Count: $TestFailedCount"
echo "Test Error Count: $TestErrorCount"
echo "Test Warning Count: $TestWarningCount"

$ScriptPath/relapse "TestCount_relapse_$BITRISE_SCHEME" "$TestCount" ">" $DBPath
$ScriptPath/relapse "TestFailedCount_relapse_$BITRISE_SCHEME" "$TestFailedCount" "<" $DBPath
$ScriptPath/relapse "TestErrorCount_relapse_$BITRISE_SCHEME" "$TestErrorCount" "<" $DBPath
$ScriptPath/relapse "TestWarningCount_relapse_$BITRISE_SCHEME" "$TestWarningCount" "<" $DBPath

git add --all
git commit -m "Update Test Count database"
git push origin HEAD:$BITRISE_GIT_BRANCH
