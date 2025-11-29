import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '_google_request_headers.dart' as google_headers;

part 'auth_provider.g.dart';

enum AuthProvider { facebook, apple, google }

@JsonSerializable()
class OAuthCredential extends Equatable {
  final String token;
  final AuthProvider provider;
  final Map<String, dynamic> meta;

  @JsonKey(ignore: true)
  final Map<String, dynamic>? requestHeaders;

  const OAuthCredential({
    required this.token,
    required this.provider,
    this.requestHeaders,
    this.meta = const {},
  });

  // ignore: unused_element
  OAuthCredential _() => _$OAuthCredentialFromJson({});

  Map<String, dynamic> toJson() => _$OAuthCredentialToJson(this);

  @override
  List<Object?> get props {
    return [token, provider, meta];
  }
}

class GoogleAuthProvider extends OAuthCredential {
  /// Create a new [OAuthCredential] from a provided [accessToken].
  static OAuthCredential credential({required String accessToken}) {
    return GoogleAuthProvider._(accessToken: accessToken);
  }

  GoogleAuthProvider._({required String accessToken})
      : super(
          token: accessToken,
          provider: AuthProvider.google,
          requestHeaders: google_headers.headers,
        );
}

class FacebookAuthProvider extends OAuthCredential {
  /// Create a new [OAuthCredential] from a provided [accessToken].
  static OAuthCredential credential({required String accessToken}) {
    return FacebookAuthProvider._(accessToken: accessToken);
  }

  const FacebookAuthProvider._({required String accessToken})
      : super(token: accessToken, provider: AuthProvider.facebook);
}

class AppleAuthProvider extends OAuthCredential {
  /// Create a new [OAuthCredential] from a provided [code].
  static OAuthCredential credential({required String code, String? name}) {
    return AppleAuthProvider._(code: code, name: name);
  }

  AppleAuthProvider._({required String code, String? name})
      : super(
          token: code,
          provider: AuthProvider.apple,
          meta: {'name': name},
        );
}
