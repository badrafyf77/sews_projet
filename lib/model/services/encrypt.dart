import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyEncryptionDecryption {
  static final keyFernet =
      encrypt.Key.fromUtf8(dotenv.env['MY_ENCREPTION_KEY']!);

  static final fernet = encrypt.Fernet(keyFernet);
  static final encrypterFernet = encrypt.Encrypter(fernet);

  static String encryptFernet(String text) {
    final encrypted = encrypterFernet.encrypt(text);
    return encrypted.base64;
  }

  static String decryptFernet(String text) {
    return encrypterFernet.decrypt(encrypt.Encrypted.fromBase64(text));
  }
}
