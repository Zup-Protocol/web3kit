# Web3Kit

Web3Kit is a core & UI library for building web3 applications with Flutter Web. It contains the most useful features for building web3 applications. And a rich UI Kit to build web3 applications with Flutter Web easily.

Behind the scenes, Web3Kit uses [Ethers.js](https://docs.ethers.io/v6/) to interact with the Ethereum network. Web3Kit also uses dart interop to interact directly with the browser, Ethers.js and the wallets.

## Installation & Initialization

To get started with Web3Kit, follow these steps:

### 1. Add the package in `pubspec.yaml`

```bash
flutter pub add web3kit
```

### 2. Add the following Script to your `index.html`

```html
<script type="module">
  import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
  window.ethers = ethers;
</script>
```

It should be placed inside the `<body>` tag. Like this:

```html
<body>
  <script type="module">
    import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
    window.ethers = ethers;
  </script>

  <script src="flutter_bootstrap.js" async></script>
</body>
```

### 3. Add Web3Kit Localizations inside Material App:

To make use of Web3Kit UI Kit, you will need to delegate Web3Kit Localizations also, like this:

```dart
localizationsDelegates: const [Web3KitLocalizations.delegate],
```

### 4. Initialize Web3Kit

To use any feature of the Web3Kit, you first need to initialize it:

```dart
await Web3Kit.initialize();
```

This initialization needs to be done only once. So you can add it in your `main.dart`:

```dart
Future<void> main() async {
  await Web3Kit.initialize(); // recommended to initialize Web3Kit before running the app

  runApp(const MyApp());
}
```
