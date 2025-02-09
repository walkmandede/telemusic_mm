import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/src/models/album_model.dart';
import 'package:telemusic_v2/src/models/artist_model.dart';
import 'package:telemusic_v2/src/models/blog_model.dart';
import 'package:telemusic_v2/src/models/category_model.dart';
import 'package:telemusic_v2/src/models/music_model.dart';
import 'package:telemusic_v2/src/models/plan_model.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:telemusic_v2/utils/services/network/api_end_points.dart';
import 'package:telemusic_v2/utils/services/network/api_request_model.dart';
import 'package:telemusic_v2/utils/services/network/api_response_model.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

enum EnumGetMusicTypes {
  artists(label: "Artists"),
  albums(label: "Albums"),
  genres(label: "Genres");

  final String label;
  const EnumGetMusicTypes({required this.label});
}

class ApiRepo {
  Future<List<ArtistModel>?> getTop50Artists() async {
    List<ArtistModel>? result;
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.getTop50Artists,
          ),
          xNeedToken: true);
      result = [];
      Iterable iterable = apiResponse.bodyData ?? [];
      for (final each in iterable) {
        result.add(ArtistModel.fromJson(json: each));
      }
    } catch (e) {
      result = null;
      superPrint(e);
    }
    return result;
  }

  Future<List<CategoryModel>?> getAllCategories() async {
    List<CategoryModel>? result;
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.musicCategories,
          ),
          xNeedToken: true);
      result = [];
      Iterable iterable = apiResponse.bodyData["data"] ?? [];

      for (final each in iterable) {
        result.add(CategoryModel.fromMap(data: each));
      }
    } catch (e) {
      result = null;
      superPrint(e);
    }
    return result;
  }

  Future<List<MusicModel>?> getMusicByCategory(
      {required String id, required String type}) async {
    List<MusicModel>? result;
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"id": id, "type": type},
            url: ApiEndPoints.getMusicListByCategory,
          ),
          xNeedToken: true);
      result = [];

      Iterable iterable = apiResponse.bodyData["data"] ?? [];

      for (final each in iterable) {
        result.add(MusicModel.fromJson(
            json: each,
            audioPath: apiResponse.bodyData["audioPath"].toString(),
            imagePath: apiResponse.bodyData["imagePath"].toString()));
      }
    } catch (e) {
      result = null;
      superPrint(e);
    }
    return result;
  }

  Future<List<AlbumModel>?> getAllAlbumsByCategory() async {
    List<AlbumModel>? result;
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: const {"type": "Albums", "_pageNumber": 1, "limit": 999999},
            url: ApiEndPoints.getMusic,
          ),
          xNeedToken: true);
      result = [];
      Iterable iterable = apiResponse.bodyData["sub_category"] ?? [];

      for (final each in iterable) {
        result.add(AlbumModel.fromJson(
            json: each,
            imagePath: apiResponse.bodyData["imagePath"].toString()));
      }
    } catch (e) {
      result = null;
      superPrint(e);
    }
    return result;
  }

  Future<List<MusicModel>?> searchMusicsByQuery({required String query}) async {
    List<MusicModel>? result;
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"search": query},
            url: ApiEndPoints.searchMusic,
          ),
          xNeedToken: true);
      result = [];
      Iterable data = apiResponse.bodyData["data"] ?? [];
      result = [
        ...data.map((each) => MusicModel.fromJson(
            json: each,
            imagePath: apiResponse.bodyData["imagePath"],
            audioPath: apiResponse.bodyData["audioPath"]))
      ];
    } catch (e) {
      result = null;
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> createAPlaylist({required String name}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"playlist_name": name},
            url: ApiEndPoints.createPlaylist,
          ),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> deletePlaylist({required String playlistId}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"playlist_id": playlistId},
            url: ApiEndPoints.deletePlaylist,
          ),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> addMusicToPlayList(
      {required String playlistId, required String musicId}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"music_id": musicId, "playlist_id": playlistId},
            url: ApiEndPoints.addMusicToPlaylist,
          ),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> removeMusicFromPlaylist(
      {required String playlistId, required String musicId}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.post,
            data: {"music_id": musicId, "playlist_id": playlistId},
            url: ApiEndPoints.removeMusicFromPlaylist,
          ),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> getAllPlaylists() async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.getPlaylist,
          ),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<List<PlanModel>> getAllPlans() async {
    List<PlanModel> result = [];
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.getAllPlans,
          ),
          xNeedToken: true);

      if (apiResponse.xSuccess) {
        String imagePath = apiResponse.bodyData["imagePath"] ?? "";
        Iterable data = apiResponse.bodyData["data"];
        if (data.isNotEmpty) {
          Iterable rawAllPlans = data.first["all_plans"] ?? [];
          for (final each in rawAllPlans) {
            result.add(PlanModel.fromJson(json: each, imagePath: imagePath));
          }
        }
      }
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> getMyPayment() async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      DataController dataController = Get.find();
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.getMyPayment,
              data: {"id": dataController.currentUser.value!.id.toString()}),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> updatePaymentMethod(
      {required String type,
      required String holderName,
      required String accountNumber}) async {
    // paymentMethodUpdate
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      DataController dataController = Get.find();
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.updateMyPayment,
              data: {
                "id": dataController.currentUser.value!.id.toString(),
                "payment_type": type,
                "payment_holder_name": holderName,
                "payment_value": accountNumber,
              }),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<List<MusicModel>> getHistory() async {
    List<MusicModel> result = [];
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.getHistory,
          ),
          xNeedToken: true);
      if (apiResponse.xSuccess) {
        Iterable rawData = apiResponse.bodyData["data"] ?? [];
        final imagePath = apiResponse.bodyData["imagePath"].toString();
        for (final each in rawData) {
          result.add(MusicModel.fromJson(
              json: each, imagePath: imagePath, audioPath: ""));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<List<MusicModel>> getFavorites() async {
    List<MusicModel> result = [];
    try {
      final apiResponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.getFavorites,
              data: const {"type": "audio"}),
          xNeedToken: true);
      if (apiResponse.xSuccess) {
        Iterable rawData = apiResponse.bodyData["data"] ?? [];
        final imagePath = apiResponse.bodyData["imagePath"].toString();
        for (final each in rawData) {
          result.add(MusicModel.fromJson(
              json: each, imagePath: imagePath, audioPath: ""));
        }
      }
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> toggleFavorite({required String musicId}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.addRemoveToFavorites,
              data: {"id": musicId, "type": "audio"}),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> toggleHistory(
      {required String musicId, required bool xAdd}) async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.addRemoveToHistory,
              data: {"music_id": musicId, "tag": xAdd ? "add" : "remove"}),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<List<BlogModel>> getBlogs() async {
    List<BlogModel> result = [];
    try {
      final apiReponse = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
            enumApiRequestMethods: EnumApiRequestMethods.get,
            url: ApiEndPoints.getBlogs,
          ),
          xNeedToken: true);
      if (apiReponse.xSuccess) {
        Iterable rawData = apiReponse.bodyData["data"]["blogs"] ?? [];
        result.addAll(rawData.map((e) => BlogModel.fromMap(data: e)));
      }
    } catch (e) {
      superPrint(e);
    }
    return result;
  }

  Future<ApiResponseModel> deleteAccount() async {
    ApiResponseModel result = ApiResponseModel.getInstance();
    DataController dataController = Get.find();
    try {
      result = await ApiService().makeARequest(
          apiRequestData: ApiRequestModel(
              enumApiRequestMethods: EnumApiRequestMethods.post,
              url: ApiEndPoints.deleteAccount,
              data: {
                "user_id": dataController.currentUser.value!.id.toString(),
              }),
          xNeedToken: true);
    } catch (e) {
      superPrint(e);
    }
    return result;
  }
}
