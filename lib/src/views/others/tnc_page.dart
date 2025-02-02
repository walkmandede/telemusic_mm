import 'package:flutter/material.dart';
import 'package:html_to_flutter/html_to_flutter.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:get/get.dart';

class TncPage extends StatefulWidget {
  const TncPage({super.key});

  @override
  State<TncPage> createState() => _TncPageState();
}

class _TncPageState extends State<TncPage> {
  DataController dataController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and conditions"),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: dataController.tncDetail,
        ),
      ),
    );
  }
}
