#!/bin/bash

# 功能模块一键生成脚本 (Clean Architecture + Riverpod 3)
# 使用方法: bash scripts/create_feature.sh <功能名称>
# 示例: bash scripts/create_feature.sh feedback

set -e

if [ -z "$1" ]; then
  echo "❌ 错误: 请提供功能名称 (小写下划线，例如: feedback)"
  exit 1
fi

# 1. 处理名称格式
FEATURE_NAME_SNAKE=$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/-/_/g')
FEATURE_NAME_PASCAL=$(echo "$FEATURE_NAME_SNAKE" | sed -r 's/(^|_)([a-z])/\U\2/g')

BASE_PATH="lib/features/$FEATURE_NAME_SNAKE"

echo "🚀 正在创建 [$FEATURE_NAME_PASCAL] 模块..."

# ---------------------------------------------------------
# Step 1: [创建目录]
# ---------------------------------------------------------
mkdir -p "$BASE_PATH/data/models"
mkdir -p "$BASE_PATH/data/repositories"
mkdir -p "$BASE_PATH/data/services"
mkdir -p "$BASE_PATH/domain/entities"
mkdir -p "$BASE_PATH/domain/repositories"
mkdir -p "$BASE_PATH/presentation/controllers"
mkdir -p "$BASE_PATH/presentation/pages"
mkdir -p "$BASE_PATH/presentation/widgets"

# ---------------------------------------------------------
# Step 2: [定义模型]
# ---------------------------------------------------------
cat <<EOF > "$BASE_PATH/data/models/${FEATURE_NAME_SNAKE}_model.dart"
/// ${FEATURE_NAME_PASCAL} 数据模型
/// 
/// 负责 JSON 序列化。逻辑：在此处对齐后端字段，处理空值。
class ${FEATURE_NAME_PASCAL}Model {
  const ${FEATURE_NAME_PASCAL}Model({required this.id, required this.content});

  final String id;
  final String content;

  factory ${FEATURE_NAME_PASCAL}Model.fromJson(Map<String, dynamic> json) {
    return ${FEATURE_NAME_PASCAL}Model(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
  };
}
EOF

# ---------------------------------------------------------
# Step 3: [写 Service]
# ---------------------------------------------------------
cat <<EOF > "$BASE_PATH/data/services/${FEATURE_NAME_SNAKE}_service.dart"
import '../models/${FEATURE_NAME_SNAKE}_model.dart';

/// 服务接口：理由是方便后续切换 Mock 实现
abstract class ${FEATURE_NAME_PASCAL}Service {
  Future<void> submit(${FEATURE_NAME_PASCAL}Model data);
}
EOF

cat <<EOF > "$BASE_PATH/data/services/remote_${FEATURE_NAME_SNAKE}_service.dart"
import '../../../../core/network/api_client.dart';
import '../models/${FEATURE_NAME_SNAKE}_model.dart';
import '${FEATURE_NAME_SNAKE}_service.dart';

/// 远程接口实现：对接 env_config.dart 中的 baseUrl
class Remote${FEATURE_NAME_PASCAL}Service implements ${FEATURE_NAME_PASCAL}Service {
  const Remote${FEATURE_NAME_PASCAL}Service(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<void> submit(${FEATURE_NAME_PASCAL}Model data) async {
    // 逻辑：调用统一的 ApiClient
    await _apiClient.post('/$FEATURE_NAME_SNAKE', data: data.toJson());
  }
}
EOF

# ---------------------------------------------------------
# Step 4: [写 Repository]
# ---------------------------------------------------------
cat <<EOF > "$BASE_PATH/data/repositories/${FEATURE_NAME_SNAKE}_repository_impl.dart"
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/error_mapper.dart';
import '../models/${FEATURE_NAME_SNAKE}_model.dart';
import '../services/remote_${FEATURE_NAME_SNAKE}_service.dart';
import '../services/${FEATURE_NAME_SNAKE}_service.dart';

/// 仓库 Provider：逻辑中转站
final ${FEATURE_NAME_SNAKE}RepositoryProvider = Provider<${FEATURE_NAME_PASCAL}RepositoryImpl>((ref) {
  return ${FEATURE_NAME_PASCAL}RepositoryImpl(
    service: Remote${FEATURE_NAME_PASCAL}Service(ref.watch(apiClientProvider)),
  );
});

class ${FEATURE_NAME_PASCAL}RepositoryImpl {
  const ${FEATURE_NAME_PASCAL}RepositoryImpl({required ${FEATURE_NAME_PASCAL}Service service})
      : _service = service;

  final ${FEATURE_NAME_PASCAL}Service _service;

  Future<void> submitData(${FEATURE_NAME_PASCAL}Model data) async {
    try {
      await _service.submit(data);
    } catch (e) {
      // 逻辑：统一错误转换
      throw ErrorMapper.toFailure(e);
    }
  }
}
EOF

# ---------------------------------------------------------
# Step 5: [写 Controller]
# ---------------------------------------------------------
cat <<EOF > "$BASE_PATH/presentation/controllers/${FEATURE_NAME_SNAKE}_controller.dart"
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/${FEATURE_NAME_SNAKE}_model.dart';
import '../../data/repositories/${FEATURE_NAME_SNAKE}_repository_impl.dart';

/// 状态控制器：管理 Loading, Error, Success
final ${FEATURE_NAME_SNAKE}ControllerProvider =
    AutoDisposeAsyncNotifierProvider<${FEATURE_NAME_PASCAL}Controller, void>(
  ${FEATURE_NAME_PASCAL}Controller.new,
);

class ${FEATURE_NAME_PASCAL}Controller extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit(String content) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final model = ${FEATURE_NAME_PASCAL}Model(id: '', content: content);
      await ref.read(${FEATURE_NAME_SNAKE}RepositoryProvider).submitData(model);
    });
    state = result;
    return !result.hasError;
  }
}
EOF

# ---------------------------------------------------------
# Step 6: [写 UI]
# ---------------------------------------------------------
cat <<EOF > "$BASE_PATH/presentation/pages/${FEATURE_NAME_SNAKE}_page.dart"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_glass_app_bar.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../shared/widgets/page_container.dart';
import '../controllers/${FEATURE_NAME_SNAKE}_controller.dart';

/// 模块页面：使用 GlassScaffold 保证视觉一致性
class ${FEATURE_NAME_PASCAL}Page extends ConsumerWidget {
  const ${FEATURE_NAME_PASCAL}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${FEATURE_NAME_SNAKE}ControllerProvider);

    return GlassScaffold(
      appBar: const AppGlassAppBar(title: '${FEATURE_NAME_PASCAL}'),
      body: PageContainer(
        child: Column(
          children: [
            if (state.isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: state.isLoading 
                ? null 
                : () => ref.read(${FEATURE_NAME_SNAKE}ControllerProvider.notifier).submit('Content'),
              child: const Text('Confirm Action'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# 设置执行权限
chmod +x "$0" 2>/dev/null || true

echo "✅ [$FEATURE_NAME_PASCAL] 模块创建完成！"
echo "👉 Step 7: 注册路由"
echo "1. 在 lib/app/router/app_routes.dart 中添加: static const $FEATURE_NAME_SNAKE = '/$FEATURE_NAME_SNAKE';"
echo "2. 在 lib/app/router/app_router.dart 中添加 GoRoute 映射到 ${FEATURE_NAME_PASCAL}Page。"
