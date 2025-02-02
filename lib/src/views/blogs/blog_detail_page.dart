import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_to_flutter/html_to_flutter.dart';
import 'package:telemusic_v2/src/models/blog_model.dart';
import 'package:telemusic_v2/utils/constants/app_constants.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogModel blogModel;
  const BlogDetailPage({super.key, required this.blogModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blogModel.title),
        centerTitle: false,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          CachedNetworkImage(
            imageUrl: blogModel.image,
            width: Get.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.basePadding,
                vertical: AppConstants.basePadding),
            child: Html(data: blogModel.detail),
          ),
        ],
      ),
    );
  }
}
