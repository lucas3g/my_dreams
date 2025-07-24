enum NamedRoutes {
  splash('/'),
  auth('/auth'),
  home('/home'),
  chat('/chat'),
  conversationChat('/conversation-chat'),
  subscription('/subscription');

  final String route;
  const NamedRoutes(this.route);
}
