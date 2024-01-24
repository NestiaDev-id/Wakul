import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:wakul2/form/login.dart';
import 'package:wakul2/home/navbar/navbar.dart';
import 'package:wakul2/splash.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyAzQ6PxuStrvF9Ms4ceaN0WZH5Qf9tSq-s",
//       appId: "1:555655192664:android:0fe6c8457ae62ccfa1ea2d",
//       messagingSenderId: "555655192664",
//       projectId: "ujicoba-firebase2",
//       authDomain: "ujicoba-firebase2.firebaseapp.com",
//       storageBucket: "ujicoba-firebase2.appspot.com",
//     ),
//   );

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const SplashScreen();
//           }

//           if (snapshot.hasData) {
//             // User is logged in
//             return const CustomNavBar();
//           } else {
//             // User is not logged in
//             return FutureBuilder(
//               future: Future.wait([
//                 // _initializeFirebase(),
//                 getCurrentPosition(),
//                 Future.delayed(const Duration(seconds: 5)),
//               ]),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const SplashScreen();
//                 } else {
//                   // return const LoginPage();
//                   return const GetMaterialApp(
//                     home: LoginPage(),
//                   );
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAzQ6PxuStrvF9Ms4ceaN0WZH5Qf9tSq-s",
      appId: "1:555655192664:android:0fe6c8457ae62ccfa1ea2d",
      messagingSenderId: "555655192664",
      projectId: "ujicoba-firebase2",
      authDomain: "ujicoba-firebase2.firebaseapp.com",
      storageBucket: "ujicoba-firebase2.appspot.com",
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            // User is logged in
            return const CustomNavBar();
          } else {
            // User is not logged in
            return const LoginPage();
          }
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Wakul',
    //   home: LoginPage(),
    // );
    return FutureBuilder(
      future: Future.wait([
        // _initializeFirebase(),
        getCurrentPosition(),
        Future.delayed(const Duration(seconds: 3)),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else {
          return const GetMaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        }
      },
    );
  }
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

Future<void> getCurrentPosition() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('error');
    }
  }

  Position position = await Geolocator.getCurrentPosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  if (placemarks.isNotEmpty) {
    print(placemarks.first);
  }
}
