import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/domain/usecase/countries_lookup_usecase.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/utils/push_notification/firebase_messaging_helper.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../utils/location/map_provider.dart';
import '../../utils/resources/assets_manager.dart';
import '../../utils/resources/routes_manager.dart';
import '../common/widgets/page_builder.dart';
import '../google_maps/bloc/maps_bloc.dart';
import '../google_maps/bloc/maps_state.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _isInit = true;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  CountriesLookupUseCase countriesLookupUseCase =
      instance<CountriesLookupUseCase>();

  @override
  void initState() {
    // getCountries();
    new Future.delayed(const Duration(seconds: 3), () {
      _goNext();
    });
    super.initState();
  }

  getCountries() async {
    (await countriesLookupUseCase.execute(LookupsUseCaseInput()))
        .fold((failure) => {_goNext()}, (countries) async {
      _appPreferences.setCountries(countries);
      _goNext();
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      setCountry();
    }
    super.didChangeDependencies();
  }

  setCountry() {
    var country = _appPreferences.getUserSelectedCountry();
    Provider.of<MapProvider>(context, listen: false)
        .setCountry(country ?? "SA", needsRebuild: false);
  }

  _goNext() async {
    await FirebaseMessagingHelper().configure(context);
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            {
              // navigate to main screen
              Navigator.pushReplacementNamed(context, Routes.mainRoute)
            }
          else
            {
              // Navigate to Login Screen
              Navigator.pushReplacementNamed(
                  context, Routes.selectRegistrationType)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        allowBackButtonInAppBar: false,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: AppSize.s210,
        ),
        SvgPicture.asset(
          ImageAssets.splashSVGIcon,
        ),
        const SizedBox(height: 16),
        const Spacer(),
        BlocConsumer<MapsBloc, MapsState>(
          listener: ((context, state) async {}),
          builder: ((context, state) {
            return const SizedBox();
          }),
        )
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
