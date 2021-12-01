import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  var app = App(8080);

  app.get('/', (request) {
    request.send({"message": "Oi thauanny"});
  });
}

class App {
  App(int port) {
    HttpServer.bind('127.0.0.1', port).then((server) {
      _server = server;
      _server!.listen((request) {
        routes.forEach((e) {
          if (e.route == request.uri.path && e.type == request.method) {
            e.callback(request);
          } else {
            request.response.statusCode = 404;
            request.send('Route not found!');
          }
        });
        request.response.close();
      });
    });
  }

  HttpServer? _server;
  List<Route> _routes = [];

  List<Route> get routes => _routes;

  void get(
    String route,
    Function(HttpRequest _request) callback,
  ) {
    _routes.add(
      Route('GET', route, callback),
    );
  }
}

class Route {
  final String type;
  final String route;
  final Function(HttpRequest _request) callback;

  Route(this.type, this.route, this.callback);

  @override
  String toString() {
    return route;
  }
}

extension HttpRequestExtensions on HttpRequest {
  void send(Object? object) {
    this.response.write(json.encode(object));
    this.response.close();
  }
}
