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
  final LatLng _initialPosition = LatLng(28.207609, 79.826660);
  Set<Polygon> _polygons = {};
  bool _mapLoaded = false;
  LatLngBounds? _bounds;

  @override
  void initState() {
    super.initState();
    _loadPolygon();
  }

  Future<void> _loadPolygon() async {
    try {
      final String response = await rootBundle.loadString('assets/UpDistrict.json');
      final data = json.decode(response);

      List<Polygon> tempPolygons = [];
      LatLngBounds? bounds;

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
            fillColor: Colors.blueAccent.withOpacity(0.5),
            onTap: () {
              print('Polygon tapped');
              _showDistrictNameDialog();
            },
          ),
        );

        // Calculate the bounds
        if (bounds == null) {
          bounds = _calculateBounds(polygonLatLngs);
        } else {
          bounds = bounds.extend(_calculateBounds(polygonLatLngs));
        }
      }

      setState(() {
        _polygons.addAll(tempPolygons);
        _bounds = bounds;
        _mapLoaded = true;
      });

      // Print out the bounds for debugging
      print('Bounds: $_bounds');

    } catch (e) {
      print("Error loading polygon: $e");
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (LatLng point in points) {
      if (minLat == null || point.latitude < minLat) {
        minLat = point.latitude;
      }
      if (maxLat == null || point.latitude > maxLat) {
        maxLat = point.latitude;
      }
      if (minLng == null || point.longitude < minLng) {
        minLng = point.longitude;
      }
      if (maxLng == null || point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  void _showDistrictNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('District'),
          content: Text('District Name:'), // Add district name if needed
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
    return (intersectCount % 2) == 1;
  }

  bool _rayCastIntersect(LatLng point, LatLng vertA, LatLng vertB) {
    final double aY = vertA.latitude;
    final double bY = vertB.latitude;
    final double aX = vertA.longitude;
    final double bX = vertB.longitude;
    final double pY = point.latitude;
    final double pX = point.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false;
    }
    final double m = (aY - bY) / (aX - bX);
    final double bee = (-aX) * m + aY;
    final double x = (pY - bee) / m;
    return x > pX;
  }

  Future<void> _setMapStyle() async {
    final String style = await rootBundle.loadString('assets/map_style.json');
    _controller?.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps with Polygon'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _setMapStyle();
              if (_bounds != null) {
                controller.animateCamera(CameraUpdate.newLatLngBounds(_bounds!, 50));
              }
              setState(() {});
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 6.0,
            ),
            polygons: _polygons,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            scrollGesturesEnabled: false,
            onTap: (LatLng latLng) {
              _checkPolygonTapped(latLng);
            },
          ),
          if (!_mapLoaded)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

extension LatLngBoundsExtension on LatLngBounds {
  LatLngBounds extend(LatLngBounds other) {
    return LatLngBounds(
      southwest: LatLng(
        (southwest.latitude < other.southwest.latitude) ? southwest.latitude : other.southwest.latitude,
        (southwest.longitude < other.southwest.longitude) ? southwest.longitude : other.southwest.longitude,
      ),
      northeast: LatLng(
        (northeast.latitude > other.northeast.latitude) ? northeast.latitude : other.northeast.latitude,
        (northeast.longitude > other.northeast.longitude) ? northeast.longitude : other.northeast.longitude,
      ),
    );
  }
}
