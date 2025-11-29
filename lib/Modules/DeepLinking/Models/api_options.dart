import 'package:equatable/equatable.dart';

import 'options.dart';

class ApiOptions extends Equatable {
  final String accessToken;
  final DeepLinkOptions deepLinkingOptions;

  const ApiOptions({
    required this.accessToken,
    required this.deepLinkingOptions,
  });

  @override
  List<Object> get props => [accessToken, deepLinkingOptions];
}
