import 'package:equatable/equatable.dart';
import 'package:the_coach/Modules/MainExercises/Models/main_exercise.dart';

// ignore: must_be_immutable
class MainExerciseViewModel extends Equatable {
  final int id;
  late bool _isFavorite;
  late int _favoriteCount;

  bool get isFavorite => _isFavorite;
  int get favoriteCount => _favoriteCount;

  MainExerciseViewModel._({
    required this.id,
    bool isFavorite = false,
    int favoriteCount = 0,
  }) {
    _isFavorite = isFavorite;
    _favoriteCount = favoriteCount;
  }

  ///Creates [MainExerciseViewModel] from a base [MainExercise] model.
  static MainExerciseViewModel fromArticle(MainExercise exercise) {
    return MainExerciseViewModel._(
      id: exercise.id,
      favoriteCount: exercise.favoritesCount,
      isFavorite: exercise.isFavorite,
    );
  }

  ///Creates an empty default view model.
  static MainExerciseViewModel get empty {
    return MainExerciseViewModel._(
      id: -1,
      favoriteCount: 0,
      isFavorite: false,
    );
  }

  ///Toggles favorite model state.
  void toggleIsFavorite(bool isFavorite) {
    if (isFavorite == _isFavorite) return;
    _isFavorite = isFavorite;
    _isFavorite ? _addFavoriteCount(1) : _addFavoriteCount(-1);
  }

  void _addFavoriteCount([int count = 1]) {
    _favoriteCount += count;
  }

  @override
  List<Object> get props => [id];

  @override
  String toString() => "MainExerciseViewModel(id: $id, favorited: $_isFavorite)";
}
