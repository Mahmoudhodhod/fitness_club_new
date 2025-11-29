import 'package:the_coach/Modules/Plans/plans_module.dart';

class PlansRepository {
  final PlansApiClient _apiClient;

  PlansRepository({
    required PlansApiClient client,
  }) : _apiClient = client;

  Future<PlanCategoriesResponse> fetchPlanCategories(String token) async {
    final result = await _apiClient.fetchPlanCategories(token);
    return result;
  }

  Future<PlansResponse> fetchPlans(
    String token, {
    required int categoryID,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchPlans(
      token,
      categoryID: categoryID,
      nextPageUrl: nextPageUrl,
    );
    return result;
  }

  Future<PlansResponse> searchPlans(
    String token, {
    required String query,
    String? nextPageUrl,
  }) async {
    final result = await _apiClient.fetchPlans(
      token,
      search: query,
      nextPageUrl: nextPageUrl,
    );
    return result;
  }

  Future<PlanWeeksResponse> fetchPlanWeeks(
    String token, {
    required int planID,
  }) async {
    return await _apiClient.fetchPlanWeeks(token, planID: planID);
  }

  Future<DayExercisesResponse> fetchDayDetails(
    String token, {
    required int dayID,
  }) async {
    return await _apiClient.fetchDayDetails(token, dayID: dayID);
  }
}
