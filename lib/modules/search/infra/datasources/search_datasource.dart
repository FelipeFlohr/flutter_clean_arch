import 'package:mobile_onboarding_clean_arch/modules/search/infra/models/result_search_model.dart';

abstract class SearchDatasource {
  Future<List<ResultSearchModel>> getSearch(String searchText);
}
