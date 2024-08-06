

String cutUserName(String username, String length) {
  username = username.toLowerCase();
  String userName = '';
  int splitUsernameLength = username.trim().split(RegExp(r'\s+')).length;
  List<String> un = username.split(' ');

  switch (length) {
    case '1':
      userName = un[0];
      break;
    case '2':
      if (splitUsernameLength < 3) {
        userName = username;
      } else if (splitUsernameLength == 3) {
        userName = un[0] + ' ' + un[1];
      } else {
        userName = un[0] + ' ' + un[2];
      }
      break;
  }

  String name = '';
  userName.split(' ').forEach((U) {
    name += (U[0].toUpperCase() + U.substring(1)) + ' ';
  });

  return name.trim();
}