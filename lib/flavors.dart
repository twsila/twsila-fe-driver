enum Flavor {
  development,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static const String awsBaseUrl =
      'http://ec2-3-88-50-10.compute-1.amazonaws.com:8080';
  static const String googleCloudBaseUrl =
      'https://twsila-dev-service-f33wiujt7a-lm.a.run.app';

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
        return awsBaseUrl;
      case Flavor.staging:
        return awsBaseUrl;
      case Flavor.production:
        return awsBaseUrl;
      default:
        return awsBaseUrl;
    }
  }
}
