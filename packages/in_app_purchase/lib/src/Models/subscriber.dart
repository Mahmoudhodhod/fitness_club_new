import 'package:equatable/equatable.dart';

class Subscriber extends Equatable {
  final int id;
  final String uuid;
  final String name;
  final String email;
  final DateTime registeredAt;
  final String imagePath;
  final bool isAdmin;

  const Subscriber({
    required this.id,
    required this.uuid,
    required this.name,
    required this.email,
    required this.registeredAt,
    required this.imagePath,
    this.isAdmin = false,
  });

  @override
  List<Object> get props {
    return [id, uuid, name, email, registeredAt, imagePath, isAdmin];
  }
}
