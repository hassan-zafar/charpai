import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/phone_number.dart';
import '../database/app_user/auth_method.dart';
import '../database/app_user/user_api.dart';
import '../database/databse_storage.dart';
import '../function/time_date_function.dart';
import '../models/app_user/app_user.dart';
import '../models/app_user/numbers_detail.dart';
import '../screens/auth/phone_registration/phone_number_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../utilities/image_picker.dart';
import '../widgets/custom_widgets/custom_toast.dart';

class AuthProvider extends ChangeNotifier {
  //
  // REGISTER FUNCTIONS
  //
  Future<void> onRegister(BuildContext context) async {
    if (_phoneNumber == null || AuthMethods.getCurrentUser == null) {
      CustomToast.errorToast(message: 'Enter Phone Number again');
      Navigator.push(
        context,
        // ignore: always_specify_types
        MaterialPageRoute(
          builder: (BuildContext context) => const PhoneNumberScreen(),
        ),
      );
    } 
    else
     if (_registerKey.currentState!.validate()) {
      String? url = '';
      _isRegsiterScreenLoading = true;
      notifyListeners();
      if (_profilePhoto != null) {
        //url = await UserApi().uploadProfilePhoto(file: _profilePhoto!);
        url = await Storagemethod().uploadtostorage(
          'users',
          AuthMethods.uid,
          _profilePhoto!,
        );
      }
      final AppUser appuser = AppUser(
        uid: AuthMethods.uid,
        name: _name.text.trim(),
        imageURL: url,
        usertype: _userType,
        phoneNumber: NumberDetails(
          countryCode: _phoneNumber!.countryCode,
          number: _phoneNumber!.number,
          completeNumber: _phoneNumber!.completeNumber,
          isoCode: _phoneNumber!.countryISOCode,
          timestamp: TimeStamp.timestamp,
        ),
      );

      final bool added = await UserApi().register(user: appuser);
      _isRegsiterScreenLoading = false;
      notifyListeners();
      if (added) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          // ignore: always_specify_types
          MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(),
          ),
        );
        //push to main Screen
        // ignore: use_build_context_synchronously

      }
    }
  }

  void pickProfilePhoto() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im == null) return;
    _profilePhoto = im;
    notifyListeners();
  }

  onvisibilityUpdate(bool value) {
    _isPublicProfile = value;
    notifyListeners();
  }

  onUpdateRegisterLoading(bool value) {
    _isRegsiterScreenLoading = value;
    notifyListeners();
  }

  //
  // OTP FUNCTIONS
  //
  onPhoneNumberChange(PhoneNumber? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  Future<void> verifyPhone(BuildContext context) async {
    if (_phoneNumber == null) return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumber!.completeNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // _smsOTP = phoneAuthCredential.smsCode;
        _verificationId = phoneAuthCredential.verificationId;
      },
      verificationFailed: (FirebaseAuthException verificationFailed) async {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
      },
      codeSent: (String verificationId, int? resendingToken) async {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    notifyListeners();
  }

  Future<int> varifyOTP(String otp) async {
    if (_verificationId == null) return 0;
    final int num = await AuthMethods().verifyOTP(_verificationId!, otp);
    return num;
  }

  //GetUser
  void getUser() async {
    _apUser = await UserApi().user(uid: AuthMethods.uid);
    notifyListeners();
  }

  String _userType = '';
  void userType(String value) {
    _userType = value;
    notifyListeners();
  }

  //
  // VARIABLES
  AppUser? _apUser;
  AppUser get apUser => _apUser!;
  PhoneNumber? _phoneNumber;
  String? _verificationId;
  // String? _smsOTP;
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  bool _isPublicProfile = true;
  bool _isRegsiterScreenLoading = false;
  Uint8List? _profilePhoto;

  TextEditingController get name => _name;
  TextEditingController get username => _username;
  TextEditingController get bio => _bio;

  GlobalKey<FormState> get registerKey => _registerKey;

  PhoneNumber? get phoneNumber => _phoneNumber;

  bool get isPublicProfile => _isPublicProfile;
  bool get isRegsiterScreenLoadingn => _isRegsiterScreenLoading;

  Uint8List? get profilePhoto => _profilePhoto;
}
