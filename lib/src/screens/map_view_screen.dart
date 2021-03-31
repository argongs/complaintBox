import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sample/src/db/elaborated_complaint_model.dart';
import '../db/database_interface.dart';
import '../db/database_provider.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => MapViewScreenState();
}

class MapViewScreenState extends State<MapViewScreen> {
  @override
  Widget build(BuildContext context) {
    final DatabaseInterface dbInteractor = DatabaseProvider.of(context);

    return Scaffold(
      body: FutureBuilder(
        future: dbInteractor.obtainElaboratedComplaints(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.length > 0)
              return createGoogleMap(snapshot.data, dbInteractor);
            else
              return Text("Add complaints to see them here!");
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget createGoogleMap(Iterable<ElaboratedComplaintModel> markerData,
      DatabaseInterface dbInteractor) {
    Completer<GoogleMapController> _controller = Completer();

    //Create the markers
    Iterable<Marker> iterableMarkers = markerData.map((element) => Marker(
        markerId: MarkerId(element.id.toString()),
        position: LatLng(element.latitude, element.longitude),
        infoWindow: InfoWindow(
          title: element.defectName,
          snippet: element.shortDescription,
        )));

    final CameraPosition initialPosition = CameraPosition(
      target: LatLng(
          markerData.elementAt(0).latitude, markerData.elementAt(0).longitude),
      zoom: 15,
    );

    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: initialPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set.from(iterableMarkers),
    );
  }
}
