import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';

abstract class SearchState {}

class SearchSuccess implements SearchState {
  final List<ResultSearch> list;

  SearchSuccess(this.list);
}

class SearchStart implements SearchState {}

class SearchLoading implements SearchState {}

class SearchError implements SearchState {}
