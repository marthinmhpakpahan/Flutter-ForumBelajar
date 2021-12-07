// @dart=2.9
import 'package:flutter/material.dart';
import 'package:forumbelajar/constants/theme.dart';
import 'package:forumbelajar/constants/session.dart';
import 'package:forumbelajar/responses/users/detail.dart';
import 'package:forumbelajar/services/user_services.dart';
import 'package:forumbelajar/models/users.dart';
import 'package:forumbelajar/views/topics/index.dart';
import 'package:forumbelajar/views/users/login.dart';
import 'package:forumbelajar/views/users/update.dart';

class UserDetails extends StatefulWidget {

  UserDetails();

  @override
  UserDetailsState createState() => UserDetailsState();

}

class UserDetailsState extends State<UserDetails> {

  final UserServices api = UserServices();
  Future<Users> user;

  @override
  void initState() {
    super.initState();
    user = getUser();

  }

  Future<Users> getUser() async {
    int user_id = Session.getSelectedProfileId();
    DetailUserResponse response = await api.getUser(user_id);
    return response.data;
  }

  _buttonUpdateProfile() {
    if(Session.getLoginUserId() == Session.getSelectedProfileId()) {
      return Material(
        borderRadius: BorderRadius.circular(14.0),
        elevation: 0,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileView()));
              },
              borderRadius: BorderRadius.circular(14.0),
              child: Center(
                child: Text(
                  'Ubah Profile',
                  style: heading5.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  _userDetailsComponent() {
    return FutureBuilder<Users>(
      future: user,
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
        return Container(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    (snapshot.data.gender == 'pria' ? 'assets/images/man_icon.png' : 'assets/images/woman_icon.png'),
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 12),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child:
                    Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Username",
                          style: TextStyle(color: primaryBlue, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.username,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey, height: 4, thickness: 2),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nama Lengkap",
                          style: TextStyle(color: primaryBlue, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.full_name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey, height: 4, thickness: 2),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(color: primaryBlue, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.email,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey, height: 4, thickness: 2),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Alamat",
                          style: TextStyle(color: primaryBlue, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.address,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(color: Colors.grey, height: 4, thickness: 2),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bergabung pada",
                          style: TextStyle(color: primaryBlue, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.data.created_at,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      SizedBox(height: 25),
                      _buttonUpdateProfile()
                    ])
                  )
                ],
              ),
            ),
          ),
        );
      },
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
                        'Profile',
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
                height: 12,
              ),
              _userDetailsComponent(),
            ],
          ),
        ),
      ),
    );
  }

}