import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

import './otp_input.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  OTPScreen({
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black, hintText: '******');

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("isValid - $isCodeSent");
    print("mobiel ${widget.mobileNumber}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Welcome to Agrovators",
                        style: TextStyle(
                            color: Color(0xff0b4f6c),
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Your one step solution",
                          style:
                              TextStyle(color: Color(0xff0b4f6c), fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(100)),
                        //color: Color(0xffcbf5ff)
                        color: Colors.blue.withOpacity(0.10)),
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 70, bottom: 15),
                          child: Text(
                            "Verification Code",
                            style: TextStyle(
                                color: Color(0xff0b4f6c),
                                fontSize: 26,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please enter the verification code sent to " +
                                  widget.mobileNumber,
                              style: TextStyle(
                                  color: Color(0xff0b4f6c),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PinInputTextField(
                            pinLength: 6,
                            decoration: _pinDecoration,
                            controller: _pinEditingController,
                            autoFocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmit: (pin) {
                              if (pin.length == 6) {
                                _onFormSubmitted();
                              } else {
                                showToast("Invalid OTP", Colors.purple);
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isCodeSent = false;
                            });
                            _onVerifyCode();
                          },
                          child: Text("Resend OTP"),
                        ),
                        InkWell(
                          onTap: () {
                            if (_pinEditingController.text.length == 6) {
                              _onFormSubmitted();
                            } else {
                              showToast("Invalid OTP", Colors.purple);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: Center(
                                child: Text(
                              "VERIFY",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xfffbfffe)),
                            )),
                            decoration: BoxDecoration(
                                color: Color(0xff6f42c1),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        // timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    print("on verify code function executed");
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          checkUserAndNavigate(value);
        } else {
          showToast("Error validating OTP, try again", Colors.purple);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.purple);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.purple);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: widget.mobileNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);
    print("on form submitted function executed");
    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        // Handle loogged in state
        print(value.user.phoneNumber);
        print(value.user.uid);
        print(value.user.uid);
        print(value.user.uid);
        checkUserAndNavigate(value);
      } else {
        showToast("Error validating OTP, try again", Colors.purple);
      }
    }).catchError((error) {
      showToast("Invalid OTP", Colors.purple);
    });
  }

  checkUserAndNavigate(AuthResult user) async {
    print("checkusernaviagte executed");
    print("Otp Verified");

    //login page
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomeScreen()),
    //     (Route<dynamic> route) => false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("otp", true);
    print(prefs.getBool("otp"));
  }
}
