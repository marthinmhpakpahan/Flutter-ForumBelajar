// @dart=2.9
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/models/comments.dart';
import 'package:forumbelajar/responses/comments/create.dart';
import 'package:forumbelajar/responses/comments/delete.dart';
import 'package:forumbelajar/responses/comments/index.dart';
import 'package:forumbelajar/responses/topics/delete.dart';
import 'package:forumbelajar/responses/topics/details.dart';
import 'package:forumbelajar/services/comment_services.dart';
import 'package:forumbelajar/services/topic_services.dart';
import 'package:forumbelajar/models/topics.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/topics/update.dart';
import 'package:forumbelajar/views/users/details.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class TopicDetails extends StatefulWidget {

  TopicDetails();

  @override
  TopicDetailsState createState() => TopicDetailsState();

}

class TopicDetailsState extends State<TopicDetails> {

  final TopicServices apiTopic = TopicServices();
  final CommentServices apiComment = CommentServices();

  TextEditingController commentController;

  Future<Topics> topic;
  Future<List<Comments>> comments;

  @override
  void initState() {
    super.initState();

    commentController = TextEditingController();

    topic = getTopic();
    comments = getComments();
  }

  Future<Topics> getTopic() async {
    int topic_id = Session.getSelectedTopicId();
    DetailsTopicResponse response = await apiTopic.getTopic(topic_id);
    return response.data;
  }

  Future<List<Comments>> getComments() async {
    int topic_id = Session.getSelectedTopicId();
    IndexCommentResponse response = await apiComment.index(topic_id);
    return response.data;
  }

  void _createComment(String comment) async {
    int topic_id = Session.getSelectedTopicId();
    int user_id = Session.getLoginUserId();
    CreateCommentResponse response = await apiComment.create(topic_id, user_id, comment);
    if(!response.error) {
      Navigator.pop(context);
      setState(() {
          comments = getComments();
      });
    }
  }

  void deleteTopic() async {
    int topic_id = Session.getSelectedTopicId();
    DeleteTopicResponse response = await apiTopic.deleteTopic(topic_id);
    if(!response.error) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TopicIndex()));
    }
  } 

  void deleteComment(int id) async {
    DeleteCommentResponse response = await apiComment.deleteComment(id);
    if(!response.error) {
      setState(() {
          comments = getComments();
      });
    }
  } 

  showDeleteTopicDialogConfirmation() {
    StylishDialog(
        context: context,
        alertType: StylishDialogType.WARNING,
        titleText: 'Warning!',
        contentText: "Apakah anda yakin ingin menghapus topik ini?",
        dismissOnTouchOutside: true,
        confirmText: 'Ya',
        cancelText: 'Tidak',
        confirmPressEvent: () {
          deleteTopic();
          Navigator.of(context).pop();
        },
        cancelPressEvent: () {
          Navigator.of(context).pop();
        },
      ).show();
  }

  showDeleteCommentDialogConfirmation(int comment_id) {
    StylishDialog(
        context: context,
        alertType: StylishDialogType.WARNING,
        titleText: 'Warning!',
        contentText: "Apakah anda yakin ingin menghapus komentar ini?",
        dismissOnTouchOutside: true,
        confirmText: 'Ya',
        cancelText: 'Tidak',
        confirmPressEvent: () {
          deleteComment(comment_id);
          Navigator.of(context).pop();
        },
        cancelPressEvent: () {
          Navigator.of(context).pop();
        },
      ).show();
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

  _topicDetailsComponent() {
    return FutureBuilder<Topics>(
      future: topic,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              height: 40, width: 40,
              child: CircularProgressIndicator()
            ),
          );
        }
        // Render student lists
        return Material(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.0),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue,
                  blurRadius: 1, // soften the shadow
                  spreadRadius: 1, //extend the shadow
                  offset: Offset(3, 3)
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14.0),
                child: 
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: [
                              Container(
                                decoration: ShapeDecoration(
                                  color: primaryBlue,
                                  shape: CircleBorder()
                                ),
                                child: 
                                Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                )
                              ),
                              SizedBox(width: 7),
                              Text(
                                snapshot.data.user.username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: textGrey
                                )
                              )
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          Text(snapshot.data.created_at)
                        ]),
                      ]
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 5),
                      child: 
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Lato',
                            color: textBlack
                          ),
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: 
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.content,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Lato',
                            color: textBlack
                          ),
                        ),
                      )
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buttonDeleteTopicComponent(snapshot.data),
                        SizedBox(width: 10),
                        _buttonUpdateTopicComponent(snapshot.data),
                    ])
                  ])
                )
              ),
            ),
          ),
          )
        );
      },
    );
  }

  _buttonUpdateTopicComponent(data) {
    if(Session.getLoginUserId() == data.user.id) {
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 10),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: 
          Row(children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.create,
                color: Colors.white,
                size: 20,
              )
            ),
            Text("Ubah",
              style: TextStyle(color: Colors.white)
            )
          ])
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTopicView(title: data.title, content: data.content)));
        },
      );
    } else {
      return Text("");
    }
  }

  _buttonDeleteTopicComponent(data) {
    if(Session.getLoginUserId() == data.user.id) {
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: 
          Row(children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              )
            ),
            Text("Hapus",
              style: TextStyle(color: Colors.white)
            )
          ])
        ),
        onTap: () {
          showDeleteTopicDialogConfirmation();
        },
      );
    } else {
      return Text("");
    }
  }

  _buttonDeleteCommentComponent(data) {
    if(Session.getLoginUserId() == data.user.id) {
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: 
          Row(children: [
            Padding(
              padding: EdgeInsets.all(3),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 20,
              )
            ),
            Text("Hapus",
              style: TextStyle(color: Colors.white)
            )
          ])
        ),
        onTap: () {
          showDeleteCommentDialogConfirmation(data.id);
        },
      );
    } else {
      return Text("");
    }
  }

  _listOfCommentsComponent() {
    return FutureBuilder<List<Comments>>(
      future: comments,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // By default, show a loading spinner.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              height: 40, width: 40,
              child: CircularProgressIndicator()
            ),
          );
        }

        if(snapshot.data.length == 0) {
          return Center(
            child: Container(
              child: Text(
                "Belum ada komentar pada topik ini!", 
                style: TextStyle(
                  fontSize: 18
                )
              )
            )
          );
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            var data = snapshot.data[index];
            return Container(
              padding: EdgeInsets.all(1),
              child: Material(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue,
                        blurRadius: 2, // soften the shadow
                        spreadRadius: 1, //extend the shadow
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              children: [
                                Container(
                                  decoration: ShapeDecoration(
                                    color: primaryBlue,
                                    shape: CircleBorder()
                                  ),
                                  child: 
                                  Padding(
                                    padding: EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  )
                                ),
                                SizedBox(width: 7),
                                Text(
                                  data.user.username,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: textGrey
                                  )
                                )
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text(data.created_at)
                          ]),
                        ]
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: 
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.content,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              color: textBlack
                            ),
                          ),
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buttonDeleteCommentComponent(data)
                      ])
                    ])
                    )
                  ),
                ),
              )
            )
            );
          },
        );
      },
    );
  }

  _buttonComment() {
    double maxWidth = (MediaQuery.of(context).size.width);
    return Material(
      borderRadius: BorderRadius.circular(14.0),
      elevation: 0,
      child: Container(
        height: 48,
        width: maxWidth,
        decoration: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              String comment = commentController.text;
              if(comment.trim() == "") {
                showErrorDialog("Username tidak boleh kosong!");
                return;
              }
              _createComment(comment);
            },
            borderRadius: BorderRadius.circular(14.0),
            child: Center(
              child: Text(
                'Buat Komentar',
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
                        'Topic',
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
                          Session.setSelectedProfileId(Session.getLoginUserId());
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
                height: 12,
              ),
              _topicDetailsComponent(),
              SizedBox(
                height: 15,
              ),
              Row(children: [
                Container(
                decoration: ShapeDecoration(
                  color: primaryBlue,
                  shape: CircleBorder()
                ),
                child: 
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.comment,
                    color: Colors.white,
                    size: 20,
                  )
                ),
              ),
              SizedBox(width: 6),
              Text(
                'Comments:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              ]),
              SizedBox(height: 10),
              Expanded(child: 
                _listOfCommentsComponent()
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          commentController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: 250,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Text("Tuliskan komentar anda disini!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: textWhiteGrey,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: TextFormField(
                                controller: commentController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Isi komentar...',
                                  hintStyle: heading6.copyWith(color: textGrey),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            _buttonComment()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
        },
        child: const Icon(Icons.comment),
        backgroundColor: Colors.blue,
      ),
    );
  }

}