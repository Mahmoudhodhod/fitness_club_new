part of 'email_verification_cubit.dart';

enum EVState { initial, loading, loaded, failed }

class EmailVerificationState extends Equatable {
  final EVState state;
  final User? user;
  final Object? companion;

  const EmailVerificationState({
    this.user,
    this.state = EVState.initial,
    this.companion,
  });

  EmailVerificationState copyWith({
    EVState? state,
    User? user,
    Object? companion,
  }) {
    return EmailVerificationState(
      state: state ?? this.state,
      user: user ?? this.user,
      companion: companion ?? this.companion,
    );
  }

  @override
  List<Object?> get props => [state, user, companion];

  @override
  String toString() {
    if (companion != null) return 'EmailVerificationState($state, e: ${companion != null})';
    return 'EmailVerificationState($state, user: ${user?.email ?? '-'})';
  }
}
