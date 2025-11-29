import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserUpdate extends Equatable {
  final String? name;
  final String? email;
  final File? image;

  const UserUpdate({
    this.name,
    this.email,
    this.image,
  });

  @visibleForTesting
  Future<Map<String, dynamic>> toMap() async {
    Map<String, dynamic> _data = {};
    if (this.image != null) _data["image"] = await MultipartFile.fromFile(this.image!.path);
    if (this.name != null) _data["name"] = this.name;
    if (this.email != null) _data["email"] = this.email;
    return _data;
  }

  ///Get user form data to be updated.
  ///
  Future<FormData?> getUpdatedData() async {
    Map<String, dynamic> _data = await toMap();
    if (_data.isEmpty) return Future.value();
    return FormData.fromMap(_data);
  }

  ///Determine if the update model is empty.
  ///
  bool isEmpty() => this == UserUpdate();

  ///Determine if the update model is not empty.
  ///
  bool isNotEmpty() => this != UserUpdate();

  @override
  List<Object?> get props => [name, email, image];

  UserUpdate copyWith({
    String? name,
    String? email,
    File? image,
  }) {
    return UserUpdate(
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }

  @override
  bool? get stringify => true;
}
