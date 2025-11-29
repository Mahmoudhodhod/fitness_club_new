import 'package:the_coach/Modules/CustomPlans/Plans/Data/plans_api_client.dart';
import 'package:the_coach/Modules/Plans/plans_module.dart';

import '../Models/models.dart';

class CPlansRepository {
  final CPlanApiClient _client;

  CPlansRepository({required CPlanApiClient client}) : _client = client;

  Future<PlansResponse> fetchPlans(String token, {String? nextPageUrl}) async {
    return await _client.fetchPlans(token, nextPageUrl: nextPageUrl);
  }

  Future<Plan> createPlan(String token, {required NewPlan plan}) async {
    return await _client.createPlan(token, plan: plan);
  }

  Future<Plan> updatePlan(String token, {required int id, required NewPlan plan}) async {
    return await _client.updatePlan(token, id: id, plan: plan);
  }

  Future<void> deletePlan(String token, {required int id}) async {
    return await _client.deletePlan(token, id: id);
  }
}
