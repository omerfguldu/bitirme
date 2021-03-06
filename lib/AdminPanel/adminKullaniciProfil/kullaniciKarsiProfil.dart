import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminKullaniciProfil/adminKarsiAbout.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminKullaniciProfil/adminkullanicicontainer.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminKullaniciProfil/adminprofilcontainer.dart';
import 'package:etkinlik_kafasi/AdminPanel/adminYetkilendirme.dart';
import 'package:etkinlik_kafasi/Firebase/firebase_database.dart';
import 'package:etkinlik_kafasi/extensions/color_data.dart';
import 'package:etkinlik_kafasi/helpers.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/models/etkinlik_model.dart';
import 'package:etkinlik_kafasi/models/profil_kafalar.dart';
import 'package:etkinlik_kafasi/profilSayfalari/karsiuserkafalartab.dart';
import 'package:etkinlik_kafasi/profilSayfalari/profilgalerigrid.dart';
import 'package:etkinlik_kafasi/profilim/profil_listTitle.dart';
import 'package:etkinlik_kafasi/profilim/profiletkinlikcard.dart';
import 'package:etkinlik_kafasi/profilim/profilfotofull.dart';
import 'package:etkinlik_kafasi/profilim/tab_bar_row.dart';
import 'package:etkinlik_kafasi/service/user_state_service.dart';
import 'package:etkinlik_kafasi/widgets/imageviewGalleryKarsiKullanici.dart';
import 'package:etkinlik_kafasi/widgets/radial_painter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';
import 'package:etkinlik_kafasi/models/meta_data.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class AdminKarsiKullaniciProfili extends StatefulWidget {
  final Map<String, dynamic> card;

  AdminKarsiKullaniciProfili({this.card});

  @override
  _AdminKarsiKullaniciProfiliState createState() => _AdminKarsiKullaniciProfiliState();
}

FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

class _AdminKarsiKullaniciProfiliState extends State<AdminKarsiKullaniciProfili> with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  File _profilFoto;
  TabController _tabController;

  int toplamEtkinlikSayim = 0;
  firebase_storage.FirebaseStorage storage;
  double leftmargin = 120.0.w;
  double topmargin = 40.0.w;
  List<String> kafalar_profil_icon_sayilari = [];
  List<String> kafalar_profil_iconlar = [];
  List<Map<String,String>> kafalar_map_list = [];
  List<Profil_kafalar> kafalar_list = [];
  List<String> kafalarim;
  static int toplamkatilma=1;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    toplamkatilma =(widget.card['etkinlikKatildi']+widget.card['etkinlikKatilmadi']) == 0 ? 1 :(widget.card['etkinlikKatildi']+widget.card['etkinlikKatilmadi']) ;

    storage = firebase_storage.FirebaseStorage.instance;
    profil_iconlari_getir();
    kafalarim= widget.card["kafalar"] != null ? List<String>.from(widget.card["kafalar"]) : null;
  }

  Future<void> profil_iconlari_getir() async  {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await FirebaseFirestore.instance.collection("users").doc(widget.card['userId']).collection("profil_iconlar").get().then((value){
      for(QueryDocumentSnapshot item in value.docs){

        Map<String, String> Profil_icon_sayilari = Map();



        if(item.id=="lider"){

          Profil_icon_sayilari['title'] = "Lider";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Lider",icon: "assets/profil_icon/lider.png",sayi: item['sayi']));

        }else if(item.id=="cilgin"){

          Profil_icon_sayilari['title'] = "????lg??n";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "????lg??n",icon: "assets/profil_icon/cilgin.png",sayi: item['sayi']));

        }else if(item.id=="adaletli"){

          Profil_icon_sayilari['title'] = "Adaletli";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Adaletli",icon: "assets/profil_icon/adalet.png",sayi: item['sayi']));

        }else if(item.id=="saygili"){

          Profil_icon_sayilari['title'] = "Sayg??l??";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Sayg??l??",icon: "assets/profil_icon/saygili.png",sayi: item['sayi']));


        }else if(item.id=="guvenilir"){
          Profil_icon_sayilari['title'] = "G??venilir";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "G??venilir",icon: "assets/profil_icon/guvenilir.png",sayi: item['sayi']));

        }else if(item.id=="romantik"){
          Profil_icon_sayilari['title'] = "Romantik";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Romantik",icon: "assets/profil_icon/romantik.png",sayi: item['sayi']));

        }else if(item.id=="comert"){
          Profil_icon_sayilari['title'] = "C??mert";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "C??mert",icon: "assets/profil_icon/comert.png",sayi: item['sayi']));

        }else if(item.id=="ek") {
          Profil_icon_sayilari['title'] = "EK";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "EK",icon: "assets/profil_icon/istekli.png" ,sayi: item['sayi']));

        }
        kafalar_profil_icon_sayilari.add(item['sayi'].toString());

      }
      setState(() {

      });

    });

    await FirebaseFirestore.instance.collection("users").doc(_userModel.user.userId).collection("profil_oy_attiklarim").doc(widget.card['userId']).get().then((value){
      print("value deger:"+value.data().toString());
      print("user id card gelen profil:"+widget.card['userId']);
      if(value.data() != null) {
        for (String item in value['kafalar']) {
          kafalar_profil_iconlar.add(item);
        }
      }

      setState(() {

      });
    });

  }


  @override
  Widget build(BuildContext context) {
    bool albumilsLoading=false;

    final _userModel = Provider.of<UserModel>(context);
    print("karsi kullan??c?? id:"+widget.card['userId']);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          children: [
            AdminKullaniciContainer(card: widget.card,),
            ProfilTabItems(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  AdminKarsiProfilAbout(userid: _userModel.user.userId,kafalar_sayilar: kafalar_profil_icon_sayilari,kafalarlar: kafalar_profil_iconlar,kafalar_map_list_icon: kafalar_map_list,kafalar_profil: kafalar_list,card: widget.card,),


                  KarsiUserKafalarTab(kafalarim: kafalarim,),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.card['userId'])
                        .collection('etkinliklerim')
                        .orderBy('tarih', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        print(snapshot.error);
                        return Center(
                            child: Text(
                              "Herhangi bir etkinlik yok!",
                              style: Theme.of(context).textTheme.caption,
                            ));
                      }
                      final int cardLength = snapshot.data.docs.length;
                      return cardLength == 0
                          ? Center(child: Text("Herhangi bir etkinlik yok!"))
                          : ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: cardLength,
                        itemBuilder: (_, int index) {
                          final DocumentSnapshot _cardetkinlikler = snapshot.data.docs[index];
                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('etkinlik')
                                .doc(_cardetkinlikler['etid'].toString())
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              print("data:" + cardLength.toString());

                              return cardLength == 0
                                  ? Text("Herhangi bir etkinlik yok!")
                                  : ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (_, int index) {
                                  final DocumentSnapshot _card = snapshot.data;
                                  return Column(
                                    children: [
                                      ProfilEtkinlikCard(
                                        etkinlikBilgileri: EtkinlikModel.fromMap(_card.data()),
                                        card: _card,
                                      ),
                                      SizedBox(
                                        height: 40.0.h,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),



                  albumilsLoading ? Center(child: CircularProgressIndicator(),) :   ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.card['userId'])
                            .collection('albumlerim')
                            .orderBy('tarih', descending: true)
                            .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                                child: Text(
                                  "Herhangi bir alb??m yok!",
                                  style: Theme.of(context).textTheme.caption,
                                ));
                          }

                          final int cardLength = snapshot.data.docs.length;

                          return GridView.builder(
                            padding: EdgeInsets.all(16.0.w),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cardLength,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 14.30.w,
                              mainAxisSpacing: 13.0.h,
                            ),
                            itemBuilder: (BuildContext context, int index) {

                              return
                                GestureDetector(
                                  onTap: () async {

                                    setState(() {
                                      albumilsLoading=true;
                                    });
                                    List<dynamic> imagelist = await snapshot.data.docs[index]['imgarray'];
                                    String imagelistId = await snapshot.data.docs[index].id;


                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GaleriGrid(
                                      imageList: imagelist,
                                      galeriBaslik: snapshot.data.docs[index]['galeribaslik'],
                                      userid: _userModel.user.userId,
                                      imageListId: imagelistId,
                                      card: snapshot.data.docs[index],
                                      benimmi: false,
                                    )));


                                    setState(() {
                                      albumilsLoading=false;
                                    });


                                  },
                                  child: snapshot.data.docs[index]['imgarray'].toString() == "[]" ? SizedBox(height: 100, width: 100) :
                                  Stack(children: [
                                    Column(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            height: 150.0.h,
                                            width: 150.0.w,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage( snapshot.data.docs[index]['imgarray'][0].toString()),
                                                  alignment: Alignment.topCenter),
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                    child: Stack(
                                                      children: [
                                                        Opacity(
                                                          opacity: 0.65,
                                                          child: Container(
                                                            width: 75.0.w,
                                                            height: 60.0.h,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(6.70)),
                                                                color: Theme.of(context).backgroundColor),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 3),
                                                          child: Container(
                                                            width: 75.0.w,
                                                            height: 50.0.h,
                                                            child: Center(
                                                              child: Text(snapshot.data.docs[index]['galeribaslik'],
                                                                maxLines: 3,
                                                                style: TextStyle(
                                                                    color: const Color(0xff343633),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "OpenSans",
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 12.7.spByWidth),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      alignment: Alignment.centerLeft,
                                                    ),
                                                    top: 12.30.h,
                                                    left: 13.30.w),
                                              ],
                                            ),

                                          ),),
                                      ],
                                    ),
                                  ],
                                  ),
                                );



                            },
                          );
                        },
                      ),
                      SizedBox(height: 100.0.h,),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> uploadAlbumImage(PickedFile pickedImage) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    String filePath = pickedImage.path;
    String userId = widget.card['userId'];
    String fileName = "${userId}-${DateTime.now()}}.jpg";
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance.ref(userId+'/usersAlbum/$fileName').putFile(file);
      String downloadURL = await firebase_storage.FirebaseStorage.instance.ref(userId+'/usersAlbum/$fileName').getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "error";
      print("Error on uploading image file ${e.code}");
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeri'),
                      onTap: () async {
                        var pickedImage = await imgFromGallery(picker);
                        Navigator.pop(context);
                        var downloadUrl = await uploadAlbumImage(pickedImage);
                        var uid = FirebaseAuth.instance.currentUser.uid;
                        var userAlbumPath = "users/$uid/albumlerim";
                        await FirebaseFirestore.instance.collection(userAlbumPath).add({"img": downloadUrl});


                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () async {
                      var pickedImage = await imgFromCamera(picker);
                      Navigator.pop(context);
                      var downloadUrl = await uploadAlbumImage(pickedImage);
                      var uid = FirebaseAuth.instance.currentUser.uid;
                      var userAlbumPath = "users/$uid/albumlerim";
                      await FirebaseFirestore.instance.collection(userAlbumPath).add({"img": downloadUrl});

                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  



  Future<String> uploadEtkinlikImage() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto == null) return "";
    String filePath = _profilFoto.path;
    String userId = _userModel.user.userId;
    String fileName = "${userId}-profil.text-${DateTime.now()}.jpg";
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance.ref('etkinlikfotolari/$fileName').putFile(file);
      String downloadURL =
      await firebase_storage.FirebaseStorage.instance.ref('etkinlikfotolari/$fileName').getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "error";
      print("Error on uploading image file ${e.code}");
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
