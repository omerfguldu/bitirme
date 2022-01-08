import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminKullaniciProfil/kullanicibilgileriniduzenle.dart';
import 'package:etkinlik_kafasi/Firebase/firebase_database.dart';
import 'package:etkinlik_kafasi/extensions/color_data.dart';
import 'package:etkinlik_kafasi/helpers.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/models/meta_data.dart';
import 'package:etkinlik_kafasi/models/profil_kafalar.dart';
import 'package:etkinlik_kafasi/profilim/profil_listTitle.dart';
import 'package:etkinlik_kafasi/service/user_state_service.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class AdminKarsiProfilAbout extends StatefulWidget {
  String userid;
  List<String> kafalar_sayilar;
  List<String> kafalarlar;
  List<Map<String,String>> kafalar_map_list_icon = [];
  List<Profil_kafalar> kafalar_profil = [];
  final Map<String, dynamic> card;
  AdminKarsiProfilAbout({this.userid,this.kafalar_sayilar,this.kafalarlar,this.kafalar_map_list_icon,this.kafalar_profil,this.card});
  @override
  _AdminKarsiProfilAboutState createState() => _AdminKarsiProfilAboutState();
}

class _AdminKarsiProfilAboutState extends State<AdminKarsiProfilAbout> {
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  List<Map<String,String>> kafalar_profil_iconlar_sayilar = [];

  List<int> Listsayilar=[];
  int tiklanan_index=20;
  @override
  Widget build(BuildContext context) {
    print("set state oldu");
    final _userModel = Provider.of<UserModel>(context);

    return  ListView(
      padding: EdgeInsets.only(top: 10.0, left: 8.0.w, right: 16.0.w),
      children: [

        ProfilListTile(
          title: "Doğum Tarihi",
          icon: Icon(
            Icons.cake,
            size: 24.0.w,
            color: Theme.of(context).primaryColor,
          ),
          trailingTitle: formatTheDate(widget.card['dogumTarihi'].toDate(), format: DateFormat("d.M.y")) ?? "",
        ),
        ProfilListTile(
          title: "İlişki Durumu",
          icon: Icon(
            Icons.favorite,
            size: 24.0.w,
            color: Colors.red,
          ),
          trailingTitle: widget.card['iliskiDurumu'] ?? "",
        ),
        ProfilListTile(
          title: "Meslek",
          icon: Icon(
            Icons.work,
            size: 24.0.w,
            color: Theme.of(context).accentColor,
          ),
          trailingTitle: widget.card['meslek'] ?? "",
        ),
        ProfilListTile(
          title: "Öğrenim Durumu:",
          icon: Icon(
            Icons.school,
            size: 24.0.w,
            color: Theme.of(context).accentColor,
          ),
          trailingTitle: widget.card['ogrenimdurumu'] ?? "",
        ),



        SizedBox(
          height: 8.0.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  _launchURL(widget.card['facebook']);
                },
                child: Image.asset(
                  "assets/facebook_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: (){
                  _launchURL(widget.card['twitter']);
                },
                child: Image.asset(
                  "assets/twitter_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: (){
                  _launchURL(widget.card['instagram']);
                },
                child: Image.asset(
                  "assets/instagram_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: (){
                  _launchURL(widget.card['tiktok']);
                },
                child: Image.asset(
                  "assets/tiktok_icon.png",
                  width: 24.0.w,
                  height: 24.0.w,
                  fit: BoxFit.contain,
                ),
              ),

            ],

          ),
        ),


        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Text(widget.card['hakkimda'].toString(),style: TextStyle(fontSize: 16.0.h),),
        ),

        SizedBox(height: 100.0.h,),
      ],
    );
  }

  _launchURL(String url) async {
    if (url != "") {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
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
