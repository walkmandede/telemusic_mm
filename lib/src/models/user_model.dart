import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? mobile;
  final String artistVerifyStatus;
  final String? emailVerifiedAt;
  final String acceptTermAndPolicy;
  final int gender;
  final int planId;
  final String purchasedPlanDate;
  final String dob;
  final String image;
  final int status;
  final int role;
  final String address;
  final String createdAt;
  final String updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    required this.artistVerifyStatus,
    this.emailVerifiedAt,
    required this.acceptTermAndPolicy,
    required this.gender,
    required this.planId,
    required this.purchasedPlanDate,
    required this.dob,
    required this.image,
    required this.status,
    required this.role,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create a `User` object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String?,
      artistVerifyStatus: json['artist_verify_status'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      acceptTermAndPolicy: json['accept_term_and_policy'] as String,
      gender: json['gender'] as int,
      planId: json['plan_id'] as int,
      purchasedPlanDate: json['purchased_plan_date'] as String,
      dob: json['dob'] as String,
      image: json['image'] as String,
      status: json['status'] as int,
      role: json['role'] as int,
      address: json['address'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  bool xShouldShowPayment() {
    return role > 0;
  }

  /// Convert `User` object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'artist_verify_status': artistVerifyStatus,
      'email_verified_at': emailVerifiedAt,
      'accept_term_and_policy': acceptTermAndPolicy,
      'gender': gender,
      'plan_id': planId,
      'purchased_plan_date': purchasedPlanDate,
      'dob': dob,
      'image': image,
      'status': status,
      'role': role,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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
