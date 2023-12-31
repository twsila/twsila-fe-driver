import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../login/view/login_view.dart';

class RegistrationTypesView extends StatefulWidget {
  const RegistrationTypesView({Key? key}) : super(key: key);

  @override
  State<RegistrationTypesView> createState() => _RegistrationTypesViewState();
}

class _RegistrationTypesViewState extends State<RegistrationTypesView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _build(context),
          scaffoldKey: _key,
          allowBackButtonInAppBar: false,
          showLanguageChange: true,
          appBarActions: [
            SizedBox(
                child: Image.asset(
              ImageAssets.newAppBarLogo,
              color: ColorManager.splashBGColor,
            )),
          ]),
    );
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: AppSize.s60,
          ),
          Text(
            AppStrings.whichRegistrationTypeYouWant.tr(),
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: ColorManager.headersTextColor),
          ),
          const SizedBox(
            height: AppSize.s16,
          ),
          registrationTypeCard(
              ImageAssets.captainApplyIcon,
              AppStrings.registerAsACaptain.tr(),
              AppStrings.addOneCar.tr(), onTap: () {
            _appPreferences.setUserType(UserTypeConstants.DRIVER);
            Navigator.pushNamed(
              context,
              Routes.loginRoute,
              arguments: LoginViewArguments(RegistrationConstants.captain),
            );
          }),
          const SizedBox(
            height: AppSize.s16,
          ),
          registrationTypeCard(
              ImageAssets.boApplyIcon,
              AppStrings.registerAsCompanyOwner.tr(),
              AppStrings.wantToAddAndManageMultipleCars.tr(), onTap: () {
            _appPreferences.setUserType(UserTypeConstants.BUSINESS_OWNER);
            Navigator.pushNamed(
              context,
              Routes.loginRoute,
              arguments:
                  LoginViewArguments(RegistrationConstants.businessOwner),
            );
          })
        ],
      ),
    );
  }

  registrationTypeCard(String iconPath, String title, String subTitle,
      {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Wrap(direction: Axis.vertical, spacing: 10, children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.p14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: AppMargin.m20),
                    child: Image.asset(
                      iconPath,
                      width: AppSize.s32,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: AppSize.s16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s14),
                  ),
                  Text(subTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: FontSize.s12,
                            color: ColorManager.headersTextColor,
                          ))
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
