import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

class MusicDownloadModel extends Equatable {
  final String id;
  final String title;
  final String artists;
  final String downloadPath;

  const MusicDownloadModel(
      {required this.id,
      required this.title,
      required this.artists,
      required this.downloadPath});

  factory MusicDownloadModel.fromMap({required Map<String, dynamic> data}) {
    return MusicDownloadModel(
        id: data["id"].toString(),
        artists: data["artists"].toString(),
        downloadPath: data["downloadPath"].toString(),
        title: data["title"].toString());
  }

  factory MusicDownloadModel.fromJson({required String jsonString}) {
    return MusicDownloadModel.fromMap(data: jsonDecode(jsonString));
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "artists": artists,
      "downloadPath": downloadPath,
      "title": title
    };
  }

  String toJsonString() {
    return jsonEncode(toMap());
  }

  MediaItem convertToMediaItem() {
    return MediaItem(
        id: downloadPath,
        album: "-",
        title: title.toString(),
        artist: artists.toString(),
        artUri: Uri.parse(
            "https://cdn1.iconfinder.com/data/icons/music-filled-outline-5/64/Musical_Note-512.png"));
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, artists, downloadPath];
}
