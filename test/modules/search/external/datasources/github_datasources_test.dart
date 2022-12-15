import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/external/datasources/github_datasources.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/models/result_search_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_datasources_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final dio = MockDio();

  final datasource = GithubDatasource(dio: dio);

  test("Should return a list of ResultSearchModel", () async {
    when(dio.get(any)).thenAnswer((_) async => Response(
        data: {}, statusCode: 200, requestOptions: RequestOptions(path: "/")));

    final result = await datasource.getSearch("felipe");
    expect(result, isA<List<ResultSearchModel>>());
  });
}
