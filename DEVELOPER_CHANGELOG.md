Bump iOS deployment target to 15.0

Files changed:
- ios/Runner.xcodeproj/project.pbxproj: updated IPHONEOS_DEPLOYMENT_TARGET from 12.0 to 15.0 in Debug/Release/Profile sections.
- ios/Flutter/AppFrameworkInfo.plist: MinimumOSVersion 12.0 -> 15.0
- ios/Runner/Info.plist: added MinimumOSVersion key with value 15.0
- .github/workflows/ci-ios-xcode.yml: added a CI workflow to run on macos-latest and build the iOS project
