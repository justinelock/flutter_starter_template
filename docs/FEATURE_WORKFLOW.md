# 功能开发全链路指南：以「登录」为例

本手册旨在指导开发者如何基于本模版快速复刻并开发一个新功能。通过理解登录（Auth）流程，你可以直接使用自动化脚本或手动复刻这套模式。

---

## 1. 核心架构：四层解耦

任何一个完整的功能都遵循以下四层结构，确保 UI、逻辑与网络请求完全分离：

| 层级 | 职责 | 核心文件示例 (Auth) |
| :--- | :--- | :--- |
| **1. UI 层 (Presentation)** | 负责显示、表单校验、调用 Controller | `login_page.dart` |
| **2. 控制器层 (Controller)** | 管理状态 (State)、处理业务逻辑、调 Repository | `auth_controller.dart` |
| **3. 仓库层 (Repository)** | 屏蔽数据源细节、处理错误映射、数据持久化 | `auth_repository_impl.dart` |
| **4. 服务层 (Service)** | 真正的网络请求 (Dio) 或 本地 Mock 实现 | `remote_auth_service.dart` |

---

## 2. “傻瓜式”一键创建模块 (推荐)

为了防止手动创建目录和文件时出现命名不规范或漏写注释，请使用项目自带的脚本。

### 2.1 运行脚本
在项目根目录下执行（以意见反馈 `feedback` 为例）：
```bash
bash scripts/create_feature.sh feedback
```

### 2.2 脚本自动完成的工作
脚本会根据你的输入（如 `feedback`），按照模版自动生成以下内容：
1.  **[创建目录]**：自动生成 `lib/features/feedback/` 下的所有子文件夹。
2.  **[定义模型]**：生成 `feedback_model.dart`，包含详细注释和 `fromJson`/`toJson`。
3.  **[写 Service]**：生成 `feedback_service.dart` 及其远程实现，默认注入 `ApiClient`。
4.  **[写 Repository]**：生成 `feedback_repository_impl.dart` 并自动配置 `feedbackRepositoryProvider`。
5.  **[写 Controller]**：生成基于 **Riverpod 3** 的 `feedback_controller.dart`，预置了 Loading 和 Error 处理。
6.  **[写 UI]**：生成 `feedback_page.dart`，已集成项目全局的 `AppGlassAppBar` 和 `PageContainer`。

---

## 3. 手动注册路由 (脚本完成后必做)

脚本无法自动修改路由表，请手动完成最后两步“接线”：

1.  **[定义路径]**：
    在 `lib/app/router/app_routes.dart` 中添加一行：
    ```dart
    static const feedback = '/feedback';
    ```

2.  **[挂载页面]**：
    在 `lib/app/router/app_router.dart` 的 `routes` 数组中添加生成的页面：
    ```dart
    GoRoute(
      path: AppRoutes.feedback,
      builder: (context, state) => const FeedbackPage(),
    ),
    ```

---

## 4. 模版避坑指南

-   **不要**在 UI 里直接调用 Dio (`ApiClient`)。
-   **必须**在 ARB 文件里加文案，严禁在 UI 硬编码用户可见的中英文。
-   **逻辑注释**：新写的逻辑必须像模版一样，写清楚“为什么这么做”和“核心逻辑”。
-   **Mock 切换**：如果后端接口还没好，在 Repository 实现类里切换为 MockService 即可跑通 UI。

---

## 5. 快速检查宏观图

```text
用户操作 -> UI.onPressed 
           -> Controller.action() 
              -> Repository.fetch() 
                 -> Service.request() 
                    -> ApiClient (Network)
```
