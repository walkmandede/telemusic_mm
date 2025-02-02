import 'package:equatable/equatable.dart';

class ApiResponseModel extends Equatable {
  int statusCode;
  dynamic bodyData;
  String? bodyString;
  String message;
  bool xSuccess;
  List<String> messageList;

  ApiResponseModel(
      {required this.statusCode,
      required this.bodyData,
      required this.bodyString,
      required this.message,
      required this.messageList,
      required this.xSuccess});

  factory ApiResponseModel.getInstance() {
    return ApiResponseModel(
        bodyData: null,
        bodyString: null,
        message: "",
        statusCode: 0,
        xSuccess: false,
        messageList: []);
  }

  @override
  List<Object?> get props => [xSuccess, statusCode, bodyData, message];
}
