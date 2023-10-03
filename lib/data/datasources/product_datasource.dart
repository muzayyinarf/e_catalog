import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:e_catalog/data/models/request/product_request_model.dart';
import 'package:e_catalog/data/models/response/product_response_model.dart';
import 'package:e_catalog/data/models/response/upload_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDataSource {
  Future<Either<String, List<ProductResponseModel>>> getAllProduct() async {
    final response =
        await http.get(Uri.parse('https://api.escuelajs.co/api/v1/products/'));
    if (response.statusCode == 200) {
      return Right(
        List<ProductResponseModel>.from(
          jsonDecode(response.body).map(
            (x) => ProductResponseModel.fromMap(x),
          ),
        ),
      );
    } else {
      return const Left('get product error');
    }
  }

  Future<Either<String, List<ProductResponseModel>>> getPaginationProduct(
      {required int offset, required int limit}) async {
    final response = await http.get(Uri.parse(
        'https://api.escuelajs.co/api/v1/products/?offset=$offset&limit=$limit'));
    if (response.statusCode == 200) {
      return Right(
        List<ProductResponseModel>.from(
          jsonDecode(response.body).map(
            (x) => ProductResponseModel.fromMap(x),
          ),
        ),
      );
    } else {
      return const Left('get product error');
    }
  }

  Future<Either<String, ProductResponseModel>> createProduct(
      ProductRequestModel model) async {
    final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/products/'),
        body: model.toJson(),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      final responseModel = ProductResponseModel.fromJson(response.body);
      debugPrint(responseModel.toString());
      return Right(responseModel);
    } else {
      return const Left('error add product');
    }
  }

  Future<Either<String, UploadResponseModel>> uploadImage(XFile image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.escuelajs.co/api/v1/files/upload'),
    );
    final bytes = await image.readAsBytes();
    final multipartFile =
        http.MultipartFile.fromBytes('file', bytes, filename: image.name);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    final Uint8List responseList = await response.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (response.statusCode == 201) {
      return Right(UploadResponseModel.fromJson(jsonDecode(responseData)));
    } else {
      return const Left('error add product');
    }
  }
}
