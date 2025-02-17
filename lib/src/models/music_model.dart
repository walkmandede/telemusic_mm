import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';

import '../../utils/services/network/api_service.dart';

class MusicModel extends Equatable {
  final int id;
  final String image;
  final String audioUrl;
  final String audioDuration;
  final String audioTitle;
  final String audioSlug;
  final String downloadPrice;
  final int audioGenreId;
  final List<int> artistIds;
  final String artistsName;
  final bool favourite;
  final int audioLanguage;
  final int listeningCount;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final DateTime createdAt;

  const MusicModel({
    required this.id,
    required this.image,
    required this.audioUrl,
    required this.audioDuration,
    required this.audioTitle,
    required this.audioSlug,
    required this.downloadPrice,
    required this.audioGenreId,
    required this.artistIds,
    required this.artistsName,
    required this.favourite,
    required this.audioLanguage,
    required this.listeningCount,
    required this.isFeatured,
    required this.isTrending,
    required this.isRecommended,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        image,
        audioUrl,
        audioDuration,
        audioTitle,
        audioSlug,
        downloadPrice,
        audioGenreId,
        artistIds,
        artistsName,
        favourite,
        audioLanguage,
        listeningCount,
        isFeatured,
        isTrending,
        isRecommended,
        createdAt,
      ];

  /// Factory constructor to create an instance from JSON
  factory MusicModel.fromJson(
      {required Map<String, dynamic> json,
      required String imagePath,
      required String audioPath}) {
    return MusicModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      image: ApiService.baseUrlForFiles + imagePath + json['image'].toString(),
      audioUrl: json['audio'].toString(),
      // audioUrl:
      //     ApiService.baseUrlForFiles + audioPath + json['audio'].toString(),
      audioDuration: json['audio_duration'].toString(),
      audioTitle: json['audio_title'].toString(),
      audioSlug: json['audio_slug'].toString(),
      downloadPrice: json['download_price'].toString(),
      audioGenreId: int.tryParse(json['audio_genre_id'].toString()) ?? 0,
      artistIds: List<int>.from(
        (json['artist_id']
            .toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)).toList(),
      ),
      artistsName: json['artists_name'].toString(),
      favourite: json['favourite'].toString() == "1",
      audioLanguage: int.tryParse(json['audio_language'].toString()) ?? 0,
      listeningCount: int.tryParse(json['listening_count'].toString()) ?? 0,
      isFeatured: int.tryParse(json['is_featured'].toString()) == 1,
      isTrending: int.tryParse(json['is_trending'].toString()) == 1,
      isRecommended: int.tryParse(json['is_recommended'].toString()) == 1,
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  /// Converts an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'audio': audioUrl,
      'audio_duration': audioDuration,
      'audio_title': audioTitle,
      'audio_slug': audioSlug,
      'download_price': downloadPrice,
      'audio_genre_id': audioGenreId,
      'artist_id': artistIds.toString(),
      'artists_name': artistsName,
      'favourite': favourite ? "1" : "0",
      'audio_language': audioLanguage,
      'listening_count': listeningCount,
      'is_featured': isFeatured ? 1 : 0,
      'is_trending': isTrending ? 1 : 0,
      'is_recommended': isRecommended ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MediaItem convertToMediaItem() {
    return MediaItem(
        id: audioUrl,
        album: "-",
        title: audioTitle.toString(),
        artist: artistsName.toString(),
        artUri: Uri.parse(image),
        duration: _convertToDurationInSeconds(audioDuration),
        extras: {"id": id.toString()});
  }

  factory MusicModel.fromMediaItem({required MediaItem mediaItem}) {
    return MusicModel(
        id: int.tryParse(mediaItem.extras!["id"].toString()) ?? 0,
        audioUrl: mediaItem.id,
        audioTitle: mediaItem.title,
        artistsName: mediaItem.artist!,
        image: mediaItem.artUri.toString(),
        audioDuration: mediaItem.duration!.inSeconds.toString(),
        artistIds: [],
        audioGenreId: 0,
        audioLanguage: 0,
        audioSlug: "",
        createdAt: DateTime(0),
        downloadPrice: "",
        favourite: false,
        isFeatured: false,
        isRecommended: false,
        isTrending: false,
        listeningCount: 0);
  }

  Duration _convertToDurationInSeconds(String time) {
    // Remove any unwanted newline characters and trim the string
    time = time.trim();

    // Split the time string by ':'
    List<String> timeParts = time.split(':');

    // Convert hours and minutes to integers
    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]);

    // Calculate the total duration in seconds
    int totalSeconds = (minutes * 60) + seconds;

    return Duration(seconds: totalSeconds);
  }
}
