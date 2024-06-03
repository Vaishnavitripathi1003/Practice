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
            onTap: () {
              print('Polygon tapped'); // Debug point
              _showDistrictNameDialog();
            }
          )
        );
      }

      setState(() {
        _polygons.addAll(tempPolygons);
      });
    } catch (e) {
      print("Error loading polygon: $e");
    }
  }
  void _showDistrictNameDialog() {
    print('Showing district name dialog'); // Debug point
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('District'),
          content: Text('District Name:'), // You might want to add the district name here
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
            onTap: (LatLng latLng) {
              _checkPolygonTapped(latLng);
            },
          ),
          if (_polygons.isEmpty)
            Center(
              child: CircularProgressIndicator(), // Show a loading indicator until polygons are loaded
            ),
        ],
      ),
    );
  }

  void _checkPolygonTapped(LatLng latLng) {
    for (Polygon polygon in _polygons) {
      if (_isPointInsidePolygon(latLng, polygon.points)) {
        _showDistrictNameDialog();
        break;
      }
    }
  }

  bool _isPointInsidePolygon(LatLng point, List<LatLng> polygonPoints) {
    int intersectCount = 0;
    for (int j = 0; j < polygonPoints.length - 1; j++) {
      if (_rayCastIntersect(point, polygonPoints[j], polygonPoints[j + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1; // odd = inside, even = outside;
  }

  bool _rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    final double aY = vertA.latitude;
    final double bY = vertB.latitude;
    final double aX = vertA.longitude;
    final double bX = vertB.longitude;
    final double pY = point.latitude;
    final double pX = point.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or b must be east of pt.x
    }
    final double m = (aY - bY) / (aX - bX);
    final double bee = (-aX) * m + aY;
    final double x = (pY - bee) / m;
    return x > pX;
  }

}
