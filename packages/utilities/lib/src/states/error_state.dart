import 'package:equatable/equatable.dart';

abstract class ErrorState extends Equatable {
  final Object? e;
  const ErrorState([this.e]);

  @override
  List<Object?> get props => [e];

  @override
  bool? get stringify => true;
}
