import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(token != null ? const MyApp(isLoggedIn: true) : const MyApp(isLoggedIn: false));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPayload? loginPayload;
  LoginResponce? loginResponce;
  bool isLoading = true;
  bool obscureText = true;

  Future<void> getData() async {
    Response response = await http.post(Uri.parse("http://192.168.1.90:8080/our_villa/api/login"), body: {
      "device_token":
          "frcCgt7LQAG04FDD0zs1nX:APA91bFHBZbKAYkgKAUkjl7Cuwh-AArGdVgEQWdlyQ9ruG8MBoUzZUPsWQJV3Y5PAqwEzdKnbLAlzds0wm1BEYyngxU5O6X2DHIV0SjtSvdVOlpmtzJ9Tg5P3tFbDIeZPQnDruT7c9So",
      "device_type": "0",
      "email": emailController.text,
      "password": passwordController.text,
      "user_type": "0"
    });
    if (response.statusCode == 200) {
      loginResponce = LoginResponce.fromMap(jsonDecode(response.body));
      print("call api ${loginResponce?.responseCode}");
      if (loginResponce?.responseCode == 1) {
        print('login api call successfully:::-----${loginResponce?.responseData?.token}');
        // Save token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', loginResponce!.responseData!.token!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {}
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Email')),
              TextFormField(
                  obscureText: obscureText,
                  controller: passwordController,
                  validator: (val) => (val?.length ?? 0) < 6 ? 'Password too short.' : null,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ))),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await getData();
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to Home Page!'),
      ),
    );
  }
}
