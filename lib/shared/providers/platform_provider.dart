import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final platformNameProvider = Provider<String>(
  (ref) => kIsWeb ? 'web' : defaultTargetPlatform.name,
  name: 'platformNameProvider',
);
