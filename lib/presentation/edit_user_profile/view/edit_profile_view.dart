import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../domain/model/driver_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../common/widgets/page_builder.dart';

class EditProfileView extends StatefulWidget {
  final DriverBaseModel driver;

  EditProfileView({required this.driver});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _displayLoadingIndicator = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _firstNameController.text = widget.driver.firstName ?? '';
    _lastNameController.text = widget.driver.lastName ?? '';
    _mobileNumberController.text = widget.driver.mobile ?? '';
    _emailController.text = widget.driver.email ?? '';
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarTitle: AppStrings.changeMyProfile.tr(),
          centerTitle: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profilePhotoHeader(),
          SizedBox(
            height: 30,
          ),
          CustomTextInputField(
            labelText: AppStrings.firstName.tr(),
            showLabelText: true,
            controller: _firstNameController,
            hintText: AppStrings.enterFirstNameHere.tr(),
            onChanged: (value) {},
          ),
          CustomTextInputField(
            labelText: AppStrings.lastName.tr(),
            showLabelText: true,
            controller: _lastNameController,
            hintText: AppStrings.enterLastNameHere.tr(),
            onChanged: (value) {},
          ),
          CustomTextInputField(
            labelText: AppStrings.jawalNumber.tr(),
            showLabelText: true,
            enabled: false,
            controller: _mobileNumberController,
            hintText: AppStrings.enterFirstNameHere.tr(),
            onChanged: (value) {},
          ),
          CustomTextInputField(
            labelText: AppStrings.email.tr(),
            showLabelText: true,
            controller: _emailController,
            hintText: '',
            onChanged: (value) {},
          ),
          SizedBox(
            height: AppSize.s50,
          ),
          CustomTextButton(
            text: AppStrings.save.tr(),
            isWaitToEnable: false,
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _profilePhotoHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSize.s16),
      child: Row(
        children: [
          Container(
              width: AppSize.s60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: FadeInImage(
                  width: AppSize.s50,
                  image: NetworkImage(
                      'https://st2.depositphotos.com/1011434/7519/i/950/depositphotos_75196567-stock-photo-handsome-man-smiling.jpg'),
                  placeholder: AssetImage(ImageAssets.appBarLogo),
                ),
              )),
          SizedBox(
            width: AppSize.s16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      AppStrings.changeCaptainPhoto.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorManager.primary,
                          fontSize: FontSize.s14),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EditProfileArguments {
  DriverBaseModel driver;

  EditProfileArguments(this.driver);
}
