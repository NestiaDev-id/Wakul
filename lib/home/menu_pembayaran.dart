import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakul2/Data/makanan.dart';
import 'package:wakul2/controller/locationscontroller.dart';
import 'package:wakul2/controller/pembayaran.dart';
import 'package:wakul2/controller/users/userController.dart';
import 'package:wakul2/home/detail_screen_makanan.dart';
import 'package:wakul2/test2.dart';
import 'package:intl/intl.dart';

class MenuPembayaran extends StatefulWidget {
  final Map<String, dynamic> pangan;
  const MenuPembayaran({Key? key, required this.pangan}) : super(key: key);

  @override
  State<MenuPembayaran> createState() => _MenuPembayaranState();
}

class _MenuPembayaranState extends State<MenuPembayaran> {
  Position? currentPosition;
  String address = "";
  List<Placemark> lokasi = [];
  LatLng? point;
  Placemark? firstPlacemark;
  LocationController locationController = LocationController();
  TextEditingController catatanController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  PembayaranController controller = PembayaranController();
  TextEditingController jumlahOrderController = TextEditingController();
  TextEditingController tanggalOrderController = TextEditingController();
  TextEditingController waktuOrderController = TextEditingController();
  TextEditingController alamatPenerimaController = TextEditingController();
  TextEditingController totalHargaController = TextEditingController();
  TextEditingController productController = TextEditingController();

  int count = 1;
  var formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  DateTime? _dateTime = DateTime.now();
  DateTime? selectedTime;

  List<int> timeValues = [0, 1, 2, 3];
  String defaultTime = 'Pilih Waktu';

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

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dateTime = value;
          _dateController.text = DateFormat('dd-MM-yyyy').format(_dateTime!);
        });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreenFood(
                        pangan: widget.pangan,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.amber,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text('Konfirmasi Pembayaran'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Alamat Pengiriman',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LokasiState(),
                                ),
                              );
                            },
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                '${user?['username']}',
                                style: const TextStyle(fontSize: 10),
                              );
                            } else {
                              return const Text(
                                'Anonymus',
                                style: TextStyle(fontSize: 10),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: LocationController().streamLokasi(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return const Text('...');
                            }
                            Map<String, dynamic> userData =
                                snapshot.data!.data()!;
                            String userAddress = userData['address'];
                            return Text(
                              userAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.pangan["imageUrls"],
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.pangan["name"],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'Staatliches',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency
                                  .format(widget.pangan["price"] * count),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Staatliches',
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                CountdownWidget(
                                  pangan: widget.pangan,
                                  onCountChanged: (newCount) {
                                    setState(() {
                                      count = newCount;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.list_alt_outlined,
                                size: 30,
                              ),
                              Text(
                                'Point',
                                style: TextStyle(fontSize: 18),
                              ),
                              Spacer(),
                              Text(
                                '35000',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Catatan:'),
                              const Spacer(),
                              Expanded(
                                child: TextField(
                                  controller: catatanController,
                                  decoration: const InputDecoration(
                                    labelText: 'Masukkan catatan tambahan',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Total Pesanan ($count Makanan): '),
                              const Spacer(),
                              Text(
                                formatCurrency
                                    .format(widget.pangan["price"] * count),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            readOnly: true,
                            controller: _dateController,
                            onTap: () {
                              _showDatePicker();
                            },
                            decoration: InputDecoration(
                              labelText: 'Pilih Tanggal',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedTime != null
                                ? formatDateTime(selectedTime!)
                                : defaultTime,
                            onChanged: (value) {
                              setState(() {
                                if (value != defaultTime) {
                                  selectedTime = parseDateTime(value!);
                                } else {
                                  selectedTime = null;
                                }
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: defaultTime,
                                child: Text(defaultTime),
                              ),
                              for (int value in timeValues)
                                DropdownMenuItem<String>(
                                  value: formatDateTime(
                                      DateTime(2023, 1, 1, value * 3, 0)),
                                  child: Text(
                                    formatDateTime(
                                        DateTime(2023, 1, 1, value * 3, 0)),
                                  ),
                                ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Pilih Waktu',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Metode Pembayaran'),
                            TextButton(
                              onPressed: () {},
                              child: const Row(
                                children: [
                                  Text('BCA'),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal Pemesanan'),
                            Text('0'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Pengiriman'),
                            Text('0'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Biaya Lain-lain'),
                            Text('0'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.zero),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Harga',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              formatCurrency
                                  .format(widget.pangan["price"] * count),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.amber),
                          child: TextButton(
                            onPressed: () async {
                              String userAddress =
                                  await locationController.getUserAddress();
                              int jumlahOrder;

                              try {
                                jumlahOrder =
                                    int.parse(jumlahOrderController.text);
                              } catch (e) {
                                print('Invalid jumlahOrder: $e');
                                // Handle the error, e.g., set a default value or show a user message.
                              }
                              controller.addTransaction(
                                jumlahOrder = count,
                                tanggalOrderController.text =
                                    _dateController.text,
                                catatanController.text,
                                waktuOrderController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now()),
                                userAddress,
                                totalHargaController.text,
                                widget.pangan,
                              );
                            },
                            child: const Text(
                              'Bayar',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    int startHour = dateTime.hour;
    int endHour = (dateTime.hour + 3) % 24;
    String startPeriod = dateTime.hour < 12 ? 'AM' : 'PM';
    String endPeriod = endHour < 12 ? 'AM' : 'PM';

    return '$startHour $startPeriod - $endHour $endPeriod';
  }

  DateTime parseDateTime(String value) {
    if (value == defaultTime) {
      // Handle the case when the default time is selected
      // You can decide what DateTime value to return in this case
      return DateTime.now();
    }

    List<String> parts = value.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    }

    return DateTime(2023, 1, 1, hour, minute);
  }
}

class CountdownWidget extends StatefulWidget {
  final Map<String, dynamic> pangan;
  final void Function(int) onCountChanged;

  const CountdownWidget(
      {Key? key, required this.pangan, required this.onCountChanged})
      : super(key: key);

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  int count = 1;
  late int price;

  void increment() {
    setState(() {
      count++;
      price = widget.pangan["price"] * count;
      widget.onCountChanged(count);
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) {
        count--;
        price = widget.pangan["price"] * count;
        widget.onCountChanged(count);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: decrement,
          icon: const Icon(Icons.remove),
        ),
        Text(
          '$count',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          onPressed: increment,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
