import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key, this.onBanner}) : super(key: key);
  final ValueChanged<bool>? onBanner;
  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  static final bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-4606907034597798/1078431304';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final windowWidth = MediaQuery.of(context).size.width.truncate();
      _loadAd(windowWidth);
    });
  }

  void _loadAd(int windowWidth) async {
    await _inlineAdaptiveAd?.dispose();
    // Get an inline adaptive size for the current orientation.
    var size = AdSize.banner;
    size = ((await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        windowWidth)) as AdSize);

    _inlineAdaptiveAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          debugPrint('Inline BannerAdListener onAdLoaded');
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Inline adaptive banner failedToLoad: $error');
          _isLoaded = false;
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    widget.onBanner!(_isLoaded && _inlineAdaptiveAd != null);
    return (_isLoaded && _inlineAdaptiveAd != null)
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: _inlineAdaptiveAd!.size.width.toDouble(),
              height: _inlineAdaptiveAd!.size.height.toDouble(),
              child: AdWidget(
                ad: _inlineAdaptiveAd!,
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  void dispose() {
    _inlineAdaptiveAd?.dispose();
    super.dispose();
  }
}
