import 'package:dio/dio.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/errors/errors.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/datasources/search_datasource.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/models/result_search_model.dart';

extension on String {
  normalizeUrlString() {
    return replaceAll(" ", "+");
  }
}

class GithubDatasource implements SearchDatasource {
  final Dio dio;

  GithubDatasource({required this.dio});

  @override
  Future<List<ResultSearchModel>> getSearch(String searchText) async {
    final response = await dio.get(
        "https://api.github.com/search/users?q=${searchText.normalizeUrlString()}");
    if (response.statusCode == 200) {
      final list = (response.data["items"] as List)
          .map((e) => ResultSearchModel.fromMap(e))
          .toList();
      return list;
    } else {
      throw DatasourceError();
    }
  }
}
