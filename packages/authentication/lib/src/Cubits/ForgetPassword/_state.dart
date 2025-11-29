import 'package:equatable/equatable.dart';
import 'package:authentication/src/Models/models.dart';

enum ForgetPasswordS {
  initial,
  loading,
  loaded,
  failed,
}

class ForgetPasswordState extends Equatable {
  final ForgetPasswordS state;
  final User? user;
  final bool isVerified;
  final Object? companion;

  const ForgetPasswordState({
    this.state = ForgetPasswordS.initial,
    this.user,
    this.isVerified = true,
    this.companion,
  });

  @override
  List<Object?> get props => [state, user, isVerified, companion];

  ForgetPasswordState copyWith({
    ForgetPasswordS? state,
    User? user,
    bool? isVerified,
    Object? companion,
  }) {
    return ForgetPasswordState(
      state: state ?? this.state,
      user: user ?? this.user,
      isVerified: isVerified ?? this.isVerified,
      companion: companion ?? this.companion,
    );
  }
}
