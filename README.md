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
