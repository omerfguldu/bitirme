import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/Firebase/firebase_database.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/profilSayfalari/kullaniciprofili.dart';
import 'package:etkinlik_kafasi/profilim/profildetay/kullaniciProfili.dart';
import 'package:etkinlik_kafasi/service/user_state_service.dart';
import 'package:etkinlik_kafasi/widgets/resimliCard.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';
import 'package:provider/provider.dart';

class Takipcilerim extends StatefulWidget {
  final DocumentSnapshot card;

  const Takipcilerim({Key key, this.card}) : super(key: key);

  @override
  _TakipcilerimState createState() => _TakipcilerimState();
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
FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

class _TakipcilerimState extends State<Takipcilerim> with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool isSearching = false;
  List<DocumentSnapshot> totalUsers = [];
  List totalBilgi = [];
  List data;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final yorumController = TextEditingController();

  void _searchUser(String searchQuery) {
    List<Map<dynamic, dynamic>> searchResult = [];

    userBloc.userController.sink.add(null);
    if (searchQuery.isEmpty) {
      userBloc.userController.sink.add(totalUsers);
      return;
    }
    totalUsers.forEach((DocumentSnapshot user) {
      String tamad = user['ad'];
      if (tamad.toLowerCase().contains(searchQuery.toLowerCase()) ||
          tamad.toLowerCase().contains(searchQuery.toLowerCase())) {
        searchResult.add(user.data());
      }
    });

    userBloc.userController.sink.add(searchResult);
  }

  Widget usersWidget(String userid) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return StreamBuilder(
        stream: userBloc.userController.stream,
        builder: (BuildContext buildContext, AsyncSnapshot<List> snapshot) {
          if (snapshot.data == null) {
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_userModel.user.userId)
                  .collection("takipcilerim")
                  // .where("userid", whereNotIn: _userModel.user.blockedUsers.map((e)=>e.userId).toList())
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final int cardLength = snapshot.data.docs.length;
                var blockIds = _userModel.user.blockedUsers.map((e) => e.userId).toList();
                var list = snapshot.data.docs
                    .where((e) => !blockIds.contains(e.get("userid"))).toList();
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (_, int index) {
                      final DocumentSnapshot _cardYonetici = list[index];

                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('userId', isEqualTo: _cardYonetici['userid'])
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (_, int index) {
                                if(!snapshot.data.docs[index].exists)
                                  return Container();
                                final DocumentSnapshot _card = snapshot.data.docs[index];

                                totalUsers.add(_card);
                                totalBilgi.add(_card);

                                return ResimliCard(
                                    textSubtitle: null,
                                    textTitle: _card['ad'].toString(),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => KarsiKullaniciProfili(
                                                  card: _card.data(),
                                              popCount: 2,
                                                )),
                                      );
                                    },
                                    fontSize: 12.0.spByWidth,
                                    img: _card['avatarImageUrl'].toString(),
                                    tarih: null);
                              },
                            );
                          });
                    });
              },
            );
          }
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _randomUsers(
                  snapshot: snapshot,
                );
        });
  }

  Widget _randomUsers({AsyncSnapshot<List> snapshot}) {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    return snapshot.data.length != 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> userbilgiler = Map();
              if (snapshot.data.runtimeType.toString() == 'List<Map<dynamic, dynamic>>') {
                userbilgiler.addAll(snapshot.data[index]);
              } else {
                QueryDocumentSnapshot veri = snapshot.data[index];
                userbilgiler.addAll(veri.data());
              }
              return ResimliCard(
                  textSubtitle: null,
                  textTitle: snapshot.data[index]['ad'],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KarsiKullaniciProfili(card: userbilgiler)),
                    );
                  },
                  fontSize: 12.0.spByWidth,
                  img: snapshot.data[index]['avatarImageUrl'].toString(),
                  tarih: null);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
            size: 17.0.w,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Takip??ilerim",
            style: TextStyle(
                color: const Color(0xff343633),
                fontWeight: FontWeight.w700,
                fontFamily: "OpenSans",
                fontStyle: FontStyle.normal,
                fontSize: 21.7.spByWidth),
            textAlign: TextAlign.center),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Container(
              width: 293.3333333333333.w,
              height: 41.666666666666664.h,
              margin: EdgeInsets.symmetric(vertical: 20.0.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.8.h)),
                boxShadow: [
                  BoxShadow(color: const Color(0x2b000000), offset: Offset(0, 2), blurRadius: 14.30.w, spreadRadius: 0)
                ],
                color: Theme.of(context).backgroundColor,
              ),
              child: TextFormField(
                onChanged: (text) => _searchUser(text),
                keyboardType: TextInputType.text,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.disabled,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 15.0.spByWidth),
                decoration: InputDecoration(
                  hintText: "Kullan??c?? Ara",
                  border: InputBorder.none,
                  icon: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 18.0.w,
                    ),
                  ),
                  labelStyle: TextStyle(
                      color: const Color(0xbf343633),
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans",
                      fontStyle: FontStyle.italic,
                      fontSize: 15.3.spByWidth),
                ),
              ),
            ),
          ),
          usersWidget(_userModel.user.userId),
        ],
      ),
    );
  }
}
