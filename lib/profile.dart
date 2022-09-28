import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/widgets/DecoratedText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

import 'l10n/Localizations.dart';

enum Gender { Male, Female, Transgender, NonBinary, PreferNotToRespond }

class ProfilePage extends StatefulWidget {
  static const String KEY_NAME = 'name';
  static const String KEY_GENDER = 'gender';
  static const String KEY_DOB = 'dob';
  static const String KEY_COR = 'cor';
  static const String KEY_MARRIED = 'married';
  static const String KEY_DISABLED = 'disabled';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  String? _name;
  IconData _editsave = CupertinoIcons.pen;
  bool isEditing = false;
  Gender _gender = Gender.PreferNotToRespond;
  DateTime? _dob;
  String? _cor;
  bool _married = false;
  bool _disabled = false;
  late TextEditingController _nameController, _corController;

  @override
  void initState() {
    print('profile initState');
    super.initState();
    _nameController = TextEditingController();
    _corController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _corController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString(ProfilePage.KEY_NAME);
      _nameController.text = _name ?? '';
      String gender = prefs.getString(ProfilePage.KEY_GENDER) ??
          Gender.PreferNotToRespond.name;
      _gender =
          Gender.values.firstWhere((e) => e.toString() == ('Gender.' + gender));
      String? dob = prefs.getString(ProfilePage.KEY_DOB);
      _dob = dob != null ? DateTime.parse(dob) : null;
      _cor = prefs.getString(ProfilePage.KEY_COR);
      _corController.text = _cor ?? '';
      _married = (prefs.getBool(ProfilePage.KEY_MARRIED) ?? false);
      _disabled = (prefs.getBool(ProfilePage.KEY_DISABLED) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('profile build');
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          leading: Visibility(
            visible: isEditing ? true : false,
            child: CupertinoButton(
              onPressed: () => cancelEdit(),
              child: new Icon(CupertinoIcons.pencil_slash),
            ),
          ),
          middle: Text(_name ?? L10n.of(context).resource('yourProfile')),
          trailing: CupertinoButton(
            onPressed: () => toggleEdit(),
            child: new Icon(_editsave),
          ),
        ),
        child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                child: SafeArea(
                    child: isEditing
                        ? buildEditableColumn()
                        : buildDisplayColumn()))));
  }

  Column buildDisplayColumn() {
    String genderStr = L10n.of(context).resource('notSet');
    switch (_gender) {
      case Gender.PreferNotToRespond:
        genderStr = L10n.of(context).resource('preferNotToRespond');
        break;
      case Gender.Transgender:
        genderStr = L10n.of(context).resource('transgender');
        break;
      case Gender.NonBinary:
        genderStr = L10n.of(context).resource('nonBinary');
        break;
      case Gender.Female:
        genderStr = L10n.of(context).resource('female');
        break;
      case Gender.Male:
        genderStr = L10n.of(context).resource('male');
        break;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DecoratedText(_name ?? L10n.of(context).resource('yourName')),
          DecoratedText(_cor ?? L10n.of(context).resource('yourCountry')),
          DecoratedText(sprintf(
              L10n.of(context).resource('dateOfBirthDisplay'), [
            _dob != null
                ? getDisplayDate(_dob!)
                : L10n.of(context).resource('notSet')
          ])),
          DecoratedText(
              sprintf(L10n.of(context).resource('genderDisplay'), [genderStr])),
          DecoratedText(_married
              ? L10n.of(context).resource('maritalStatusMarried')
              : L10n.of(context).resource('maritalStatusUnmarried')),
          DecoratedText(_disabled
              ? L10n.of(context).resource('phyConditionsDisabled')
              : L10n.of(context).resource('phyConditionsNotDisabled')),
        ]);
  }

  Column buildEditableColumn() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CupertinoTextField(
            controller: _nameController,
            placeholder: L10n.of(context).resource('yourName'),
          ),
          CupertinoTextField(
            controller: _corController,
            placeholder: L10n.of(context).resource('yourCountry'),
          ),
          Text(L10n.of(context).resource('dateOfBirth')),
          CupertinoButton(
            onPressed: () => _showDialog(
              CupertinoDatePicker(
                initialDateTime: _dob,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _dob = newDate);
                },
              ),
            ),
            // In this example, the date value is formatted manually. You can use intl package
            // to format the value based on user's locale settings.
            child: Text(
              _dob != null
                  ? getDisplayDate(_dob!)
                  : L10n.of(context).resource('notSet'),
              style: const TextStyle(
                fontSize: 22.0,
              ),
            ),
          ),
          Text(L10n.of(context).resource('gender')),
          CupertinoSegmentedControl<Gender>(
            groupValue: _gender,
            onValueChanged: (Gender value) {
              setState(() {
                _gender = value;
              });
            },
            children: <Gender, Widget>{
              Gender.Male: Text(L10n.of(context).resource('male')),
              Gender.Female: Text(L10n.of(context).resource('female')),
              Gender.NonBinary: Text(L10n.of(context).resource('nonBinary')),
              Gender.Transgender:
                  Text(L10n.of(context).resource('transgender')),
              Gender.PreferNotToRespond:
                  Text(L10n.of(context).resource('preferNotToRespond')),
            },
          ),
          Text(L10n.of(context).resource('maritalStatus')),
          CupertinoSegmentedControl<bool>(
            groupValue: _married,
            onValueChanged: (bool value) {
              setState(() {
                _married = value;
              });
            },
            children: <bool, Widget>{
              true: Text(L10n.of(context).resource('married')),
              false: Text(L10n.of(context).resource('unmarried')),
            },
          ),
          Text(L10n.of(context).resource('phyCondidtions')),
          CupertinoSegmentedControl<bool>(
            groupValue: _disabled,
            onValueChanged: (bool value) {
              setState(() {
                _disabled = value;
              });
            },
            children: <bool, Widget>{
              true: Text(L10n.of(context).resource('disabled')),
              false: Text(L10n.of(context).resource('noDisability')),
            },
          ),
        ]);
  }

  toggleEdit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (isEditing) {
        _editsave = CupertinoIcons.pen;
        _name = _nameController.text;
        _cor = _corController.text;
        prefs.setString(ProfilePage.KEY_NAME, _nameController.text);
        prefs.setString(ProfilePage.KEY_COR, _corController.text);
        prefs.setString(ProfilePage.KEY_GENDER, _gender.name);
        prefs.setBool(ProfilePage.KEY_MARRIED, _married);
        prefs.setBool(ProfilePage.KEY_DISABLED, _disabled);
        prefs.setString(ProfilePage.KEY_DOB, _dob.toString());
      } else {
        _editsave = CupertinoIcons.square_arrow_down;
      }
      isEditing = !isEditing;
    });
  }

  cancelEdit() {
    setState(() {
      isEditing = false;
      _editsave = CupertinoIcons.pen;
    });
    _loadProfile();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
