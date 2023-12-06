// Useful for working with bytes (Uint8List).
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

// Cryptographic libraries
import "package:pointycastle/asymmetric/api.dart"; // RSA
import 'package:encrypt/encrypt.dart' as encrypt; // Main lib
import 'package:crypto/crypto.dart'; // Hashing functions

import 'package:dio/dio.dart';

// We use this class to authenticate with Lanis' Encryption and decrypt things.
class Cryptor {
  static const int passphraseSize = 46; // 184 bits like Lanis Passphrase
  late encrypt.Key key; // authenticate()
  bool authenticated = false;
  late Dio dio;

  Future<RSAPublicKey?> getPublicKey() async {
    try {
      final response = await dio.post(
        "https://start.schulportal.hessen.de/ajax.php",
        queryParameters: {"f": "rsaPublicKey"},
        options: Options(
          headers: {
            "Accept": "*/*",
            "Content-Type":
            "application/x-www-form-urlencoded; charset=UTF-8",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
          },
        ),
      );
      return encrypt.RSAKeyParser().parse(jsonDecode(response.toString())["publickey"]) as RSAPublicKey;
    } on (SocketException, DioException) {
      return null;
    }
  }

  Future<String?> handshake(String encryptedKey) async {
    try {
      final response = await dio.post(
        "https://start.schulportal.hessen.de/ajax.php",
        queryParameters: {"f": "rsaHandshake", "s": Random().nextInt(2000)},
        data: {"key": encryptedKey},
        options: Options(
          headers: {
            "Accept": "*/*",
            "Content-Type":
            "application/x-www-form-urlencoded; charset=UTF-8",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
          },
        ),
      );
      return jsonDecode(response.toString())["challenge"];
    } on (SocketException, DioException) {
      return null;
    }
  }

  encrypt.Key generateKey() {
    final generatedKey = encrypt.Key.fromSecureRandom(passphraseSize);

    /* Lanis uses this string (UUID) which has 184 bits (46 chars):
    *       xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx-xxxxxx3xx
    *  and replaces x and y with a (pseudo-)random number.
    *  We can just generate random chars because it doesn't matter.
    *  And it is even cryptographically safe, not like Lanis.
    */

    return generatedKey;
  }

  Uint8List encryptKey(RSAPublicKey publicKey) {
    final rsa = encrypt.RSA(publicKey: publicKey, encoding: encrypt.RSAEncoding.PKCS1);
    return rsa.encrypt(key.bytes).bytes;
  }

  bool checkForEqualEncryption(Uint8List challenge) {
    final decryptedChallenge = decrypt(challenge);
    return base64.encode(decryptedChallenge!) == base64.encode(key.bytes);
  }

  // Lanis uses jCryption, a old unmaintained js encryption library, which uses CryptoJS.
  // This is a dart implementation of OpenSSL's EVP_BytesToKey, which CryptoJS uses.
  // https://www.openssl.org/docs/man3.1/man3/EVP_BytesToKey.html
  // NOTE: This is deprecated and should only be used for compatibility.
  // https://gist.github.com/suehok/dfc4a6989537e4a3ba4058669289737f
  Uint8List bytesToKeys(Uint8List salt) {
    Uint8List concatenatedHashes = Uint8List(0);
    Uint8List currentHash = Uint8List(0);
    bool enoughBytesForKey = false;
    Uint8List preHash = Uint8List(0);

    while (!enoughBytesForKey) {
      if (currentHash.isNotEmpty) {
        preHash = Uint8List.fromList(
            currentHash + key.bytes + salt);
      } else {
        preHash = Uint8List.fromList(
            key.bytes + salt);
      }

      currentHash = md5.convert(preHash).bytes as Uint8List;
      concatenatedHashes = Uint8List.fromList(concatenatedHashes + currentHash);
      if (concatenatedHashes.length >= 48) enoughBytesForKey = true;
    }

    return concatenatedHashes;
  }

  String encryptString(String decryptedData) {
    final salt = encrypt.SecureRandom(8).bytes;

    final derivedKeyAndIV = bytesToKeys(salt);

    final derivedKey = encrypt.Key(derivedKeyAndIV.sublist(0, 32));
    final derivedIV = encrypt.IV(derivedKeyAndIV.sublist(32, 48));

    // CBC mode isn't the best anymore.
    final aes = encrypt.Encrypter(encrypt.AES(derivedKey, mode: encrypt.AESMode.cbc, padding: "PKCS7"));

    final encryptedData = aes.encrypt(decryptedData, iv: derivedIV).bytes;

    final finalEncrypted = utf8.encode("Salted__") + salt + encryptedData;

    return base64.encode(finalEncrypted);
  }

  List<int>? decrypt(Uint8List encryptedDataWithSalt) {
    final encryptedData = encrypt.Encrypted.fromBase64(base64.encode(encryptedDataWithSalt.sublist(16)));

    // 0 to 8 is "Salted__" in ASCII. If this doesn't exists then something is wrong.
    if ("Salted__" != utf8.decode(encryptedDataWithSalt.sublist(0, 8))) {
      return null;
    }

    final salt = encryptedDataWithSalt.sublist(8, 16);

    final derivedKeyAndIV = bytesToKeys(salt);

    final derivedKey = encrypt.Key(derivedKeyAndIV.sublist(0, 32));
    final derivedIV = encrypt.IV(derivedKeyAndIV.sublist(32, 48));

    // CBC mode isn't the best anymore.
    final aes = encrypt.Encrypter(encrypt.AES(derivedKey, mode: encrypt.AESMode.cbc));

    return aes.decryptBytes(encryptedData, iv: derivedIV);
  }

  // Use this to get a readable string for humans™. If you get null then something is wrong.
  String? decryptString(String encryptedData) {
    final decryptedBytes = decrypt(base64.decode(encryptedData));

    if (decryptedBytes != null) {
      return utf8.decode(decryptedBytes);
    }

    return null;
  }

  String decryptEncodedTags(String htmlString) {
    // Definiere das Muster für das <encoded> Tag
    RegExp exp = RegExp(r'<encoded>(.*?)<\/encoded>');

    // Verwende die replaceAll-Funktion, um alle Übereinstimmungen zu ersetzen
    String replacedHtml = htmlString.replaceAllMapped(exp, (match) {
      // Extrahiere den Inhalt zwischen <encoded> und </encoded>
      String? encodedContent = match.group(1);

      // Entschlüssle den Inhalt und ersetze das Tag
      String? decryptedContent = decryptString(encodedContent!);

      // Gib den ersetzen String zurück
      return decryptedContent ?? "";
    });

    return replacedHtml;
  }


  // Use this to start allowing Lanis to return encrypted messages.
  Future<int> start(Dio dioClient) async {
    dio = dioClient;

    key = generateKey();

    final publicKey = await getPublicKey();

    if (publicKey == null) {
      return -3;
    }

    final encryptedKey = encryptKey(publicKey);

    final challenge = await handshake(base64.encode(encryptedKey));

    if (challenge == null) {
      return -3;
    }

    final equal = checkForEqualEncryption(base64.decode(challenge));

    if (equal) {
      authenticated = true;
      return 0;
    }

    return -6;
  }
}