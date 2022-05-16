# 快速上手

> 在开始之前，推荐先学习[Dart](https://dart.cn/guides)、[Flutter](https://flutter.cn/docs)、[GetX](https://pub.flutter-io.cn/packages/get)、[Dio](https://pub.flutter-io.cn/packages/dio)等框架

## 安装

```bash
git clone https://gitee.com/xinou/flutter_chat.git my_project
cd my_project
```

## 目录结构

```bash
├── android                                     # android 原生目录
├── ios                                         # ios 原生目录
├── assets                                      # 资源目录
│   ├── fonts                                   # 字体目录
│   │   └── iconfont.ttf                        # 状态图标字体包
│   ├── icons                                   # svg图标目录
│   └── images                                  # jpg、png等图片资源目录
├── lib                                         # dart 源码目录
│   ├── config                                  # 公共配置目录
│   │   ├── constant.dart                       # 公共配置文件
│   │   ├── net                                 # 网络请求相关目录
│   │   │   ├── app_dio.dart                    # dio封装
│   │   │   ├── app_exception.dart              # 网络请求错误封装
│   │   │   ├── app_response.dart               # 统一返回体封装
│   │   │   └── interceptors                    # 拦截器目录
│   │   │       ├── request_interceptor.dart    # 请求拦截器
│   │   │       └── response_interceptor.dart   # 响应拦截器
│   │   ├── resource_mananger.dart              # 资源管理
│   │   ├── router_manager.dart                 # 路由管理
│   │   ├── scroll_behavior_config.dart         # 滚动水波纹配置
│   │   └── tap_config.dart                     # 函数节流、防抖
│   ├── controller                              # GetX控制器
│   │   └── home                                # demo
│   │       └── home_controller.dart
│   ├── main.dart                               # 程序入口与信息初始化
│   ├── model                                   # 实体类
│   │   └── user.dart
│   ├── service                                 # 网络请求service
│   │   └── user_service.dart
│   ├── state                                   # 状态相关目录
│   │   ├── base_getx_controller.dart           # GetXController封装
│   │   ├── view_state.dart                     # 状态
│   │   └── view_state_widget.dart              # 状态组件
│   ├── ui                                      # 用户ui相关目录
│   │   ├── helper                              # UI助手目录
│   │   │   ├── dialog_helper.dart              # 弹窗助手
│   │   │   └── permission_helper.dart          # 权限申请助手
│   │   ├── pages                               # 页面目录
│   │   │   ├── home                            # demo
│   │   │   │   └── home_page.dart
│   │   │   └── splash_page.dart                # 闪屏页
│   │   ├── theme                               # 全局主题目录
│   │   │   └── app_theme.dart                  # 应用主题文件
│   │   └── widget                              # 组件目录
│   │   │   ├── app_bar.dart                    # 封装AppBar
│   │   │   ├── custom_tapped.dart              # 封装点击效果
│   │   │   └── group_widget.dart               # 封装分组组件
│   └── utils                                   # 工具类目录
├── flutter_chat.iml
├── pubspec.lock
└── pubspec.yaml                                # 项目依赖
```

## 本地开发
推荐使用VSCode进行开发

1. 进入目录安装依赖

```bash
flutter pub get
```

2. 连接调试设备，运行项目

3. 安装遇到的问题

   ###### [ios开发 正确安装pod 'libwebp'库](https://www.jianshu.com/p/1c8a4becc176)

   ###### [Cannot run with sound null safety because dependencies don't support null safety](https://stackoverflow.com/questions/64917744/cannot-run-with-sound-null-safety-because-dependencies-dont-support-null-safety)

4. 

