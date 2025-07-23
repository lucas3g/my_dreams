enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  chat('/chat'),
  conversationChat('/conversation-chat'),
  planting('/planting'),
  myPlantings('/my-plantings'),
  impact('/impact');

  final String route;
  const NamedRoutes(this.route);
}
