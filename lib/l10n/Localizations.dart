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
      'prev': 'Previous',
      'next': 'Next',
      'recentSubmissions': 'Recent Submissions',
      'scorePerfect100': 'Score: Perfect 💯',
      'scoreWithVal': 'Score: %d',
      'notOptedForDeed': 'Not opted for deed.',
      'wordWithDetails': 'Word: %s\n%s',
      'quoteWithContent': '%s',
      'deedForTheDay': 'Good Deed for the day\n%s',
      'weekWithStart': 'Week: %s',
      'lookAroundSmile': 'Look around with a good smile.',
      'deepBreath': 'Take a deep breath.',
      'yourMood': 'Your mood',
      'writeAboutFeel': 'Write a few words about why you feel so today.',
      'yourAnswer': 'Your answer',
      'clickForGoodDeed': 'Click here if you want to do a good deed.',
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
      'preferNotToRespond': 'Prefer Not To Respond',
      'transgender': 'Transgender',
      'male': 'Male',
      'female': 'Female',
      'nonBinary': 'Non Binary',
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
      'didNotWrite': 'Did not write.',
      'close': 'Close',
      'getStarted': 'Your privacy is assured. Your data or anything you write in this app is not transferred outside your phone or used by anyone else.\n\nGet started.\nWishing you a good time ahead!',
      'profileWelcome': 'Update your profile to get a personalized experience everyday that is specially prepared for you.',
      'historyWelcome': 'Check your past mood state and see your happiness progress everyday. Keep yourself motivated.',
      'homeWelcome': 'Select your mood every day on the home page and go through the flow which motivates you for the day.',
      'welcome': 'Welcome to Goodness!\nHelp yourself to improve your mood by reducing negative thoughts and encouraging positive thoughts.',
      'highMood': 'Highly %s',
      'moderateMood': 'Moderately %s',
      'slightMood': 'Slightly %s',
      'privacyAssurance': 'Your privacy is assured. Your data or anything you write in this app is not transferred outside your phone or used by anyone else.',
      'quote': 'Quote',
      'share': 'Share',
      'tryApp': 'Try our app for iOS and Android for full history retention and more enhanced features. Click on the links below to download.',
      'appDownloadProfileInfo': 'You can download this later in profile page.',
      'dailyReminderNotificationTitle': 'Time to record your day!',
      'dailyReminderNotificationBody': 'Record your mood today for a better tomorrow.',
      'dailyReminderNotificationPayload': 'Way to go for better tomorrow!'
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
      'quoteWithContent': '%s',
      'deedForTheDay': 'நாள்தோறும் நற்செயல்\n%s',
      'weekWithStart': 'வாரம்: %s',
      'lookAroundSmile': 'புன்னகையுடன் சுற்றிப் பாருங்கள்',
      'deepBreath': 'ஆழ்ந்த மூச்சு எடுத்துக் கொள்ளுங்கள்',
      'yourMood': 'தங்கள் மனநிலை',
      'writeAboutFeel': 'ஏன் அப்படி உணர்கிறீர்கள் என்பதைப் பற்றி சில வார்த்தைகளை எழுதுங்கள்.',
      'yourAnswer': 'உங்கள் விடை',
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
      'didNotWrite': 'எழுதவில்லை',
      'close': 'மூடு',
      'getStarted': 'உங்கள் தனியுரிமைக்கு உறுதி. உங்கள் தரவு அல்லது இந்த செயலியில் நீங்கள் எழுதும் எதுவும் உங்கள் மொபைலுக்கு வெளியே மாற்றப்படுவதில்லை அல்லது வேறு யாராலும் பயன்படுத்தப்படுவதில்லை.\n\nதொடங்கலாம்.\nஉங்கள் நாட்கள் இனிதாக அமைய வாழ்த்துக்கள்!',
      'profileWelcome': 'உங்களுக்காக பிரத்யேகமாகத் தயாரிக்கப்பட்ட தனிப்பட்ட அனுபவத்தைப் பெற உங்கள் சுயவிவரத்தைப் புதுப்பிக்கவும்.',
      'historyWelcome': 'உங்கள் கடந்தகால மனநிலையை சரிபார்த்து, உங்கள் மகிழ்ச்சியின் முன்னேற்றத்தை தினமும் பாருங்கள். உங்களை ஊக்கப் படுத்திக் கொள்ளுங்கள்.',
      'homeWelcome': 'முகப்புப் பக்கத்தில் ஒவ்வொரு நாளும் உங்கள் மனநிலையைத் தேர்ந்தெடுத்து, அந்த நாளுக்கு புத்துணர்ச்சி அளிக்கும் பாதையில் செல்லுங்கள்.',
      'welcome': 'Goodnessக்கு வரவேற்கிறோம்!\nஎதிர்மறை எண்ணங்களைக் குறைத்து, நல்ல எண்ணங்களை ஊக்குவித்து உங்கள் மனநிலையை மேம்படுத்திக்கொள்ள உதவுங்கள்.',
      'highMood': 'மிகவும் %s',
      'moderateMood': 'மிதமான %s',
      'slightMood': 'சிறிதளவு %s',
      'privacyAssurance': 'உங்கள் தனியுரிமைக்கு உறுதி. உங்கள் தரவு அல்லது இந்த செயலியில் நீங்கள் எழுதும் எதுவும் உங்கள் மொபைலுக்கு வெளியே மாற்றப்படுவதில்லை அல்லது வேறு யாராலும் பயன்படுத்தப்படுவதில்லை.',
      'quote': 'வாசகம்',
      'share': 'பகிர்',
      'tryApp': 'முழு வரலாற்றைத் தக்கவைத்துக் கொள்ளவும் மேலும் மேம்படுத்தப்பட்ட அம்சங்களுக்கும் iOS மற்றும் Androidக்கான எங்கள் செயலியை முயற்சிக்கவும். பதிவிறக்கம் செய்ய கீழே உள்ள இணைப்புகளை கிளிக் செய்யவும்.',
      'appDownloadProfileInfo': 'சுயவிவரப் பக்கத்தில் இதைப் பின்னரும் பதிவிறக்கம் செய்யலாம்.',
      'dailyReminderNotificationTitle': 'உங்கள் நாளை பதிவு செய்ய வேண்டிய நேரம்!',
      'dailyReminderNotificationBody': 'ஒரு சிறந்த எதிர்காலத்திற்காக உங்கள் மனநிலையை இன்று பதிவு செய்யுங்கள்.',
      'dailyReminderNotificationPayload': 'நல்ல எதிர்காலத்தை நோக்கி செல்வதற்கான வழி!'
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