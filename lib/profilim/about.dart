import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/Firebase/firebase_database.dart';
import 'package:etkinlik_kafasi/extensions/color_data.dart';
import 'package:etkinlik_kafasi/helpers.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/models/meta_data.dart';
import 'package:etkinlik_kafasi/models/profil_kafalar.dart';
import 'package:etkinlik_kafasi/profilim/profil_listTitle.dart';
import 'package:etkinlik_kafasi/profilim/profile_bakanlar.dart';
import 'package:etkinlik_kafasi/service/user_state_service.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  List<String> kafalar_sayilar;
  List<String> kafalarlar;
  List<Map<String, String>> kafalar_map_list_icon = [];
  List<Profil_kafalar> kafalar_profil = [];

  About({ this.kafalar_sayilar, this.kafalarlar, this.kafalar_map_list_icon, this.kafalar_profil});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  List<Map<String, String>> kafalar_profil_iconlar_sayilar = [];

  List<int> Listsayilar = [];
  int tiklanan_index = 20;

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    return ListView(
      padding: EdgeInsets.only(top: 10.0, left: 8.0.w, right: 16.0.w),
      children: [
        //TODO ListTile ile arası padding sıkıştılılacak...

        ProfilListTile(
          title: "Doğum Tarihi",
          icon: Icon(
            Icons.cake,
            size: 34.0.h,
            color: Theme.of(context).primaryColor,
          ),
          trailingTitle: formatTheDate(_userModel.user.dogumTarihi, format: DateFormat("d.M.y")) ?? "",
        ),
        SizedBox(height: 10.0.h,),
        ProfilListTile(
          title: "İlişki Durumu",
          icon: Icon(
            Icons.favorite,
            size: 34.0.h,
            color: Colors.red,
          ),
          trailingTitle: _userModel.user.iliskiDurumu ?? "",
        ),
        SizedBox(height: 10.0.h,),
        ProfilListTile(
          title: "Meslek",
          icon: Icon(
            Icons.work,
            size: 34.0.h,
            color: Theme.of(context).accentColor,
          ),
          trailingTitle: _userModel.user.meslek ?? "",
        ),
        SizedBox(height: 10.0.h,),
        ProfilListTile(
          title: "Öğrenim Durumu:",
          icon: Icon(
            Icons.school,
            size: 34.0.h,
            color: Theme.of(context).accentColor,
          ),
          trailingTitle: _userModel.user.ogrenimDurumu ?? "",
        ),
        SizedBox(height: 10.0.h,),

        SizedBox(
          height: 8.0.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _launchURL(_userModel.user.facebook);
                },
                child: Image.asset(
                  "assets/facebook_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
//                          alignment: Alignment.bottomRight,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(_userModel.user.twitter);
                },
                child: Image.asset(
                  "assets/twitter_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
//                          alignment: Alignment.bottomRight,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(_userModel.user.instagram);
                },
                child: Image.asset(
                  "assets/instagram_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
//                          alignment: Alignment.bottomRight,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchURL(_userModel.user.tiktok);
                },
                child: Image.asset(
                  "assets/tiktok_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
//                          alignment: Alignment.bottomRight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Text(
            _userModel.user.hakkimda.toString(),
            style: TextStyle(fontSize: 16),
          ),
        ),

        SizedBox(
          height: 100.0.h,
        ),
      ],
    );
  }

  _launchURL(String url) async {
    print("url " + url.toString());
    if (url != "") {
      if (await canLaunch(url)) {
        print("1");
        await launch(url);
      } else {
        print("2");
        Fluttertoast.showToast(
          msg: "Geçerli link yok!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          textColor: Colors.white,
          backgroundColor: Colors.purpleAccent,
        );
      }
    } else {
      print("3");
      Fluttertoast.showToast(
        msg: "Link tanımsız!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
