import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';

class PendingApprovalDriver extends StatefulWidget {
  const PendingApprovalDriver({Key? key}) : super(key: key);

  @override
  State<PendingApprovalDriver> createState() => _PendingApprovalDriverState();
}

class _PendingApprovalDriverState extends State<PendingApprovalDriver> {
  String text1 =
      "عزيزى الكابتن نشكر لكم التسجيل مع توصيلة و نود أن تبلغكم ان طلبكم لا زال تحت المراجعة و الوقت المتوقع لاكمال الطلب هو 12:00 ساعة";
  String text2 = "مبروك تم قبول طلبكم";
  String text3 =
      "عزيزى الكابتن محمد عبد الله يسعدنا ابلاغكم بانه تم قبول تسجيلكم لدى توصيلة و يمكنك البدء بالبحث عن رحلات مطلوبة و تقديم خدماتكم للعملاء";

  bool showPending = true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarBrightness: Brightness.dark),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: showPending
                  ? Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: FontSize.s16, color: ColorManager.black),
              )
                  : Column(
                children: [
                  Text(
                    text2,
                    style: TextStyle(
                        fontSize: 12, color: ColorManager.green),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      text3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.black),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            showPending
                ? Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPending = false;
                    });
                  },
                  child: const Text("تــم")),
            )
                : Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                    context, Routes.
                    categoriesRoute
                    );
                  },
                  child: const Text("إنــهاء")),
            )
          ],
        ));
  }
}
