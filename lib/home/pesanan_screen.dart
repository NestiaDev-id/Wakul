// import 'package:flutter/material.dart';
// import 'package:wakul2/controller/pembayaran.dart';

// class PesananPagState extends StatefulWidget {
//   const PesananPagState({super.key});

//   @override
//   State<PesananPagState> createState() => _PesananPagStateState();
// }

// class _PesananPagStateState extends State<PesananPagState> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: StreamBuilder<List<Map<String, dynamic>>>(
//           stream: PembayaranController().fetchAllTransactions(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData || snapshot.data == null) {
//               return Center(child: const CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No data available.'));
//             }
//             var listAllMakanan = snapshot.data!;
//             print(listAllMakanan);
//             return ListView.builder(
//               scrollDirection: Axis.vertical,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 final Map<String, dynamic> orderData = listAllMakanan[index];
//                 final List<Map<String, dynamic>> products =
//                     orderData["products"];

// // Example accessing product data
//                 final Map<String, dynamic> productData = products[0];
//                 final String productName = productData["name"];
//                 final int productPrice =
//                     productData["price"]; // Example of accessing price
//                 final String productId =
//                     productData["idProduct"]; // Example of accessing idProduct

//                 return InkWell(
//                   onTap: () {
//                     // Uncomment the navigation code when needed
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) {
//                     //       return DetailScreenFood(
//                     //         // Pass relevant data to the detail screen
//                     //         productName: productName,
//                     //         productImageUrl: productImageUrl,
//                     //       );
//                     //     },
//                     //   ),
//                     // );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       top: 5,
//                       left: 10.0,
//                       right: 10,
//                       bottom: 5,
//                     ),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * 0.12,
//                       decoration: BoxDecoration(
//                         border: Border.all(),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           // Example of loading an image from the network
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: Image.network(
//                               productImageUrl,
//                               height: 100,
//                               width: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   productName,
//                                   style: const TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               itemCount: listAllMakanan.length,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
