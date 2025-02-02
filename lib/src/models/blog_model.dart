import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

class BlogModel extends Equatable {
  final String id;
  final String title;
  final String detail;
  final String image;

  const BlogModel({
    required this.id,
    required this.title,
    required this.image,
    required this.detail,
  });

  factory BlogModel.fromMap({required Map<String, dynamic> data}) {
    return BlogModel(
        id: data["id"].toString(),
        title: data["title"].toString(),
        detail: data["detail"].toString(),
        image: "${ApiService.baseUrlForFiles}images/blogs/${data["image"]}");
  }

  @override
  List<Object?> get props => [id, title, detail, image];
}
