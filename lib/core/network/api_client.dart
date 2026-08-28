import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../errors/app_error.dart';
import '../storage/secure_storage_service.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int statusCode;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    required this.statusCode,
  });
}

class ApiClient extends GetxService {
  static ApiClient get to => Get.find();
  
  late String _baseUrl;
  final Duration _timeout = const Duration(seconds: 20);

  Future<ApiClient> init() async {
    _baseUrl = AppConfig.current.baseUrl;
    return this;
  }

  Map<String, String> _buildHeaders({Map<String, String>? customHeaders}) {
    final token = SecureStorageService.to.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      var uri = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams.map((k, v) => MapEntry(k, v.toString())));
      }
      final response = await http.get(uri, headers: _buildHeaders(customHeaders: headers)).timeout(_timeout);
      return _processResponse(response);
    } on TimeoutException {
      throw AppError(message: 'Request timed out. Please try again.', type: ErrorType.timeout);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError.network(e.toString());
    }
  }

  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final response = await http
          .post(
            uri,
            headers: _buildHeaders(customHeaders: headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);
      return _processResponse(response);
    } on TimeoutException {
      throw AppError(message: 'Request timed out. Please try again.', type: ErrorType.timeout);
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError.network(e.toString());
    }
  }

  ApiResponse<dynamic> _processResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic bodyData;
    try {
      bodyData = jsonDecode(response.body);
    } catch (_) {
      bodyData = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse(
        success: true,
        message: bodyData is Map ? (bodyData['message'] ?? 'Success') : 'Success',
        data: bodyData,
        statusCode: statusCode,
      );
    } else if (statusCode == 401) {
      throw AppError.unauthorized();
    } else if (statusCode == 404) {
      throw AppError(message: 'Resource not found', statusCode: 404, type: ErrorType.notFound);
    } else {
      final msg = bodyData is Map ? (bodyData['message'] ?? bodyData['error'] ?? 'Server error') : 'Server error ($statusCode)';
      throw AppError.server(msg.toString(), statusCode);
    }
  }
}
