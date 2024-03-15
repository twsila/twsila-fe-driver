import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:moyasar/moyasar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/edit_user_profile/view/edit_profile_view.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/widget/menu_widget.dart';
import 'package:taxi_for_you/presentation/payment/view/payment_screen.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/constants_manager.dart';
import '../../../../utils/resources/langauge_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
import '../../../common/widgets/custom_network_image_widget.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  DriverBaseModel? driver;
  AppPreferences _appPreferences = instance<AppPreferences>();
  final SharedPreferences _sharedPreferences = instance();

  @override
  void initState() {
    driver = _appPreferences.getCachedDriver() ?? null;
    super.initState();
  }

  Future<String> getProfilePicPath() async {
    return _appPreferences.userProfilePicture(driver!);
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      _sharedPreferences.setString(
                          PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
                      Phoenix.rebirth(context);
                    },
                    child: Text(
                      AppStrings.en.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () {
                      _sharedPreferences.setString(
                          PREFS_KEY_LANG, LanguageType.ARABIC.getValue());
                      Phoenix.rebirth(context);
                    },
                    child: Text(
                      AppStrings.ar.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
            ));
  }

  void _showPaymentBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      elevation: 10,
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height / 1.2,
        child: PaymentScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: false,
      ),
    );
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
      listener: (context, state) {
        if (state is MyProfileLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is LoggedOutSuccessfully) {
          Navigator.pushNamed(context, Routes.selectRegistrationType);
        }
        if (state is MyProfileFail) {
          CustomDialog(context).showErrorDialog('', '', state.errorMessage);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(AppMargin.m12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    AppStrings.myProfile.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s28),
                  ),
                ),
                _appPreferences.getCachedDriver()!.captainType ==
                        RegistrationConstants.businessOwner
                    ? _successSubscriptionAndPayWidgetBO()
                    : Container(),
                _profileDataHeader(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: const Divider(),
                ),
                MenuWidget(
                  menuImage:
                      driver!.captainType == RegistrationConstants.captain
                          ? ImageAssets.MyServicesIc
                          : ImageAssets.carsAndDriversIcon,
                  menuLabel:
                      driver!.captainType == RegistrationConstants.captain
                          ? AppStrings.myServices.tr()
                          : AppStrings.DriversAndCars.tr(),
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        driver!.captainType == RegistrationConstants.captain
                            ? Routes.myServices
                            : Routes.boDriversAndCars);
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
                driver!.captainType == RegistrationConstants.captain &&
                        (driver as Driver).businessOwnerId == null
                    ? Column(
                        children: [
                          MenuWidget(
                            menuImage: ImageAssets.addRequestsIcon,
                            menuLabel: AppStrings.addRequestsFromBo.tr(),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.driverRequests);
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            child: const Divider(),
                          )
                        ],
                      )
                    : Container(),
                MenuWidget(
                  menuImage: ImageAssets.walletAndRevenueIc,
                  menuLabel: AppStrings.WalletAndRevenue.tr(),
                  onPressed: () {},
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
                MenuWidget(
                  menuImage: ImageAssets.inviteFriends,
                  menuLabel: AppStrings.inviteFriendsAndWin.tr(),
                  onPressed: () {},
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
                MenuWidget(
                  menuImage: ImageAssets.getHelpIc,
                  menuLabel: AppStrings.getHelp.tr(),
                  onPressed: () {},
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
                MenuWidget(
                  menuImage: ImageAssets.languageIc,
                  menuLabel: AppStrings.language.tr(),
                  onPressed: () {
                    _showBottomSheet();
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
                MenuWidget(
                  menuImage: ImageAssets.logout,
                  menuLabel: AppStrings.logout.tr(),
                  onPressed: () {
                    CustomDialog(context).showCupertinoDialog(
                        AppStrings.logout.tr(),
                        AppStrings.areYouSureYouWantToLogout.tr(),
                        AppStrings.confirmLogout.tr(),
                        AppStrings.cancel.tr(),
                        ColorManager.error, () {
                      BlocProvider.of<MyProfileBloc>(context).add(
                        logoutEvent(context),
                      );
                      Navigator.pop(context);
                    }, () {
                      Navigator.pop(context);
                    });
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: const Divider(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _successSubscriptionAndPayWidgetBO() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      margin: EdgeInsets.only(top: 5, bottom: 10),
      decoration: BoxDecoration(color: ColorManager.highlightBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                color: ColorManager.primary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                AppStrings.yourAccountRegisteredSuccessfully.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ColorManager.primary,
                    fontSize: FontSize.s16),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${AppStrings.payBusinessOwnerFeesMessage.tr()}: 200 ${getCurrency("SA")}",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorManager.secondaryColor,
                fontSize: FontSize.s16),
          ),
          CustomTextButton(
            text: AppStrings.viewSubscriptionBenefits.tr(),
            isWaitToEnable: false,
            borderColor: ColorManager.black,
            backgroundColor: ColorManager.highlightBackgroundColor,
            textColor: ColorManager.black,
            onPressed: () {
              Navigator.pushNamed(context, Routes.boSubscriptionBenefits);
            },
          ),
          CustomTextButton(
            text: AppStrings.subscribeAndGoToPay.tr(),
            isWaitToEnable: false,
            icon: Image.asset(
              ImageAssets.tripDetailsVisaIcon,
              color: ColorManager.white,
              width: 16,
            ),
            onPressed: () {
              // Navigator.pushNamed(context, Routes.paymentScreen);
              _showPaymentBottomSheet();
            },
          )
        ],
      ),
    );
  }

  Widget _profileDataHeader() {
    return FutureBuilder<String>(
        future: getProfilePicPath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Row(
              children: [
                Container(
                  width: AppSize.s90,
                  height: AppSize.s90,
                  margin: EdgeInsets.all(1.5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CustomNetworkImageWidget(
                      imageUrl: snapshot.data.toString(),
                    ),
                  ),
                ),
                SizedBox(
                  width: AppSize.s16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver != null
                          ? (driver?.firstName ?? "") +
                              ' ' +
                              (driver?.lastName ?? "")
                          : "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s18),
                    ),
                    Text(
                      driver != null ? (driver?.mobile ?? "") : "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ColorManager.headersTextColor,
                          fontSize: FontSize.s14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.editProfile,
                            arguments: EditProfileArguments(driver!));
                      },
                      child: Row(
                        children: [
                          Text(
                            AppStrings.changeMyProfile.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s14),
                          ),
                          Icon(
                            Icons.edit_note,
                            color: ColorManager.primary,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        }); // snapshot.data  :- get your object which is pass from your downloadData() function
  }
}
