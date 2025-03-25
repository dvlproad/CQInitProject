# CQInitProject
每个项目的初始工程



## iOS

1、创建iOS工程

2、添加 Podfile



## 构建 Flutter 模块

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
