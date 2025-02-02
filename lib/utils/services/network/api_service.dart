import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:telemusic_v2/src/controllers/data_controller.dart';
import 'package:telemusic_v2/utils/constants/app_functions.dart';
import 'package:http/http.dart' as http;
import 'package:telemusic_v2/utils/services/network/api_response_model.dart';
import 'api_request_model.dart';

class ApiService {
  static String baseUrl = "https://dash.telemusic.io/public/api/v1/";
  static String baseUrlForFiles = "https://dash.telemusic.io/public/";
  static String basePathForArtistsImage = "images/artist/";

  static String getNetworkImage({required String path}) {
    return baseUrl + path;
  }

  Future<ApiResponseModel> makeARequest(
      {required ApiRequestModel apiRequestData,
      bool xNeedToken = false}) async {
    ApiResponseModel apiResponseModel = ApiResponseModel.getInstance();
    apiRequestData.url = baseUrl + apiRequestData.url;
    DataController dataController = Get.find();
    apiRequestData.headers = {
      "Content-Type": "application/json",
      if (xNeedToken) "authorization": "Bearer ${dataController.apiToken}"
    }..addAll(apiRequestData.headers ?? {});
    try {
      switch (apiRequestData.enumApiRequestMethods) {
        case EnumApiRequestMethods.get:
          apiResponseModel = convertHttpResponseIntoApiResponseModel(
              httpResponse: await _getRequest(apiRequestData: apiRequestData));
          break;
        case EnumApiRequestMethods.post:
          apiResponseModel = convertHttpResponseIntoApiResponseModel(
              httpResponse: await _postRequest(apiRequestData: apiRequestData));
          break;
        case EnumApiRequestMethods.put:
          apiResponseModel = convertHttpResponseIntoApiResponseModel(
              httpResponse: await _getRequest(apiRequestData: apiRequestData));
          break;
        case EnumApiRequestMethods.patch:
          apiResponseModel = convertHttpResponseIntoApiResponseModel(
              httpResponse: await _getRequest(apiRequestData: apiRequestData));
          break;
        case EnumApiRequestMethods.delete:
          apiResponseModel = convertHttpResponseIntoApiResponseModel(
              httpResponse: await _getRequest(apiRequestData: apiRequestData));
          break;
      }
    } catch (exception) {
      superPrint(exception);
    }
    return apiResponseModel;
  }

  static Future<bool> checkInternet() async {
    if (kIsWeb) {
      return true;
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        return false;
      }
      return false;
    }
  }

  ApiResponseModel convertHttpResponseIntoApiResponseModel(
      {required http.Response httpResponse}) {
    ApiResponseModel apiResponseModel = ApiResponseModel.getInstance();
    try {
      apiResponseModel.bodyData = jsonDecode(httpResponse.body);

      apiResponseModel.bodyString = httpResponse.body;
      apiResponseModel.statusCode = httpResponse.statusCode;
      apiResponseModel.xSuccess = apiResponseModel.bodyData["status"] ?? false;
      apiResponseModel.message = apiResponseModel.bodyData["msg"] ?? "-";
    } catch (e) {
      superPrint(e, title: "Converting HTTP Response to Api Response Model");
    }
    return apiResponseModel;
  }

  Future<http.Response> _getRequest(
      {required ApiRequestModel apiRequestData}) async {
    return http.get(
      Uri.parse(apiRequestData.url),
      headers: apiRequestData.headers,
    );
  }

  Future<http.Response> _postRequest(
      {required ApiRequestModel apiRequestData}) async {
    return http.post(
      Uri.parse(apiRequestData.url),
      body: jsonEncode(apiRequestData.data),
      headers: apiRequestData.headers,
    );
  }
}
