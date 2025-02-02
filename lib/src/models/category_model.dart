import 'package:equatable/equatable.dart';
import 'package:telemusic_v2/src/models/sub_category_model.dart';

class CategoryModel extends Equatable {
  final String categoryName;
  final String imagePath;
  final List<SubCategoryModel> subCategories;

  const CategoryModel(
      {required this.categoryName,
      required this.imagePath,
      required this.subCategories});

  factory CategoryModel.fromMap({required Map<String, dynamic> data}) {
    final imagePath = data["imagePath"].toString();
    final Iterable rawSubCategories = data["sub_category"] ?? [];
    return CategoryModel(
        categoryName: data["cat_name"].toString(),
        imagePath: imagePath,
        subCategories: rawSubCategories
            .map((each) =>
                SubCategoryModel.fromJson(json: each, imagePath: imagePath))
            .toList());
  }

  @override
  List<Object?> get props => [categoryName, imagePath, subCategories];
}
