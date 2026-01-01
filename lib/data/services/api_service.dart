import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/range_model.dart';

class RangeApiService {
  static const _url =
      'https://nd-assignment.azurewebsites.net/api/get-ranges';

  static const _token =
      'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

  Future<List<RangeModel>> fetchRanges() async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => RangeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load ranges');
    }
  }
}
