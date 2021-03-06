import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_kafasi/Firebase/firebase_database.dart';
import 'package:etkinlik_kafasi/extensions/color_data.dart';
import 'package:etkinlik_kafasi/helpers.dart';
import 'package:etkinlik_kafasi/locator.dart';
import 'package:etkinlik_kafasi/models/etkinlik_model.dart';
import 'package:etkinlik_kafasi/models/profil_kafalar.dart';
import 'package:etkinlik_kafasi/profilSayfalari/karsiKullaniciInfoContainer.dart';
import 'package:etkinlik_kafasi/profilSayfalari/karsiProfilAbout.dart';
import 'package:etkinlik_kafasi/profilSayfalari/karsiprofilgalerigrid.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:etkinlik_kafasi/extensions/size_extension.dart';
import 'package:etkinlik_kafasi/models/meta_data.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';

class KarsiKullaniciProfili extends StatefulWidget {
  final Map<String, dynamic> card;
  final int popCount;
  KarsiKullaniciProfili({this.card,this.popCount=1});

  @override
  _KarsiKullaniciProfiliState createState() => _KarsiKullaniciProfiliState();
}

FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

enum OtherUserProfileAction { block, report }

class _KarsiKullaniciProfiliState extends State<KarsiKullaniciProfili> with SingleTickerProviderStateMixin {
  final picker = ImagePicker();
  File _profilFoto;
  TabController _tabController;
  bool albumilsLoading = false;
  static int toplamkatilma = 1;
  int toplamEtkinlikSayim = 0;
  firebase_storage.FirebaseStorage storage;
  double leftmargin = 120.0.w;
  double topmargin = 40.0.w;
  List<String> kafalar_profil_icon_sayilari = [];
  List<String> kafalar_profil_iconlar = [];
  List<Map<String, String>> kafalar_map_list = [];
  List<Profil_kafalar> kafalar_list = [];
  List<String> kafalarim;
  var selectedProfileAction;
  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 4, vsync: this);

    storage = firebase_storage.FirebaseStorage.instance;
    profil_iconlari_getir();
    kafalarim = widget.card["kafalar"] == null ? [] : List<String>.from(widget.card["kafalar"]);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    _firestoreDBService.setMeAsVisitor(
        profileOwnerUserId: widget.card["userId"],
        name: _userModel.user.adsoyad,
        myUserId: _userModel.user.userId,
        imageUrl: _userModel.user.avatarImageUrl);
  }

  Future<void> profil_iconlari_getir() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.card['userId'])
        .collection("profil_iconlar")
        .get()
        .then((value) {
      for (QueryDocumentSnapshot item in value.docs) {
        Map<String, String> Profil_icon_sayilari = Map();

        if (item.id == "lider") {
          Profil_icon_sayilari['title'] = "Lider";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Lider", icon: "assets/profil_icon/lider.png", sayi: item['sayi']));
        } else if (item.id == "cilgin") {
          Profil_icon_sayilari['title'] = "????lg??n";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "????lg??n", icon: "assets/profil_icon/cilgin.png", sayi: item['sayi']));
        } else if (item.id == "adaletli") {
          Profil_icon_sayilari['title'] = "Adaletli";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Adaletli", icon: "assets/profil_icon/adalet.png", sayi: item['sayi']));
        } else if (item.id == "saygili") {
          Profil_icon_sayilari['title'] = "Sayg??l??";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "Sayg??l??", icon: "assets/profil_icon/saygili.png", sayi: item['sayi']));
        } else if (item.id == "guvenilir") {
          Profil_icon_sayilari['title'] = "G??venilir";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list
              .add(Profil_kafalar(name: "G??venilir", icon: "assets/profil_icon/guvenilir.png", sayi: item['sayi']));
        } else if (item.id == "romantik") {
          Profil_icon_sayilari['title'] = "Romantik";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list
              .add(Profil_kafalar(name: "Romantik", icon: "assets/profil_icon/romantik.png", sayi: item['sayi']));
        } else if (item.id == "comert") {
          Profil_icon_sayilari['title'] = "C??mert";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "C??mert", icon: "assets/profil_icon/comert.png", sayi: item['sayi']));
        } else if (item.id == "ek") {
          Profil_icon_sayilari['title'] = "EK";
          Profil_icon_sayilari['sayi'] = item['sayi'].toString();
          kafalar_map_list.add(Profil_icon_sayilari);

          kafalar_list.add(Profil_kafalar(name: "EK", icon: "assets/profil_icon/istekli.png", sayi: item['sayi']));
        }
        kafalar_profil_icon_sayilari.add(item['sayi'].toString());
      }
      setState(() {});
    });

    await FirebaseFirestore.instance
        .collection("users")
        .doc(_userModel.user.userId)
        .collection("profil_oy_attiklarim")
        .doc(widget.card['userId'])
        .get()
        .then((value) {
      print("value deger:" + value.data().toString());
      if (value.data() != null) {
        for (String item in value['kafalar']) {
          kafalar_profil_iconlar.add(item);
        }
      }

      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    toplamkatilma = (_userModel.user.etkinlikKatilma + _userModel.user.etkinlikKatilmama) == 0
        ? 1
        : (_userModel.user.etkinlikKatilma + _userModel.user.etkinlikKatilmama);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton<OtherUserProfileAction>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (result) async{
                  if(result == OtherUserProfileAction.block){
                    await blockUser(context);
                    Fluttertoast.showToast(
                        msg: "Kullan??c?? Engellendi!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        fontSize: 15.0.h);
                    var count = 0;
                    Navigator.of(context).popUntil((route) => count++==widget.popCount);
                  }

                  if(result == OtherUserProfileAction.report){
                    await reportUser();
                    Fluttertoast.showToast(
                        msg: "??ikayetiniz Al??nm????t??r!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        fontSize: 15.0.h);
                  }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem<OtherUserProfileAction>(
                      value: OtherUserProfileAction.block,
                      child: Text('Engelle'),
                    ),
                    const PopupMenuItem<OtherUserProfileAction>(
                      value: OtherUserProfileAction.report,
                      child: Text('??ikayet Et'),
                    ),
                  ])
        ],
      ),
      body: Container(
        child: Column(
          children: [
            KarsiKullaniciInfoContainer(
              card: widget.card,
            ),
            ProfilTabItems(tabController: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  widget.card['profilGizlilik'] == true
                      ? Center(
                          child: Text(
                          "Bu Profil Gizlidir",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                      : KarsiProfilAbout(
                          userid: _userModel.user.userId,
                          kafalar_sayilar: kafalar_profil_icon_sayilari,
                          kafalarlar: kafalar_profil_iconlar,
                          kafalar_map_list_icon: kafalar_map_list,
                          kafalar_profil: kafalar_list,
                          hakkimda: widget.card['hakkimda'],
                          card: widget.card,
                        ),
                  KarsiUserKafalarTab(
                    kafalarim: kafalarim,
                  ),
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
                                if(!_cardetkinlikler.exists)
                                  return Container();
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
                                              if(!_card.exists)
                                                return Container();
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

                  albumilsLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
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
                                    print("index :" + index.toString());
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          albumilsLoading = true;
                                        });
                                        List<dynamic> imagelist = await snapshot.data.docs[index]['imgarray'];
                                        String imagelistId = await snapshot.data.docs[index].id;

                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => KarsiProfilGaleriGrid(
                                                  imageList: imagelist,
                                                  galeriBaslik: snapshot.data.docs[index]['galeribaslik'],
                                                  userid: _userModel.user.userId,
                                                  imageListId: imagelistId,
                                                  card: snapshot.data.docs[index],
                                                  benimmi: false,
                                                )));

                                        setState(() {
                                          albumilsLoading = false;
                                        });
                                      },
                                      child: snapshot.data.docs[index]['imgarray'].toString() == "[]"
                                          ? SizedBox(height: 100, width: 100)
                                          : Stack(
                                              children: [
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
                                                              image: NetworkImage(
                                                                  snapshot.data.docs[index]['imgarray'][0].toString()),
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
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(6.70)),
                                                                            color: Theme.of(context).backgroundColor),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 3),
                                                                      child: Container(
                                                                        width: 75.0.w,
                                                                        height: 50.0.h,
                                                                        child: Center(
                                                                          child: Text(
                                                                            snapshot.data.docs[index]['galeribaslik'],
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
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 100,
                            ),
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

   Future<bool> blockUser(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await _firestoreDBService.blockUser(context, _userModel.user.userId, widget.card["userId"], widget.card["ad"]);
    return true;
  }

  Future<bool> reportUser() async{
    await _firestoreDBService.reportUser(widget.card["email"], widget.card["userId"]);
    return true;
  }

  Future<String> uploadAlbumImage(PickedFile pickedImage) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    String filePath = pickedImage.path;
    String userId = widget.card['userId'];
    String fileName = "${userId}-${DateTime.now()}}.jpg";
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance.ref(userId + '/usersAlbum/$fileName').putFile(file);
      String downloadURL =
          await firebase_storage.FirebaseStorage.instance.ref(userId + '/usersAlbum/$fileName').getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return "error";
      print("Error on uploading image file ${e.code}");
    }
  }

  Widget _buildYorumlarGrafikleri() {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(widget.card['userId']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final int cardLength = 1;

        return ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cardLength,
          itemBuilder: (_, int index) {
            final DocumentSnapshot _card = snapshot.data;
            int iyi = _card['yorumiyi'].toInt();
            int orta = _card['yorumorta'].toInt();
            int kotu = _card['yorumkotu'].toInt();
            int toplam = (iyi + orta + kotu) == 0 ? 0 : (iyi + orta + kotu);

            double iyiort = (iyi / toplam);
            double ortaort = (orta / 2 / toplam);

            print("toplam:" + toplam.toString());
            print("iyi:" + iyi.toString());
            print("orta:" + orta.toString());
            print("kotu:" + kotu.toString());
            print("iyiort:" + iyiort.toString());

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Row(
                children: [
                  Container(
                    width: 50.0.w,
                    height: 50.0.w,
                    child: CustomPaint(
                      foregroundPainter: RadialPainter(
                          bgColor: Colors.grey[200],
                          lineColor: Color(0xff00af54),
                          percent: iyiort.isNaN ? 0 : iyiort,
                          width: 5.0),
                      child: Center(
                        child: Text(
                          toplam != 0 ? '%' + (iyiort * 100 + ortaort * 100).ceil().toString() : "%0",
                          style: TextStyle(
                            fontSize: 13.70.spByWidth,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 14.0.h,
                          child: Row(
                            children: [
                              Container(
                                width: 30.0.w,
                                child: Text("??yi",
                                    style: TextStyle(
                                        color: const Color(0xff343633),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 11.7.h),
                                    textAlign: TextAlign.left),
                              ),
                              Expanded(
                                child: SliderTheme(
                                    data: SliderThemeData(
                                      disabledActiveTrackColor: Color(0xff00af54),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                      trackHeight: 7.0.h,
                                      trackShape: CustomTrackShape(),
                                    ),
                                    child: Slider(
                                      value: toplam != 0 ? iyi.toDouble() : 0,
                                      onChanged: null,
                                      activeColor: Color(0xff00af54),
                                      max: toplam.toDouble(),
                                      min: 0,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 14.0.h,
                          child: Row(
                            children: [
                              Container(
                                width: 30.0.w,
                                child: Text("Orta",
                                    style: TextStyle(
                                        color: const Color(0xff343633),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 11.7.h),
                                    textAlign: TextAlign.left),
                              ),
                              Expanded(
                                child: SliderTheme(
                                    data: SliderThemeData(
                                      disabledActiveTrackColor: Color(0xfff7cb15),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                      trackShape: CustomTrackShape(),
                                      trackHeight: 7.0.h,
                                    ),
                                    child: Slider(
                                      value: orta.toDouble(),
                                      onChanged: null,
                                      activeColor: Color(0xff00af54),
                                      max: toplam.toDouble(),
                                      min: 0,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 14.0.h,
                          child: Row(
                            children: [
                              Container(
                                width: 30.0.w,
                                child: Text("K??t??",
                                    style: TextStyle(
                                        color: const Color(0xff343633),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 11.7.h),
                                    textAlign: TextAlign.left),
                              ),
                              Expanded(
                                child: SliderTheme(
                                    data: SliderThemeData(
                                      disabledActiveTrackColor: Color(0xfff21b3f),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                      trackShape: CustomTrackShape(),
                                      trackHeight: 7.0.h,
                                    ),
                                    child: Slider(
                                      value: kotu.toDouble(),
                                      onChanged: null,
                                      activeColor: Color(0xff00af54),
                                      max: toplam.toDouble(),
                                      min: 0,
                                    )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(toplam.toString() + " Oy",
                              style: TextStyle(
                                  color: const Color(0xff343633),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "OpenSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 10.0.spByWidth),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildYorumlar() {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection("users").doc(widget.card['userId']).collection("yorumlar").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final int cardLength = snapshot.data.docs.length;

        return ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cardLength,
          itemBuilder: (_, int index) {
            final DocumentSnapshot _cardYonetici = snapshot.data.docs[index];
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(_cardYonetici['userid']).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                String assets = "";
                final String notrActive = "assets/notr_active.png";
                final String olumluActive = "assets/olumlu_active.png";
                final String olumsuzActive = "assets/olumsuz_active.png";

                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (_, int index) {
                    final DocumentSnapshot _card = snapshot.data;

                    if (_cardYonetici['yorumdeger'].toString() == 'olumsuz') {
                      assets = olumsuzActive;
                    } else if (_cardYonetici['yorumdeger'].toString() == 'notr') {
                      assets = notrActive;
                    } else {
                      assets = olumluActive;
                    }
                    final gun = _cardYonetici['tarih'].toDate();
                    final bugun = DateTime.now();
                    final difference = bugun.difference(gun).inDays;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0.0.w),
                            title: Text(_card['ad'].toString(),
                                style: TextStyle(
                                    color: const Color(0xff343633),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "OpenSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 13.3.spByWidth),
                                textAlign: TextAlign.left),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(_card['avatarImageUrl'].toString()),
                              radius: 20.0.h,
                            ),
                            trailing: Text(difference.toString() + " g??n ??nce",
                                style: TextStyle(
                                    color: const Color(0xff343633),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 10.0.spByWidth),
                                textAlign: TextAlign.right),
                          ),
                          Text(
                            _cardYonetici['yorum'] != null ? _cardYonetici['yorum'].toString() : "",
                            style: const TextStyle(
                                color: const Color(0xff343633),
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans",
                                fontStyle: FontStyle.normal,
                                fontSize: 13.3),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
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
