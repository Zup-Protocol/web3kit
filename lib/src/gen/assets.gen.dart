/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/all-networks.svg
  SvgGenImage get allNetworks => const SvgGenImage('assets/icons/all-networks.svg');

  /// File path: assets/icons/cable.connector.horizontal.svg
  SvgGenImage get cableConnectorHorizontal => const SvgGenImage('assets/icons/cable.connector.horizontal.svg');

  /// File path: assets/icons/cable.connector.slash.svg
  SvgGenImage get cableConnectorSlash => const SvgGenImage('assets/icons/cable.connector.slash.svg');

  /// File path: assets/icons/info.circle.svg
  SvgGenImage get infoCircle => const SvgGenImage('assets/icons/info.circle.svg');

  /// File path: assets/icons/magnifyingglass.svg
  SvgGenImage get magnifyingglass => const SvgGenImage('assets/icons/magnifyingglass.svg');

  /// File path: assets/icons/square.on.square.svg
  SvgGenImage get squareOnSquare => const SvgGenImage('assets/icons/square.on.square.svg');

  /// File path: assets/icons/wallet.bifold.svg
  SvgGenImage get walletBifold => const SvgGenImage('assets/icons/wallet.bifold.svg');

  /// File path: assets/icons/wallet.search.svg
  SvgGenImage get walletSearch => const SvgGenImage('assets/icons/wallet.search.svg');

  /// File path: assets/icons/wallet_connect.svg
  SvgGenImage get walletConnect => const SvgGenImage('assets/icons/wallet_connect.svg');

  /// List of all assets
  List<SvgGenImage> get values => [allNetworks, cableConnectorHorizontal, cableConnectorSlash, infoCircle, magnifyingglass, squareOnSquare, walletBifold, walletSearch, walletConnect];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/wallets.png
  AssetGenImage get wallets => const AssetGenImage('assets/images/wallets.png');

  /// List of all assets
  List<AssetGenImage> get values => [wallets];
}

class $AssetsLogosGen {
  const $AssetsLogosGen();

  /// File path: assets/logos/arbitrum.svg
  SvgGenImage get arbitrum => const SvgGenImage('assets/logos/arbitrum.svg');

  /// File path: assets/logos/base.svg
  SvgGenImage get base => const SvgGenImage('assets/logos/base.svg');

  /// File path: assets/logos/ethereum.svg
  SvgGenImage get ethereum => const SvgGenImage('assets/logos/ethereum.svg');

  /// List of all assets
  List<SvgGenImage> get values => [arbitrum, base, ethereum];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogosGen logos = $AssetsLogosGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ?? (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}