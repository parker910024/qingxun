fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios d
```
fastlane ios d
```
1. 发布iOS Dubug ipa 到 firim 网站
### ios r
```
fastlane ios r
```
2. 发布iOS Release ipa 到 firim 网站
### ios store
```
fastlane ios store
```
3. 发布iOS Release ipa 到 苹果商店
### ios archiveAction
```
fastlane ios archiveAction
```
4. 打包操作
### ios uploadToFirim
```
fastlane ios uploadToFirim
```
5. 执行上传操作
### ios uploadAppleStore
```
fastlane ios uploadAppleStore
```
6. 发布到 Apple Store
### ios updateProjectBuildNumber
```
fastlane ios updateProjectBuildNumber
```
7. 用于更新 App 的 build Num 的方法
### ios upload_dSYM
```
fastlane ios upload_dSYM
```
8. 上传符号表操作
### ios resigh
```
fastlane ios resigh
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
