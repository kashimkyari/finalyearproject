import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:MDXApp/models/classroom.dart';

class location extends StatefulWidget {
  static const String routName = "/location";

  @override
  _locationState createState() => _locationState();
}

// ignore: camel_case_types
class _locationState extends State<location> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Position currentPosition;
  var geoLocator = Geolocator();

  @override
  void initState() {
    locatePosition();
    getMarker();
    super.initState();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;

    final LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    final CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify['lat'], specify['long']),
      infoWindow:
          InfoWindow(title: specify['name'], snippet: specify['collegeId']),
      icon: BitmapDescriptor.defaultMarker,
    );
    setState(() {
      markers[markerId] = marker;
      print(markerId);
    });
  }

  // Future<void> joinClassroom({
  //   @required String classroomCode,
  // })

  getMarker() async {
    Firestore.instance
        .collection('classrooms')
        .document('fFLzXVRVy6aOpK8sKpMZ')
        .collection('students')
        .getDocuments()
        .then((myData) {
      if (myData.documents.isNotEmpty) {
        for (int i = 0; i < myData.documents.length; i++) {
          initMarker(myData.documents[i].data, myData.documents[i].documentID);
        }
      }
    });
  }

  static final CameraPosition _kGoogleplex =
      CameraPosition(target: LatLng(20.3484, 57.5522), zoom: 14);
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId('shop'),
            position: LatLng(20.3484, 57.5522),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Home'))
      ].toSet();
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Location",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Stack(children: [
          GoogleMap(
            mapType: MapType.hybrid,
            markers: Set<Marker>.of(markers.values),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(20.3484, 57.5522),
              //zoom: 380,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),
        ]));
  }
}
