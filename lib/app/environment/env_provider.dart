import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env_config.dart';
import 'feature_flags.dart';

final envConfigProvider = Provider<EnvConfig>(
  (ref) => EnvConfig.current(),
  name: 'envConfigProvider',
);

final featureFlagsProvider = Provider<FeatureFlags>(
  (ref) => ref.watch(envConfigProvider).featureFlags,
  name: 'featureFlagsProvider',
);
