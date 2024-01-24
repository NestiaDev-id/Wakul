import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakul2/controller/locationsController.dart';

class LokasiState extends StatefulWidget {
  const LokasiState({Key? key}) : super(key: key);

  @override
  State<LokasiState> createState() => _LokasiStateState();
}

class _LokasiStateState extends State<LokasiState> {
  Position? currentPosition;
  LatLng? point;
  LatLng? newCenter;
  String address = "";
  List<Placemark> lokasi = [];
  final TextEditingController _addressController = TextEditingController();
  Placemark? firstPlacemark;
  final MapController _mapController = MapController();

  getCurrentPosition() async {
    Position position = await determite();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      point = LatLng(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        firstPlacemark = placemarks.first;
      }
    });
  }

  Future<Position> determite() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  Future<void> updateLocation() async {
    try {
      await LocationController().updatePositioned(point!);
    } catch (e) {
      print("Error updating location: $e");
      Get.snackbar(
        'Error Updated',
        'Error updating location: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: point ?? LatLng(-7.7956, 110.3695),
              zoom: 12,
              maxZoom: 18,
              onTap: (tapPosition, p) async {
                lokasi = await placemarkFromCoordinates(
                  p.latitude,
                  p.longitude,
                );

                print("$firstPlacemark");

                if (lokasi.isNotEmpty) {
                  setState(
                    () {
                      firstPlacemark = lokasi.first;
                      point = p;
                    },
                  );
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 100,
                    height: 100,
                    point: point ?? LatLng(0.0, 0.0),
                    builder: (context) => const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      hintText: "Cari Lokasi Anda",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          if (_addressController.text.isNotEmpty) {
                            List<Location> locations =
                                await locationFromAddress(
                              _addressController.text,
                            );
                            if (locations.isNotEmpty) {
                              Location location = locations.first;
                              LatLng newCenter =
                                  LatLng(location.latitude, location.longitude);

                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                newCenter.latitude,
                                newCenter.longitude,
                              );

                              setState(
                                () {
                                  firstPlacemark = placemarks.isNotEmpty
                                      ? placemarks.first
                                      : null;
                                  point = newCenter;
                                  print("$firstPlacemark");

                                  _mapController.move(
                                    LatLng(newCenter.latitude,
                                        newCenter.longitude),
                                    12,
                                  );
                                },
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Visibility(
                        visible: (firstPlacemark?.street != null),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Alamat: ${firstPlacemark?.street}, ${firstPlacemark?.locality}, ${firstPlacemark?.subAdministrativeArea},${firstPlacemark?.administrativeArea},",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Card(
                            color: const Color(0xFFFAD677),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Kembali',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.blue,
                            child: TextButton(
                              onPressed: updateLocation,
                              child: const Text(
                                'Simpan alamat anda',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
