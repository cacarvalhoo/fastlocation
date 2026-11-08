# FastLocation

Aplicativo Flutter para consulta de CEP e endereços, usando a API pública
[ViaCEP](https://viacep.com.br). Desenvolvido para Android e iOS.

**Autor:** Carolina Carvalho

## Funcionalidades

- Tela de abertura com animação e redirecionamento automático para a Home.
- Consulta por **CEP** (8 dígitos).
- Consulta por **endereço** (UF, cidade e logradouro completo ou parcial).
- Tela de loading durante a consulta externa.
- Componente de "nada encontrado" quando a busca não retorna resultados.
- Último endereço consultado em destaque na Home.
- **Traçar rota** da localização atual até o último endereço consultado, no aplicativo de mapas do aparelho.
- **Histórico** dos endereços consultados, com opção de abrir no mapa e limpar.
- Armazenamento local (Hive): o histórico e o último endereço continuam disponíveis ao fechar e reabrir o app.

## Tecnologias

- Flutter e Dart
- Dio (requisições HTTP)
- MobX e flutter_mobx (gerenciamento de estado e reatividade)
- Hive (armazenamento local)
- map_launcher (abrir aplicativos de mapas)
- geocoding (instalado conforme o enunciado)

## Estrutura

````
lib/
├── main.dart
└── src/
    ├── app.dart
    ├── http/            # cliente Dio
    ├── routes/          # rotas nomeadas
    ├── shared/          # cores, métricas, componentes e Hive
    └── modules/
        ├── initial/     # tela de abertura
        ├── home/        # consulta (components, controller, model, page, repositories, service)
        └── history/     # histórico (controller, page)
````

## Pré-requisitos

- Flutter SDK (canal stable) com Dart 3.10 ou superior (confira com `flutter --version`)
- Android Studio (Android SDK e emulador) ou um celular com depuração USB
- Git

Confira o ambiente com `flutter doctor`.

## Como executar

````bash
git clone https://github.com/SEU_USUARIO/fastlocation.git
cd fastlocation
flutter pub get
flutter run
````

Para gerar os arquivos do MobX, se necessário:

````bash
dart run build_runner build --delete-conflicting-outputs
````

## Como testar

- Consulta por CEP: `88101000`
- Busca por endereço: UF `SC`, cidade `São José`, logradouro `Bom Pastor`
- CEP inexistente (exibe "nada encontrado"): `99999999`
- Histórico: toque no ícone de relógio na barra superior
- Rota: na Home, com um endereço consultado, toque em **Traçar rota**

## Observações

- O app precisa de internet para consultar o ViaCEP.
- A busca por CEP retorna a rua sem número. Na busca por endereço, o número
  digitado após o nome da rua é ignorado, pois o ViaCEP só aceita o logradouro.
- O pacote `geocoding` está instalado conforme o enunciado. A rota usa o
  endereço em texto, e o aplicativo de mapas resolve a localização.
- No Android, o `AndroidManifest.xml` declara a permissão `INTERNET` e as
  entradas `<queries>` necessárias para abrir aplicativos de mapas.
- Em emulador Android, a localização padrão fica na Califórnia. Para ver a rota
  completa, configure uma localização em *Extended controls > Location*.
  Em um celular real a origem é a posição do aparelho.
````
````

## Como aplicar

1. Abra o `README.md` na raiz do projeto no VS Code.
2. Aperte **Ctrl+A**, **Delete** e cole o conteúdo acima. Copie só o que está **dentro** do bloco, sem as linhas de crases do começo e do fim.
3. Troque `SEU_USUARIO` pelo seu usuário do GitHub (se não lembrar, rode `git remote -v`).
4. Salve com **Ctrl+S** e rode, um comando por vez:

````powershell
git add .
````

````powershell
git commit -m "docs: atualiza README"
````

````powershell
git push
````