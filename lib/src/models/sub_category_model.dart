import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

class SubCategoryModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String image;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final dynamic data;
  final Map<EnumStreamChannel, int> streamCounts;

  const SubCategoryModel(
      {required this.id,
      required this.name,
      required this.slug,
      required this.image,
      required this.isFeatured,
      required this.isTrending,
      required this.isRecommended,
      this.streamCounts = const {},
      this.data});

  /// Factory constructor to create a `GenreModel` from JSON
  factory SubCategoryModel.fromJson(
      {required Map<String, dynamic> json, required String imagePath}) {
    return SubCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      image: ApiService.baseUrlForFiles + imagePath + json['image'].toString(),
      isFeatured: (json['is_featured'] as int) == 1,
      isTrending: (json['is_trending'] as int) == 1,
      isRecommended: (json['is_recommended'] as int) == 1,
    );
  }

  /// Convert `GenreModel` object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'is_featured': isFeatured ? 1 : 0,
      'is_trending': isTrending ? 1 : 0,
      'is_recommended': isRecommended ? 1 : 0,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        image,
        isFeatured,
        isTrending,
        isRecommended,
      ];
}
