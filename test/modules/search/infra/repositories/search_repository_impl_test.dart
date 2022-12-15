import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/errors/errors.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/datasources/search_datasource.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/models/result_search_model.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/repositories/search_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchDatasource])
void main() {
  final datasource = MockSearchDatasource();
  final repository = SearchRepositoryImpl(datasource);

  test("should return a list of ResultSearchModel", () async {
    when(datasource.getSearch(any))
        .thenAnswer((_) async => <ResultSearchModel>[]);
    final result = await repository.search("felipe");

    expect(result.isRight(), true);
    result.fold((l) => throw Exception("Side was of left"),
        (r) => expect(r, isA<List<ResultSearch>>()));
  });

  test("should return a DatasourceError if datasource fails", () async {
    when(datasource.getSearch(any)).thenThrow(Exception());

    final result = await repository.search("felipe");
    expect(result.fold(id, id), isA<DatasourceError>());
  });
}
