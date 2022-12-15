import 'package:dio/dio.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/datasources/search_datasource.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/models/result_search_model.dart';

class GithubDatasource implements SearchDatasource {
  final Dio dio;

  GithubDatasource({required this.dio});

  @override
  Future<List<ResultSearchModel>> getSearch(String searchText) {
    // TODO: implement getSearch
    throw UnimplementedError();
  }
}
