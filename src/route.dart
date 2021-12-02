import 'dart:io';

class Route {
  final String type;
  final String route;
  final Future<void> Function(HttpRequest _request) callback;

  Route(this.type, this.route, this.callback);

  @override
  String toString() {
    return route;
  }
}
