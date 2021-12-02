import 'dart:convert';
import 'dart:io';

import 'route.dart';

class App {
  App(this.port);

  HttpServer? _server;
  Map<String, Route> _routes = {};
  final int port;

  // List<Route> get routes => _routes;

  void init() {
    HttpServer.bind('127.0.0.1', port).then((server) {
      _server = server;
      _server!.listen((request) async {
        await _handleRequest(request);
      });
    });
  }

  void get(
    String route,
    Future<void> Function(HttpRequest _request) callback,
  ) {
    _routes.addAll(
      {'$route GET': Route('GET', route, callback)},
    );
  }

  void post(
    String route,
    Future<void> Function(HttpRequest _request) callback,
  ) {
    _routes.addAll(
      {'$route POST': Route('POST', route, callback)},
    );
  }

  Future<void> _handleRequest(HttpRequest request) async {
    bool returned = false;
    String key = '${request.uri.path} ${request.method}';

    if (_routes.containsKey(key)) {
      Route route = _routes[key]!;
      returned = true;
      await route.callback(request);
    }
    if (!returned) {
      request.response.statusCode = 404;
      request.send({'error': '${request.uri.path} not found'});
    }
  }
}

extension HttpRequestExtensions on HttpRequest {
  Future<void> send(Object? object) async {
    this.response.write(json.encode(object));
    await this.response.flush();
    this.response.close();
  }

  dynamic get body async {
    var _body = await utf8.decodeStream(this);

    return json.decode(_body);
  }
}
