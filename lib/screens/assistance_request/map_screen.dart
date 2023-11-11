import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng placePosition;
  const MapScreen({super.key, required this.placePosition});

  @override
  State<MapScreen> createState() =>
      _MapScreenState(placePosition: placePosition);
}

class _MapScreenState extends State<MapScreen> {
  final LatLng placePosition;
  _MapScreenState({Key? key, required this.placePosition});

  LatLng initialPosition = LatLng(-17.784302, -63.180892);
  LatLng myActualPosition = LatLng(-17.784302, -63.180892);
  late Position currentPosition;

  String MAPBOX_ACCESS_TOKEN = '';

  MapController mapController = MapController();
  final double minZoom = 5;
  final double maxZoom = 25;
  final double initialZoom = 13;
  final double initialZoomPosition = 15;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void zoomIn() {
    if (mapController.zoom < maxZoom) {
      mapController.move(mapController.center, mapController.zoom + 1);
    }
  }

  void zoomOut() {
    if (mapController.zoom > minZoom) {
      mapController.move(mapController.center, mapController.zoom - 1);
    }
  }

  void moveToLocation() {
    mapController.move(placePosition, initialZoomPosition);
  }

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    currentPosition = await determinePosition();
    setState(() {
      myActualPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      mapController.move(myActualPosition, initialZoomPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: initialPosition,
          minZoom: minZoom,
          maxZoom: maxZoom,
          zoom: initialZoom,
        ),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                  point: placePosition,
                  builder: (context) {
                    return const Icon(Icons.place, color: Colors.red, size: 40);
                  }),
              Marker(
                  point: myActualPosition,
                  builder: (context) {
                    return const Icon(Icons.person_pin_outlined,
                        color: Colors.green, size: 40);
                  }),
            ],
          ),
        ],
        children: [],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed: zoomIn, child: const Icon(Icons.zoom_in)),
          ElevatedButton(onPressed: zoomOut, child: const Icon(Icons.zoom_out)),
          ElevatedButton(
              onPressed: moveToLocation, child: const Icon(Icons.place)),
          ElevatedButton(
              onPressed: getCurrentLocation,
              child: const Icon(Icons.location_searching_sharp)),
        ],
      ),
    );
  }
}
