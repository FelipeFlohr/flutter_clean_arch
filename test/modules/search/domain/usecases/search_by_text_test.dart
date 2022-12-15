import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/errors/errors.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/repositories/search_repository.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_by_text_test.mocks.dart';

@GenerateMocks([SearchRepository])
void main() {
  final repository = MockSearchRepository();
  final usecase = SearchByTextImpl(repository);

  test("should return a ResultSearch list", () async {
    when(repository.search(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    final result = await usecase("felipe");
    expect(result.isRight(), true);
    result.fold((l) => throw Exception("Result was of left"), (r) {
      expect(r, isA<List<ResultSearch>>());
      return r;
    });
  });

  test("should return an exception if the text is invalid", () async {
    when(repository.search(any))
        .thenAnswer((_) async => const Right(<ResultSearch>[]));

    final result = await usecase("");
    expect(result.isLeft(), true);
    result.fold((l) => expect(l, isA<FailureSearch>()),
        (r) => throw Exception("Result was of right"));
  });
}
