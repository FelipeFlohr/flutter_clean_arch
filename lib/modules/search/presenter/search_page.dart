import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/domain/entities/result_search.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_state.dart';
import 'package:mobile_onboarding_clean_arch/modules/search/presenter/stores/search_store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchPageStore = Modular.get<SearchStore>();
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Github Search"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
            ),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Search..."),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: BlocBuilder(
              bloc: searchPageStore,
              builder: (context, state) {
                if (state is SearchError) {
                  return _getFailed();
                } else if (state is SearchLoading) {
                  return _getLoading();
                } else if (state is SearchSuccess) {
                  return _getSuccess(state.list);
                } else {
                  return _getDefault();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _getDefault() {
    return const Text("Digite um usuário");
  }

  _getLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _getSuccess(List<ResultSearch> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        final item = list[index];
        return ListTile(
          title: Text(item.title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(item.img),
          ),
          subtitle: Text(item.content),
        );
      },
    );
  }

  _getFailed() {
    return const Text("Ocorreu um erro. Tente novamente mais tarde.");
  }

  _onSearchChanged(String searchText) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 800),
      () async {
        await searchPageStore.get(searchText);
      },
    );
  }
}
