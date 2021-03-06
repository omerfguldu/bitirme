import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminFirebaseIslemleri.dart';
import 'package:etkinlik_kafasi/extensions/color_data.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/widgets/AlertDialog.dart';
import 'package:etkinlik_kafasi/widgets/resimliCard.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';

class AdminYoneticiAta extends StatefulWidget {
  @override
  _AdminYoneticiAtaState createState() => _AdminYoneticiAtaState();
}


class UserBloc extends Bloc {
  final userController = StreamController<List>.broadcast();


  @override
  void dispose() {
    // TODO: implement dispose
    userController.close();
  }
}
abstract class Bloc {
  void dispose();
}



UserBloc userBloc = UserBloc();

class _AdminYoneticiAtaState extends State<AdminYoneticiAta> {
  bool isSearching = false;
  List<DocumentSnapshot> totalUsers = [];
  List data;
  AdminFirebaseIslemleri _adminIslemleri = locator<AdminFirebaseIslemleri>();

  void _searchUser(String searchQuery) {

    List<Map<dynamic,dynamic>> searchResult = [];

    userBloc.userController.sink.add(null);
    if (searchQuery.isEmpty) {
      userBloc.userController.sink.add(totalUsers);
      return;
    }
    totalUsers.forEach((DocumentSnapshot user) {
      String tamad=user['ad'];
      if (tamad.toLowerCase().contains(searchQuery.toLowerCase()) ||
          tamad.toLowerCase().contains(searchQuery.toLowerCase())) {
          searchResult.add(user.data());
      }
    });


    userBloc.userController.sink.add(searchResult);
  }

  Widget usersWidget() {
    return StreamBuilder(

        stream: userBloc.userController.stream,
        builder: (BuildContext buildContext,
            AsyncSnapshot<List> snapshot) {

          if (snapshot.data == null) {

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').limit(50).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                final int cardLength = snapshot.data.docs.length;



                return ListView.builder(
                  itemCount: cardLength,
                  itemBuilder: (_, int index) {
                    final DocumentSnapshot _card = snapshot.data.docs[index];
                      if(cardLength > totalUsers.length)
                      {
                        totalUsers.add(_card);
                      }


                    return _card['yoneticimi'] == true ? Container() : ResimliCard(textSubtitle: null, textTitle: _card['ad'].toString(), onPressed: (){
                      var dialog = CustomAlertDialog(
                          message: "Bu ki??iyi y??netici yapmak istedi??inize emin misiniz?",
                          onPostivePressed: () {
                            _adminIslemleri.adminYoneticiAta(_card);
                            Navigator.pop(context);
                          },
                          onNegativePressed: (){

                          },
                          positiveBtnText: 'Evet',
                          negativeBtnText: '??ptal');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog);
                    }, fontSize: 12.0.spByWidth,
                        img: _card['avatarImageUrl'].toString(), tarih: null);
                  },
                );

              },
            );
          }
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
            child: CircularProgressIndicator(),
          )
              : _randomUsers(snapshot: snapshot);
        });
  }

  Widget _randomUsers({AsyncSnapshot<List> snapshot}) {

    return    ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        //snapshot.data[index].toString()

        return snapshot.data[index]['yoneticimi'] == true ? Container() : ResimliCard(textSubtitle: null, textTitle: snapshot.data[index]['ad'].toString(), onPressed: (){
          var dialog = CustomAlertDialog(
              message: "Bu ki??iyi y??netici yapmak istedi??inize emin misiniz?",
              onPostivePressed: () {
                _adminIslemleri.adminYoneticiAta(snapshot.data[index]);
                Navigator.pop(context);
              },
              onNegativePressed: (){

              },
              positiveBtnText: 'Evet',
              negativeBtnText: '??ptal');
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog);
        }, fontSize: 12.0.spByWidth,
            img: snapshot.data[index]['avatarImageUrl'].toString(), tarih: null);
      },
      itemCount: snapshot.data == null ? 0 : snapshot.data.length,
    );
  }

  @override
  Widget build(BuildContext context) {

    AdminFirebaseIslemleri _adminIslemleri = locator<AdminFirebaseIslemleri>();

    return  Scaffold(
      backgroundColor: Renkler.backGroundColor,
      appBar: AppBar(
        backgroundColor: Renkler.appbarGroundColor,
        title: !isSearching
            ? Text("Ki??i Se??",
            style: TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
                fontFamily: "OpenSans",
                fontStyle: FontStyle.normal,
                fontSize: 21.7.spByWidth),
            textAlign: TextAlign.center)
            : TextField(
          onChanged: (text) => _searchUser(text),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Aray??n??z...",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).backgroundColor,
            size: 17.0.h,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        brightness: Brightness.light,
        // status bar brightness
        actions: <Widget>[
          isSearching
              ? IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
             // totalUsers=[];
              setState(() {
               isSearching = false;
               userBloc.userController.sink.add(null);

              });


            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
             // totalUsers=[];
              setState(() {
                isSearching = true;

              });



            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg_curve.png"),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: usersWidget(),
      ),
    );
  }
}
