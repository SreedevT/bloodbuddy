import 'dart:developer';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hospital {
  final String name;
  final LatLng position;
  late final String city;

  Hospital({required this.name, required this.position});

  @override
  String toString() {
    return 'Hospital: $name\n lat: ${position.latitude}\n lon: ${position.longitude}';
  }
}

Future<List<Hospital>> fetchHospitals(
    double latitude, double longitude, double radius) async {
  String apiUrl = 'https://overpass-api.de/api/interpreter?data=';

  // Construct the Overpass query to fetch hospitals within the specified radius
  String overpassQuery = '''
    [out:json];
    node[healthcare=hospital](around:${radius * 1000}, $latitude, $longitude);
    out ;
  ''';

  String encodedQuery = Uri.encodeComponent(overpassQuery);
  String url = '$apiUrl$encodedQuery';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<dynamic, dynamic> data = jsonDecode(response.body);
    var rawData = jsonDecode(response.body) as Map<dynamic, dynamic>;
    log(rawData.toString());
    List<dynamic> hospitals = data['elements'];
    // return hospitals;
    return hospitals.map((item) {
      final String name = item['tags']['name'] ?? 'Unknown';
      final double latitude = item['lat'];
      final double longitude = item['lon'];
      return Hospital(name: name, position: LatLng(latitude, longitude));
    }).toList();
  } else {
    throw Exception('Failed to fetch hospitals');
  }
}
