import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:the_coach/Modules/MainExercises/Models/models.dart';
import 'package:the_coach/Modules/MainExercises/ViewModels/view_models.dart';

class MainExerciseViewActionsHandler extends ChangeNotifier {
  static MainExerciseViewActionsHandler get(BuildContext context) => context.read<MainExerciseViewActionsHandler>();

  MainExerciseViewModel? _mainExercise;
  Map<int, MainExerciseViewModel> _localDB = {};
  MainExerciseViewModel get exercise => _mainExercise ?? MainExerciseViewModel.empty;

  void setMainExercise(MainExercise model) {
    _mainExercise = _getExercise(model.id) ?? MainExerciseViewModel.fromArticle(model);
    _updateExerciseLocalDB();
    notifyListeners();
  }

  void toggleIsFavorite(bool isFavorite) {
    assert(_mainExercise != null);
    _mainExercise!.toggleIsFavorite(isFavorite);
    _updateExerciseLocalDB();
    notifyListeners();
  }

  bool isExerciseFavorite(int id, {required bool originalFavorite}) {
    final isFav = _getExercise(id)?.isFavorite ?? originalFavorite;
    return isFav;
  }

  MainExerciseViewModel? _getExercise(int id) {
    final localDB = _localDB[id];
    return localDB;
  }

  void _updateExerciseLocalDB() {
    assert(_mainExercise != null);
    final id = _mainExercise!.id;
    _localDB[id] = _mainExercise!;
  }

  @override
  void dispose() {
    _mainExercise = null;
    _localDB.clear();
    super.dispose();
  }
}
