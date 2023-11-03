import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption {
  static final keyFernet = encrypt.Key.fromUtf8('my32lengthsecretkey:dimaraja1949');

  static final fernet = encrypt.Fernet(keyFernet);
  static final encrypterFernet = encrypt.Encrypter(fernet);

  static encrypt.Encrypted encryptFernet(text) {
    final encrypted = encrypterFernet.encrypt(text);
    return encrypted;
  }

  static String decryptFernet(encrypt.Encrypted encrypted) {
    return encrypterFernet.decrypt(encrypted);
  }
}
