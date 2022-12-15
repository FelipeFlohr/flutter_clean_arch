import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/repositories/search_repository.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mockito/mockito.dart';

class SearchRepositoryMock extends Mock implements SearchRepository {
}

void main() {
  final SearchRepository repository = SearchRepositoryMock();
  final usecase = SearchByTextImpl(repository);

  test("should return a ResultSearch list", () async {
    when(repository.search(any)).thenAnswer((realInvocation) => Right())

    final result = await usecase("whatever");

    /**
     * Um "Either" pode retornar tanto um "Left" como um Right. Como o nosso Left
     * é uma exceção, então espera-se que o resultado seja um Right.
     */
    expect(result, isA<Right>());

    final List<ResultSearch> resultRight =
        result.fold((l) => throw Exception("Left pos caught"), (r) => r);
    expect(result, isA<List<ResultSearch>>());
  });
}
