import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/famille_membre.dart';
import 'api_client.dart';

/// Toutes les opérations sur les membres de la famille (table `famille_membre`).
class FamilleService {
  static String get _url => '${ApiConfig.baseUrl}/famille-membres';
  static const _jsonHeaders = {'Content-Type': 'application/json'};

  /// GET /famille-membres — liste de tous les membres.
  static Future<List<FamilleMembre>> getAll() async {
    final body = await callApi(() => http.get(Uri.parse(_url)));
    final list = (body['data'] as List?) ?? [];
    return list
        .map((e) => FamilleMembre.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /famille-membres/{id} — un seul membre.
  static Future<FamilleMembre> getById(int id) async {
    final body = await callApi(() => http.get(Uri.parse('$_url/$id')));
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// POST /famille-membres — ajout (JSON sans photo, form-data avec photo).
  static Future<FamilleMembre> create(FamilleMembre m, {XFile? image}) async {
    final body = image == null
        ? await callApi(() => http.post(Uri.parse(_url),
            headers: _jsonHeaders, body: jsonEncode(m.toFields())))
        : await _multipart(_url, m, image);
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Modification : PUT (JSON) si la photo ne change pas,
  /// POST form-data si on envoie une nouvelle photo.
  static Future<FamilleMembre> update(FamilleMembre m, {XFile? image}) async {
    final url = '$_url/${m.id}';
    final body = image == null
        ? await callApi(() => http.put(Uri.parse(url),
            headers: _jsonHeaders, body: jsonEncode(m.toFields())))
        : await _multipart(url, m, image);
    return FamilleMembre.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// DELETE /famille-membres/{id}
  static Future<void> delete(int id) async {
    await callApi(() => http.delete(Uri.parse('$_url/$id')));
  }

  /// Envoi en multipart/form-data (texte + fichier image).
  static Future<Map<String, dynamic>> _multipart(
      String url, FamilleMembre m, XFile image) async {
    final bytes = await image.readAsBytes();
    return callApi(() async {
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(m.toFields())
        ..files.add(
            http.MultipartFile.fromBytes('image', bytes, filename: image.name));
      return http.Response.fromStream(await request.send());
    });
  }
}
