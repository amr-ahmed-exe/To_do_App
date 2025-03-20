import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/Core/network/end_points.dart';

import 'api_response.dart';

class APIHelper {
  // singleton
  static final APIHelper _apiHelper = APIHelper._internal();

  factory APIHelper() {
    addInterceptors();
    return _apiHelper;
  }

  APIHelper._internal();

  // declaring dio
  static late Dio dio;
  static void addInterceptors() {
    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseURL,
        connectTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // ignore: avoid_print
          print("Headers : ${options.headers.toString()}");
          // ignore: avoid_print
          print("data : ${(options.data as FormData).fields.toString()}");
          // ignore: avoid_print
          print("method : ${options.method}");
          // ignore: avoid_print
          print("EndPoint : ${options.path}");
          return handler.next(options); // Continue request
        },
      ),
    );
  }

  // get request

  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await dio.get(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: await getDefaultOptions(isAuthorized: isAuthorized),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // post

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var options = await getDefaultOptions(isAuthorized: isAuthorized);
      var response = await dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: options,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      // ignore: avoid_print
      print("-----Error ${e.toString()}");
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: await getDefaultOptions(isAuthorized: isAuthorized),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: await getDefaultOptions(isAuthorized: isAuthorized),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<Options> getDefaultOptions({required bool isAuthorized}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return Options(
      headers: {
        if (isAuthorized)
          "Authorization": "Bearer ${prefs.getString('access_token')}",
      },
    );
  }
}
