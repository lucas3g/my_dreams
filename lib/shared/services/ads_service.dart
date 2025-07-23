import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  BannerAd? topBanner;
  BannerAd? bottomBanner;
  InterstitialAd? _interstitial;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadBanners();
    await loadInterstitial();
  }

  void _loadBanners() {
    topBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-1898798427054986/9646986739',
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();

    bottomBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-1898798427054986/2817854509',
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  Future<void> loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-1898798427054986/1528823562',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
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
