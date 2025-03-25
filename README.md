# CQInitProject
每个项目的初始工程



## iOS

1、创建iOS工程

2、添加 Podfile

3、运行项目

>  运行项目出现如下错误时候 `xcode运行ios项目报错Sandbox: rsync.samba(24352) deny(1) file-write-create`，解决方式为设置 `ENABLE_USER_SCRIPT_SANDBOXING` 为 `NO` 即可。



## 构建 Flutter 模块

2025.03.25：[官方文档：将 Flutter module 集成到 iOS 项目](https://docs.flutter.cn/add-to-app/ios/project-setup)

之前旧的集成方式（已不适用）：[《iOS项目集成Flutter.md》](https://dvlproad.github.io/Flutter/2%E9%9B%86%E6%88%90/iOS%E9%A1%B9%E7%9B%AE%E9%9B%86%E6%88%90Flutter/)



1、创建 Flutter 模块 通过命令创建一个 Flutter 模块，而不是完整的 Flutter 应用，这个模块会作为 Android 或 iOS 项目的一部分，会在 模块中编写业务逻辑。

```
flutter create --template module cqinitproject_flutter
```

2、在 `pubspec.yaml` 中添加依赖库

```
	flutter_demo_kit: any
  flutter_network_kit: any
```

执行 `flutter pub get`

3、**在 Podfile 中添加 Flutter 模块，并执行 pod install 安装 Flutter 相关依赖****

```ruby
# Podfile

flutter_application_path = '../cqinitproject_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'CQInitProject_iOS' do
  use_frameworks! 
  use_modular_headers!

  # 添加 Flutter 依赖
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end
```

如果 pod install 失败，可能原因一般是

`flutter create -t module cqinitproject_flutter` 创建的是 Flutter 模块，默认不会包含 ios 和 android 目录，因为它是 用于嵌入原生项目 的 Flutter 组件，而不是一个完整的独立 Flutter 应用。但是我现在需要在我已有的iOS app上添加Flutter混编。所以解决方式如下：

方法1(推荐）：

```ruby
flutter create --org com.dvlproad.cqinitproject .
```

创建出来的  ios 和 android 目录是 .ios 是 .android，他们可能是隐藏文件。所以你看不到不一定代表没有生成。

方法2：尝试先运行：`flutter build ios --no-codesign` 来生成 iOS 目录，再执行 pod install。







