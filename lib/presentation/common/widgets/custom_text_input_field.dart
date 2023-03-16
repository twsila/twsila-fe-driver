import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/resources/color_manager.dart';

class CustomTextInputField extends StatefulWidget {
  final FormFieldValidator<String>? validationMethod;
  final String? hintText;
  final Color? textColor;
  final Color? hintTextColor;
  final String? errorLabel;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? semanticsLabelKey;
  final String? errorLabelKey;
  final bool enabled;
  final Widget? icon;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool validateEmptyString;
  final bool validateZeroNumber;
  final bool clearIcon;
  final double? borderRadius;
  final Color? borderColor;
  final Color? clearIconColor;
  final bool isKeyboardDigitsOnly;
  final List<TextInputFormatter>? inputFormatter;
  final bool obscureText;
  final bool showLabelText;
  final String? labelText;
  final Color fillColor;
  final EdgeInsets? padding;
  final String? helperText;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onClearIconTapped;
  final bool validateSpecialCharacter;
  final bool checkMinimumCharacter;
  final int minmumNumberOfCharacters;
  final bool validateEmail;
  final bool isDimmed;
  final Function? shouldrequestFocus;
  final Function(String?)? onSaved;
  final Color? backgroundColor;
  final bool? istitleBold;

  // final String? key;

  CustomTextInputField(
      {this.enabled = true,
      this.isDimmed = false,
      this.textColor,
      this.hintTextColor,
      this.obscureText = false,
      this.isKeyboardDigitsOnly = false,
      this.padding,
      this.maxLines,
      // this.initialValue = "",
      this.prefixIcon,
      this.clearIcon = false,
      this.suffixIcon,
      this.keyboardType = TextInputType.text,
      this.validationMethod,
      this.icon,
      this.hintText = '',
      this.backgroundColor,
      this.errorLabel,
      this.textInputAction = TextInputAction.next,
      this.onEditingComplete,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.semanticsLabelKey,
      this.errorLabelKey,
      Key? key,
      this.maxLength,
      this.textAlign,
      this.inputFormatter,
      this.validateEmptyString = false,
      this.borderRadius,
      this.borderColor,
      this.validateZeroNumber = false,
      this.showLabelText = false,
      this.labelText,
      this.fillColor = Colors.white,
      this.helperText,
      this.onFieldSubmitted,
      this.onClearIconTapped,
      this.validateSpecialCharacter = false,
      this.checkMinimumCharacter = false,
      this.validateEmail = false,
      this.shouldrequestFocus,
      this.minmumNumberOfCharacters = 0,
      this.onSaved,
      this.istitleBold = true,
      this.clearIconColor})
      : super(key: key);

  @override
  _CustomTextInputFieldState createState() => new _CustomTextInputFieldState();
}

class _CustomTextInputFieldState extends State<CustomTextInputField> {
  FocusNode? _myFocusNode;
  TextEditingController? _textController;

  @override
  void initState() {
    _myFocusNode = (widget.focusNode == null) ? FocusNode() : widget.focusNode;
    _textController = (widget.controller == null)
        ? TextEditingController()
        : widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showLabelText
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.labelText!,
                  style: widget.istitleBold!
                      ? Theme.of(context).textTheme.headline6
                      : const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16)),
              _textFormField(),
            ],
          )
        : _textFormField();
  }

  _textFormField() {
    return Semantics(
      label: widget.semanticsLabelKey,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            TextFormField(
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: widget.textColor ?? ColorManager.primary),
              obscureText: widget.obscureText,
              textAlign: widget.textAlign ?? TextAlign.start,
              maxLength: widget.maxLength,
              cursorColor: widget.hintTextColor ?? ColorManager.lightGrey,
              textInputAction: widget.textInputAction,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              focusNode: _myFocusNode,
              controller: _textController,
              keyboardType: widget.keyboardType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              onFieldSubmitted: widget.onFieldSubmitted,
              inputFormatters: widget.inputFormatter ??
                  <TextInputFormatter>[
                    if (widget.isKeyboardDigitsOnly)
                      FilteringTextInputFormatter.digitsOnly
                  ],
              // Only numbers
              decoration: InputDecoration(
                fillColor:
                    widget.enabled ? widget.fillColor : ColorManager.lightGrey,
                filled: true,
                errorMaxLines: 8,
                helperMaxLines: 8,
                helperText: widget.helperText,
                contentPadding: widget.padding ??
                    const EdgeInsets.only(
                      left: 10,
                      right: 10
                    ),
                counterStyle: const TextStyle(
                  height: double.minPositive,
                ),
                counterText: "",
                prefixIcon: widget.prefixIcon,
                suffixIcon: (widget.clearIcon)
                    ? Padding(
                        padding: const EdgeInsetsDirectional.all(14),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ColorManager.primary, width: 1.5),
                            ),
                            child: Icon(
                              Icons.clear_rounded,
                              color: ColorManager.primary,
                              size: 13.0,
                            ),
                          ),
                          onTap: () {
                            if (widget.onClearIconTapped != null) {
                              widget.onClearIconTapped!();
                            } else {
                              setState(() {
                                widget.controller!.clear();
                                if (widget.onChanged != null) {
                                  widget.onChanged!("");
                                }
                              });
                            }
                          },
                        ),
                      )
                    : widget.suffixIcon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [widget.suffixIcon!],
                          )
                        : null,
                errorStyle: TextStyle(
                  color: ColorManager.error,
                ),
                // helperStyle: Theme.of(context)
                //     .textTheme
                //     .headline5!
                //     .copyWith(color: ColorManager.helperTextColor),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: ColorManager.error,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? ColorManager.lightGrey,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? ColorManager.lightGrey,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: ColorManager.error,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? ColorManager.lightGrey,
                  ),
                ),
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.headline5!.copyWith(
                    color: widget.hintTextColor ?? ColorManager.lightGrey,
                    fontSize: 13),
                alignLabelWithHint: true,
              ),
              onChanged: (val) {
                if (widget.onChanged != null) widget.onChanged!(val);
              },
              onSaved: widget.onSaved,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _myFocusNode?.dispose();
    super.dispose();
  }
}
