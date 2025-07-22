enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  dream('/dream'),
  dreamChat('/dream-chat'),
  planting('/planting'),
  myPlantings('/my-plantings'),
  impact('/impact');

  final String route;
  const NamedRoutes(this.route);
}
