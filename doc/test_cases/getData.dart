Future<void> fetchData(codes) async {
  int counter = 0;
  var toReturn = <Future>[];
  for (var item in codes) {
    var thread = Future(() async {
      var response = await dio
          .get('https://store.steampowered.com/api/appdetails?appids=$item');
      var data = response.data;
    });
    toReturn.add(thread);
    counter++;
  }
  await Future.wait(toReturn);
}
