enum Flavor {
  development,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static const String awsDevBaseUrl =
      'http://ec2-3-208-18-171.compute-1.amazonaws.com:8080';
  static const String awsStagingBaseUrl =
      'http://ec2-184-72-167-224.compute-1.amazonaws.com:8080';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'D-Captain - Business owner';
      case Flavor.staging:
        return 'S-Captain - Business owner';
      case Flavor.production:
        return 'Captain - Business owner';
      default:
        return 'title';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return awsDevBaseUrl;
      case Flavor.staging:
        return awsStagingBaseUrl;
      case Flavor.production:
        return awsStagingBaseUrl;
      default:
        return awsStagingBaseUrl;
    }
  }
}
