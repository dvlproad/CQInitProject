# CQInitProject
每个项目的初始工程



## iOS

1、创建iOS工程

2、添加 Podfile

3、运行项目

>  运行项目出现如下错误时候 `xcode运行ios项目报错Sandbox: rsync.samba(24352) deny(1) file-write-create`，解决方式为设置 `ENABLE_USER_SCRIPT_SANDBOXING` 为 `NO` 即可。





## Android

[《将 Flutter module 集成到 Android 项目》](https://docs.flutter.cn/add-to-app/android/project-setup)

从 Kotlin 代码中调用 `include_flutter.groovy` 的功能需要 Flutter 3.27。你如果需要判断当前的 Flutter 版本，请运行 `flutter --version`。

[Flutter SDK 归档列表](https://docs.flutter.cn/release/archive)

```sh
fvm --version
fvm install 3.27.4
fvm list
fvm use 3.27.4  	# 该目录下的项目会使用指定版本的 Flutter
fvm global 3.27.4	# 所有项目都会使用指定版本的 Flutter
flutter --version
```



## 构建 Flutter 模块

2025.03.25：[官方文档：将 Flutter module 集成到 iOS 项目](https://docs.flutter.cn/add-to-app/ios/project-setup)

之前旧的集成方式（已不适用）：[《iOS项目集成Flutter.md》](https://dvlproad.github.io/Flutter/2%E9%9B%86%E6%88%90/iOS%E9%A1%B9%E7%9B%AE%E9%9B%86%E6%88%90Flutter/)



1、创建 Flutter 模块 通过命令创建一个 Flutter 模块，而不是完整的 Flutter 应用，这个模块会作为 Android 或 iOS 项目的一部分，会在 模块中编写业务逻辑。

```shell
flutter create --template module cqinitproject_flutter
flutter create -t module --org com.dvlproad cqinitproject_flutter # 可避免后续 `flutter build ios` 未设置id问题
```

2、在 `pubspec.yaml` 中添加依赖库

```
	flutter_demo_kit: any
  flutter_network_kit: any
```

执行 `flutter pub get`



### iOS：将 Flutter module 作为依赖项

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

4、在主工程（iOS代码中）使用Flutter模块，跳转到指定页面

```swift
import UIKit
import Flutter
import FlutterPluginRegistrant

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var flutterEngine = FlutterEngine(name: "my_flutter_engine")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        flutterEngine.run()
        GeneratedPluginRegistrant.register(with: flutterEngine)
        
        return true
    }
}    
```

在 iOS 代码中跳转到 Flutter 界面

```swift
import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.setTitle("打开Flutter页面", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(openFlutterPage), for: .touchUpInside)
        view.addSubview(button)
    }

    
    @IBAction func openFlutterPage() {
        let flutterViewController = FlutterViewController(engine: (UIApplication.shared.delegate as! AppDelegate).flutterEngine, nibName: nil, bundle: nil)
        flutterViewController.modalPresentationStyle = .fullScreen
        present(flutterViewController, animated: true, completion: nil)
    }
}
```

### Android：将 Flutter module 作为依赖项

dev.flutter.flutter-gradle-plugin 需要在 **项目级**（project 级别）添加 maven 仓库

所以需要

```kotlin
dependencyResolutionManagement {
		# repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS) // 会引起Flutter错误，需要修改
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
    }
}
```

使用 **依赖模块的源码** 的方式：

```kotlin
// MyApp/settings.gradle.kts
rootProject.name = "CQInitProject_Android"
include(":app")

// Replace "cqinitproject_flutter" with whatever package_name you supplied when you ran:
// `$ flutter create -t module [package_name]
val filePath = settingsDir.parentFile.toString() + "/cqinitproject_flutter/.android/include_flutter.groovy"
apply(from = File(filePath))


// MyApp/app/build.gradle
dependencies {
    implementation(project(":flutter"))
}
```





