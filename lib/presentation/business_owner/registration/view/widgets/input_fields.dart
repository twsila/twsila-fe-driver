import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/gender_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/terms_conditions.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/upload_bo_document.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/common/widgets/multi_pick_image.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/documents_helper.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../../utils/resources/font_manager.dart';
import '../../../../../utils/resources/styles_manager.dart';
import '../../../../service_registration/view/widgets/uploadDocumentWidget.dart';

class RegistartionBOInputFields extends StatefulWidget {
  final RegisterBusinessOwnerViewModel viewModel;

  const RegistartionBOInputFields({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<RegistartionBOInputFields> createState() =>
      _RegistartionBOInputFieldsState();
}

class _RegistartionBOInputFieldsState extends State<RegistartionBOInputFields> {
  checkValidations() {
    setState(() {
      widget.viewModel.isValid =
          widget.viewModel.formKey.currentState != null &&
              widget.viewModel.formKey.currentState!.validate() &&
              widget.viewModel.termsAndCondition != false &&
              widget.viewModel.businessOwnerModel.images != null &&
              widget.viewModel.businessOwnerModel.images!.isNotEmpty &&
              widget.viewModel.businessOwnerModel.profileImage != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.viewModel.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.ownerfirstName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.enterFirstNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.firstName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.ownerlastName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.enterLastNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.lastName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            controller: widget.viewModel.mobileNumberController,
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.mobileNumber.tr(),
            showLabelText: true,
            enabled: false,
            hintText: AppStrings.phoneNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.entityName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.companyName.tr(),
            showLabelText: true,
            validateSpecialCharacter: true,
            isCharacterOnly: true,
            hintText: AppStrings.companyNameHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.entityName = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.commercialNumber.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.commercialNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.commercialNumber = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.taxNumber.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.commercialNumberHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.taxNumber = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmptyString: true,
            labelText: AppStrings.nationalID.tr(),
            showLabelText: true,
            keyboardType: TextInputType.number,
            hintText: AppStrings.nationalIDHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.nationalId = value;
              checkValidations();
            },
          ),
          const SizedBox(height: 16),
          CustomTextInputField(
            margin: EdgeInsets.zero,
            validateEmail: true,
            validateEmptyString: true,
            labelText: AppStrings.email.tr(),
            showLabelText: true,
            hintText: AppStrings.emailHint.tr(),
            onChanged: (value) {
              widget.viewModel.businessOwnerModel.email = value;
              checkValidations();
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: GenderWidget(
              initialGender: widget.viewModel.businessOwnerModel.gender,
              viewModel: widget.viewModel,
              onSelectGender: (gender) {
                widget.viewModel.businessOwnerModel.gender = gender.value;
              },
            ),
          ),
          // UploadDocumentWidget(
          //     AppStrings.boNationalId.tr(), AppStrings.addPhotos.tr(),
          //     () async {
          //   DocumentData boNationalIdDocument = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => UploadBoDocumentView(
          //                 Document: Documents.boNationalId,
          //               )));
          //
          //   widget.viewModel.businessOwnerModel.boNationalIdDocument =
          //       boNationalIdDocument;
          // }),
          // UploadDocumentWidget(AppStrings.boCommercialRegistrationDocument.tr(),
          //     AppStrings.addPhotos.tr(), () async {
          //   DocumentData boCommercialRegistrationDocument =
          //       await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (BuildContext context) => UploadBoDocumentView(
          //                     Document:
          //                         Documents.boCommercialRegistrationDocument,
          //                   )));
          //   widget.viewModel.businessOwnerModel
          //           .boCommercialRegistrationDocument =
          //       boCommercialRegistrationDocument;
          // }),
          MutliPickImageWidget(
            (images) {
              if (images == null) return;
              widget.viewModel.businessOwnerModel.images =
                  images.map<File>((xfile) => File(xfile.path)).toList();
              checkValidations();
            },
            AppStrings.uploadBOid.tr(),
            AppStrings.boImage.tr(),
            Icon(Icons.person, color: Colors.white),
            ColorManager.headersTextColor,
            null,
            onRemovedImage: (removedImage) {
              widget.viewModel.businessOwnerModel.images!
                  .removeWhere((element) => element.path == removedImage.path);
              checkValidations();
            },
          ),
          TermsAndConditionsWidget(onChecked: (check) {
            widget.viewModel.termsAndCondition = check;
            checkValidations();
          }),
          Container(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(AppPadding.p8),
            color: Colors.white,
            child: CustomTextButton(
              onPressed: widget.viewModel.isValid
                  ? () {
                      BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        RegisterBOWithService(
                          businessOwnerModel:
                              widget.viewModel.businessOwnerModel,
                        ),
                      );
                    }
                  : null,
              text: AppStrings.save.tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget UploadDocumentWidget(
      String title, String buttonText, Function() onTap) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getRegularStyle(
                color: ColorManager.titlesTextColor, fontSize: FontSize.s14),
          ),
          CustomTextButton(
            text: buttonText,
            width: AppSize.s140,
            height: AppSize.s50,
            isWaitToEnable: false,
            fontSize: FontSize.s10,
            backgroundColor: ColorManager.secondaryColor,
            onPressed: onTap,
          )
        ],
      ),
    );
  }
}
