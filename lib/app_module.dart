import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/usecases/search_by_text.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/external/datasources/github_datasources.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/infra/repositories/search_repository_impl.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.factory((i) => Dio()),
        Bind.factory((i) => GithubDatasource(dio: i())),
        Bind.factory((i) => SearchRepositoryImpl(i())),
        Bind.factory((i) => SearchByTextImpl(i())),
      ];

  @override
  final List<ModularRoute> routes = [];
}
