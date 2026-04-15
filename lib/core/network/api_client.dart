import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_provider.dart';
import 'loading_provider.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;
  AuthProvider? _authProvider;
  LoadingProvider? _loadingProvider;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    // Normalize Base URL (handle trailing slashes) matching React config.js logic
    String baseUrl = 'https://be-lens.onrender.com/api';
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Handle global loading state unless 'silent' is passed in extra
        final bool isSilent = options.extra['silent'] == true;
        if (!isSilent && _loadingProvider != null) {
          _loadingProvider!.startLoading();
        }

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        
        // Don't add token for login request (consistent with React ApiClient.js line 21)
        if (token != null && token.isNotEmpty && !options.path.contains('/auth/login')) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final bool isSilent = response.requestOptions.extra['silent'] == true;
        if (!isSilent && _loadingProvider != null) {
          _loadingProvider!.stopLoading();
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        final bool isSilent = e.requestOptions.extra['silent'] == true;
        if (!isSilent && _loadingProvider != null) {
          _loadingProvider!.stopLoading();
        }

        final status = e.response?.statusCode;
        final data = e.response?.data;
        final message = (data is Map) ? (data['message']?.toString().toLowerCase() ?? '') : '';

        // 401 Unauthorized OR 403 with 'session' in message logic from React (line 50)
        if (status == 401 || (status == 403 && message.contains('session'))) {
          if (_authProvider != null) {
            _authProvider!.logout();
          }
        }
        return handler.next(e);
      },
    ));
  }

  void init(AuthProvider auth, LoadingProvider loading) {
    _authProvider = auth;
    _loadingProvider = loading;
  }
}

final apiClient = ApiClient();
