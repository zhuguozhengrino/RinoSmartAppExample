fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios prepare

```sh
[bundle exec] fastlane ios prepare
```

构建前的准备工作

这是一个私有任务，仅供 Fastfile 内部 lane 调用使用

### ios get_api_key

```sh
[bundle exec] fastlane ios get_api_key
```

获取 apple connect api key

这是一个私有任务，仅供 Fastfile 内部 lane 调用使用

### ios build

```sh
[bundle exec] fastlane ios build
```

编译 IOS 包

### ios clean

```sh
[bundle exec] fastlane ios clean
```

清除已经构建的IPA等文件

### ios notify_wechat_bot

```sh
[bundle exec] fastlane ios notify_wechat_bot
```

通知企业微信

### ios get_current_version

```sh
[bundle exec] fastlane ios get_current_version
```

测试版本号

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
