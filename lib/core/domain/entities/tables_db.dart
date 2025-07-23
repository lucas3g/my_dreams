enum TablesDB {
  userDreams('user_dreams'),
  conversations('conversations'),
  messages('messages');

  final String name;
  const TablesDB(this.name);
}
