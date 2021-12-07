// @dart=2.9
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/responses/users/register.dart';
import 'package:forumbelajar/services/user_services.dart';
import 'package:forumbelajar/views/users/login.dart';

ProgressDialog progressDialog;

class Register extends StatefulWidget {

  Register({Key key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();

}

class RegisterState extends State<Register> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = UserServices();
  String gender = "";

  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  bool isCheckedPria = false, isCheckedPerempuan = false;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

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

  // This is for text onChange
  TextEditingController usernameController, passwordController, passwordConfimationController, emailController, fullNameController, genderController, addressController;

  void register(String username, String password, String email, String full_name, String gender, String address) async {
    await progressDialog.show();
    RegisterResponse response = await api.register(username, password, email, full_name, gender, address);
    if(response.error == false) {
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
    passwordConfimationController = TextEditingController();
    emailController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    super.initState();
  }

  _buttonRegister() {
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
              String username = usernameController.text, password = passwordController.text, email = emailController.text;
              String full_name = fullNameController.text, address = addressController.text, passwordConfirm = passwordConfimationController.text;
              if(email.trim() == "") {
                showErrorDialog("Email tidak boleh kosong!");
                return;
              }
              if(full_name.trim() == "") {
                showErrorDialog("Name Lengkap tidak boleh kosong!");
                return;
              }
              if(username.trim() == "") {
                showErrorDialog("Username tidak boleh kosong!");
                return;
              }
              if(password.trim() == "") {
                showErrorDialog("Password tidak boleh kosong!");
                return;
              }
              if(password.trim() != passwordConfirm) {
                showErrorDialog("Password dan konfirmasi tidak sama!");
                return;
              }
              if(gender.trim() == "") {
                showErrorDialog("Gender tidak boleh kosong!");
                return;
              }
              if(address.trim() == "") {
                showErrorDialog("Alamat tidak boleh kosong!");
                return;
              }
              register(username, password, email, full_name, gender, address);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Register',
                style: heading5.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _priaCustomCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCheckedPria = true;
          isCheckedPerempuan = false;
          gender = "Pria";
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCheckedPria ? primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          border: isCheckedPria ? null : Border.all(color: textGrey, width: 1.5),
        ),
        width: 20,
        height: 20,
        child: isCheckedPria
            ? Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  _perempuanCustomCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCheckedPerempuan = true;
          isCheckedPria = false;
          gender = "Wanita";
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCheckedPerempuan ? primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
          border: isCheckedPerempuan ? null : Border.all(color: textGrey, width: 1.5),
        ),
        width: 20,
        height: 20,
        child: isCheckedPerempuan
            ? Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
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
                    'Register new account',
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
                height: 32,
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
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          hintText: 'Nama Lengkap',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                      height: 16,
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
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordConfimationController,
                        obscureText: !passwordConfrimationVisible,
                        decoration: InputDecoration(
                          hintText: 'Password Confirmation',
                          hintStyle: heading6.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordConfrimationVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() {
                                passwordConfrimationVisible =
                                    !passwordConfrimationVisible;
                              });
                            },
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
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _priaCustomCheckbox(),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Laki-laki', style: regular16pt),
                    SizedBox(
                      width: 48,
                    ),
                    _perempuanCustomCheckbox(),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Perempuan', style: regular16pt),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: textWhiteGrey,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: TextFormField(
                  maxLines: 4,
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'Alamat',
                    hintStyle: heading6.copyWith(color: textGrey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              _buttonRegister(),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: regular16pt.copyWith(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Text(
                      'Login',
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