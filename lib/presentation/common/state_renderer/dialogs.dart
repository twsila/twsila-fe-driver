import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';

class ShowDialogHelper {
  static void showErrorMessage(String message, BuildContext context) {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[500],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Avenir',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static void showSuccessMessage(String message, BuildContext context) {
    FToast fToast;
    fToast = FToast();
    fToast.init(context);

    fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[900],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset(
                ImageAssets.checkIcon,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Avenir',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static void showDialogPopupWithCancel(String title, String message,
      BuildContext context, Function cancelFunc, Function okFunc,
      {String? okText, Widget? messageWidget, bool dismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Avenir',
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
              child: messageWidget ??
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Avenir',
                      color: Colors.white.withOpacity(0.8),
                    ),
                  )),
          actions: <Widget>[
            TextButton(
              child: Text(
                'إلغاء',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                cancelFunc();
              },
            ),
            TextButton(
              child: Text(
                okText ?? 'تأكيد',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                okFunc();
              },
            ),
          ],
        ),
      ),
    );
  }
}
