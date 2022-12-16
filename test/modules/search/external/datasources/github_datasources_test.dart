import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/errors/errors.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/external/datasources/github_datasources.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../utils/github_response.dart';
import 'github_datasources_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final dio = MockDio();
  final datasource = GithubDatasource(dio: dio);

  test("Should return a list of ResultSearchModel", () async {
    when(dio.get(any)).thenAnswer((_) async => Response(
        data: jsonDecode(githubResult),
        statusCode: 200,
        requestOptions: RequestOptions(path: "/")));

    // Retornando erro por causa de Null Safety. Implementação será feita em breve
    final future = datasource.getSearch("felipe");
    expect(future, completes);
  });

  test("Should return an error if HTTP status code is not 200", () async {
    when(dio.get(any)).thenAnswer((_) async => Response(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(path: "/")));

    final future = datasource.getSearch("benio");
    expect(future, throwsA(isA<DatasourceError>()));
  });
}
