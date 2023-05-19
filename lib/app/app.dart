import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/domain/usecase/login_usecase.dart';
import 'package:taxi_for_you/presentation/google_maps/bloc/maps_bloc.dart';
import 'package:taxi_for_you/presentation/google_maps/model/maps_repo.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/utils/location/map_provider.dart';
import 'package:taxi_for_you/utils/resources/theme_manager.dart';

import '../utils/resources/routes_manager.dart';
import 'app_prefs.dart';
import 'di.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatefulWidget {
  // named constructor
  MyApp._internal();

  int appState = 0;

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LoginUseCase _loginUseCase = instance<LoginUseCase>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocal().then((local) => {context.setLocale(local)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(value: MapsBloc(MapsRepo())),
        BlocProvider.value(value: LoginBloc(loginUseCase: _loginUseCase)),
        ChangeNotifierProvider(create: (_) => MapProvider())
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashRoute,
        theme: getApplicationTheme(),
      ),
    );
  }
}
