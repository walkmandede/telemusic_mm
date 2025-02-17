import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String audioDownloadList;
  final String email;
  final String artistVerifyStatus;
  final String? emailVerifiedAt;
  final int acceptTermAndPolicy;
  final String? mobile;
  final int gender;
  final int planId;
  final String purchasedPlanDate;
  final String dob;
  final String image;
  final int status;
  final int role;
  final String address;
  final String billingDetail;
  final String countryId;
  final String stateId;
  final String cityId;
  final String braintreeId;
  final String pincode;
  final String? createdAt;
  final String? updatedAt;
  final String planExpiryDate;
  final int inAppPurchase;
  final Map<String, dynamic> planDetail;
  final int download;
  final int ads;
  final String currencyCode;
  final String currencySymbol;
  final String tax;
  final String adminRzpKey;
  final String adminRzpSecret;
  final String paymentType;
  final String googleApiKey;
  final String ytChannelKey;
  final String ytCountryCode;
  final int isYoutube;
  final String appLanguage;

  const UserModel({
    required this.id,
    required this.name,
    required this.audioDownloadList,
    required this.email,
    required this.artistVerifyStatus,
    this.emailVerifiedAt,
    required this.acceptTermAndPolicy,
    this.mobile,
    required this.gender,
    required this.planId,
    required this.purchasedPlanDate,
    required this.dob,
    required this.image,
    required this.status,
    required this.role,
    required this.address,
    required this.billingDetail,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.braintreeId,
    required this.pincode,
    this.createdAt,
    this.updatedAt,
    required this.planExpiryDate,
    required this.inAppPurchase,
    required this.planDetail,
    required this.download,
    required this.ads,
    required this.currencyCode,
    required this.currencySymbol,
    required this.tax,
    required this.adminRzpKey,
    required this.adminRzpSecret,
    required this.paymentType,
    required this.googleApiKey,
    required this.ytChannelKey,
    required this.ytCountryCode,
    required this.isYoutube,
    required this.appLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: int.tryParse(data['id'].toString()) ?? 0,
      name: data['name'].toString(),
      audioDownloadList: data['audio_download_list'].toString(),
      email: data['email'].toString(),
      artistVerifyStatus: data['artist_verify_status'].toString(),
      emailVerifiedAt: data['email_verified_at']?.toString(),
      acceptTermAndPolicy:
          int.tryParse(data['accept_term_and_policy'].toString()) ?? 0,
      mobile: data['mobile']?.toString(),
      gender: int.tryParse(data['gender'].toString()) ?? 0,
      planId: int.tryParse(data['plan_id'].toString()) ?? 0,
      purchasedPlanDate: data['purchased_plan_date'].toString(),
      dob: data['dob'].toString(),
      image: data['image'].toString(),
      status: int.tryParse(data['status'].toString()) ?? 0,
      role: int.tryParse(data['role'].toString()) ?? 0,
      address: data['address'].toString(),
      billingDetail: data['billing_detail'].toString(),
      countryId: data['country_id'].toString(),
      stateId: data['state_id'].toString(),
      cityId: data['city_id'].toString(),
      braintreeId: data['braintree_id'].toString(),
      pincode: data['pincode'].toString(),
      createdAt: data['created_at']?.toString(),
      updatedAt: data['updated_at']?.toString(),
      planExpiryDate: data['plan_expiry_date'].toString(),
      inAppPurchase: int.tryParse(data['in_app_purchase'].toString()) ?? 0,
      planDetail: data['plan_detail'] ?? {},
      download: int.tryParse(data['download'].toString()) ?? 0,
      ads: int.tryParse(data['ads'].toString()) ?? 0,
      currencyCode: data['currencyCode'].toString(),
      currencySymbol: data['currencySymbol'].toString(),
      tax: data['tax'].toString(),
      adminRzpKey: data['admin_rzp_key'].toString(),
      adminRzpSecret: data['admin_rzp_secret'].toString(),
      paymentType: data['payment_type'].toString(),
      googleApiKey: data['google_api_key'].toString(),
      ytChannelKey: data['yt_channel_key'].toString(),
      ytCountryCode: data['yt_country_code'].toString(),
      isYoutube: int.tryParse(data['is_youtube'].toString()) ?? 0,
      appLanguage: data['app_language'].toString(),
    );
  }

  bool xShouldShowPayment() {
    return role > 0;
  }

  bool xShouldShowDownload() {
    return download > 0;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        mobile,
        artistVerifyStatus,
        emailVerifiedAt,
        acceptTermAndPolicy,
        gender,
        planId,
        purchasedPlanDate,
        dob,
        image,
        status,
        role,
        address,
        createdAt,
        updatedAt,
      ];

  String getNameInitials() {
    if (name.isEmpty) return "";

    // Split the name by spaces
    List<String> nameParts = name.split(' ');

    // Map each part to its first character and join them
    String initials = nameParts
        .where((part) => part.isNotEmpty) // Ensure no empty parts
        .map((part) => part[0].toUpperCase())
        .join();

    return initials;
  }

  bool xPremium() {
    return planId > 0;
  }
}
