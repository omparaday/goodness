import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:goodness/dbhelpers/DailyData.dart';
import 'package:goodness/main.dart';
import 'package:goodness/widgets/DecoratedText.dart';
import 'package:goodness/widgets/DecoratedWidget.dart';
import 'package:goodness/widgets/RounderSegmentControl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dbhelpers/Utils.dart';
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
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.white,
            darkColor: CupertinoColors.black,
          ),
          leading: Visibility(
            visible: isEditing ? true : false,
            child: CupertinoButton(
              onPressed: () => cancelEdit(),
              child: new Icon(CupertinoIcons.pencil_slash),
            ),
          ),
          middle: Text(
            L10n.of(context).resource('yourProfile'),
            style: TextStyle(fontSize: 22),
          ),
          trailing: CupertinoButton(
            onPressed: () => toggleEdit(),
            child: new Icon(_editsave),
          ),
        ),
        child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: SafeArea(
                    child: Column(children: <Widget>[
                  isEditing ? buildEditableColumn() : buildDisplayColumn(),
                  SizedBox(
                    height: 20,
                  ),
                  kIsWeb
                      ? Text(L10n.of(context).resource('tryApp'))
                      : SizedBox.shrink(),
                  kIsWeb
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {
                                launchUrl(new Uri(
                                    scheme: 'https',
                                    host: 'play.google.com',
                                    path: '/store/apps/details',
                                    queryParameters: {
                                      'id': 'com.monsoon.goodness'
                                    }));
                              },
                              child: new Image.asset(
                                'assets/googlePlayStore.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                launchUrl(new Uri(
                                    scheme: 'https',
                                    host: 'apps.apple.com',
                                    path: '/app/goodness-day/id6444273449'));
                              },
                              child: new Image.asset(
                                'assets/appStoreIcon.png',
                                width: 50,
                                height: 50,
                              ),
                            )
                          ],
                        )
                      : SizedBox.shrink(),
                  Text(
                    L10n.of(context).resource('privacyAssurance'),
                    style: TextStyle(
                        fontSize: SMALL_FONTSIZE,
                        color: CupertinoColors.systemGrey),
                  ),
                ])))));
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
          DecoratedWidget(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                  child: Text(
                    _dob != null
                        ? getDisplayDate(_dob!)
                        : L10n.of(context).resource('notSet'),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ])),
          DecoratedWidget(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(L10n.of(context).resource('gender')),
                RoundedSegmentControl<Gender>(
                  groupValue: _gender,
                  onValueChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  children: <Gender, String>{
                    Gender.Male: L10n.of(context).resource('male'),
                    Gender.Female: (L10n.of(context).resource('female')),
                    Gender.NonBinary:
                        (L10n.of(context).resource('nonBinary')),
                    Gender.Transgender:
                        (L10n.of(context).resource('transgender')),
                    Gender.PreferNotToRespond:
                        (L10n.of(context).resource('preferNotToRespond')),
                  },
                ),
              ])),
          DecoratedWidget(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(L10n.of(context).resource('maritalStatus')),
                RoundedSegmentControl<bool>(
                  groupValue: _married,
                  onValueChanged: (bool value) {
                    setState(() {
                      _married = value;
                    });
                  },
                  children: <bool, String>{
                    true: (L10n.of(context).resource('married')),
                    false: (L10n.of(context).resource('unmarried')),
                  },
                ),
              ])),
          DecoratedWidget(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(L10n.of(context).resource('phyCondidtions')),
                RoundedSegmentControl<bool>(
                  groupValue: _disabled,
                  onValueChanged: (bool value) {
                    setState(() {
                      _disabled = value;
                    });
                  },
                  children: <bool, String>{
                    true: (L10n.of(context).resource('disabled')),
                    false: (L10n.of(context).resource('noDisability')),
                  },
                ),
              ])),
          SizedBox(
            height: 20,
          ),
          CupertinoButton(
            onPressed: () => toggleEdit(),
            child: Text(L10n.of(context).resource('submit')),
          )
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
        _editsave = CupertinoIcons.folder_badge_plus;
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
