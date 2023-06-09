import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../resources/values_manager.dart';

class CustomDialog {
  BuildContext context;

  CustomDialog(this.context);

  showErrorDialog(String? title, String? desc, String body,
      {Function()? onBtnPressed}) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      body: Center(
        child: Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: AppSize.s16),
        ),
      ),
      title: title ?? "",
      titleTextStyle: Theme.of(context).textTheme.displayMedium,
      desc: desc ?? "",
      buttonsBorderRadius: BorderRadius.circular(2),
      btnOkColor: ColorManager.secondaryColor,
      descTextStyle: Theme.of(context).textTheme.displayMedium,
      btnOkOnPress: onBtnPressed ?? () {},
    ).show();
  }

  showCupertinoDialog(
      String title,
      String content,
      String defaultActionButtonText,
      String secondButtonText,
      Function() onDefaultActionButtonPressed,
      Function() onSecondButtonPressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: new Text(
                content,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold,fontSize: FontSize.s12),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    defaultActionButtonText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: onDefaultActionButtonPressed,
                ),
                CupertinoDialogAction(
                  child: Text(
                    secondButtonText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.secondaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: onSecondButtonPressed,
                )
              ],
            ));
  }
}
