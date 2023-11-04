// ignore_for_file: public_member_api_docs, sort_constructors_first

class Appareil {
  final String id;
  final String utilisateur;
  final String site;
  final String appareil;
  final String debutContrat;
  final String finContrat;
  final String a7;
  final String a8;
  final String a9;
  final String a10;
  final String a11;
  final String a12;
  final String a13;
  final String a14;
  final String a15;
  final String a16;
  final String a17;
  final String a18;
  final String a19;
  final String a20;

  Appareil(
    this.id,
    this.utilisateur,
    this.site,
    this.appareil,
    this.debutContrat,
    this.finContrat,
    this.a7,
    this.a8,
    this.a9,
    this.a10,
    this.a11,
    this.a12,
    this.a13,
    this.a14,
    this.a15,
    this.a16,
    this.a17,
    this.a18,
    this.a19,
    this.a20,
  );

  factory Appareil.fromJson(jsonData) {
    return Appareil(
      jsonData['a1'],
      jsonData['a2'],
      jsonData['a3'],
      jsonData['a4'],
      jsonData['a5'],
      jsonData['a6'],
      jsonData['a7'],
      jsonData['a8'],
      jsonData['a9'],
      jsonData['a10'],
      jsonData['a11'],
      jsonData['a12'],
      jsonData['a13'],
      jsonData['a14'],
      jsonData['a15'],
      jsonData['a16'],
      jsonData['a17'],
      jsonData['a18'],
      jsonData['a19'],
      jsonData['a20'],
    );
  }
}

class Historique {
  final String type;
  final int nmbrPiece;
  final DateTime date;
  final String time;
  final String icon;
  final String id;

  Historique(
    this.type,
    this.nmbrPiece,
    this.date,
    this.time,
    this.icon,
    this.id,
  );

  factory Historique.fromJson(jsonData) {
    return Historique(
      jsonData['Type'],
      jsonData['Nombre de pieces'],
      jsonData['Date'],
      jsonData['Time'],
      jsonData['Icon'],
      jsonData['Id'],
    );
  }
}

class User {
  String displayName;
  String email;
  String post;
  String passUser;
  String site;

  User(
    this.displayName,
    this.email,
    this.post,
    this.passUser,
    this.site,
  );

  factory User.fromJson(jsonData) {
    return User(
      jsonData['displayName'],
      jsonData['email'],
      jsonData['post'],
      jsonData['passUser'],
      jsonData['site'],
    );
  }
}

class EditArguments {
  final String siteIndex;
  final String siteValue;
  final String appareilIndex;
  final String appareilValue;
  final String site;

  EditArguments(
    this.siteIndex,
    this.siteValue,
    this.appareilIndex,
    this.appareilValue,
    this.site,
  );
}

class UserInfo {
  String displayName;
  String site;
  String idToken;
  String email;
  String password;

  UserInfo(
    this.displayName,
    this.site,
    this.idToken,
    this.email,
    this.password,
  );
}
