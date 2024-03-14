import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moyasar/moyasar.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen();

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late PaymentConfig paymentConfig;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  @override
  void initState() {
    paymentConfig = PaymentConfig(
      publishableApiKey: 'pk_test_VzZuYND1H3pFgVYv9TLFwrK1mFuLGtELzAEjCQe3',
      amount: 25758,
      // SAR 257.58
      description: 'order #1324',
      metadata: {'size': '250g'},
      creditCard: CreditCardConfig(saveCard: false, manual: false),
    );
    super.initState();
  }

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          CustomDialog(context)
              .showSuccessDialog('', '', AppStrings.paidSuccessfully.tr());
          break;
        case PaymentStatus.failed:
          CustomDialog(context)
              .showErrorDialog('', '', AppStrings.failureInPayment.tr());
          break;
        case PaymentStatus.authorized:
          // handle authorized.
          break;
        default:
      }
      return;
    }

    // handle failures.
    if (result is ApiError) {}
    if (result is AuthError) {}
    if (result is ValidationError) {}
    if (result is PaymentCanceledError) {}
    // if (result is UnprocessableTokenError) {}
    // if (result is TimeoutError) {}
    // if (result is NetworkError) {}
    // if (result is UnspecifiedError) {}
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

  Widget _getContentWidget(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0))),
      padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p12, vertical: AppPadding.p12),
      margin: EdgeInsets.only(top: AppMargin.m28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.enterCreditCardData.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontSize: FontSize.s18),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: ColorManager.black,
                ),
              )
            ],
          ),
          SizedBox(
            height: AppSize.s16,
          ),
          Expanded(
            child: CreditCard(
              config: paymentConfig,
              onPaymentResult: onPaymentResult,
            ),
          )
        ],
      ),
    );
  }
}
