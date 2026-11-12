import 'package:http/http.dart' as http;

class HttpClient extends http.BaseClient {
  final String baseUrl = 'http://localhost:3000';
  final http.Client _inner;
  String? _token;

  HttpClient({http.Client? client, String? token})
    : _inner = client ?? http.Client(),
      _token = token;

  String? get token => _token;

  void setToken(String? token) {
    _token = token;
  }

  Uri uri(String path) => Uri.parse('$baseUrl$path');

  final Map<String, String> JSON = {'content-type': 'application/json'};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (_token != null && _token!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
