// @dart=2.9
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/models/topics.dart';
import 'package:forumbelajar/responses/topics/create.dart';
import 'package:forumbelajar/responses/topics/update.dart';
import 'package:forumbelajar/services/topic_services.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/users/details.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:http/http.dart' as http;

class UpdateTopicView extends StatefulWidget {

  const UpdateTopicView({this.title, this.content});
  final String title, content;

  @override
  UpdateTopicViewState createState() => UpdateTopicViewState();

}

class UpdateTopicViewState extends State<UpdateTopicView> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = TopicServices();

  // This is for text onChange
  TextEditingController titleController, contentController;

  void updateTopic(String title, String content) async {
    int user_id = Session.getLoginUserId(), topic_id = Session.getSelectedTopicId();
    UpdateTopicResponse response = await api.update(user_id, topic_id, title, content);
    print(topic_id);
    if(response.error == false) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicIndex()));
    } else {
      // SHOW ERROR MESSAGE
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
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
              updateTopic(title, content);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Ubah Topik',
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
                        'Ubah Topik',
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
                  "Tuliskan perubahan topik anda!",
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