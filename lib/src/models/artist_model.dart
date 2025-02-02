import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/constants/app_svgs.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

enum EnumStreamChannel {
  amazon(
      label: "Amazon",
      backendEnum: "amazon_music_stream_rate",
      icon: AppSvgs.amazon),
  apple(
      label: "Apple Music",
      backendEnum: "apple_music_stream_rate",
      icon: AppSvgs.appleMusic),
  facebook(
      label: "Facebook",
      backendEnum: "facebook_stream_rate",
      icon: AppSvgs.facebookStream),
  iTune(
      label: "iTune",
      backendEnum: "itunes_stream_rate",
      icon: AppSvgs.iTunesStream),
  spotify(
      label: "Spotify",
      backendEnum: "spotify_stream_rate",
      icon: AppSvgs.spotifyStream),
  tiktok(
      label: "TikTok",
      backendEnum: "tiktok_stream_rate",
      icon: AppSvgs.tiktokStream),
  tidal(
      label: "Tidal",
      backendEnum: "tidal_stream_rate",
      icon: AppSvgs.tidalStream),
  youtube(
      label: "Youtube",
      backendEnum: "youtube_stream_rate",
      icon: AppSvgs.youtubeStream),
  youtubeMusic(
      label: "YT Music",
      backendEnum: "youtube_music_stream_rate",
      icon: AppSvgs.youtubeMusicStream),
  total(
      label: "Total",
      backendEnum: "total_stream_rate",
      icon: AppSvgs.totalStream);

  final String label;
  final String icon;
  final String backendEnum;

  const EnumStreamChannel(
      {required this.label, required this.icon, required this.backendEnum});
}

class ArtistModel extends Equatable {
  final int id;
  final String image;
  final String artistName;
  final String userId;
  final String artistSlug;
  final String? dob;
  final List<String> audioLanguageIds;
  final String? description;
  final String artistGenreId;
  final int listeningCount;
  final bool isFeatured;
  final bool isTrending;
  final bool isRecommended;
  final int status;
  final String createdAt;
  final String updatedAt;
  final Map<EnumStreamChannel, int> enumStreamChannelCountMap;
  final int customOrder;
  final String paymentType;
  final String paymentHolderName;
  final String paymentValue;
  final String totalPaymentValue;

  const ArtistModel({
    required this.id,
    required this.image,
    required this.artistName,
    required this.userId,
    required this.artistSlug,
    this.dob,
    required this.audioLanguageIds,
    this.description,
    required this.artistGenreId,
    required this.listeningCount,
    required this.isFeatured,
    required this.isTrending,
    required this.isRecommended,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.enumStreamChannelCountMap,
    required this.customOrder,
    required this.paymentType,
    required this.paymentHolderName,
    required this.paymentValue,
    required this.totalPaymentValue,
  });

/* amazonMusicStreamRate:
          int.tryParse(json['amazon_music_stream_rate'].toString()) ?? 0,
      appleMusicStreamRate:
          int.tryParse(json['apple_music_stream_rate'].toString()) ?? 0,
      facebookStreamRate:
          int.tryParse(json['facebook_stream_rate'].toString()) ?? 0,
      itunesStreamRate:
          int.tryParse(json['itunes_stream_rate'].toString()) ?? 0,
      spotifyStreamRate:
          int.tryParse(json['spotify_stream_rate'].toString()) ?? 0,
      tiktokStreamRate:
          int.tryParse(json['tiktok_stream_rate'].toString()) ?? 0,
      tidalStreamRate: int.tryParse(json['tidal_stream_rate'].toString()) ?? 0,
      youtubeStreamRate:
          int.tryParse(json['youtube_stream_rate'].toString()) ?? 0,
      youtubeMusicStreamRate:
          int.tryParse(json['youtube_music_stream_rate'].toString()) ?? 0,
      totalStreamRate: int.tryParse(json['total_stream_rate'].toString()) ?? 0,*/
  factory ArtistModel.fromJson({required Map<String, dynamic> json}) {
    Map<EnumStreamChannel, int> enumStreamChannelCountMap = {};
    for (final each in EnumStreamChannel.values) {
      enumStreamChannelCountMap[each] =
          int.tryParse(json[each.backendEnum].toString()) ?? 0;
    }
    return ArtistModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      image: ApiService.baseUrlForFiles +
          ApiService.basePathForArtistsImage +
          json['image'].toString(),
      artistName: json['artist_name'].toString(),
      userId: json['user_id'].toString(),
      artistSlug: json['artist_slug'].toString(),
      dob: json['dob'].toString(),
      audioLanguageIds: List<String>.from(json['audio_language_id'] != null
          ? (json['audio_language_id'].toString())
              .replaceAll(RegExp(r'[\[\]\"]'), '')
              .split(',')
          : []),
      description: json['description'].toString(),
      artistGenreId: json['artist_genre_id'].toString(),
      listeningCount: int.tryParse(json['listening_count'].toString()) ?? 0,
      isFeatured: (int.tryParse(json['is_featured'].toString()) ?? 0) == 1,
      isTrending: (int.tryParse(json['is_trending'].toString()) ?? 0) == 1,
      isRecommended:
          (int.tryParse(json['is_recommended'].toString()) ?? 0) == 1,
      status: int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      enumStreamChannelCountMap: enumStreamChannelCountMap,
      customOrder: int.tryParse(json['custom_order'].toString()) ?? 0,
      paymentType: json['payment_type'].toString(),
      paymentHolderName: json['payment_holder_name'].toString(),
      paymentValue: json['payment_value'].toString(),
      totalPaymentValue: json['total_payment_value'].toString(),
    );
  }

  /// Convert `ArtistModel` to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'artist_name': artistName,
      'user_id': userId,
      'artist_slug': artistSlug,
      'dob': dob,
      'audio_language_id': audioLanguageIds.toString(),
      'description': description,
      'artist_genre_id': artistGenreId,
      'listening_count': listeningCount,
      'is_featured': isFeatured ? 1 : 0,
      'is_trending': isTrending ? 1 : 0,
      'is_recommended': isRecommended ? 1 : 0,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'custom_order': customOrder,
      'payment_type': paymentType,
      'payment_holder_name': paymentHolderName,
      'payment_value': paymentValue,
      'total_payment_value': totalPaymentValue,
    };
  }

  @override
  List<Object?> get props => [
        id,
        image,
        artistName,
        userId,
        artistSlug,
        dob,
        audioLanguageIds,
        description,
        artistGenreId,
        listeningCount,
        isFeatured,
        isTrending,
        isRecommended,
        status,
        createdAt,
        updatedAt,
        customOrder,
        paymentType,
        paymentHolderName,
        paymentValue,
        totalPaymentValue,
      ];
}
