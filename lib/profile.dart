import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Gender {
  Male,
  Female,
  Transgender,
  NonBinary,
  PreferNotToRespond
}

class ProfilePage extends StatefulWidget {
  static const String KEY_NAME = 'name';
  static const String KEY_GENDER = 'gender';
  static const String KEY_DOB = 'dob';
  static const String KEY_COR = 'cor';
  static const String KEY_MARRIED = 'married';
  static const String KEY_DISABLED = 'disabled';

  ProfilePage({super.key});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  IconData _editsave = CupertinoIcons.pen;
  bool isEditing = false;
  Gender _gender = Gender.PreferNotToRespond;
  DateTime? _dob = null;
  String _cor = '';
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
      _name = (prefs.getString(ProfilePage.KEY_NAME) ?? "");
      _nameController.text = _name;
      String gender = prefs.getString(ProfilePage.KEY_GENDER) ?? Gender.PreferNotToRespond.name;
      _gender = Gender.values.firstWhere((e) => e.toString() == ('Gender.' + gender));
      String? dob = prefs.getString(ProfilePage.KEY_DOB);
      _dob = dob != null ? DateTime.parse(dob) : null;
      _cor = (prefs.getString(ProfilePage.KEY_COR) ?? "");
      _corController.text = _cor;
      _married = (prefs.getBool(ProfilePage.KEY_MARRIED) ?? false);
      _disabled = (prefs.getBool(ProfilePage.KEY_DISABLED) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: CupertinoNavigationBar(
          leading: Visibility(
            visible: isEditing? true : false,
            child: CupertinoButton(
              onPressed: () => cancelEdit(),
              child: new Icon(CupertinoIcons.pencil_slash),
            ),
          ),
          middle: Text('Your Profile'),
          trailing: CupertinoButton(
            onPressed: () => toggleEdit(),
            child: new Icon(_editsave),
          ),
        ),
        child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Name'),
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Your Name',
                    enabled: isEditing,
                  ),
                  Text('Country'),
                  CupertinoTextField(
                    controller: _corController,
                    placeholder: 'Your Country',
                    enabled: isEditing,
                  ),
                  Text('Date of Birth'),
                  CupertinoButton(
                    // Display a CupertinoDatePicker in date picker mode.
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: _dob,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        // This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => _dob = newDate);
                        },
                      ),
                    ),
                    // In this example, the date value is formatted manually. You can use intl package
                    // to format the value based on user's locale settings.
                    child: Text(
                      _dob != null ? '${_dob?.month}-${_dob?.day}-${_dob?.year}' : 'Not Set',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  Text('Gender'),
                  CupertinoSegmentedControl<Gender>(
                    groupValue: _gender,
                    onValueChanged: (!isEditing ? (Gender value) => null : (Gender value) {
                      _gender = value;
                    }),
                    children: const <Gender, Widget>{
                      Gender.Male: Text('Male'),
                      Gender.Female: Text('Female'),
                      Gender.NonBinary: Text('NonBinary'),
                      Gender.Transgender: Text('Transgender'),
                      Gender.PreferNotToRespond: Text('PreferNotToRespond'),
                    },
                  ),
                  Text('Marital Status'),
                  CupertinoSegmentedControl<bool>(
                    groupValue: _married,
                    onValueChanged: (!isEditing ? (bool value) => null : (bool value) {
                      _married = value;
                    }),
                    children: const <bool, Widget>{
                      true: Text('Married'),
                      false: Text('Unmarried'),
                    },
                  ),
                  Text('Physical Conditions'),
                  CupertinoSegmentedControl<bool>(
                    groupValue: _disabled,
                    onValueChanged: (!isEditing ? (bool value) => null : (bool value) {
                      _disabled = value;
                    }),
                    children: const <bool, Widget>{
                      true: Text('Disabled'),
                      false: Text('No Disability'),
                    },
                  ),
                ]
            )

        )
    );
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
}