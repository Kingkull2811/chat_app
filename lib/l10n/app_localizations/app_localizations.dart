import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'app_localizations/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @successfully.
  ///
  /// In en, this message translates to:
  /// **'Successfully!'**
  String get successfully;

  /// No description provided for @internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get internal_server_error;

  /// No description provided for @photo_camera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo from camera'**
  String get photo_camera;

  /// No description provided for @photo_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo from gallery'**
  String get photo_gallery;

  /// No description provided for @select_student.
  ///
  /// In en, this message translates to:
  /// **'Select Student'**
  String get select_student;

  /// No description provided for @student_id.
  ///
  /// In en, this message translates to:
  /// **'Student Id:'**
  String get student_id;

  /// No description provided for @student_name.
  ///
  /// In en, this message translates to:
  /// **'Student Name:'**
  String get student_name;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth:'**
  String get dob;

  /// No description provided for @classTitle.
  ///
  /// In en, this message translates to:
  /// **'Class:'**
  String get classTitle;

  /// No description provided for @view_list_added.
  ///
  /// In en, this message translates to:
  /// **'View the list of students added'**
  String get view_list_added;

  /// No description provided for @no_find_student.
  ///
  /// In en, this message translates to:
  /// **'Can\\\'t find student with student SSID:'**
  String get no_find_student;

  /// No description provided for @search_ssid.
  ///
  /// In en, this message translates to:
  /// **'Search with SSID'**
  String get search_ssid;

  /// No description provided for @search_w_ssid.
  ///
  /// In en, this message translates to:
  /// **'Search student with student SSID'**
  String get search_w_ssid;

  /// No description provided for @no_internet_title.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet_title;

  /// No description provided for @no_internet_content.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection again or connect to Wi-fi'**
  String get no_internet_content;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Student\\\'s Parent'**
  String get parent;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get enter_username;

  /// No description provided for @fullname.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullname;

  /// No description provided for @enter_fullname.
  ///
  /// In en, this message translates to:
  /// **'Please enter full name'**
  String get enter_fullname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get enter_email;

  /// No description provided for @valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get valid_email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get enter_phone;

  /// No description provided for @empty_avatar.
  ///
  /// In en, this message translates to:
  /// **'Image avatar cannot be empty'**
  String get empty_avatar;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPassword;

  /// No description provided for @enterEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email. We will send a code to your email to reset your password.'**
  String get enterEmailToReset;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send me Code'**
  String get sendCode;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enterPassword;

  /// No description provided for @passwordLeast.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLeast;

  /// No description provided for @passwordLess.
  ///
  /// In en, this message translates to:
  /// **'Password must be less than 40 characters'**
  String get passwordLess;

  /// No description provided for @noUserInfor.
  ///
  /// In en, this message translates to:
  /// **'Can\\\'t get user info'**
  String get noUserInfor;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong, please try again later!'**
  String get wrong;

  /// No description provided for @wrongU.
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password'**
  String get wrongU;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\\\'t have an account? '**
  String get noAccount;

  /// No description provided for @remember.
  ///
  /// In en, this message translates to:
  /// **'Remember password'**
  String get remember;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get setNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPass;

  /// No description provided for @enterConfirmPass.
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm new password'**
  String get enterConfirmPass;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New password and confirm new password do not match'**
  String get passwordNotMatch;

  /// No description provided for @setPassword.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get setPassword;

  /// No description provided for @confirmPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPass;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter old password'**
  String get enterOldPassword;

  /// No description provided for @enterConPass.
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm password'**
  String get enterConPass;

  /// No description provided for @passwordMatch.
  ///
  /// In en, this message translates to:
  /// **'Password and confirm password do not match'**
  String get passwordMatch;

  /// No description provided for @isTeacher.
  ///
  /// In en, this message translates to:
  /// **'You are teacher?'**
  String get isTeacher;

  /// No description provided for @plsLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login!'**
  String get plsLogin;

  /// No description provided for @alreadyAcc.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyAcc;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otp;

  /// No description provided for @willSend.
  ///
  /// In en, this message translates to:
  /// **'We will send you an onetime OTP code on the email:'**
  String get willSend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified!'**
  String get verified;

  /// No description provided for @accVerified.
  ///
  /// In en, this message translates to:
  /// **'You have verified your account.'**
  String get accVerified;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\\\'t you receive the OTP code? '**
  String get resendOtp;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @incomeCall.
  ///
  /// In en, this message translates to:
  /// **'Incoming call'**
  String get incomeCall;

  /// No description provided for @inProcessCall.
  ///
  /// In en, this message translates to:
  /// **'Call in progress'**
  String get inProcessCall;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Reminder me'**
  String get remindMe;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @slideTalk.
  ///
  /// In en, this message translates to:
  /// **'Slide to Talk'**
  String get slideTalk;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want block'**
  String get blockContent;

  /// No description provided for @blockContent2.
  ///
  /// In en, this message translates to:
  /// **'\\nAfter block, you can send message to'**
  String get blockContent2;

  /// No description provided for @blockContent3.
  ///
  /// In en, this message translates to:
  /// **'and vice versa.'**
  String get blockContent3;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get deleteChat;

  /// No description provided for @deleteContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this chat? Once deleted, you cannot restore this chat.'**
  String get deleteContent;

  /// No description provided for @deleteContent2.
  ///
  /// In en, this message translates to:
  /// **'\\nAt the same time, this conversation will also be deleted for the remaining person in this chat.'**
  String get deleteContent2;

  /// No description provided for @sayHi.
  ///
  /// In en, this message translates to:
  /// **'Say hi 👋 to start chat with '**
  String get sayHi;

  /// No description provided for @noRecent.
  ///
  /// In en, this message translates to:
  /// **'No Recents'**
  String get noRecent;

  /// No description provided for @noContact.
  ///
  /// In en, this message translates to:
  /// **'No contact'**
  String get noContact;

  /// No description provided for @createMessage.
  ///
  /// In en, this message translates to:
  /// **'Create new message'**
  String get createMessage;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get name;

  /// No description provided for @tel.
  ///
  /// In en, this message translates to:
  /// **'Phone: '**
  String get tel;

  /// No description provided for @parentOf.
  ///
  /// In en, this message translates to:
  /// **'Parent of:'**
  String get parentOf;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @pressExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit.'**
  String get pressExit;

  /// No description provided for @addNews.
  ///
  /// In en, this message translates to:
  /// **'Add News'**
  String get addNews;

  /// No description provided for @editNews.
  ///
  /// In en, this message translates to:
  /// **'Edit News'**
  String get editNews;

  /// No description provided for @postNews.
  ///
  /// In en, this message translates to:
  /// **'Post News'**
  String get postNews;

  /// No description provided for @backNews.
  ///
  /// In en, this message translates to:
  /// **'Go to news page'**
  String get backNews;

  /// No description provided for @writeTitle.
  ///
  /// In en, this message translates to:
  /// **'Write the title ...'**
  String get writeTitle;

  /// No description provided for @writeContent.
  ///
  /// In en, this message translates to:
  /// **'Write the content ...'**
  String get writeContent;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add an image or video'**
  String get addImage;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @noNews.
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get noNews;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **' show more'**
  String get more;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'\\nshow less'**
  String get less;

  /// No description provided for @deleteNews.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this news?'**
  String get deleteNews;

  /// No description provided for @notFindNews.
  ///
  /// In en, this message translates to:
  /// **'Did not find the news'**
  String get notFindNews;

  /// No description provided for @deletedNews.
  ///
  /// In en, this message translates to:
  /// **'The news has been deleted'**
  String get deletedNews;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Learning Results Tracking'**
  String get onboardingTitle1;

  /// No description provided for @onboardingContent1.
  ///
  /// In en, this message translates to:
  /// **'Our app allows teachers to easily record and track student\\\'s learning outcomes.'**
  String get onboardingContent1;

  /// No description provided for @onboardingContent11.
  ///
  /// In en, this message translates to:
  /// **' Teachers can assess individual progress, identify areas of improvement, and tailor their teaching strategies accordingly. With comprehensive analytics and visualizations, educators can gain valuable insights into student performance.'**
  String get onboardingContent11;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Information Exchange'**
  String get onboardingTitle2;

  /// No description provided for @onboardingContent2.
  ///
  /// In en, this message translates to:
  /// **'We understand the importance of effective communication between teachers and parents. Our app facilitates seamless information exchange, enabling teachers to share important updates, homework assignments, and upcoming assessments directly with parents.'**
  String get onboardingContent2;

  /// No description provided for @onboardingContent22.
  ///
  /// In en, this message translates to:
  /// **' Parents can stay informed about their child\\\'s academic progress and provide necessary support.'**
  String get onboardingContent22;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Real-time Notifications'**
  String get onboardingTitle3;

  /// No description provided for @onboardingContent3.
  ///
  /// In en, this message translates to:
  /// **'Stay up-to-date with real-time notifications. Receive instant alerts regarding important deadlines, upcoming events, and announcements from the school.'**
  String get onboardingContent3;

  /// No description provided for @onboardingContent33.
  ///
  /// In en, this message translates to:
  /// **' Be notified when a teacher sends a message or when a new grade is added, ensuring that you never miss crucial information.'**
  String get onboardingContent33;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @notiSound.
  ///
  /// In en, this message translates to:
  /// **'Notification & Sound'**
  String get notiSound;

  /// No description provided for @notiOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on the notification'**
  String get notiOn;

  /// No description provided for @notiOnLock.
  ///
  /// In en, this message translates to:
  /// **'Notifications on lock screen'**
  String get notiOnLock;

  /// No description provided for @notiPreviewOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on the notification preview'**
  String get notiPreviewOn;

  /// No description provided for @vibrateCall.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when a call coming'**
  String get vibrateCall;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @incomeCallSound.
  ///
  /// In en, this message translates to:
  /// **'Incoming message sound'**
  String get incomeCallSound;

  /// No description provided for @waitingCallSound.
  ///
  /// In en, this message translates to:
  /// **'Incoming call waiting sound'**
  String get waitingCallSound;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'This user data could not be found'**
  String get userNotFound;

  /// No description provided for @noStudent.
  ///
  /// In en, this message translates to:
  /// **'There is no data on students who are children of this parent'**
  String get noStudent;

  /// No description provided for @dOB.
  ///
  /// In en, this message translates to:
  /// **'D.O.B:'**
  String get dOB;

  /// No description provided for @schoolY.
  ///
  /// In en, this message translates to:
  /// **'School Year'**
  String get schoolY;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Policies'**
  String get terms;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @wantLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out ?'**
  String get wantLogout;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'Agree. I have read and understood'**
  String get agreeTerms;

  /// No description provided for @editClass.
  ///
  /// In en, this message translates to:
  /// **'Edit class'**
  String get editClass;

  /// No description provided for @addClass.
  ///
  /// In en, this message translates to:
  /// **'Add new class'**
  String get addClass;

  /// No description provided for @classCode.
  ///
  /// In en, this message translates to:
  /// **'Class Code'**
  String get classCode;

  /// No description provided for @className.
  ///
  /// In en, this message translates to:
  /// **'Class Name'**
  String get className;

  /// No description provided for @enterClass.
  ///
  /// In en, this message translates to:
  /// **'Please enter class name'**
  String get enterClass;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @plsYear.
  ///
  /// In en, this message translates to:
  /// **'Please select school year'**
  String get plsYear;

  /// No description provided for @enterClassCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter class code'**
  String get enterClassCode;

  /// No description provided for @enterSubject.
  ///
  /// In en, this message translates to:
  /// **'Please select the subject for class'**
  String get enterSubject;

  /// No description provided for @noClass.
  ///
  /// In en, this message translates to:
  /// **'Class not found'**
  String get noClass;

  /// No description provided for @failClass.
  ///
  /// In en, this message translates to:
  /// **'Update class failure'**
  String get failClass;

  /// No description provided for @addFailClass.
  ///
  /// In en, this message translates to:
  /// **'Add new class failure'**
  String get addFailClass;

  /// No description provided for @selectSubject.
  ///
  /// In en, this message translates to:
  /// **'Select the subject for class'**
  String get selectSubject;

  /// No description provided for @noSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject data not found'**
  String get noSubject;

  /// No description provided for @selectSY.
  ///
  /// In en, this message translates to:
  /// **'Select School Year'**
  String get selectSY;

  /// No description provided for @noSemester.
  ///
  /// In en, this message translates to:
  /// **'List semester not found'**
  String get noSemester;

  /// No description provided for @listClass.
  ///
  /// In en, this message translates to:
  /// **'List Class:'**
  String get listClass;

  /// No description provided for @deleteClass.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this class?'**
  String get deleteClass;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year:'**
  String get year;

  /// No description provided for @serial.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get serial;

  /// No description provided for @subCode.
  ///
  /// In en, this message translates to:
  /// **'Subject code'**
  String get subCode;

  /// No description provided for @subName.
  ///
  /// In en, this message translates to:
  /// **'Subject name'**
  String get subName;

  /// No description provided for @classManage.
  ///
  /// In en, this message translates to:
  /// **'Class Management'**
  String get classManage;

  /// No description provided for @addStu.
  ///
  /// In en, this message translates to:
  /// **'Add a new student'**
  String get addStu;

  /// No description provided for @editStu.
  ///
  /// In en, this message translates to:
  /// **'Edit student info'**
  String get editStu;

  /// No description provided for @enterSSID.
  ///
  /// In en, this message translates to:
  /// **'Please enter SSID like SSID**** with * is the number'**
  String get enterSSID;

  /// No description provided for @noEmptySSID.
  ///
  /// In en, this message translates to:
  /// **'SSID can\\\'t be empty'**
  String get noEmptySSID;

  /// No description provided for @stuSSID.
  ///
  /// In en, this message translates to:
  /// **'Student SSID'**
  String get stuSSID;

  /// No description provided for @stuName.
  ///
  /// In en, this message translates to:
  /// **'Student name'**
  String get stuName;

  /// No description provided for @enterStuName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the student\\\'s name'**
  String get enterStuName;

  /// No description provided for @enterDOB.
  ///
  /// In en, this message translates to:
  /// **'Please enter date of birth'**
  String get enterDOB;

  /// No description provided for @selectClass.
  ///
  /// In en, this message translates to:
  /// **'Please select class'**
  String get selectClass;

  /// No description provided for @selectScY.
  ///
  /// In en, this message translates to:
  /// **'Please select school year'**
  String get selectScY;

  /// No description provided for @stuImage.
  ///
  /// In en, this message translates to:
  /// **'Student Image'**
  String get stuImage;

  /// No description provided for @searchStu.
  ///
  /// In en, this message translates to:
  /// **'Select student ...'**
  String get searchStu;

  /// No description provided for @deleteStu.
  ///
  /// In en, this message translates to:
  /// **'Do you want delete this student\'s information?'**
  String get deleteStu;

  /// No description provided for @noStu.
  ///
  /// In en, this message translates to:
  /// **'Student\'s information not found'**
  String get noStu;

  /// No description provided for @addStuImage.
  ///
  /// In en, this message translates to:
  /// **'Add a student image'**
  String get addStuImage;

  /// No description provided for @addImageStu.
  ///
  /// In en, this message translates to:
  /// **'Please add student image'**
  String get addImageStu;

  /// No description provided for @addStuFail.
  ///
  /// In en, this message translates to:
  /// **'Add new student\'s information failure'**
  String get addStuFail;

  /// No description provided for @updateStuSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update student\'s information success'**
  String get updateStuSuccess;

  /// No description provided for @updateStuFail.
  ///
  /// In en, this message translates to:
  /// **'Update student\'s information failure'**
  String get updateStuFail;

  /// No description provided for @stuManage.
  ///
  /// In en, this message translates to:
  /// **'Students Management'**
  String get stuManage;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'List student:'**
  String get students;

  /// No description provided for @selClass.
  ///
  /// In en, this message translates to:
  /// **'Select Class'**
  String get selClass;

  /// No description provided for @subManage.
  ///
  /// In en, this message translates to:
  /// **'Subjects Management'**
  String get subManage;

  /// No description provided for @subjects.
  ///
  /// In en, this message translates to:
  /// **'List Subject:'**
  String get subjects;

  /// No description provided for @deleteSub.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this subject?'**
  String get deleteSub;

  /// No description provided for @addSub.
  ///
  /// In en, this message translates to:
  /// **'Add new subject'**
  String get addSub;

  /// No description provided for @editSub.
  ///
  /// In en, this message translates to:
  /// **'Edit subject'**
  String get editSub;

  /// No description provided for @emptySubCode.
  ///
  /// In en, this message translates to:
  /// **'Subject Code can\\\'t be empty'**
  String get emptySubCode;

  /// No description provided for @emptySubName.
  ///
  /// In en, this message translates to:
  /// **'Subject Name can\\\'t be empty'**
  String get emptySubName;

  /// No description provided for @addSubFail.
  ///
  /// In en, this message translates to:
  /// **'Add new subject failure!'**
  String get addSubFail;

  /// No description provided for @updateSubSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update subject successfully!'**
  String get updateSubSuccess;

  /// No description provided for @updateSubFail.
  ///
  /// In en, this message translates to:
  /// **'Update subject failure!'**
  String get updateSubFail;

  /// No description provided for @semester.
  ///
  /// In en, this message translates to:
  /// **'Semester'**
  String get semester;

  /// No description provided for @enterPoint.
  ///
  /// In en, this message translates to:
  /// **'Enter point'**
  String get enterPoint;

  /// No description provided for @point4Stu.
  ///
  /// In en, this message translates to:
  /// **'Enter point subject for student:'**
  String get point4Stu;

  /// No description provided for @selectSemester.
  ///
  /// In en, this message translates to:
  /// **'Select Semester'**
  String get selectSemester;

  /// No description provided for @updateTranscriptDone.
  ///
  /// In en, this message translates to:
  /// **'Update transcript done'**
  String get updateTranscriptDone;

  /// No description provided for @noChange.
  ///
  /// In en, this message translates to:
  /// **'No change in the transcript yet.'**
  String get noChange;

  /// No description provided for @plsSelectSemester.
  ///
  /// In en, this message translates to:
  /// **'Please select semester to show list subject point.'**
  String get plsSelectSemester;

  /// No description provided for @changeOral.
  ///
  /// In en, this message translates to:
  /// **'Change Oral Test Point'**
  String get changeOral;

  /// No description provided for @change15.
  ///
  /// In en, this message translates to:
  /// **'Change 15 Minutes Test Point'**
  String get change15;

  /// No description provided for @change45.
  ///
  /// In en, this message translates to:
  /// **'Change 45 Minutes Test Point'**
  String get change45;

  /// No description provided for @changeFinal.
  ///
  /// In en, this message translates to:
  /// **'Change Final Exam Test Point'**
  String get changeFinal;

  /// No description provided for @saveChange.
  ///
  /// In en, this message translates to:
  /// **'Save change?'**
  String get saveChange;

  /// No description provided for @saveChangeContent.
  ///
  /// In en, this message translates to:
  /// **'The transcript has been changed, do you want to save this changes?'**
  String get saveChangeContent;

  /// No description provided for @transcriptManage.
  ///
  /// In en, this message translates to:
  /// **'Transcript Management'**
  String get transcriptManage;

  /// No description provided for @oneGPA.
  ///
  /// In en, this message translates to:
  /// **'Semester 1 GPA:'**
  String get oneGPA;

  /// No description provided for @twoGPA.
  ///
  /// In en, this message translates to:
  /// **'Semester 2 GPA:'**
  String get twoGPA;

  /// No description provided for @yGPA.
  ///
  /// In en, this message translates to:
  /// **'School year GPA:'**
  String get yGPA;

  /// No description provided for @subjectName.
  ///
  /// In en, this message translates to:
  /// **'Subject Name'**
  String get subjectName;

  /// No description provided for @tOral.
  ///
  /// In en, this message translates to:
  /// **'Oral test'**
  String get tOral;

  /// No description provided for @t15.
  ///
  /// In en, this message translates to:
  /// **'15m Test'**
  String get t15;

  /// No description provided for @t45.
  ///
  /// In en, this message translates to:
  /// **'45m Test'**
  String get t45;

  /// No description provided for @tFinal.
  ///
  /// In en, this message translates to:
  /// **'Final Test'**
  String get tFinal;

  /// No description provided for @sGPA.
  ///
  /// In en, this message translates to:
  /// **'Semester GPA'**
  String get sGPA;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
