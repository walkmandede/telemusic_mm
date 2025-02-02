import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/utils/services/network/api_service.dart';

class PlanModel extends Equatable {
  final int id;
  final String image;
  final String planName;
  final String planAmount;
  final int isMonthDays;
  final int validity;
  final int isDownload;
  final int showAdvertisement;
  final String inAppPurchase;
  final String productId;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlanModel({
    required this.id,
    required this.image,
    required this.planName,
    required this.planAmount,
    required this.isMonthDays,
    required this.validity,
    required this.isDownload,
    required this.showAdvertisement,
    required this.inAppPurchase,
    required this.productId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating a Plan instance from JSON
  factory PlanModel.fromJson(
      {required Map<String, dynamic> json, required String imagePath}) {
    return PlanModel(
      id: json['id'],
      image: ApiService.baseUrlForFiles + imagePath + json['image'].toString(),
      planName: json['plan_name'],
      planAmount: json['plan_amount'],
      isMonthDays: json['is_month_days'],
      validity: json['validity'],
      isDownload: json['is_download'],
      showAdvertisement: json['show_advertisement'],
      inAppPurchase: json['in_app_purchase'],
      productId: json['product_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Plan instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'plan_name': planName,
      'plan_amount': planAmount,
      'is_month_days': isMonthDays,
      'validity': validity,
      'is_download': isDownload,
      'show_advertisement': showAdvertisement,
      'in_app_purchase': inAppPurchase,
      'product_id': productId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        image,
        planName,
        planAmount,
        isMonthDays,
        validity,
        isDownload,
        showAdvertisement,
        inAppPurchase,
        productId,
        status,
        createdAt,
        updatedAt,
      ];
}
