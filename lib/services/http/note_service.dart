
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notesapp_flutter/configs/api_config.dart';
import 'package:notesapp_flutter/models/response_model.dart';
import 'package:notesapp_flutter/services/storage/shared_storage.dart';

class NoteService {
  final String _baseUrl = "${ApiConfig.baseUrl}/notes";
  
  Future<ResponseModel> getNotes() async {
    final String? accessToken = await SharedStorageService.getAccessToken();
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
    );
    return ResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<ResponseModel> saveNote({
    required String title, required String tags, required String body
  }) async {
    // merubah string to list dipisahkan dengan coma dan menghapus spasi
    List tagsList = tags.split(",").map((tag) => tag.trim()).toList();

    final String? accessToken = await SharedStorageService.getAccessToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
      body: jsonEncode({
        "title": title,
        "tags": tagsList,
        "body": body,
      }),
    );

    return ResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<ResponseModel> getDetailNote({required String noteId}) async {
    final String? accessToken = await SharedStorageService.getAccessToken();

    String url = "$_baseUrl/$noteId";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
    );

    return ResponseModel.fromJson(jsonDecode(response.body));
  }

  Future<ResponseModel> deleteNotes({required String noteId }) async {
    final String? accessToken = await SharedStorageService.getAccessToken();

    // https://notesapi.caniget.my.id:443/notes/{id}
    String url = "$_baseUrl/$noteId";
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
    );

    return ResponseModel.fromJson(jsonDecode(response.body));
  }
}