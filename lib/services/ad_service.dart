import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Test Ad Unit IDs
  static const String _testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5354046379';
  static const String _testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
  static const String _testNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110'; // Or your specific factory ID if not listTile
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  // Use test IDs
  static String get appOpenAdUnitId => _testAppOpenAdUnitId;
  static String get nativeAdUnitId => _testNativeAdUnitId;
  static String get interstitialAdUnitId => _testInterstitialAdUnitId;
  static String get rewardedAdUnitId => _testRewardedAdUnitId;

  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isAppOpenAdLoading = false;
  bool _isInterstitialAdLoading = false;
  bool _isRewardedAdLoading = false;

  Completer<bool>? _appOpenAdCompleter;
  Completer<bool>? _interstitialAdCompleter;
  Completer<bool>? _rewardedAdCompleter;
  Completer<NativeAd>? _nativeAdCompleter;


  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  Future<bool> loadAppOpenAd() async {
    if (_appOpenAd != null) {
      debugPrint('AppOpenAd: Already loaded.');
      return true;
    }
    if (_isAppOpenAdLoading) {
      debugPrint('AppOpenAd: Load already in progress.');
      return await _appOpenAdCompleter?.future ?? false;
    }

    _isAppOpenAdLoading = true;
    _appOpenAdCompleter = Completer<bool>();
    debugPrint('AppOpenAd: Loading with ID: $appOpenAdUnitId');

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd: Loaded successfully.');
          _appOpenAd = ad;
          _isAppOpenAdLoading = false;
          if (!(_appOpenAdCompleter?.isCompleted ?? true)) {
            _appOpenAdCompleter!.complete(true);
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd: Failed to load: $error');
          _appOpenAd = null;
          _isAppOpenAdLoading = false;
          if (!(_appOpenAdCompleter?.isCompleted ?? true)) {
            _appOpenAdCompleter!.complete(false);
          }
        },
      ),
    );
    return _appOpenAdCompleter!.future;
  }

  void showAppOpenAd() {
    if (_appOpenAd == null) {
      debugPrint('AppOpenAd: Not available to show. Load it first.');
      // Optionally, trigger a load here if desired, but calling code should typically ensure it's loaded.
      // loadAppOpenAd(); 
      return;
    }
    debugPrint('AppOpenAd: Attempting to show.');

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => debugPrint('AppOpenAd: Showed full screen content.'),
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AppOpenAd: Failed to show full screen content: $error');
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AppOpenAd: Dismissed full screen content.');
        ad.dispose();
        _appOpenAd = null;
        // Consider preloading the next ad, or let the calling code decide.
        // loadAppOpenAd(); 
      },
    );
    _appOpenAd!.show();
  }

  Future<NativeAd> loadNativeAd({String factoryId = 'listTile'}) async {
    if (_nativeAdCompleter != null && !_nativeAdCompleter!.isCompleted) {
        debugPrint('NativeAd: Load already in progress.');
        return _nativeAdCompleter!.future;
    }
    _nativeAdCompleter = Completer<NativeAd>();
    debugPrint('NativeAd: Loading with ID: $nativeAdUnitId, FactoryID: $factoryId');

    final nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
      factoryId: factoryId, // Ensure this factoryId is registered in your native ad setup
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('NativeAd: Loaded successfully.');
          if (!(_nativeAdCompleter?.isCompleted ?? true)) {
            _nativeAdCompleter!.complete(ad as NativeAd);
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('NativeAd: Failed to load: $error');
          ad.dispose();
          if (!(_nativeAdCompleter?.isCompleted ?? true)) {
            _nativeAdCompleter!.completeError(error);
          }
        },
      ),
      request: const AdRequest(),
    );
    nativeAd.load();
    return _nativeAdCompleter!.future;
  }

  Future<bool> loadInterstitialAd() async {
    if (_interstitialAd != null) {
      debugPrint('InterstitialAd: Already loaded.');
      return true;
    }
    if (_isInterstitialAdLoading) {
      debugPrint('InterstitialAd: Load already in progress.');
      return await _interstitialAdCompleter?.future ?? false;
    }

    _isInterstitialAdLoading = true;
    _interstitialAdCompleter = Completer<bool>();
    debugPrint('InterstitialAd: Loading with ID: $interstitialAdUnitId');

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd: Loaded successfully.');
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
          if (!(_interstitialAdCompleter?.isCompleted ?? true)) {
            _interstitialAdCompleter!.complete(true);
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd: Failed to load: $error');
          _interstitialAd = null;
          _isInterstitialAdLoading = false;
          if (!(_interstitialAdCompleter?.isCompleted ?? true)) {
            _interstitialAdCompleter!.complete(false);
          }
        },
      ),
    );
    return _interstitialAdCompleter!.future;
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('InterstitialAd: Not available to show. Load it first.');
      // loadInterstitialAd(); 
      return;
    }
    debugPrint('InterstitialAd: Attempting to show.');

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('InterstitialAd: Showed full screen content.'),
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('InterstitialAd: Failed to show full screen content: $error');
        ad.dispose();
        _interstitialAd = null;
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('InterstitialAd: Dismissed full screen content.');
        ad.dispose();
        _interstitialAd = null;
        // loadInterstitialAd(); 
      },
    );
    _interstitialAd!.show();
  }

  Future<bool> loadRewardedAd() async {
    if (_rewardedAd != null) {
      debugPrint('RewardedAd: Already loaded.');
      return true;
    }
    if (_isRewardedAdLoading) {
      debugPrint('RewardedAd: Load already in progress.');
      return await _rewardedAdCompleter?.future ?? false;
    }
    _isRewardedAdLoading = true;
    _rewardedAdCompleter = Completer<bool>();
    debugPrint('RewardedAd: Loading with ID: $rewardedAdUnitId');

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('RewardedAd: Loaded successfully.');
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          
          // It's crucial to set the FullScreenContentCallback here, before show() is called.
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('RewardedAd: Ad showed full screen content.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              debugPrint('RewardedAd: Ad dismissed full screen content.');
              ad.dispose();
              _rewardedAd = null;
              // loadRewardedAd(); // Preload next
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              debugPrint('RewardedAd: Ad failed to show full screen content: $error');
              ad.dispose();
              _rewardedAd = null;
            },
          );
          if (!(_rewardedAdCompleter?.isCompleted ?? true)) {
            _rewardedAdCompleter!.complete(true);
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd: Failed to load: $error');
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          if (!(_rewardedAdCompleter?.isCompleted ?? true)) {
            _rewardedAdCompleter!.complete(false);
          }
        },
      ),
    );
    return _rewardedAdCompleter!.future;
  }

  void showRewardedAd({
    required void Function(AdWithoutView, RewardItem) onUserEarnedReward,
    VoidCallback? onAdShowed,
    VoidCallback? onAdDismissed,
    Function(AdError)? onAdFailedToShow,
  }) {
    if (kDebugMode) {
      print("Attempting to show Rewarded Ad.");
    }
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          if (kDebugMode) {
            print('$ad onAdShowedFullScreenContent.');
          }
          onAdShowed?.call();
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          if (kDebugMode) {
            print('$ad onAdDismissedFullScreenContent.');
          }
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoading = false; 
          loadRewardedAd(); // Preload the next one
          onAdDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          if (kDebugMode) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
          }
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          loadRewardedAd(); // Preload the next one
          onAdFailedToShow?.call(error);
        },
        onAdImpression: (RewardedAd ad) {
          if (kDebugMode) {
            print('$ad onAdImpression.');
          }
        },
      );

      _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      if (kDebugMode) {
        print('Rewarded Ad not loaded when showRewardedAd was called.');
      }
      onAdFailedToShow?.call(AdError(0, 'AdNotReady', 'Rewarded ad is not ready.'));
      if (!_isRewardedAdLoading) {
        loadRewardedAd(); // Attempt to load for next time
      }
    }
  }

  void dispose() {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    // No need to dispose native ad here as it's typically tied to a widget lifecycle
    // and completed via _nativeAdCompleter.

    if (_appOpenAdCompleter != null && !_appOpenAdCompleter!.isCompleted) {
      _appOpenAdCompleter!.complete(false);
    }
    if (_interstitialAdCompleter != null && !_interstitialAdCompleter!.isCompleted) {
      _interstitialAdCompleter!.complete(false);
    }
    if (_rewardedAdCompleter != null && !_rewardedAdCompleter!.isCompleted) {
      _rewardedAdCompleter!.complete(false);
    }
    if (_nativeAdCompleter != null && !_nativeAdCompleter!.isCompleted) {
      // Completing with an error or null might be appropriate if dispose is called mid-load
      _nativeAdCompleter!.completeError(StateError('AdService disposed during native ad load'));
    }
  }
}
