class JsonUser {
  String status;

  JsonUser({    this.status,  });

  factory JsonUser.fromJson(Map<String, dynamic> parsedJson) {
    //Map json = parsedJson['user'];
    return JsonUser(
      status: parsedJson['status_text'],
    );
  }
}