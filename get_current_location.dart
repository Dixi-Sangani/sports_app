import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _address = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Function to get the current location and address
  void _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      setState(() {
        _address = (placemarks[0].name ?? '') +
            ", " +
            (placemarks[0].subLocality ?? '') +
            ", " +
            (placemarks[0].locality ?? '') +
            ", " +
            (placemarks[0].administrativeArea ?? '') +
            ", " +
            (placemarks[0].country ?? '');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 40.0,
              color: Colors.blue,
            ),
            SizedBox(height: 10.0),
            Text(
              '$_address',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}