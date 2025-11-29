import 'package:the_coach/Modules/CustomPlans/Weeks/Data/week_api_client.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

class CWeeksRepository {
  final CPlanWeekApiClient _client;

  CWeeksRepository({required CPlanWeekApiClient client}) : _client = client;

  Future<PlanWeeksResponse> fetchPlanWeeks(String token, {required int planID}) async {
    return await _client.fetchPlanWeeks(token, planID: planID);
  }

  Future<PlanWeek> createWeek(String token, {required int planID}) async {
    return await _client.createWeek(token, planID: planID);
  }

  Future<void> deleteWeek(String token, {required int planID, required int weekID}) async {
    return await _client.deleteWeek(token, planID: planID, id: weekID);
  }
}
