import 'package:firebase_auth/firebase_auth.dart';
import '../../models/app_user/app_user.dart';
import '../../widgets/custom_widgets/custom_toast.dart';
import 'user_api.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get getCurrentUser => _auth.currentUser;
  static String get uid => _auth.currentUser?.uid ?? '';
  // 'hDS8mbQbD8Sm6LAAYaiN59KPx5o1';
  static String get phoneNumber => _auth.currentUser?.phoneNumber ?? '';
  // '+923000000000';

  Future<int> verifyOTP(String verificationId, String otp) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final UserCredential authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        final AppUser? appUser =
            await UserApi().user(uid: authCredential.user!.uid);
        if (appUser == null) return 0; // User is New on App
        return 1; // User Already Exist NO new info needed
      }
      return -1; // ERROR while Entering OTP
    } catch (ex) {
      CustomToast.errorToast(message: ex.toString());
      return -1;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
