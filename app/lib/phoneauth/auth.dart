import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../phoneauth/otp_screen.dart';

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => new _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  void initState() {
    super.initState();
  }

  bool isvalid;
  String phnnum;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
// resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(height: 150,),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Agrovators",
                                  style: TextStyle(
                                      color: Color(0xff0b4f6c),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "Your one step solution",
                                  style: TextStyle(
                                      color: Color(0xff0b4f6c),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // PhoneLogin()
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: SingleChildScrollView(
                          child: InternationalPhoneNumberInput(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);

                              phnnum = number.phoneNumber;
                            },
                            onInputValidated: (bool value) {
                              print(value);
                              isvalid = value;
                            },
                            ignoreBlank: false,
                            autoValidate: false,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: controller,
                            inputBorder: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        print('login pressed');
                        print(phnnum);
                        if (isvalid) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("phn", phnnum);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  mobileNumber: phnnum,
                                ),
                              ));
                        } else {
                          print("Invalid number");
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                        child: Text(
                                      "Please Enter Proper Phone Number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Center(
                            child: Text(
                          "VERIFY",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: Color(0xff6f42c1),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
