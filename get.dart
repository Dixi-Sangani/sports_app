import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'model/comman_model.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserData? apiDataModel;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  /// ------- get -------///
/*  getData() async {
    Response response = await http.get(Uri.parse("https://api.eatsconnect.com/api//v1/get-category"));
    if (response.statusCode == 200) {
      apiDataModel = ApiDataModel.fromMap(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
    }
    return;
  } */

  /// --------- post ----------///
  getData() async {
    Response response = await http.post(Uri.parse("https://api.eatsconnect.com/api/v1/post/get-post"), body: {
    "userId": "6580423757f85ec6d8e8bd14"

    });
    if (response.statusCode == 200) {
      apiDataModel = UserData.fromMap(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('api call'),
        ),
        body: !isLoading
            ? ListView.builder(itemCount: apiDataModel?.data?.posts?.length ?? 0, itemBuilder: (context, index) {
          return Text(
              "${apiDataModel?.data?.posts?[index].description}"
          );
        })
            : const Center(
          child: CircularProgressIndicator(),
        ));
  }
}