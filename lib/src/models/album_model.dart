import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

class AlbumModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String image;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final List<String> artistIds;
  final List<String> artists;

  const AlbumModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.isFeatured,
    required this.isTrending,
    required this.isRecommended,
    required this.artistIds,
    required this.artists,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        image,
        isFeatured,
        isTrending,
        isRecommended,
        artistIds,
        artists,
      ];

  /// Factory constructor to create an instance from JSON
  factory AlbumModel.fromJson(
      {required Map<String, dynamic> json, required String imagePath}) {
    List<dynamic> artistList = jsonDecode(json['artist_list']);
    final artistIds = artistList.map((e) => e.toString()).toList();
    return AlbumModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'].toString(),
      slug: json['slug'].toString(),
      image: ApiService.baseUrlForFiles + imagePath + json['image'].toString(),
      isFeatured: int.tryParse(json['is_featured'].toString()) == 1,
      isTrending: int.tryParse(json['is_trending'].toString()) == 1,
      isRecommended: int.tryParse(json['is_recommended'].toString()) == 1,
      artistIds: artistIds,
      artists: List<String>.from(json['artists'].map((e) => e.toString())),
    );
  }

  /// Converts an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'is_featured': isFeatured ? 1 : 0,
      'is_trending': isTrending ? 1 : 0,
      'is_recommended': isRecommended ? 1 : 0,
      'artist_list': artistIds.toString(),
      'artists': artists,
    };
  }
}
