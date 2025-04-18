library intl_phone_field;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/helpers.dart';

import './countries.dart';
import './phone_number.dart';

class IntlPhoneField extends StatefulWidget {
  /// The TextFormField key.
  final GlobalKey<FormFieldState>? formFieldKey;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;
  final FormFieldSetter<PhoneNumber>? onSaved;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted], [onSelectionChanged]:
  ///    which are more specialized input change notifications.
  final ValueChanged<PhoneNumber>? onChanged;

  /// An optional method that validates an input. Returns an error string to display if the input is invalid, or null otherwise.
  ///
  /// A [PhoneNumber] is passed to the validator as argument.
  /// The validator can handle asynchronous validation when declared as a [Future].
  /// Or run synchronously when declared as a [Function].
  ///
  /// By default, the validator checks whether the input number length is between selected country's phone numbers min and max length.
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// focusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field.  The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  ///
  /// See also:
  ///
  ///  * [EditableText.onSubmitted] for an example of how to handle moving to
  ///    the next/previous field when using [TextInputAction.next] and
  ///    [TextInputAction.previous] for [textInputAction].
  final void Function(String)? onSubmitted;

  /// If false the widget is "disabled": it ignores taps, the [TextFormField]'s
  /// [decoration] is rendered in grey,
  /// [decoration]'s [InputDecoration.counterText] is set to `""`,
  /// and the drop down icon is hidden no matter [showDropdownIcon] value.
  ///
  /// If non-null this property overrides the [decoration]'s
  /// [Decoration.enabled] property.
  final bool enabled;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// Initial Value for the field.
  /// This property can be used to pre-fill the field.
  final String? initialValue;

  /// 2 letter ISO Code or country dial code.
  ///
  /// ```dart
  /// initialCountryCode: 'IN', // India
  /// initialCountryCode: '+225', // Côte d'Ivoire
  /// when you pass an invalid `initialCountryCode`, it defaults to the first country in the list
  /// Which the default List is Afghanistan
  /// ```
  final String initialCountryCode;

  /// List of Country to display see countries.dart for format
  final List<Country>? countries;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  final InputDecoration decoration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle1` text style from the current [Theme].
  final TextStyle? style;

  /// Won't work if [enabled] is set to `false`.
  final bool showDropdownIcon;

  final BoxDecoration dropdownDecoration;

  /// The style use for the country dial code.
  final TextStyle? dropdownTextStyle;

  /// Position of an icon [leading, trailing]
  final IconPosition dropdownIconPosition;

  /// Icon of the drop down button.
  ///
  /// Default is [Icon(Icons.arrow_drop_down)]
  final Icon dropdownIcon;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Autovalidate mode for text form field.
  ///
  /// If [AutovalidateMode.onUserInteraction], this FormField will only auto-validate after its content changes.
  /// If [AutovalidateMode.always], it will auto-validate even without user interaction.
  /// If [AutovalidateMode.disabled], auto-validation will be disabled.
  ///
  /// Defaults to [AutovalidateMode.onUserInteraction].
  final AutovalidateMode? autovalidateMode;

  /// Whether to show or hide country flag.
  ///
  /// Default value is `true`.
  final bool showCountryFlag;

  /// Message to be displayed on autoValidate error
  ///
  /// Default value is `Invalid Mobile Number`.
  final String? invalidNumberMessage;

  /// The color of the cursor.
  final Color? cursorColor;

  /// How tall the cursor will be.
  final double? cursorHeight;

  final double? spacing;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// Whether to show cursor.
  final bool? showCursor;

  /// The padding of the Flags Button.
  ///
  /// The amount of insets that are applied to the Flags Button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry flagsButtonPadding;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Optional set of styles to allow for customizing the country search
  /// & pick dialog
  final PickerDialogStyle? pickerDialogStyle;

  /// The margin of the country selector button.
  ///
  /// The amount of space to surround the country selector button.
  ///
  /// If unset, defaults to [EdgeInsets.zero].
  final EdgeInsets flagsButtonMargin;

  /// Enable the autofill hint for phone number.
  final bool disableAutoFillHints;

  /// If null, default magnification configuration will be used.
  final TextMagnifierConfiguration? magnifierConfiguration;

  const IntlPhoneField({
    Key? key,
    this.formFieldKey,
    required this.initialCountryCode,
    this.disableAutoFillHints = false,
    this.obscureText = false,
    this.textAlign = TextAlign.left,
    this.textAlignVertical,
    this.onTap,
    this.spacing,
    this.readOnly = false,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    this.dropdownTextStyle,
    this.onSubmitted,
    this.validator,
    this.onChanged,
    this.countries,
    this.onSaved,
    this.showDropdownIcon = true,
    this.dropdownDecoration = const BoxDecoration(),
    this.enabled = true,
    this.keyboardAppearance,
    this.dropdownIconPosition = IconPosition.leading,
    this.dropdownIcon = const Icon(Icons.arrow_drop_down),
    this.autofocus = false,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCountryFlag = true,
    this.cursorColor,
    this.flagsButtonPadding = EdgeInsets.zero,
    this.invalidNumberMessage = 'Invalid Mobile Number',
    this.cursorHeight,
    this.cursorRadius = Radius.zero,
    this.cursorWidth = 2.0,
    this.showCursor = true,
    this.pickerDialogStyle,
    this.flagsButtonMargin = EdgeInsets.zero,
    this.magnifierConfiguration,
  }) : super(key: key);

  @override
  State<IntlPhoneField> createState() => _IntlPhoneFieldState();
}

class _IntlPhoneFieldState extends State<IntlPhoneField> {
  late List<Country> _countryList;
  late Country _selectedCountry;
  late List<Country> filteredCountries;
  late String number;

  String? validatorMessage;

  @override
  void initState() {
    super.initState();
    _countryList = widget.countries ?? countries;
    filteredCountries = _countryList;
    number = widget.initialValue ?? '';
    if (number.startsWith('+')) {
      number = number.substring(1);
      // parse initial value
      _selectedCountry = countries.firstWhere(
        (country) => number.startsWith(country.fullCountryCode),
        orElse: () => _countryList.first,
      );

      // remove country code from the initial number value
      number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
    } else {
      _selectedCountry = _countryList.firstWhere(
        (item) => item.code == (widget.initialCountryCode),
        orElse: () => _countryList.first,
      );
      // remove country code from the initial number value
      if (number.startsWith('+')) {
        number = number.replaceFirst(RegExp("^\\+${_selectedCountry.fullCountryCode}"), "");
      } else {
        number = number.replaceFirst(RegExp("^${_selectedCountry.fullCountryCode}"), "");
      }
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      final initialPhoneNumber = PhoneNumber(
        countryISOCode: _selectedCountry.code,
        countryCode: '+${_selectedCountry.dialCode}',
        number: widget.initialValue ?? '',
      );

      final value = widget.validator?.call(initialPhoneNumber);

      if (value is String) {
        validatorMessage = value;
      } else {
        (value as Future).then((msg) {
          validatorMessage = msg;
        });
      }
    }
  }

  String? _validator(String? value) {
    if (value?.isEmpty == true) {
      return 'Phone number must not be empty';
    }
    if (value == null || !isNumeric(value)) return validatorMessage;
    return value.length >= _selectedCountry.minLength && value.length <= _selectedCountry.maxLength
        ? null
        : widget.invalidNumberMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            key: widget.formFieldKey,
            readOnly: true,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            cursorColor: widget.cursorColor,
            cursorHeight: widget.cursorHeight,
            cursorRadius: widget.cursorRadius,
            cursorWidth: widget.cursorWidth,
            magnifierConfiguration: widget.magnifierConfiguration,
            enabled: widget.enabled,
            keyboardAppearance: widget.keyboardAppearance,
            autofocus: widget.autofocus,
            autovalidateMode: widget.autovalidateMode,
            style: widget.style,
            decoration: widget.decoration.copyWith(
              suffixIcon: _buildFlagsButton(),
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefix: const SizedBox(
                width: 10,
              ),
              suffix: const SizedBox(
                width: 10,
              ),
            ),
          ),
        ),
        SizedBox(
          width: widget.spacing,
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            key: widget.formFieldKey,
            initialValue: (widget.controller == null) ? number : null,
            autofillHints: widget.disableAutoFillHints ? null : [AutofillHints.telephoneNumberNational],
            readOnly: widget.readOnly,
            obscureText: widget.obscureText,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            cursorColor: widget.cursorColor,
            onTap: widget.onTap,
            controller: widget.controller,
            focusNode: widget.focusNode,
            cursorHeight: widget.cursorHeight,
            cursorRadius: widget.cursorRadius,
            cursorWidth: widget.cursorWidth,
            showCursor: widget.showCursor,
            onFieldSubmitted: widget.onSubmitted,
            magnifierConfiguration: widget.magnifierConfiguration,
            decoration: widget.decoration.copyWith(
              counterText: !widget.enabled ? '' : null,
              contentPadding: EdgeInsets.zero,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefix: const SizedBox(
                width: 10,
              ),
              suffix: const SizedBox(
                width: 10,
              ),
            ),
            style: widget.style,
            onSaved: (value) {
              widget.onSaved?.call(
                PhoneNumber(
                  countryISOCode: _selectedCountry.code,
                  countryCode: '+${_selectedCountry.dialCode}${_selectedCountry.regionCode}',
                  number: value!,
                ),
              );
            },
            onChanged: (value) async {
              final phoneNumber = PhoneNumber(
                countryISOCode: _selectedCountry.code,
                countryCode: '+${_selectedCountry.fullCountryCode}',
                number: value,
              );

              if (widget.autovalidateMode != AutovalidateMode.disabled) {
                validatorMessage = await widget.validator?.call(phoneNumber);
              }

              widget.onChanged?.call(phoneNumber);
            },
            validator: _validator,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            enabled: widget.enabled,
            keyboardAppearance: widget.keyboardAppearance,
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            autovalidateMode: widget.autovalidateMode,
          ),
        ),
      ],
    );
  }

  Container _buildFlagsButton() {
    return Container(
      margin: widget.flagsButtonMargin,
      child: DecoratedBox(
        decoration: widget.dropdownDecoration,
        child: Padding(
          padding: widget.flagsButtonPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.showCountryFlag) ...[
                Text(
                  _selectedCountry.flag,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                '+${_selectedCountry.dialCode}',
                style: widget.dropdownTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}
