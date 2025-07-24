enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  chat('/chat'),
  conversationChat('/conversation-chat'),
  planting('/planting'),
  myPlantings('/my-plantings'),
  impact('/impact'),
  subscription('/subscription');

  final String route;
  const NamedRoutes(this.route);
}
