import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoverLoadingWidget extends StatelessWidget {
  const DiscoverLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
