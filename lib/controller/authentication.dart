import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:wakul2/form/login.dart';
import 'package:wakul2/home/navbar/navbar.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final String apiUrl = 'http://10.10.48.105:9000';
  final String registerEndpoint = '/api/register';
  final String loginEndpoint = '/api/login';
  final token = ''.obs;
  final errorMessage = ''.obs;
  final loginMessage = ''.obs;

  final box = GetStorage();

  Future<String> getIpAddress() async {
    var response = await http.get(Uri.parse('https://ipinfo.io/ip'));
    if (response.statusCode == 200) {
      return response.body.trim();
    } else {
      throw Exception('Failed to get IP address');
    }
  }

  Future<void> registrasi({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'username': username,
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse(apiUrl + registerEndpoint),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        // loginMessage.value = "Registration Succesful";
        Get.snackbar("Register Status", "Register Succesful");
        Get.to(() => const LoginPage());
        // print(loginMessage.value);
      } else {
        isLoading.value = false;
        // errorMessage.value =
        //     "Registration failed. Status code: ${response.statusCode}";
        Get.snackbar("Register Status",
            "Register failed. Status code ${response.statusCode}");
        // print(errorMessage.value);
      }
    } catch (e) {
      isLoading.value = false;
      // errorMessage.value = "Registration failed due to an exception: $e";
      // print(errorMessage.value);
      Get.snackbar(
          "Register Status", "Register failed due to an exception: $e");
    }
  }

  Future login({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'username': username,
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse(apiUrl + loginEndpoint),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);

        Get.offAll(() => const CustomNavBar());
      } else {
        isLoading.value = false;
        // loginMessage.value =
        //     "Login failed. Status code: ${response.statusCode}";
        // print(loginMessage.value);
        Get.snackbar("Login Status",
            "Login failed. Status code: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      // loginMessage.value = "Login failed due to an exception: $e";
      // print(loginMessage.value);
      Get.snackbar("Login Status", "Login failed due to an exception: $e");
    }
  }
}
