import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_app/AllWidgets/Rider.dart';


class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;



  void locatPosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlatPoisition = LatLng(position.latitude, position.longitude);
    
    
    CameraPosition cameraPosition = new CameraPosition(target: latlatPoisition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/feriUser.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),),
                          SizedBox(height: 6.0),
                          Text("Visit Profile"),
                        ],
                      )

                    ],
                  ),
                ),
              ),

              DividerWidget(),

              SizedBox(height: 12.0,),

            //  Rider Body Controller

              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.payment),
                title: Text("Metode Pembayaran", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.shield_rounded),
                title: Text("Kebijakan Privasi", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.language),
                title: Text("Pilihan Bahasa", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Notifikasi", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.star),
                title: Text("Beri Rating", style: TextStyle(fontSize: 15.0),),
              ),

              ListTile(
                leading: Icon(Icons.logout_rounded),
                title: Text("Keluar", style: TextStyle(fontSize: 15.0),),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          zoomControlsEnabled: true,

          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            setState(() {
              bottomPaddingOfMap = 300.0;
            });

            locatPosition();
          },
        ),

          // Hamburger button

          Positioned(
            top: 45.0,
              left: 22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),

                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0),
                    Text("Hay Gojekers!", style: TextStyle(fontSize: 16.0),),
                    Text("Mau ke mana hari ini?", style: TextStyle(fontSize: 22.0, fontFamily: "Brand Bold"),),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 0.1,
                            offset: Offset(0.7, 0.7),
                          )
                        ],
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children : [
                          Icon(Icons.search, color: Colors.green, ),
                          SizedBox(width: 10.0,),
                            Text("Cari lokasi tujuan", style: TextStyle(color: Colors.grey),)
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.0),
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.grey,),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lokasi Rumah"),
                            SizedBox(height: 4.0,),
                            Text("Alamat Rumahmu", style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),


                    DividerWidget(),

                    SizedBox(height: 16.0),

                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.grey,),
                        SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lokasi Kerja"),
                            SizedBox(height: 4.0,),
                            Text("Alamat Kerjamu", style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
      ],
      ),
    );
  }
}
