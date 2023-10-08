import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_language_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

import '../../../utils/resources/values_manager.dart';
import 'custom_back_button.dart';
import 'loading_indicator.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({Key? key, required this.pageBuilder}) : super(key: key);

  final PageBuilder pageBuilder;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.pageBuilder.backButtonCallBack != null &&
            !widget.pageBuilder.displayLoadingIndicator) {
          widget.pageBuilder.backButtonCallBack!();
          return false;
        }
        return !widget.pageBuilder.displayLoadingIndicator;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // image: widget.pageBuilder.hasBackgroundImage
                //     ? DecorationImage(image: AssetImage(Image.sanlam_bg), fit: BoxFit.cover)
                //     : null,
              ),
              child: SafeArea(
                child: Scaffold(
                  key: widget.pageBuilder.scaffoldKey,
                  extendBodyBehindAppBar:
                      widget.pageBuilder.extendBodyBehindAppBar,
                  backgroundColor: Colors.transparent,
                  resizeToAvoidBottomInset:
                      widget.pageBuilder.resizeToAvoidBottomInsets,
                  appBar: !widget.pageBuilder.appbar
                      ? null
                      : AppBar(
                          automaticallyImplyLeading:
                              widget.pageBuilder.allowBackButtonInAppBar,
                          primary: true,
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarColor: ColorManager.secondaryColor),
                          actions: widget.pageBuilder.appBarActions,
                          leading: (widget.pageBuilder.allowBackButtonInAppBar)
                              ? Semantics(
                                  label: "Sanlam_back_button",
                                  child: CustomBackButton(
                                    onPressed: () {
                                      FocusScope.of(widget.pageBuilder.context)
                                          .unfocus();
                                      if (widget
                                              .pageBuilder.backButtonCallBack !=
                                          null) {
                                        widget
                                            .pageBuilder.backButtonCallBack!();
                                      } else {
                                        Navigator.pop(
                                            widget.pageBuilder.context);
                                      }
                                    },
                                  ),
                                )
                              : widget.pageBuilder.showLanguageChange!
                                  ? Semantics(child: LanguageWidget())
                                  : null,

                          title: _buildAppbarTitle(),
                          backgroundColor:
                              widget.pageBuilder.appBarBackgroundColor ??
                                  Colors.transparent,
                          // Material 3, disable scroll elevation
                          scrolledUnderElevation: 0,
                          centerTitle: widget.pageBuilder.centerTitle ?? false,
                          iconTheme: IconThemeData(color: Colors.black),
                          elevation: widget.pageBuilder.elevation ?? 0,
                        ),
                  body: widget.pageBuilder.screenTitle != null
                      ? SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.pageBuilder.screenTitle!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                _buildBody(widget.pageBuilder)
                              ],
                            ),
                          ),
                        )
                      : _buildBody(widget.pageBuilder),
                  floatingActionButton: widget.pageBuilder.floatingActionButton,
                ),
              ),
            ),
            if (widget.pageBuilder.displayLoadingIndicator) EasyLoader(),
          ],
        ),
      ),
    );
  }

  Widget? _buildAppbarTitle() {
    return widget.pageBuilder.appbarTitleWidget != null
        ? widget.pageBuilder.appbarTitleWidget
        : widget.pageBuilder.appBarTitle != null
            ? Text(
                widget.pageBuilder.appBarTitle!,
                style: TextStyle(
                    color: ColorManager.blackTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )
            : null;
  }

  _buildBody(PageBuilder pageBuilder) {
    return pageBuilder.body;
  }
}
