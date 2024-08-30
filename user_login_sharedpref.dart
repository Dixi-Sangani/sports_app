import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginController extends GetxController {
  var usernameController = ''.obs;
  var emailController = ''.obs;
  var storedUsername = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedUsername.value = prefs.getString('username') ?? '';

    if (storedUsername.isNotEmpty) {
      Get.off(() => HomeScreen());
    } else {
      Get.off(() => LoginScreen());
    }
  }

  Future<void> _storeUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  void login() {
    String username = usernameController.value.trim();
    String email = emailController.value.trim();

    if (storedUsername.isNotEmpty) {
      if (storedUsername.value == username) {
        Get.snackbar('Error', 'Username already exists.');
      } else {
        _storeUsername(username).then((_) {
          Get.off(() => HomeScreen());
        });
      }
    } else {
      _storeUsername(username).then((_) {
        Get.off(() => HomeScreen());
      });
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    Get.off(() => LoginScreen());
  }
}



class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => controller.usernameController.value = value,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              onChanged: (value) => controller.emailController.value = value,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}



class HomeScreen extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(LoginController());

    return GetMaterialApp(
      title: 'Flutter Login',
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()), // Placeholder until navigation is decided
      ),
    );
  }
}