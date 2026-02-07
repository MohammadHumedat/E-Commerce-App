import 'package:flutter/material.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.productCount,
    required this.imgURL,
    this.bgColor,
    this.textColor,
  });
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      productCount: map['productCount'] ?? 0,
      imgURL: map['imgURL']?.toString() ?? '',
      bgColor: _parseColor(map['bgColor']),
      textColor: _parseColor(map['textColor']),
    );
  }
  static Color? _parseColor(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return Color(value);
    }

    if (value is String) {
      if (value.startsWith('0x') || value.startsWith('0X')) {
        final colorInt = int.tryParse(value);
        return colorInt != null ? Color(colorInt) : null;
      }

      final colorInt = int.tryParse(value);
      return colorInt != null ? Color(colorInt) : null;
    }

    return null;
  }

  final String id;
  final String name;
  final int productCount;
  final Color? bgColor;
  final Color? textColor;
  final String imgURL;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'productCount': productCount,
      'imgURL': imgURL,
      'bgColor': bgColor,
      'textColor': textColor,
    };
  }
}

List<CategoryModel> dummyCategory = [
  CategoryModel(
    id: '1',
    name: 'Electronics',
    productCount: 125,
    imgURL:
        'https://images.unsplash.com/photo-1591238372408-8b98667c0460?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    bgColor: const Color(0xFFE0F7FA),
    textColor: const Color.fromARGB(255, 0, 0, 0),
  ),
  CategoryModel(
    id: '2',
    name: 'Fashion',
    productCount: 210,
    imgURL:
        'https://plus.unsplash.com/premium_photo-1664202526559-e21e9c0fb46a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
    bgColor: const Color(0xFFFFF3E0),
    textColor: Colors.black,
  ),
  CategoryModel(
    id: '3',
    name: 'Home & Kitchen',
    productCount: 98,
    imgURL:
        'https://images.unsplash.com/photo-1694885169022-3d88c594a3ad?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
    bgColor: const Color(0xFFE8F5E9),
    textColor: Colors.black,
  ),
  CategoryModel(
    id: '4',
    name: 'Beauty',
    productCount: 150,
    imgURL:
        'https://plus.unsplash.com/premium_photo-1684407616442-8d5a1b7c978e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8QmVhdXR5fGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    bgColor: const Color(0xFFFFEBEE),
    textColor: Colors.black,
  ),
  CategoryModel(
    id: '5',
    name: 'Sports',
    productCount: 80,
    imgURL:
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
    bgColor: const Color(0xFFE3F2FD),
    textColor: Colors.black,
  ),
  CategoryModel(
    id: '6',
    name: 'Groceries',
    productCount: 65,
    imgURL:
        'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1074',
    bgColor: const Color(0xFFF1F8E9),
    textColor: Colors.black,
  ),
];
