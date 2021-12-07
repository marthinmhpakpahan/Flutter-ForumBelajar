// @dart=2.9
import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/models/users.dart';
import 'package:forumbelajar/responses/users/detail.dart';
import 'package:forumbelajar/responses/users/register.dart';
import 'package:forumbelajar/responses/users/update.dart';
import 'package:forumbelajar/services/user_services.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/users/details.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

ProgressDialog progressDialog;

class UpdateProfileView extends StatefulWidget {

  UpdateProfileView({Key key}) : super(key: key);

  @override
  UpdateProfileViewState createState() => UpdateProfileViewState();

}

class UpdateProfileViewState extends State<UpdateProfileView> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = UserServices();
  Future<Users> user;
  String gender = "";

  bool passwordVisible = false;
  bool passwordConfrimationVisible = false;
  bool isCheckedPria = false, isCheckedPerempuan = false;

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  // This is for text onChange
  TextEditingController usernameController, passwordController, passwordConfirmController, emailController, fullNameController, genderController, addressController;

  void updateUser(String username, String password, String email, String full_name, String gender, String address) async {
    await progressDialog.show();
    int user_id = Session.getLoginUserId();
    UpdateUserResponse response = await api.updateUser(user_id, username, password, email, full_name, gender, address);
    if(response.error == false) {
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails()));
    } else {
      if (progressDialog.isShowing()) {
        await progressDialog.hide();
      }
      showErrorDialog(response.message);
    }
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

  Future<Users> getUser() async {
    int user_id = Session.getSelectedProfileId();
    DetailUserResponse response = await api.getUser(user_id);
    usernameController.text = response.data.username;
    emailController.text = response.data.email;
    fullNameController.text = response.data.full_name;
    addressController.text = response.data.address;
    if(response.data.gender == "pria") {
      setState(() {
        isCheckedPria = true;
        isCheckedPerempuan = false;
        gender = response.data.gender;
      });
    } else {
      setState(() {
        isCheckedPerempuan = true;
        isCheckedPria = false;
        gender = response.data.gender;
      });
    }
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    user = getUser();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
    emailController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
  }

  _buttonUpdate() {
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
              String full_name = fullNameController.text, address = addressController.text, passwordConfirm = passwordConfirmController.text;
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
              updateUser(username, password, email, full_name, gender, address);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Simpan',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Row(children: [
                      GestureDetector(
                      child: 
                        Container(
                          decoration: ShapeDecoration(
                            color: primaryBlue,
                            shape: CircleBorder()
                          ),
                          child: 
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            )
                          )
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails()));
                        },
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Ubah Profile',
                        style: heading2.copyWith(color: textBlack),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      GestureDetector(
                        child: 
                        Container(
                          decoration: ShapeDecoration(
                            color: primaryBlue,
                            shape: CircleBorder()
                          ),
                          child: 
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 25,
                            )
                          )
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TopicIndex()));
                        },
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: 
                        Container(
                          decoration: ShapeDecoration(
                            color: primaryBlue,
                            shape: CircleBorder()
                          ),
                          child: 
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 25,
                            )
                          )
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                        },
                      )
                    ])
                  ])
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
                        controller: passwordConfirmController,
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
              _buttonUpdate(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

}