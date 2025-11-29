part of 'processdeeplinkingoptions_cubit.dart';

abstract class ProcessDeepLinkingOptionsState extends Equatable {
  const ProcessDeepLinkingOptionsState();

  @override
  List<Object?> get props => [];
}

class ProcessDeepLinkingOptionsInitial extends ProcessDeepLinkingOptionsState {}

// is loading
class ProcessDeepLinkingOptionsIsLoading extends ProcessDeepLinkingOptionsState {}

// succeeded
class ProcessDeepLinkingOptionsSucceeded extends ProcessDeepLinkingOptionsState {}

// failed
class ProcessDeepLinkingOptionsFailure extends ErrorState implements ProcessDeepLinkingOptionsState {
  const ProcessDeepLinkingOptionsFailure([Object? e]) : super(e);
}
