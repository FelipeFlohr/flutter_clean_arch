import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/repositories/search_repository.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/external/datasources/github_datasources.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/datasources/search_datasource.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/repositories/search_repository_impl.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/search_page.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_store.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory<Dio>((i) => Dio()),
        Bind.factory<SearchDatasource>((i) => GithubDatasource(dio: i())),
        Bind.factory<SearchRepository>((i) => SearchRepositoryImpl(i())),
        Bind.factory<SearchByText>((i) => SearchByTextImpl(i())),
        Bind.singleton<SearchStore>((i) => SearchStore(i())),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      "/",
      child: (context, args) => const SearchPage(),
    ),
  ];
}
