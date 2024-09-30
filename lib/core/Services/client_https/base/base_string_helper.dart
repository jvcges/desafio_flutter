class BaseStringHelper {
  final String baseUrl;
  final String protocol;
  final Duration? connectTimeout;
  final Duration? receiveTimeout;
  final Duration? sendTimeout;

  BaseStringHelper({
    this.baseUrl = '#',
    this.protocol = 'https',
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
  });

  factory BaseStringHelper.staging({String? url}) {
    return BaseStringHelper(baseUrl: url ?? '');
  }

  String get fullUrl => '$protocol://$baseUrl';
}
