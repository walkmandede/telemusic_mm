import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:telemusic_v2/src/views/_common/image_placeholder_widget.dart';
import 'music_model.dart'; // Import your existing MusicModel

class PlaylistModel extends Equatable {
  final int id;
  final int userId;
  final String playlistName;
  final List<MusicModel> songList;
  final String createdAt;
  final String updatedAt;

  const PlaylistModel({
    required this.id,
    required this.userId,
    required this.playlistName,
    required this.songList,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory PlaylistModel.fromJson(
      {required Map<String, dynamic> json,
      required String imagePath,
      required String audioPath}) {
    return PlaylistModel(
      id: json['id'],
      userId: json['user_id'],
      playlistName: json['playlist_name'],
      songList: (json['song_list'] as List)
          .map((songJson) => MusicModel.fromJson(
              json: songJson, audioPath: audioPath, imagePath: imagePath))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Widget? getCoverImage() {
    Widget? result;
    if (songList.isNotEmpty) {
      result = CachedNetworkImage(
        imageUrl: songList.first.image,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const ImagePlaceholderWidget();
        },
      );
    }
    return result;
  }

  // Override the props to make the model work with Equatable
  @override
  List<Object?> get props => [
        id,
        userId,
        playlistName,
        songList,
        createdAt,
        updatedAt,
      ];
}
