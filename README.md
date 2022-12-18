# Mobile Onboarding -> Clean Architecture
Este repositório contém os estudos relacionados ao "Clean Architecture", do Uncle Bob.

Objetivo: criar um sistema de pesquisa que consiga obter tanto a informação de um usuário do YouTube como do GitHub, reaproveitando o código

## 1. O Domain
A camada de Domain contém as Regras de Negócio Corporativa (entities) e de Aplicação (usecases).

- Entities: são objetos entidade-relacional simples podendo conter regras de validação dos seus dados por meio de funções ou ValueObjects. A entidade **não deve usar nenhum objeto das outras camadas**.
- Casos de uso: executam a lógica necessária para resolver o problema. Se o caso de uso precisar de algum acesso externo então esse acesso deve ser feito por meio de contratos de interface que serão implementados em uma camada de mais baixo nível.
- Repository: contém apenas o contrato de interfaces e a responsabilidade de implementação desse objeto deverá ser repassado a outra camada mais baixa.
- Errors: contém os erros que podem ser lançados durante no runtime da aplicação.

Por fim, a camada **Domain** deve ser responsável apenas pela execução da lógica de negócio, não deve haver implementações de outros objetos como Repositories ou Services dentro do Domain.

### 1.1 Unit testing
Unit testing foi realizado em ambiente mocado, dentro do endereço *"test/modules/search/domain/usecases"*. Para isso, foi utilizado o ***Mockito***, que auxilía na construção de classes mocadas. Para utilizar o Mockito, foi necessário utilizar a annotation ***@GenerateMocks*** no `main()` do teste, passando as classes á serem mocadas como argumento, veja:
```dart
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
```

**Nota-se que é necessário rodar o comando** `flutter pub run build_runner build --delete-conflicting-outputs` **no terminal** para gerar as classes mocadas compiladas.

## 2. A Infrastructure (Infra) / Data
Esta camada dá suporte a camada **Domain** implementando suas interfaces. Para isso, adapta os dados externos para que possa cumprir os contratos do domínio.

Nessa camada foi implementada as interfaces que podem ou não depender de dados externos como uma API.

## 3. A External
A camada external deve conter tudo aquilo que terá grandes chances de ser alterado sem que o programador possa intervir diretamente no projeto. Exemplo: num sistema onde o login é feito com o Firebase Auth, há a demanda de trocar por outro serviço. Para isso, bastaria apenas implementar um datasource baseado no outro provider e "Inverter a dependência" assim quando necessário.

Os Datasources devem se preocupar apenas em "descobrir" os dados externos e enviar para a camada de Infra para serem tratados. Da mesma forma os objetos **Drivers** devem apenas retornar as informações solicitadas sobre o Hardware do Device e não devem fazer tratamento fora ao que lhe foi solicitado no contrato.

## 4. Injeção de dependências
A injeção de dependências foi realizada com o Modular, uma dependência desenvolvida pela própria galera do Flutterando. A mesma foi inspirada no Angular e precisa ser instanciada no inicializar da Aplicação, veja:
```dart
void main() {
  runApp(ModularApp(
    module: AppModule(), // <- Contêm os módulos da aplicação
    child: const AppWidget(), // <- Contêm o Entrypoint da UI da aplicação
  ));
}
```

Um exemplo de módulos seria o seguinte:
```dart
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
```

Um bind pode ter os seguintes quatro tipos:
- *`Bind.singleton`*: Cria uma única instância quando o módulo é inicializado
- *`Bind.lazySingleton`*: Cria uma única instância quando o Bind for chamado
- *`Bind.factory`*: Cria uma instância conforme a demanda
- *`Bind.instance`*: Adiciona uma instância já existente 

## 5. A Presenter
A camada **Presenter** é a responsável por declarar as entradas, saídas e interações da aplicação. Nela contém os Widgets, Pages, States e Stores de um módulo. Na gerência de estado desse exemplo foi utilizado o ***Cubit***, que faz parte da biblioteca do *BLoC*. Veja as declarações de estado:
```dart
abstract class SearchState {}

class SearchSuccess implements SearchState {
  final List<ResultSearch> list;

  SearchSuccess(this.list);
}

class SearchStart implements SearchState {}

class SearchLoading implements SearchState {}

class SearchError implements SearchState {}
```
Repare como as últimas quatro classes implementam o `SearchState`. Com os estados declarados, basta implementar o Store, veja:
```dart
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
```
Repare que o Store herda a classe `Cubit` passando o tipo `SearchState` como genérico. Além disso, recebe o *usecase* SearchByText via injeção de dependências. No mais, a classe possui o método `get`, na qual busca os usuários baseado no parâmetro *searchText*. De inicio, o método emite o estado ***`SearchLoading`***, e, caso tenha sucesso, emite o ***`SearchSuccess`***, senão emitirá o ***`SearchError`***.

A renderização é feita utilizando o `BlocBuilder`, veja:
```dart
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
}
```
Conforme cada estado, o *BlocBuilder* chama um método que retorna um Widget para representar o estado atual. Nos Widgets *padrão* e de erro, retorna um simples Widget de Text, veja:

*Widget padrão:*
```dart
_getDefault() {
  return const Text("Digite um usuário");
}
```
*Widget de erro:*
```dart
_getFailed() {
  return const Text("Ocorreu um erro. Tente novamente mais tarde.");
}
```
<br />
Nos estados e *Loading* e de sucesso, retorna um Widget mais robusto. Veja:

*Widget de Loading:*
```dart
_getLoading() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}
```
*Widget de sucesso:*
```dart
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
```
---
Também foi implementado um *debounce* no TextInput, para fazer com que não fique consumindo excessivamente a API do GitHub. O *debounce* possui um delay de 800ms. Veja a implementação:
```dart
_onSearchChanged(String searchText) {
  if (_debounce?.isActive ?? false) {
    _debounce?.cancel();
  }
  _debounce = Timer(
    const Duration(milliseconds: 800),
    () async { // <- Callback
      await searchPageStore.get(searchText);
    },
  );
}
```