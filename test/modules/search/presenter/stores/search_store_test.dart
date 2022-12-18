import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/errors/errors.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_state.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_store.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_store_test.mocks.dart';

@GenerateMocks([SearchByText])
void main() {
  late MockSearchByText usecase;
  late SearchStore store;

  // Before Each
  setUp(
    () {
      usecase = MockSearchByText();
      store = SearchStore(usecase);
    },
  );
  // After each
  tearDown(
    () {
      usecase = MockSearchByText();
      store = SearchStore(usecase);
    },
  );

  blocTest(
    "Should return the success state in the right order",
    build: () => store,
    act: (bloc) {
      when(usecase.call(any))
          .thenAnswer((_) async => const Right(<ResultSearch>[]));

      bloc.get("felipe");
    },
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchSuccess>(),
    ],
  );

  blocTest(
    "Should return the failed state in the right order",
    build: () => store,
    act: (bloc) {
      when(usecase.call(any)).thenAnswer((_) async => Left(DatasourceError()));

      bloc.get("felipe");
    },
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchError>(),
    ],
  );
}
