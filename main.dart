import 'src/app_exports.dart';

void main(List<String> args) async {
  var app = App(8080);

  app.get('/', (request) async {
    request.send({"message": "Oi salve danigol"});
  });

  app.get('/:name', (request) async {
    request.send({
      'teste': [1, 2, 3, 4, 5, 6],
    });
  });

  app.post('/testePost', (request) async {
    var body = await request.body;
    print(body['oi']);

    request.send(body);
  });
  app.init();
}
