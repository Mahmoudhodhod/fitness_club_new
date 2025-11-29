part of 'fetchdata_cubit.dart';

enum LoadingState {
  initial,
  loading,
  loaded,
  failed,
}

class FetchDataState extends Equatable {
  final LoadingState loadingState;
  final User user;
  final Object? e;

  const FetchDataState({
    this.loadingState = LoadingState.initial,
    this.user = User.empty,
    this.e,
  });

  FetchDataState copyWith({
    LoadingState? loadingState,
    User? user,
    Object? e,
  }) {
    return FetchDataState(
      loadingState: loadingState ?? this.loadingState,
      user: user ?? this.user,
      e: e ?? this.e,
    );
  }

  @override
  List<Object?> get props => [loadingState, user, e];

  @override
  String toString() {
    final state = this.loadingState.toString().split(".").last;
    if (e == null) return "FetchDataState(user: ${user.id}, laodingState: $state)";
    return 'FetchDataState(user: ${user.id}, state: $state e => $e )';
  }
}
