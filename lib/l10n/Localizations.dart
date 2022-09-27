import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class L10n {
  L10n(this.locale);

  final Locale locale;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'home': 'Home',
      'history': 'History',
      'profile': 'Profile',
      'happy': 'Happy',
      'excited': 'Excited',
      'peaceful': 'Peaceful',
      'fear': 'Fear',
      'sad': 'Sad',
      'weak': 'Weak',
      'angry': 'Angry',
      'strong': 'Strong',
      'week': 'Week',
      'month': 'Month',
      'year': 'Year',
      'all': 'All',
      'averageScore': 'Average Score: %s',
      'prev': 'Prev',
      'next': 'Next',
      'recentSubmissions': 'Recent Submissions',
      'scorePerfect100': 'Score: Perfect 💯',
      'scoreWithVal': 'Score: %d',
      'notOptedForDeed': 'Not opted for deed.',
      'wordWithDetails': 'Word: %s\n%s',
      'quoteWithContent': 'Quote\n%s',
      'deedForTheDay': 'Good Deed for the day\n%s',
      'weekWithStart': 'Week: %s',
      'lookAroundSmile': 'Look around with a good smile',
      'deepBreath': 'Take a deep breath',
      'yourMood': 'Your mood',
      'writeAboutFeel': 'Write a few words about why you feel so today.',
      'clickForGoodDeed': 'Click here you want to do a good deed',
      'submit': 'Submit',
      'proceed': 'Proceed',
      'yourscorePerfect100': 'Your goodness score is Perfect 💯',
      'yourscoreWithVal': 'Your goodness score is %d',
      'disabled': 'Disabled',
      'noDisability': 'No Disability',
      'phyCondidtions': 'Physical Conditions',
      'unmarried': 'Unmarried',
      'married': 'Married',
      'maritalStatus': 'Marital Status',
      'preferNotToRespond': 'PreferNotToRespond',
      'transgender': 'Transgender',
      'male': 'Male',
      'female': 'Female',
      'nonBinary': 'NonBinary',
      'gender': 'Gender',
      'notSet': 'Not Set',
      'dateOfBirth': 'Date of Birth',
      'yourCountry': 'Your Country',
      'yourName': 'Your Name',
      'yourProfile': 'Your Profile',
      'phyConditionsNotDisabled': 'Physical Conditions: No Disability',
      'phyConditionsDisabled': 'Physical Conditions: Disabled',
      'maritalStatusUnmarried': 'Marital Status: Unmarried',
      'maritalStatusMarried': 'Marital Status: Married',
      'dateOfBirthDisplay': 'Date of Birth: %s',
      'genderDisplay': 'Gender: %s',
    },
    'ta': {
      'home': 'முகப்பு',
      'history': 'கடந்தவை',
      'profile': 'சுயவிவரம்',
      'happy': 'மகிழ்ச்சி',
      'excited': 'உற்சாகம்',
      'peaceful': 'அமைதி',
      'fear': 'பயம்',
      'sad': 'வருத்தம்',
      'weak': 'பலவீனம்',
      'angry': 'கோபம்',
      'strong': 'எழுச்சி',
      'week': 'வாரம்',
      'month': 'மாதம்',
      'year': 'வருடம்',
      'all': 'அனைத்தும்',
      'averageScore': 'சராசரி மதிப்பு: %s',
      'prev': 'முன்',
      'next': 'பின்',
      'recentSubmissions': 'சமீபத்திய சமர்ப்பிப்புகள்',
      'scorePerfect100': 'மதிப்பு: கச்சிதமான 💯',
      'scoreWithVal': 'மதிப்பு: %d',
      'notOptedForDeed': 'நற்செயலில் ஈடுபட விழையவில்லை.',
      'wordWithDetails': 'வார்த்தை: %s\n%s',
      'quoteWithContent': 'வாசகம்\n%s',
      'deedForTheDay': 'நாள்தோறும் நற்செயல்\n%s',
      'weekWithStart': 'வாரம்: %s',
      'lookAroundSmile': 'புன்னகையுடன் சுற்றிப் பாருங்கள்',
      'deepBreath': 'ஆழ்ந்த மூச்சு எடுத்துக் கொள்ளுங்கள்',
      'yourMood': 'தங்கள் மனநிலை',
      'writeAboutFeel': 'ஏன் அப்படி உணர்கிறீர்கள் என்பதைப் பற்றி சில வார்த்தைகளை எழுதுங்கள்.',
      'clickForGoodDeed': 'ஒரு நற்செயலைச் செய்ய விரும்பும் இங்கே கிளிக் செய்யவும்',
      'submit': 'சமர்ப்பிக்கவும்',
      'proceed': 'தொடரவும்',
      'yourscorePerfect100': 'தங்கள் மதிப்பு கச்சிதமான 💯',
      'yourscoreWithVal': 'தங்கள் மதிப்பு %d',
      'disabled': 'ஊனமுற்றவர்',
      'noDisability': 'உடல் ஊனமுற்றவர் அல்ல',
      'phyCondidtions': 'உடல் நிலைகள்',
      'unmarried': 'திருமணமாகாதவர்',
      'married': 'திருமணமானவர்',
      'maritalStatus': 'திருமண நிலை',
      'preferNotToRespond': 'பதிலளிக்க வேண்டாம்',
      'transgender': 'மாற்றுப்பாலினர்',
      'male': 'ஆண்',
      'female': 'பெண்',
      'nonBinary': 'பைனரி அல்லாத பாலினம்',
      'gender': 'பாலினம்',
      'notSet': 'கொடுக்கப்படவில்லை',
      'dateOfBirth': 'பிறந்த நாள்',
      'yourCountry': 'தங்கள் நாடு',
      'yourName': 'தங்கள் பெயர்',
      'yourProfile': 'தங்கள் சுயவிவரம்',
      'phyConditionsNotDisabled': 'உடல் நிலைகள்: உடல் ஊனமுற்றவர் அல்ல',
      'phyConditionsDisabled': 'உடல் நிலைகள்: ஊனமுற்றவர்',
      'maritalStatusUnmarried': 'திருமண நிலை: திருமணமாகாதவர்',
      'maritalStatusMarried': 'திருமண நிலை: திருமணமானவர்',
      'dateOfBirthDisplay': 'பிறந்த நாள்: %s',
      'genderDisplay': 'பாலினம்: %s',
    },
  };

  static List<String> languages ()=> _localizedValues.keys.toList();

  String resource(String name) {
    return _localizedValues[locale.languageCode]![name]!;
  }
}
// #enddocregion Demo

// #docregion Delegate
class L10nDelegate
    extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => L10n.languages().contains(locale.languageCode);


  @override
  Future<L10n> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<L10n>(L10n(locale));
  }

  @override
  bool shouldReload(L10nDelegate old) => false;
}