import 'user.dart';

class FetchUsersResult {
  List<User> users = const [];
  int? totalUsers;

  FetchUsersResult(this.users, this.totalUsers);
}
