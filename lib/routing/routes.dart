class _Routes {
  String path;
  String name;
  _Routes({
    required this.name,
    required this.path,
  });
}

class Routes {
  static _Routes splash = _Routes(name: 'root', path: '/root');

  static _Routes onboarding = _Routes(name: 'onboarding', path: '/onboarding');

  static _Routes login = _Routes(name: 'login', path: '/login');

  static _Routes otpScreen = _Routes(name: 'otpScreen', path: '/otpScreen');

  static _Routes termUseScreen =
      _Routes(name: 'termUseScreen', path: '/ternUseScreen');

  static _Routes profileComplete =
      _Routes(name: 'profileComplete', path: '/profileComplete');

  static _Routes profile = _Routes(name: 'profile', path: '/profile');

  static _Routes topupScreen =
      _Routes(name: 'topupScreen', path: '/topupScreen');

  static _Routes cardPaymentScreen =
      _Routes(name: 'cardPaymentScreen', path: '/cardPaymentScreen');

  static _Routes emptySubscriptionScreen = _Routes(
      name: 'emptySubscriptionScreen', path: '/emptySubscriptionScreen');

  static _Routes aboutScreen =
      _Routes(name: 'aboutScreen', path: '/aboutScreen');

  static _Routes feedbackFormScreen =
      _Routes(name: 'feedbackFormScreen', path: '/feedbackFormScreen');

  static _Routes helpSupportScreen =
      _Routes(name: 'helpSupportScreen', path: '/helpSupportScreen');

  static _Routes notificationScreen =
      _Routes(name: 'notificationScreen', path: '/notificationScreen');

  static _Routes savedAddresses =
      _Routes(name: 'savedAddresses', path: '/savedAddresses');

  static _Routes newAddress = _Routes(name: 'newAddress', path: '/newAddress');

  static _Routes notificationSettingScreen = _Routes(
      name: 'notificationSettingScreen', path: '/notificationSettingScreen');

  static _Routes profileEditScreen =
      _Routes(name: 'profileEditScreen', path: '/profileEditScreen');

  static _Routes languageScreen =
      _Routes(name: 'languageScreen', path: '/languageScreen');

  static _Routes addressAdded =
      _Routes(name: 'addressAdded', path: '/addressAdded');
  static _Routes newOrder = _Routes(name: 'newOrder', path: '/newOrder');

  static _Routes orderPlaced =
      _Routes(name: 'orderPlaced', path: '/orderPlaced');

  static _Routes transectionScreen =
      _Routes(name: 'transectionScreen', path: '/transectionScreen');

  static _Routes orderDetail =
      _Routes(name: 'orderDetail', path: '/orderDetail');

  static _Routes viewStatusScreen =
      _Routes(name: 'viewStatusScreen', path: '/viewStatusScreen');

  static _Routes rateOrder = _Routes(name: 'rateOrder', path: '/rateOrder');

  static _Routes paymentScreen =
      _Routes(name: 'paymentScreen', path: '/paymentScreen');

  static _Routes home = _Routes(name: 'home', path: '/home');

  static _Routes order = _Routes(name: 'order', path: '/order');

  static _Routes wallete = _Routes(name: 'wallete', path: '/wallete');

  static _Routes historyScreen =
      _Routes(name: 'historyScreen', path: '/historyScreen');

  static _Routes subscription =
      _Routes(name: 'subscription', path: '/subscription');

  static _Routes newSubscription =
      _Routes(name: 'newSubscription', path: '/newSubscription');

  static _Routes subscribed = _Routes(name: 'subscribed', path: '/subscribed');

  static _Routes chatScreen = _Routes(name: 'chatScreen', path: '/ChatScreen');
}
