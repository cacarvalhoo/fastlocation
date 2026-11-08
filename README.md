# FastLocation

Aplicativo Flutter para consulta de CEP e endereços, usando a API pública
[ViaCEP](https://viacep.com.br). Desenvolvido para Android e iOS.

**Autor:** Carolina Carvalho

## Funcionalidades

- Tela de abertura e redirecionamento para a Home.
- Consulta por **CEP** (8 dígitos).
- Consulta por **endereço** (UF, cidade e logradouro completo ou parcial).
- Último endereço consultado em destaque na Home.
- **Traçar rota** até o endereço no aplicativo de mapas do aparelho.
- **Histórico** dos endereços consultados, com opção de abrir no mapa e limpar.

## Tecnologias

- Flutter e Dart
- Dio (requisições HTTP)
- MobX e flutter_mobx (gerenciamento de estado)
- Hive (armazenamento local)
- map_launcher (abrir aplicativos de mapas)

## Estrutura

```
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── http/            # cliente Dio
    ├── routes/          # rotas nomeadas
    ├── shared/          # cores, métricas, componentes e Hive
    └── modules/
        ├── initial/     # tela de abertura
        ├── home/        # consulta (model, repositories, service, controller, page)
        └── history/     # histórico (controller, page)
```

## Pré-requisitos

- Flutter SDK (canal stable) e Dart
- Android Studio (Android SDK e emulador) ou um celular com depuração USB
- Git

Confira o ambiente com `flutter doctor`.

## Como executar

```bash
git clone https://github.com/SEU_USUARIO/fastlocation.git
cd fastlocation
flutter pub get
flutter run
```

Para gerar os arquivos do MobX, se necessário:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Observações

- O app precisa de internet para consultar o ViaCEP.
- A busca por CEP retorna a rua sem número. Na busca por endereço, o número
  digitado após o nome da rua é ignorado, pois o ViaCEP só aceita o logradouro.
- Em emulador Android, a localização padrão fica na Califórnia. Para ver a rota
  completa, configure uma localização em *Extended controls > Location*.
  Em um celular real a origem é a posição do aparelho.