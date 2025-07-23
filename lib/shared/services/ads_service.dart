import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:injectable/injectable.dart';

@singleton
class AdsService extends ChangeNotifier {
  BannerAd? topBanner;
  BannerAd? bottomBanner;
  InterstitialAd? _interstitial;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    await _loadBanners();
    await loadInterstitial();
  }

  Future<void> _loadBanners() async {
    topBanner?.dispose();
    bottomBanner?.dispose();
    topBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-1898798427054986/9646986739',
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );

    await topBanner?.load();

    bottomBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-1898798427054986/2817854509',
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );

    await bottomBanner?.load();
    notifyListeners();
  }

  Future<void> loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-1898798427054986/1528823562',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (error) => _interstitial = null,
      ),
    );
  }

  Future<void> showInterstitial() async {
    if (_interstitial != null) {
      await _interstitial!.show();
      await _interstitial!.dispose();
      _interstitial = null;
      await loadInterstitial();
    }
  }

  void dispose() {
    topBanner?.dispose();
    bottomBanner?.dispose();
    _interstitial?.dispose();
  }
}
