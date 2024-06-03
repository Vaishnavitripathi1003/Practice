import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  final LatLng _initialPosition = LatLng(28.207609, 79.826660); // Example coordinates
  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _loadPolygon();
  }

  Future<void> _loadPolygon() async {
    try {
      final String response = await rootBundle.loadString('assets/UpDistrict.json');
      final data = json.decode(response);

      // Use a temporary list to avoid multiple calls to setState
      List<Polygon> tempPolygons = [];

      for (var feature in data['features']) {
        List<dynamic> coordinatesData = feature['geometry']['coordinates'][0];
        List<LatLng> polygonLatLngs = coordinatesData.map((point) {
          double lat = point[1].toDouble();
          double lng = point[0].toDouble();
          return LatLng(lat, lng);
        }).toList();

        tempPolygons.add(
          Polygon(
            polygonId: PolygonId('polygon_${tempPolygons.length + 1}'),
            points: polygonLatLngs,
            strokeWidth: 2,
            strokeColor: Colors.red,
            fillColor: Colors.blue,
          ),
        );
      }

      setState(() {
        _polygons.addAll(tempPolygons);
      });
    } catch (e) {
      print("Error loading polygon: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Polygon'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            polygons: _polygons,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_polygons.isEmpty)
            Center(
              child: CircularProgressIndicator(), // Show a loading indicator until polygons are loaded
            ),
        ],
      ),
    );
  }
}
