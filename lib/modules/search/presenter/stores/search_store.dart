import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_state.dart';

class SearchStore extends Cubit<SearchState> {
  final SearchByText usecase;

  SearchStore(this.usecase) : super(SearchStart());

  get(String searchText) async {
    emit(SearchLoading());

    final res = await usecase(searchText);
    res.fold(
      (l) {
        emit(SearchError());
      },
      (r) {
        final searchSuccess = SearchSuccess(r);
        emit(searchSuccess);
      },
    );
  }
}
