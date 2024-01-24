import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakul2/account/edit_profile_screen.dart';
import 'package:wakul2/controller/locationscontroller.dart';
import 'package:wakul2/controller/users/userController.dart';
import 'package:wakul2/form/login.dart';
import 'package:wakul2/test2.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  Position? currentPosition;
  LatLng? point;
  String address = "";
  List<Placemark> lokasi = [];
  Placemark? firstPlacemark;
  final MapController _mapController = MapController();

  bool _isDisposed = false;

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag menjadi true saat widget di-Dispose
    super.dispose();
  }

  getCurrentPosition() async {
    try {
      if (_isDisposed) return; // Cek apakah widget masih terpasang

      Position position = await determite();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!_isDisposed) {
        // Cek lagi sebelum pemanggilan setState
        setState(() {
          point = LatLng(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            firstPlacemark = placemarks.first;
          }
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        // Cek lagi sebelum menampilkan pesan kesalahan
        print('Error: $e');
      }
    }
  }

  Future<Position> determite() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Future.error('error');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: UserController().getDataUser(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (snapshot.hasData) {
                                  Map<String, dynamic>? user =
                                      snapshot.data!.data();
                                  String imageUrl = user?['imageUrls'] ?? '';
                                  if (imageUrl.isNotEmpty) {
                                    return SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: ClipOval(
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // If imageUrl is empty, you can show a default image or placeholder
                                    return Image.asset('images/user.png');
                                  }
                                } else {
                                  // Loading indicator or placeholder while data is being fetched
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: UserController().getDataUser(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    Map<String, dynamic>? user =
                                        snapshot.data!.data();
                                    return Text(
                                      "${user?['username']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      "Anonymus",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                } catch (e) {
                                  print('Error during logout: $e');
                                }
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.10,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: 10,
                    height: MediaQuery.of(context).size.height * 0.10,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                        width: 0.7,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: UserController().streamRole(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Icon(Icons.hourglass_empty);
                            }
                            String? role = snapshot.data!.data()!["roles"];
                            if (role == "seller") {
                              return const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(
                                              Icons.watch_later_outlined,
                                              size: 30)),
                                      Text('Waktu Operasional'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(Icons.stars, size: 30)),
                                      Text('Penilaian'),
                                    ],
                                  ),
                                ],
                              );
                            } else if (role == "driver") {
                              return const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(
                                        Icons.star,
                                        size: 30,
                                        color: Colors.amber,
                                      )),
                                      Text('Ratings'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                          child:
                                              Icon(Icons.fastfood, size: 30)),
                                      Text('Orders Complete'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(
                                              Icons.delivery_dining_outlined,
                                              size: 30)),
                                      Text('Dikirim'),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(Icons.list_alt_outlined,
                                              size: 30)),
                                      Text('Points'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(Icons.stars, size: 30)),
                                      Text('Penilaian'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Expanded(
                                          child: Icon(
                                              Icons.delivery_dining_outlined,
                                              size: 30)),
                                      Text('Dikirim'),
                                    ],
                                  ),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Icon(Icons.manage_accounts_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Pengaturan Akun',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.7,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Foto Porfil'),
                                StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: UserController().getDataUser(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (snapshot.hasData) {
                                      Map<String, dynamic>? user =
                                          snapshot.data!.data();
                                      String imageUrl =
                                          user?['imageUrls'] ?? '';
                                      if (imageUrl.isNotEmpty) {
                                        return SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ClipOval(
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      } else {
                                        // If imageUrl is empty, you can show a default image or placeholder
                                        return Image.asset('images/user.png');
                                      }
                                    } else {
                                      // Loading indicator or placeholder while data is being fetched
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Nama'),
                                StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: UserController().getDataUser(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (snapshot.hasData) {
                                      Map<String, dynamic>? user =
                                          snapshot.data!.data();
                                      return Text(
                                        "${user?['username']}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      );
                                    } else {
                                      return const Text(
                                        "Anonymus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfilePage(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Ganti Alamat '),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const LokasiState();
                                            },
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Lihat Lebih Lanjut',
                                      ),
                                    )
                                  ],
                                ),
                                StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: LocationController().streamLokasi(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          !snapshot.data!.exists) {
                                        return const Text('...');
                                      }
                                      Map<String, dynamic> userData =
                                          snapshot.data!.data()!;

                                      String userAddress = userData['address'];

                                      return Text(
                                        userAddress,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      );
                                    }),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: FutureBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                      future: LocationController()
                                          .getLocation(), // Ganti dengan metode yang sesuai
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              "Error: ${snapshot.error}");
                                        } else if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return const Text(
                                              "Data not available");
                                        }

                                        Map<String, dynamic>? userData =
                                            snapshot.data!.data();

                                        if (userData == null) {
                                          return const Text(
                                              "User data is null");
                                        }

                                        double latitude = userData['location']
                                                ?['latitude'] ??
                                            0.0;
                                        double longitude = userData['location']
                                                ?['longitude'] ??
                                            0.0;

                                        LatLng userLocation =
                                            LatLng(latitude, longitude);

                                        return FlutterMap(
                                          mapController: _mapController,
                                          options: MapOptions(
                                            onTap: (tapPosition, point) async {
                                              lokasi =
                                                  await placemarkFromCoordinates(
                                                point.latitude,
                                                point.longitude,
                                              );
                                              if (lokasi.isNotEmpty) {
                                                setState(() {
                                                  firstPlacemark = lokasi.first;
                                                  point = point;
                                                  _mapController.move(
                                                    LatLng(point.latitude,
                                                        point.longitude),
                                                    12,
                                                  );
                                                });
                                              }
                                            },
                                            center: userLocation,
                                            zoom: 15,
                                            maxZoom: 18,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.example.app',
                                            ),
                                            MarkerLayer(
                                              markers: [
                                                Marker(
                                                  point: userLocation,
                                                  width: 100,
                                                  height: 100,
                                                  builder: (context) =>
                                                      const Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
