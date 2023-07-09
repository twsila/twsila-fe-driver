import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/widget/menu_widget.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/routes_manager.dart';
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
  Driver? driver;
  AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    driver = _appPreferences.getCachedDriver() ?? null;
    super.initState();
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
          Navigator.pushReplacementNamed(
              context, Routes.selectRegistrationType);
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(AppMargin.m12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.myProfile.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontSize: FontSize.s28),
              ),
              _profileDataHeader(),
              MenuWidget(
                menuImage: ImageAssets.MyServicesIc,
                menuLabel: AppStrings.myServices.tr(),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.myServices);
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: const Divider(),
              ),
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
                menuImage: ImageAssets.logout,
                menuLabel: AppStrings.logout.tr(),
                onPressed: () {
                  CustomDialog(context).showCupertinoDialog(
                      AppStrings.logout.tr(),
                      AppStrings.areYouSureYouWantToLogout.tr(),
                      AppStrings.confirmLogout.tr(),
                      AppStrings.cancel.tr(),
                      ColorManager.error, () {
                    BlocProvider.of<MyProfileBloc>(context).add(logoutEvent());
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
        );
      },
    );
  }

  Widget _profileDataHeader() {
    return Row(
      children: [
        Container(
          width: AppSize.s90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: FadeInImage(
            width: AppSize.s50,
            image: NetworkImage(
                'https://st2.depositphotos.com/1011434/7519/i/950/depositphotos_75196567-stock-photo-handsome-man-smiling.jpg'),
            placeholder: AssetImage(ImageAssets.appBarLogo),
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
                  ? (driver?.firstName ?? "") + ' ' + (driver?.lastName ?? "")
                  : "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s18),
            ),
            Text(
              driver != null ? (driver?.mobile ?? "") : "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorManager.headersTextColor, fontSize: FontSize.s14),
            ),
            Row(
              children: [
                Text(
                  AppStrings.changeMyProfile.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ColorManager.primary, fontSize: FontSize.s14),
                ),
                Icon(
                  Icons.edit_note,
                  color: ColorManager.primary,
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}
