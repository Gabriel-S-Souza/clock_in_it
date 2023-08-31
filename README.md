## Clock In It

Clock In It permite aos usuários fazer login, visualizar uma lista de colaboradores com ou sem conexão com a internet (caching), ele permite ainda ver detalhes dos colaboradores e receber notificações com informações da API armazenadas. A versão web pode ser acessada aqui: https://golden-dieffenbachia-3c2ae4.netlify.app/#/

### Tecnologias
- Flutter
- Dart
- flutter_bloc
- dio
- get_it
- go_router
- jwt
- flutter_local_notifications
  
### Técnicas
- Arquitetura:
   - O projeto segue **Clean Architecture** (baseado na proposta da [**Resocoder**](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)) que enfatiza a separação de responsabilidades em camadas, prevenindo que as estruturas de alto nível sejam sujeitas a mudanças excessivas relacionadas aos detalhes.
   - Adota também o padrão de organização [**Feature First**](https://codewithandrea.com/articles/flutter-project-structure/), que prioriza a estruturação do projeto em torno das funcionalidades, facilitando a manutenção e a escalabilidade.
- Testes unitários:
  - Os testes seguem o pattern **Arrange, Act, Assert** e para mocks foi utilizado [**Mockito**](https://pub.dev/packages/mockito)
- Autenticação com JWT
- Caching com Decorator Pattern
- Princípios SOLID
- Injeção de Dependência
- Service Locator
- Factory Methods
- Singleton
- State Management

### Como Executar
A versão do Flutter utilizada no projeto foi a 3.10.6.
Clone este repositório para o seu ambiente de desenvolvimento:
```
git clone https://github.com/Gabriel-S-Souza/clock_in_it.git
```

Abra o projeto em um editor de código e baixe as dependências:

```
flutter pub get
```

Selecione um dispositivo android ou ios ou selecione o chrome para a versão web. E então execute o app:

```
flutter run
```
