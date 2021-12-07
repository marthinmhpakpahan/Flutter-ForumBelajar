// @dart=2.9
import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/responses/topics/create.dart';
import 'package:forumbelajar/services/topic_services.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/users/details.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

ProgressDialog progressDialog;

class CreateTopic extends StatefulWidget {

  CreateTopic();

  @override
  CreateTopicState createState() => CreateTopicState();

}

class CreateTopicState extends State<CreateTopic> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = TopicServices();
  String gender = "pria";

  // This is for text onChange
  TextEditingController titleController, contentController;

  void createTopic(String title, String content) async {
    await progressDialog.show();
    int user_id = Session.getLoginUserId();
    CreateTopicResponse response = await api.create(user_id, title, content);
    if(response.error == false) {
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  _buttonCreateTopic() {
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
              String title = titleController.text, content = contentController.text;
              if(title.trim() == "") {
                showErrorDialog("Judul tidak boleh kosong!");
                return;
              }
              if(content.trim() == "") {
                showErrorDialog("Isi topik tidak boleh kosong!");
                return;
              }
              createTopic(title, content);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Create Topic',
                style: heading5.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
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
          padding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TopicIndex()));
                        },
                      ),
                      SizedBox(width: 15),
                      Text(
                        'New Topic',
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
                              Icons.person,
                              color: Colors.white,
                              size: 25,
                            )
                          )
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails()));
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
                height: 60,
              ),
              Center(child: 
                Text(
                  "Tuliskan detail topik anda disini!",
                  style: TextStyle(
                    fontSize: 20
                  )
                ),
              ),
              SizedBox(
                height: 24,
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
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Judul',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        maxLines: 8,
                        controller: contentController,
                        decoration: InputDecoration(
                          hintText: 'Isi topik diskusi . . .',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              _buttonCreateTopic(),
            ],
          ),
        ),
      ),
    );
  }

}