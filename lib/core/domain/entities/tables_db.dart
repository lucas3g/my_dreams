enum TablesDB {
  plantings('user_plantings'),
  userInfoWithPlantings('user_plantings_with_userinfo'),
  userDreams('user_dreams');

  final String name;
  const TablesDB(this.name);
}
