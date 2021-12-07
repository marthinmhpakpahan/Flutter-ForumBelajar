// @dart=2.9
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/responses/users/login.dart';
import 'package:forumbelajar/services/user_services.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/users/register.dart';

ProgressDialog progressDialog;

class Login extends StatefulWidget {

  Login({Key key}) : super(key: key);

  @override
  LoginState createState() => LoginState();

}

class LoginState extends State<Login> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = UserServices();

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  // This is for text onChange
  TextEditingController usernameController;
  TextEditingController passwordController;

  showErrorDialog(String message) {
    StylishDialog(
        context: context,
        alertType: StylishDialogType.ERROR,
        titleText: 'Error',
        contentText: message,
        dismissOnTouchOutside: true,
        confirmText: 'Close',
        confirmPressEvent: () {
          Navigator.of(context).pop();
        },
      ).show();
  }

  void login(String username, String password) async {
    await progressDialog.show();
    LoginResponse response = await api.login(username, password);
    if(response.error == false) {
      Session.setLoginStatus(true);
      Session.setLoginUserId(response.data.id);
      Session.setLoginUsername(response.data.username);
      Session.setLoginFullName(response.data.full_name);
      Session.setSelectedProfileId(response.data.id);
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicIndex()));
    } else {
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
      showErrorDialog(response.message);
    }
  }

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  _buttonLogin() {
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              String username = usernameController.text, password = passwordController.text;
              if(username.trim() == "") {
                showErrorDialog("Username tidak boleh kosong!");
                return;
              }
              if(password.trim() == "") {
                showErrorDialog("Password tidak boleh kosong!");
                return;
              }
              login(username, password);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Login',
                style: heading5.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _linkRegister() {
    return GestureDetector(
      child: Text(
        "Belum punya akun? Daftar Sekarang!", 
        style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );

    progressDialog.style(
      message: 'Silahkan tunggu...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login to your\naccount',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: togglePassword,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              _buttonLogin(),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Register()));
                    },
                    child: Text(
                      'Register',
                      style: regular16pt.copyWith(color: primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}