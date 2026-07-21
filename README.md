# Flutter Game of Flags 🏳️

Jogo de quiz sobre bandeiras de países desenvolvido em Flutter e Dart. O jogador escolhe a bandeira correta entre 6 opções, podendo configurar a quantidade de rodadas e ativar um cronômetro para deixar o desafio mais difícil. Ao final de cada partida, o resultado é salvo em um histórico local.

## Funcionalidades

- 🎮 Quiz com 6 opções de bandeiras por rodada, sendo apenas uma correta
- 🔢 Seleção da quantidade de rodadas por partida (10, 15, 20, 25 ou 30)
- ⏱️ Modo cronômetro opcional (15 segundos por rodada)
- 🔊 Efeitos sonoros de início de jogo e de contagem regressiva
- 📊 Tela de resultado ao final da partida, exibindo as bandeiras utilizadas na rodada
- 📜 Histórico de partidas salvo localmente, ordenado por aproveitamento, pontuação e tempo

## Como executar

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (Dart SDK ^3.10.7)
- Um emulador Android/iOS configurado, um navegador (para Flutter Web) ou um dispositivo físico conectado

### Passos

```bash
# 1. Acesse a pasta do projeto
cd Flutter_Game_Of_Flags

# 2. Instale as dependências
flutter pub get

# 3. Verifique os dispositivos disponíveis
flutter devices

# 4. Execute o aplicativo
flutter run
```

Para rodar em uma plataforma específica:

```bash
flutter run -d chrome     # Web
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

Para gerar um build de produção (exemplo Android):

```bash
flutter build apk --release
```