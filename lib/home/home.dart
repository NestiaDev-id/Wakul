import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:latlong2/latlong.dart';
import 'package:wakul2/controller/locationscontroller.dart';
import 'package:wakul2/controller/products/products.dart';
import 'package:wakul2/controller/users/userController.dart';
import 'appbar/appbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wakul2/home/detail_screen_category.dart';
import 'package:wakul2/Data/kategori.dart';

import 'package:wakul2/home/detail_screen_makanan.dart';
import 'package:wakul2/Data/makanan.dart';

import 'package:wakul2/home/detail_screen_toko.dart';
import 'package:wakul2/Data/toko.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPosition;
  LatLng? point;
  String address = "";
  List<Placemark> lokasi = [];
  Placemark? firstPlacemark;
  bool shimmer = true;
  bool hasInternet = true;
  var formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  Future<void> checkInternetConnection() async {
    // Simulate some asynchronous operation
    await Future.delayed(const Duration(seconds: 3));

    // Check if the widget is still mounted
    if (!mounted) return;

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
    } else {
      setState(() {
        hasInternet = true;
        // getCurrentPosition();
      });
    }

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        shimmer = false;
      });
    }
  }

  // getCurrentPosition() async {
  //   Position position = await determite();
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //     position.latitude,
  //     position.longitude,
  //   );

  //   setState(() {
  //     point = LatLng(position.latitude, position.longitude);
  //     if (placemarks.isNotEmpty) {
  //       firstPlacemark = placemarks.first;
  //     }
  //   });
  // }

  // Future<Position> determite() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('error');
  //     }
  //   }

  //   return await Geolocator.getCurrentPosition();
  // }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasInternet) {
      return const Center(
        child: Text("Your internet is broken."),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          const Text('Antar Ke '),
                          Expanded(
                            child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                              stream: LocationController().streamLokasi(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('Data is null');
                                }
                                Map<String, dynamic> userData =
                                    snapshot.data!.data()!;

                                String userAddress = userData['address'];
                                return Text(
                                  userAddress,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1, aspectRatio: 50 / 17),
                        items: [
                          "images/banner-1.webp",
                          "images/banner3 2.png",
                          "images/banner-2.webp",
                          "images/banner3 3.png",
                        ].map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Image.asset(
                                      i,
                                      fit: BoxFit.cover,
                                    )),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Kategori'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Row(
                          children: [
                            Expanded(
                              child: StreamBuilder<QuerySnapshot<Object?>>(
                                stream:
                                    MakananController().streamKategoriMakanan(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        children: List.generate(
                                          5,
                                          (index) => Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    var listAllMakanan = snapshot.data!.docs;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot<
                                                Map<String, dynamic>> document =
                                            listAllMakanan[index]
                                                as DocumentSnapshot<
                                                    Map<String, dynamic>>;

                                        final Map<String, dynamic> data =
                                            document.data()!;

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreenCategory(
                                                        kategori: document.id,
                                                        data: document.data()!),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                height: 50,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              (listAllMakanan[index]
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>)[
                                                                  "bannerImageUrls"]["banner2"],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        (listAllMakanan[index]
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>)[
                                                            "name"],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: listAllMakanan.length,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rekomendasi Minuman'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Row(
                          children: [
                            Expanded(
                              child: StreamBuilder<QuerySnapshot<Object?>>(
                                stream: MakananController().streamMinuman(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        children: List.generate(
                                          5,
                                          (index) => Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    var listAllMakanan = snapshot.data!.docs;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot<
                                                Map<String, dynamic>> document =
                                            listAllMakanan[index]
                                                as DocumentSnapshot<
                                                    Map<String, dynamic>>;

                                        final Map<String, dynamic> data =
                                            document.data()!;

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DetailScreenFood(
                                                    pangan: data,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            (listAllMakanan[index]
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)[
                                                                "imageUrls"],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      (listAllMakanan[index]
                                                              .data()
                                                          as Map<String,
                                                              dynamic>)["name"],
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      formatCurrency.format(
                                                          (listAllMakanan[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              "price"]),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: listAllMakanan.length,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rekomendasi Snack'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Row(
                          children: [
                            Expanded(
                              child: StreamBuilder<QuerySnapshot<Object?>>(
                                stream: MakananController().streamSnack(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        children: List.generate(
                                          // Adjust the number of shimmer items as needed
                                          5,
                                          (index) => Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    var listAllMakanan = snapshot.data!.docs;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot<
                                                Map<String, dynamic>> document =
                                            listAllMakanan[index]
                                                as DocumentSnapshot<
                                                    Map<String, dynamic>>;

                                        final Map<String, dynamic> data =
                                            document.data()!;

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DetailScreenFood(
                                                    pangan: data,
                                                  );
                                                },
                                              ),
                                            );
                                            print(data);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            (listAllMakanan[index]
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)[
                                                                "imageUrls"],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      (listAllMakanan[index]
                                                              .data()
                                                          as Map<String,
                                                              dynamic>)["name"],
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      formatCurrency.format(
                                                          (listAllMakanan[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              "price"]),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: listAllMakanan.length,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rekomendasi Makanan'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Row(
                          children: [
                            Expanded(
                              child: StreamBuilder<QuerySnapshot<Object?>>(
                                stream: MakananController().streamMakanan(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        children: List.generate(
                                          // Adjust the number of shimmer items as needed
                                          5,
                                          (index) => Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    var listAllMakanan = snapshot.data!.docs;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot<
                                                Map<String, dynamic>> document =
                                            listAllMakanan[index]
                                                as DocumentSnapshot<
                                                    Map<String, dynamic>>;

                                        final Map<String, dynamic> data =
                                            document.data()!;

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DetailScreenFood(
                                                    pangan: data,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              child: Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            (listAllMakanan[index]
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>)[
                                                                "imageUrls"],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      (listAllMakanan[index]
                                                              .data()
                                                          as Map<String,
                                                              dynamic>)["name"],
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      formatCurrency.format(
                                                          (listAllMakanan[index]
                                                                      .data()
                                                                  as Map<String,
                                                                      dynamic>)[
                                                              "price"]),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: listAllMakanan.length,
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kunjungi Toko Terdekatmu!'),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Lihat Lebih Banyak',
                              style: TextStyle(fontSize: 10),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final Toko toko = tokoList[index];
                                  if (shimmer) {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white,
                                      highlightColor: Colors.transparent,
                                      child: InkWell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: Container(
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DetailScreenToko(toko: toko);
                                        }));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: AspectRatio(
                                                    aspectRatio: 1.3,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: Image.network(
                                                        toko.imageUrls[0],
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(
                                                        toko.name,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        toko.address,
                                                        style: const TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                itemCount: tokoList.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Produk Unggulan')],
                        ),
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SizedBox(
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        'images/makan1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Ayam Bakar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Wayahae House',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SizedBox(
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        'images/makan1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Ayam Bakar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Wayahae House',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SizedBox(
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        'images/makan1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Ayam Bakar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Wayahae House',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SizedBox(
                                    width: 150,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      child: Image.asset(
                                        'images/makan1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Ayam Bakar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Wayahae House',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const CustomAppBar(),
          ],
        ),
      ),
    );
  }
}
