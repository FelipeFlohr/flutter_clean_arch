import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/app_module.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';

import 'modules/search/external/datasources/github_datasources_test.mocks.dart';
import 'modules/search/utils/github_response.dart';

@GenerateMocks([Dio])
void main() {
  final dioMock = MockDio();

  setUp(() {
    initModule(
      AppModule(),
      replaceBinds: [
        Bind.instance<Dio>(dioMock),
      ],
    );
  });

  test("Should bring the usecase without errors", () {
    final usecase = Modular.get<SearchByText>();
    expect(usecase, isA<SearchByTextImpl>());
  });

  test("Should return a list of ResultSearch", () async {
    when(dioMock.get(any)).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: "/"),
        data: jsonDecode(githubResult),
        statusCode: 200,
      ),
    );

    final usecase = Modular.get<SearchByText>();
    final result = await usecase("Felipe");

    expect(result.isRight(), true);
    result.fold((l) => throw Exception("Left side"),
        (r) => expect(r, isA<List<ResultSearch>>()));
  });
}
