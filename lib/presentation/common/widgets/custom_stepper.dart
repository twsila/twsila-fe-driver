// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';

// TODO(dragostis): Missing functionality:
//   * mobile horizontal mode with adding/removing steps
//   * alternative labeling
//   * stepper feedback in the case of high-latency interactions

/// The state of a [CustomStep] which is used to control the style of the circle and
/// text.
///
/// See also:
///
///  * [CustomStep]
enum StepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a pencil icon in its circle.
  editing,

  /// A step that displays a tick icon in its circle.
  complete,

  /// A step that is disabled and does not to react to taps.
  disabled,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}

/// Defines the [CustomStepper]'s main axis.
enum StepperType {
  /// A vertical layout of the steps with their content in-between the titles.
  vertical,

  /// A horizontal layout of the steps with their content below the titles.
  horizontal,
}

/// Define StepIndicatorAlignment
enum StepIndicatorAlignment {
  /// Dotted line and line will be drawn at the left portion of the screen.
  left,

  /// Dotted line and line will be drawn at the right portion of the screen.
  right,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 8.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

/// A material step used in [CustomStepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
///
/// See also:
///
///  * [CustomStepper]
///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class CustomStep {
  /// Creates a step for a [CustomStepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const CustomStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive = false,
    this.continueButtonLabel,
    this.cancelButtonLabel,
  })  : assert(title != null),
        assert(content != null),
        assert(state != null);

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;

  /// Set a different text on Stepper Continue Button
  final String? continueButtonLabel;

  /// Set a different text on Stepper Cancel Button
  final String? cancelButtonLabel;
}

/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// {@tool sample --template=stateful_widget_scaffold_center}
///
/// ```dart
/// int _index = 0;
///
/// @override
/// Widget build(BuildContext context) {
///   return Stepper(
///     currentStep: _index,
///     onStepCancel: () {
///       if (_index > 0) {
///         setState(() { _index -= 1; });
///       }
///     },
///     onStepContinue: () {
///       if (_index <= 0) {
///         setState(() { _index += 1; });
///       }
///     },
///     onStepTapped: (int index) {
///       setState(() { _index = index; });
///     },
///     steps: <Step>[
///       Step(
///         title: const Text('Step 1 title'),
///         content: Container(
///           alignment: Alignment.centerLeft,
///           child: const Text('Content for Step 1')
///         ),
///       ),
///       const Step(
///         title: Text('Step 2 title'),
///         content: Text('Content for Step 2'),
///       ),
///     ],
///   );
/// }
/// ```
///
/// {@end-tool}
///
/// See also:
///
///  * [CustomStep]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class CustomStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps], [type], and [currentStep] arguments must not be null.
  const CustomStepper({
    Key? key,
    required this.steps,
    this.physics,
    this.type = StepperType.vertical,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
    this.dottedLine = false,
    this.stepIndicatorAlignment = StepIndicatorAlignment.left,
  })  : assert(steps != null),
        assert(type != null),
        assert(currentStep != null),
        assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<CustomStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final StepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepCancel;

  /// Set the line to be dotted or solid line
  final bool dottedLine;

  /// Set StepIndicatorAlignment
  final StepIndicatorAlignment stepIndicatorAlignment;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions: [onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  /// For example, keeping track of the [currentStep] within the callback can
  /// change the text of the continue or cancel button depending on which step users are at.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }) {
  ///          return Row(
  ///            children: <Widget>[
  ///              TextButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('NEXT'),
  ///              ),
  ///              TextButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final ControlsWidgetBuilder? controlsBuilder;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1)
      _oldStates[i] = widget.steps[i].state;
  }

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1)
      _oldStates[i] = oldWidget.steps[i].state;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildLine(int index, bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 16.0,
      color: widget.steps[index].isActive ||
              widget.steps[index].state == StepState.complete
          ? ColorManager.primary
          : ColorManager.disableTextColor,
    );
  }

  Widget _buildDotted(bool visible) {
    return visible
        ? CustomPaint(
            size: Size(1.0, 12.0),
            painter: DottedLineVerticalPainter(),
          )
        : Container();
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final StepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    assert(state != null);
    switch (state) {
      case StepState.indexed:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: widget.steps[index].isActive ||
                    widget.steps[index].state == StepState.complete
                ? ColorManager.primary
                : ColorManager.disableTextColor,
          ),
        );
      case StepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case StepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Color _circleColor(int index) {
    return widget.steps[index].isActive ||
            widget.steps[index].state == StepState.complete
        ? ColorManager.primary
        : ColorManager.disableTextColor;
  }

  Widget _buildCircle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(
              index, oldState && widget.steps[index].state == StepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height:
              _kTriangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(
                  0.0, 0.8), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(index,
                  oldState && widget.steps[index].state != StepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == StepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != StepState.error)
        return _buildCircle(index, false);
      else
        return _buildTriangle(index, false);
    }
  }

  Widget _buildVerticalControls(int index) {
    if (widget.controlsBuilder != null)
      return widget.controlsBuilder!(context,
          ControlsDetails(currentStep: widget.currentStep, stepIndex: index));

    final Color cancelColor;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    final ThemeData themeData = Theme.of(context);
    final ColorScheme colorScheme = themeData.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: widget.onStepContinue,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : (_isDark()
                            ? colorScheme.onSurface
                            : colorScheme.onPrimary);
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    return _isDark() || states.contains(MaterialState.disabled)
                        ? null
                        : colorScheme.primary;
                  }),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      buttonPadding),
                  shape: MaterialStateProperty.all<OutlinedBorder>(buttonShape),
                ),
                child: Text(
                  (widget.steps[index].continueButtonLabel != null)
                      ? widget.steps[index].continueButtonLabel!
                      : localizations.continueButtonLabel,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(
                  primary: cancelColor,
                  padding: buttonPadding,
                  shape: buttonShape,
                ),
                child: Text((widget.steps[index].cancelButtonLabel != null)
                    ? widget.steps[index].cancelButtonLabel!
                    : localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StepState.indexed:
        return textTheme.bodyText1!.copyWith(
          color: widget.steps[index].isActive
              ? ColorManager.primary
              : ColorManager.grey1,
        );
      case StepState.editing:
      case StepState.complete:
        return textTheme.bodyText1!;
      case StepState.disabled:
        return textTheme.bodyText1!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodyText1!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        return textTheme.caption!;
      case StepState.disabled:
        return textTheme.caption!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.caption!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.steps[index].subtitle!,
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        children: <Widget>[
          widget.stepIndicatorAlignment == StepIndicatorAlignment.right
              ? _buildHeaderTitle(index)
              : Container(),
          // Expanded(
          //   child: Container(
          //     margin: const EdgeInsetsDirectional.only(start: 12.0),
          //     child: _buildHeaderText(index),
          //   ),
          // ),
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              widget.dottedLine
                  ? _buildDotted(!_isFirst(index))
                  : _buildLine(index, !_isFirst(index)),
              _buildIcon(index),
              widget.dottedLine
                  ? _buildDotted(!_isLast(index))
                  : _buildLine(index, !_isLast(index)),
            ],
          ),
          widget.stepIndicatorAlignment == StepIndicatorAlignment.left
              ? _buildHeaderTitle(index)
              : Container(),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 12.0),
        child: _buildHeaderText(index),
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        widget.stepIndicatorAlignment == StepIndicatorAlignment.left
            ? _buildVerticalStepIndicator(index)
            : Container(),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0,
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(index),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
        widget.stepIndicatorAlignment == StepIndicatorAlignment.right
            ? _buildVerticalStepIndicator(index)
            : Container(),
      ],
    );
  }

  Widget _buildVerticalStepIndicator(int index) {
    return _isLast(index)
        ? Container()
        : PositionedDirectional(
            start: widget.stepIndicatorAlignment == StepIndicatorAlignment.left
                ? (widget.dottedLine ? 35.5 : 24.0)
                : null,
            end: widget.stepIndicatorAlignment == StepIndicatorAlignment.right
                ? (widget.dottedLine
                    ? 36.5
                    : 24.0) // Offset needed for dotted/solid line
                : null,
            top: 0.0,
            bottom: 0.0,
            child: widget.dottedLine
                ? CustomPaint(
                    // size: Size(1.0, double.infinity),
                    painter: DottedLineVerticalPainter(),
                  )
                : SizedBox(
                    width: 24.0,
                    child: Center(
                      child: SizedBox(
                        width: _isLast(index) ? 0.0 : 1.0,
                        child: Container(
                          color: widget.steps[index].isActive ||
                                  widget.steps[index].state ==
                                      StepState.complete
                              ? ColorManager.primary
                              : ColorManager.disableTextColor,
                        ),
                      ),
                    ),
                  ),
          );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.steps[i].state != StepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext!,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        widget.onStepTapped?.call(i);
                      }
                    : null,
                canRequestFocus: widget.steps[i].state != StepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != StepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 72.0,
                child: Center(
                  child: _buildIcon(i),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 12.0),
                child: _buildHeaderText(i),
              ),
            ],
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.grey.shade400,
            ),
          ),
      ],
    ];

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: children,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                vsync: this,
                child: widget.steps[widget.currentStep].content,
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<CustomStepper>() != null)
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      return true;
    }());
    assert(widget.type != null);
    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    required this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}

class DottedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 10, startY = 0;
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawCircle(Offset(0, startY), dashHeight, paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
