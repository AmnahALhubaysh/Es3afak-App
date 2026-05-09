import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Esafak'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcome;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'What would you like to learn today?'**
  String get question;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @learnFirstAid.
  ///
  /// In en, this message translates to:
  /// **'Learn first aid'**
  String get learnFirstAid;

  /// No description provided for @practicePlay.
  ///
  /// In en, this message translates to:
  /// **'Practice & play'**
  String get practicePlay;

  /// No description provided for @emergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergencyCall;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search for a lesson...'**
  String get search;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency?'**
  String get emergency;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call 997'**
  String get call;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @quickQuiz.
  ///
  /// In en, this message translates to:
  /// **'Quick Quiz'**
  String get quickQuiz;

  /// No description provided for @memoryMatch.
  ///
  /// In en, this message translates to:
  /// **'Memory Match'**
  String get memoryMatch;

  /// No description provided for @puzzle.
  ///
  /// In en, this message translates to:
  /// **'First Aid Puzzle'**
  String get puzzle;

  /// No description provided for @scenarios.
  ///
  /// In en, this message translates to:
  /// **'Emergency Scenarios'**
  String get scenarios;

  /// No description provided for @learningGames.
  ///
  /// In en, this message translates to:
  /// **'Learning Games'**
  String get learningGames;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice your skills through fun games'**
  String get practice;

  /// No description provided for @q1.
  ///
  /// In en, this message translates to:
  /// **'What is the first step when bleeding occurs?'**
  String get q1;

  /// No description provided for @q1_o1.
  ///
  /// In en, this message translates to:
  /// **'Wash with water'**
  String get q1_o1;

  /// No description provided for @q1_o2.
  ///
  /// In en, this message translates to:
  /// **'Direct pressure'**
  String get q1_o2;

  /// No description provided for @q1_o3.
  ///
  /// In en, this message translates to:
  /// **'Elevate the limb'**
  String get q1_o3;

  /// No description provided for @q1_o4.
  ///
  /// In en, this message translates to:
  /// **'Call ambulance'**
  String get q1_o4;

  /// No description provided for @q2.
  ///
  /// In en, this message translates to:
  /// **'What should you do for a minor burn?'**
  String get q2;

  /// No description provided for @q2_o1.
  ///
  /// In en, this message translates to:
  /// **'Apply ice'**
  String get q2_o1;

  /// No description provided for @q2_o2.
  ///
  /// In en, this message translates to:
  /// **'Apply butter'**
  String get q2_o2;

  /// No description provided for @q2_o3.
  ///
  /// In en, this message translates to:
  /// **'Cool running water'**
  String get q2_o3;

  /// No description provided for @q2_o4.
  ///
  /// In en, this message translates to:
  /// **'Cover the burn'**
  String get q2_o4;

  /// No description provided for @q3.
  ///
  /// In en, this message translates to:
  /// **'How do you deal with a nosebleed?'**
  String get q3;

  /// No description provided for @q3_o1.
  ///
  /// In en, this message translates to:
  /// **'Tilt head back'**
  String get q3_o1;

  /// No description provided for @q3_o2.
  ///
  /// In en, this message translates to:
  /// **'Tilt head forward'**
  String get q3_o2;

  /// No description provided for @q3_o3.
  ///
  /// In en, this message translates to:
  /// **'Lie down'**
  String get q3_o3;

  /// No description provided for @q3_o4.
  ///
  /// In en, this message translates to:
  /// **'Use cotton'**
  String get q3_o4;

  /// No description provided for @q4.
  ///
  /// In en, this message translates to:
  /// **'What is the correct action for a bee sting?'**
  String get q4;

  /// No description provided for @q4_o1.
  ///
  /// In en, this message translates to:
  /// **'Remove with tweezers'**
  String get q4_o1;

  /// No description provided for @q4_o2.
  ///
  /// In en, this message translates to:
  /// **'Rub the area'**
  String get q4_o2;

  /// No description provided for @q4_o3.
  ///
  /// In en, this message translates to:
  /// **'Scrape with a card'**
  String get q4_o3;

  /// No description provided for @q4_o4.
  ///
  /// In en, this message translates to:
  /// **'Apply salt'**
  String get q4_o4;

  /// No description provided for @q5.
  ///
  /// In en, this message translates to:
  /// **'What do you do if someone is choking?'**
  String get q5;

  /// No description provided for @q5_o1.
  ///
  /// In en, this message translates to:
  /// **'Give water'**
  String get q5_o1;

  /// No description provided for @q5_o2.
  ///
  /// In en, this message translates to:
  /// **'Back blows'**
  String get q5_o2;

  /// No description provided for @q5_o3.
  ///
  /// In en, this message translates to:
  /// **'Lay them down'**
  String get q5_o3;

  /// No description provided for @q5_o4.
  ///
  /// In en, this message translates to:
  /// **'Let them cough'**
  String get q5_o4;

  /// No description provided for @q6.
  ///
  /// In en, this message translates to:
  /// **'What method is used for an ankle sprain?'**
  String get q6;

  /// No description provided for @q6_o1.
  ///
  /// In en, this message translates to:
  /// **'Compression and cooling'**
  String get q6_o1;

  /// No description provided for @q6_o2.
  ///
  /// In en, this message translates to:
  /// **'Walk on it'**
  String get q6_o2;

  /// No description provided for @q6_o3.
  ///
  /// In en, this message translates to:
  /// **'Hot water'**
  String get q6_o3;

  /// No description provided for @q6_o4.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get q6_o4;

  /// No description provided for @q7.
  ///
  /// In en, this message translates to:
  /// **'What is the unified emergency number?'**
  String get q7;

  /// No description provided for @q7_o1.
  ///
  /// In en, this message translates to:
  /// **'911'**
  String get q7_o1;

  /// No description provided for @q7_o2.
  ///
  /// In en, this message translates to:
  /// **'999'**
  String get q7_o2;

  /// No description provided for @q7_o3.
  ///
  /// In en, this message translates to:
  /// **'123'**
  String get q7_o3;

  /// No description provided for @q7_o4.
  ///
  /// In en, this message translates to:
  /// **'997'**
  String get q7_o4;

  /// No description provided for @q8.
  ///
  /// In en, this message translates to:
  /// **'What do you do for someone who fainted?'**
  String get q8;

  /// No description provided for @q8_o1.
  ///
  /// In en, this message translates to:
  /// **'Pull their head'**
  String get q8_o1;

  /// No description provided for @q8_o2.
  ///
  /// In en, this message translates to:
  /// **'Raise their legs'**
  String get q8_o2;

  /// No description provided for @q8_o3.
  ///
  /// In en, this message translates to:
  /// **'Splash water'**
  String get q8_o3;

  /// No description provided for @q8_o4.
  ///
  /// In en, this message translates to:
  /// **'Shake them hard'**
  String get q8_o4;

  /// No description provided for @q9.
  ///
  /// In en, this message translates to:
  /// **'How do you treat heat stroke?'**
  String get q9;

  /// No description provided for @q9_o1.
  ///
  /// In en, this message translates to:
  /// **'Drink coffee'**
  String get q9_o1;

  /// No description provided for @q9_o2.
  ///
  /// In en, this message translates to:
  /// **'Cool place and fluids'**
  String get q9_o2;

  /// No description provided for @q9_o3.
  ///
  /// In en, this message translates to:
  /// **'Cover the body'**
  String get q9_o3;

  /// No description provided for @q9_o4.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get q9_o4;

  /// No description provided for @q10.
  ///
  /// In en, this message translates to:
  /// **'What to do if a chemical enters the eye?'**
  String get q10;

  /// No description provided for @q10_o1.
  ///
  /// In en, this message translates to:
  /// **'Rub the eye'**
  String get q10_o1;

  /// No description provided for @q10_o2.
  ///
  /// In en, this message translates to:
  /// **'Rinse with running water'**
  String get q10_o2;

  /// No description provided for @q10_o3.
  ///
  /// In en, this message translates to:
  /// **'Close tightly'**
  String get q10_o3;

  /// No description provided for @q10_o4.
  ///
  /// In en, this message translates to:
  /// **'Use eye drops'**
  String get q10_o4;

  /// No description provided for @s1_msg.
  ///
  /// In en, this message translates to:
  /// **'The injured person is experiencing sudden fainting!'**
  String get s1_msg;

  /// No description provided for @legs_up.
  ///
  /// In en, this message translates to:
  /// **'Raise legs'**
  String get legs_up;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Splash water'**
  String get water;

  /// No description provided for @shake.
  ///
  /// In en, this message translates to:
  /// **'Shake violently'**
  String get shake;

  /// No description provided for @s2_msg.
  ///
  /// In en, this message translates to:
  /// **'A person has suffered severe heat stroke'**
  String get s2_msg;

  /// No description provided for @cool_place.
  ///
  /// In en, this message translates to:
  /// **'Cool place'**
  String get cool_place;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @s3_msg.
  ///
  /// In en, this message translates to:
  /// **'Severe bleeding in the hand due to a wound!'**
  String get s3_msg;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Direct pressure'**
  String get pressure;

  /// No description provided for @wash.
  ///
  /// In en, this message translates to:
  /// **'Wash with water'**
  String get wash;

  /// No description provided for @ointment.
  ///
  /// In en, this message translates to:
  /// **'Ointment'**
  String get ointment;

  /// No description provided for @s4_msg.
  ///
  /// In en, this message translates to:
  /// **'Minor burn caused by the oven'**
  String get s4_msg;

  /// No description provided for @ice.
  ///
  /// In en, this message translates to:
  /// **'Ice'**
  String get ice;

  /// No description provided for @tap_water.
  ///
  /// In en, this message translates to:
  /// **'Lukewarm water'**
  String get tap_water;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Toothpaste'**
  String get paste;

  /// No description provided for @s5_msg.
  ///
  /// In en, this message translates to:
  /// **'A person is choking and cannot breathe'**
  String get s5_msg;

  /// No description provided for @back_blows.
  ///
  /// In en, this message translates to:
  /// **'Back blows'**
  String get back_blows;

  /// No description provided for @give_water.
  ///
  /// In en, this message translates to:
  /// **'Give water'**
  String get give_water;

  /// No description provided for @lie_down.
  ///
  /// In en, this message translates to:
  /// **'Lay down'**
  String get lie_down;

  /// No description provided for @s6_msg.
  ///
  /// In en, this message translates to:
  /// **'Suspected leg fracture after a fall'**
  String get s6_msg;

  /// No description provided for @massage.
  ///
  /// In en, this message translates to:
  /// **'Massage'**
  String get massage;

  /// No description provided for @no_move.
  ///
  /// In en, this message translates to:
  /// **'Do not move'**
  String get no_move;

  /// No description provided for @pull.
  ///
  /// In en, this message translates to:
  /// **'Pull the leg'**
  String get pull;

  /// No description provided for @s7_msg.
  ///
  /// In en, this message translates to:
  /// **'Bee sting with the stinger still in the skin'**
  String get s7_msg;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Scrape with a card'**
  String get card;

  /// No description provided for @fingers.
  ///
  /// In en, this message translates to:
  /// **'Remove by hand'**
  String get fingers;

  /// No description provided for @rub.
  ///
  /// In en, this message translates to:
  /// **'Rub hard'**
  String get rub;

  /// No description provided for @s8_msg.
  ///
  /// In en, this message translates to:
  /// **'Sudden ankle sprain'**
  String get s8_msg;

  /// No description provided for @ice_pack.
  ///
  /// In en, this message translates to:
  /// **'Cold compress'**
  String get ice_pack;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// No description provided for @hot_water.
  ///
  /// In en, this message translates to:
  /// **'Hot water'**
  String get hot_water;

  /// No description provided for @s9_msg.
  ///
  /// In en, this message translates to:
  /// **'Sudden stop of breathing and pulse'**
  String get s9_msg;

  /// No description provided for @cpr.
  ///
  /// In en, this message translates to:
  /// **'CPR'**
  String get cpr;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No description provided for @cry.
  ///
  /// In en, this message translates to:
  /// **'Shout'**
  String get cry;

  /// No description provided for @s10_msg.
  ///
  /// In en, this message translates to:
  /// **'Cleaning chemical entered the eye'**
  String get s10_msg;

  /// No description provided for @rub_eye.
  ///
  /// In en, this message translates to:
  /// **'Rub the eye'**
  String get rub_eye;

  /// No description provided for @flush.
  ///
  /// In en, this message translates to:
  /// **'Continuous rinsing'**
  String get flush;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close the eye'**
  String get close;

  /// No description provided for @case1_title.
  ///
  /// In en, this message translates to:
  /// **'Wound Treatment'**
  String get case1_title;

  /// No description provided for @case1_step1.
  ///
  /// In en, this message translates to:
  /// **'Clean the wound'**
  String get case1_step1;

  /// No description provided for @case1_step2.
  ///
  /// In en, this message translates to:
  /// **'Apply antiseptic'**
  String get case1_step2;

  /// No description provided for @case1_step3.
  ///
  /// In en, this message translates to:
  /// **'Cover with bandage'**
  String get case1_step3;

  /// No description provided for @case2_title.
  ///
  /// In en, this message translates to:
  /// **'Burn Treatment'**
  String get case2_title;

  /// No description provided for @case2_step1.
  ///
  /// In en, this message translates to:
  /// **'Lukewarm water'**
  String get case2_step1;

  /// No description provided for @case2_step2.
  ///
  /// In en, this message translates to:
  /// **'Light covering'**
  String get case2_step2;

  /// No description provided for @case2_step3.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get case2_step3;

  /// No description provided for @case3_title.
  ///
  /// In en, this message translates to:
  /// **'Nosebleed'**
  String get case3_title;

  /// No description provided for @case3_step1.
  ///
  /// In en, this message translates to:
  /// **'Lean forward'**
  String get case3_step1;

  /// No description provided for @case3_step2.
  ///
  /// In en, this message translates to:
  /// **'Press the nose'**
  String get case3_step2;

  /// No description provided for @case3_step3.
  ///
  /// In en, this message translates to:
  /// **'Apply cold compress'**
  String get case3_step3;

  /// No description provided for @case4_title.
  ///
  /// In en, this message translates to:
  /// **'Fainting'**
  String get case4_title;

  /// No description provided for @case4_step1.
  ///
  /// In en, this message translates to:
  /// **'Check breathing'**
  String get case4_step1;

  /// No description provided for @case4_step2.
  ///
  /// In en, this message translates to:
  /// **'Raise legs'**
  String get case4_step2;

  /// No description provided for @case4_step3.
  ///
  /// In en, this message translates to:
  /// **'Loosen tight clothes'**
  String get case4_step3;

  /// No description provided for @case5_title.
  ///
  /// In en, this message translates to:
  /// **'Choking'**
  String get case5_title;

  /// No description provided for @case5_step1.
  ///
  /// In en, this message translates to:
  /// **'Encourage coughing'**
  String get case5_step1;

  /// No description provided for @case5_step2.
  ///
  /// In en, this message translates to:
  /// **'5 back blows'**
  String get case5_step2;

  /// No description provided for @case5_step3.
  ///
  /// In en, this message translates to:
  /// **'5 abdominal thrusts'**
  String get case5_step3;

  /// No description provided for @case6_title.
  ///
  /// In en, this message translates to:
  /// **'Ankle Sprain'**
  String get case6_title;

  /// No description provided for @case6_step1.
  ///
  /// In en, this message translates to:
  /// **'Rest completely'**
  String get case6_step1;

  /// No description provided for @case6_step2.
  ///
  /// In en, this message translates to:
  /// **'Apply ice'**
  String get case6_step2;

  /// No description provided for @case6_step3.
  ///
  /// In en, this message translates to:
  /// **'Compression bandage'**
  String get case6_step3;

  /// No description provided for @case7_title.
  ///
  /// In en, this message translates to:
  /// **'Heat Stroke'**
  String get case7_title;

  /// No description provided for @case7_step1.
  ///
  /// In en, this message translates to:
  /// **'Move to shade'**
  String get case7_step1;

  /// No description provided for @case7_step2.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get case7_step2;

  /// No description provided for @case7_step3.
  ///
  /// In en, this message translates to:
  /// **'Cool the body'**
  String get case7_step3;

  /// No description provided for @case8_title.
  ///
  /// In en, this message translates to:
  /// **'Hand Fracture'**
  String get case8_title;

  /// No description provided for @case8_step1.
  ///
  /// In en, this message translates to:
  /// **'Do not move'**
  String get case8_step1;

  /// No description provided for @case8_step2.
  ///
  /// In en, this message translates to:
  /// **'Make a sling'**
  String get case8_step2;

  /// No description provided for @case8_step3.
  ///
  /// In en, this message translates to:
  /// **'Call ambulance 997'**
  String get case8_step3;

  /// No description provided for @case9_title.
  ///
  /// In en, this message translates to:
  /// **'Insect Sting'**
  String get case9_title;

  /// No description provided for @case9_step1.
  ///
  /// In en, this message translates to:
  /// **'Remove stinger with card'**
  String get case9_step1;

  /// No description provided for @case9_step2.
  ///
  /// In en, this message translates to:
  /// **'Wash with soap and water'**
  String get case9_step2;

  /// No description provided for @case9_step3.
  ///
  /// In en, this message translates to:
  /// **'Apply cold compress'**
  String get case9_step3;

  /// No description provided for @case10_title.
  ///
  /// In en, this message translates to:
  /// **'Substance in Eye'**
  String get case10_title;

  /// No description provided for @case10_step1.
  ///
  /// In en, this message translates to:
  /// **'Rinse with running water'**
  String get case10_step1;

  /// No description provided for @case10_step2.
  ///
  /// In en, this message translates to:
  /// **'Cover with cotton'**
  String get case10_step2;

  /// No description provided for @case10_step3.
  ///
  /// In en, this message translates to:
  /// **'Visit doctor immediately'**
  String get case10_step3;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again, this is not the ideal solution!'**
  String get tryAgain;

  /// No description provided for @tryAgain1.
  ///
  /// In en, this message translates to:
  /// **'The order is incorrect, try again!'**
  String get tryAgain1;

  /// No description provided for @drag_tool_msg.
  ///
  /// In en, this message translates to:
  /// **'Drag the correct tool to the patient'**
  String get drag_tool_msg;

  /// No description provided for @dragSteps.
  ///
  /// In en, this message translates to:
  /// **'Drag the steps to arrange them correctly from top to bottom.'**
  String get dragSteps;

  /// No description provided for @success_msg.
  ///
  /// In en, this message translates to:
  /// **'First aid completed successfully!'**
  String get success_msg;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @completedScenarios.
  ///
  /// In en, this message translates to:
  /// **'You have successfully completed all emergency scenarios.'**
  String get completedScenarios;

  /// No description provided for @completePuzzle.
  ///
  /// In en, this message translates to:
  /// **'You have successfully completed all stages of the arrangement and acquired basic first aid skills.'**
  String get completePuzzle;

  /// No description provided for @wellDone.
  ///
  /// In en, this message translates to:
  /// **'Well done! 🎉'**
  String get wellDone;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back to the Games'**
  String get back;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done. Close the Game.'**
  String get done;

  /// No description provided for @scenario.
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get scenario;

  /// No description provided for @arrange.
  ///
  /// In en, this message translates to:
  /// **'Arrange the steps:'**
  String get arrange;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check the correct order'**
  String get check;

  /// No description provided for @q.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get q;

  /// No description provided for @quizEnd.
  ///
  /// In en, this message translates to:
  /// **'Quiz finished! Your score:'**
  String get quizEnd;

  /// No description provided for @fracture.
  ///
  /// In en, this message translates to:
  /// **'Fracture'**
  String get fracture;

  /// No description provided for @nosebleed.
  ///
  /// In en, this message translates to:
  /// **'Nosebleed'**
  String get nosebleed;

  /// No description provided for @lowBloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Low Blood Sugar'**
  String get lowBloodSugar;

  /// No description provided for @heatStroke.
  ///
  /// In en, this message translates to:
  /// **'Heat Stroke'**
  String get heatStroke;

  /// No description provided for @choking.
  ///
  /// In en, this message translates to:
  /// **'Choking'**
  String get choking;

  /// No description provided for @burn.
  ///
  /// In en, this message translates to:
  /// **'Burn'**
  String get burn;

  /// No description provided for @wound.
  ///
  /// In en, this message translates to:
  /// **'Wound'**
  String get wound;

  /// No description provided for @firstAidLessons.
  ///
  /// In en, this message translates to:
  /// **'First Aid Lessons'**
  String get firstAidLessons;

  /// No description provided for @lessonCICU.
  ///
  /// In en, this message translates to:
  /// **'Lesson content is currently unavailable'**
  String get lessonCICU;

  /// No description provided for @sorryVideoCU.
  ///
  /// In en, this message translates to:
  /// **'Sorry, this video is currently unavailable.'**
  String get sorryVideoCU;

  /// No description provided for @failedVideoFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video file'**
  String get failedVideoFile;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose the language to enable the explanation'**
  String get choose;

  /// No description provided for @educationalVideo.
  ///
  /// In en, this message translates to:
  /// **'Educational video'**
  String get educationalVideo;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
