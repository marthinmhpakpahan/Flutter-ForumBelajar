// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/models/topics.dart';
import 'package:forumbelajar/views/topics/create.dart';
import 'package:forumbelajar/views/topics/details.dart';
import 'package:forumbelajar/responses/topics/index.dart';
import 'package:forumbelajar/services/topic_services.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/views/users/details.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class TopicIndex extends StatefulWidget {

  TopicIndex();

  @override
  TopicIndexState createState() => TopicIndexState();

}

class TopicIndexState extends State<TopicIndex> {
  // This is  for form validations
  final formKey = GlobalKey<FormState>();
  final api = TopicServices();
  Future<List<Topics>> topics;


  @override
  void initState() {
    super.initState();
    topics = getIndexTopics();
  }

  Future<List<Topics>> getIndexTopics() async {
    IndexTopicResponse response = await api.index();
    return response.data;
  }

  listOfTopicsComponent(topics) {
    return FutureBuilder<List<Topics>>(
      future: topics,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.0),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue,
                        blurRadius: 0.02, // soften the shadow
                        spreadRadius: 0.05, //extend the shadow
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Session.setSelectedTopicId(data.id);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TopicDetails()));
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: 
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                        children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Session.setSelectedProfileId(data.user.id);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails()));
                              },
                              child: Row(
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
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: 
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.title,
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
                              data.content,
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
                                  size: 18,
                                )
                              )
                            ),
                            SizedBox(width: 5),
                            Text(
                              data.commentsCount.toString() + " comments" ,
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            )
                        ]
                      ),
                      ])
                      )
                    ),
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

  _buttonCreateTopic() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTopic()));
      },
      child: Align(
      alignment: Alignment.centerRight,
      child: Material(
        borderRadius: BorderRadius.circular(14.0),
        elevation: 0,
        child: Container(
          width: 155,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Row(
              children: [
                SizedBox(width: 10),
                Icon(
                  Icons.topic,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 10),
                Material(
                color: Colors.transparent,
                child: Center(
                    child: Text(
                      'New Topic',
                      style: heading5.copyWith(color: Colors.white),
                    ),
                  ),
              ),
            ])
        ),
      )
    )
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'Topics',
                        style: heading2.copyWith(color: textBlack),
                      ),
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
                    ]),
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
                height: 30,
              ),
              _buttonCreateTopic(),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: listOfTopicsComponent(topics)
              )
            ],
          ),
        ),
      ),
    );
  }
}