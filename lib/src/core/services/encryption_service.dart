import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';

class HybridEncryptionResult {
  final Map<String, String> payloadForServer;
  final Uint8List aesKeyBytes;
  final Uint8List ivBytes;
  HybridEncryptionResult({
    required this.payloadForServer,
    required this.aesKeyBytes,
    required this.ivBytes,
  });
}

class EncryptionService {
  static const String rsaPublicKeyPem = '''
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2as2CrVXOxvz2Ax2NFDP
8tANogZ2z5eC9SKDc5f+Ix1BEsFaDI9so7eVRZf3Kw2y6BsbLoubYtqCxom9lAJM
9MHQ4V0XgqiscRy6/7Pypp4/SjMB+D4nQzUITuQHcM0HamQriYMcNuuKCL5fE3SJ
ji09hfnOYSrO7bOeoBJWSQbbseZy/WJzl+35oAZPb4L3HYZWxEazbthaRE5TyHFO
AFd4wmIc4qRcY9rxIdDRA5kuiv89UvBHH6kk+SE+/mayZP5qZ1a5JusyLoZIY6zR
bqxi908ZCPG3GsLNJOT3dDPb5SDBJXqwKxce5pQKOjBw021nqLZ+C4RemyljG7uP
+wIDAQAB
-----END PUBLIC KEY-----
''';

  static const String rsaPrivateKeyPem = '''
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA2as2CrVXOxvz2Ax2NFDP8tANogZ2z5eC9SKDc5f+Ix1BEsFa
DI9so7eVRZf3Kw2y6BsbLoubYtqCxom9lAJM9MHQ4V0XgqiscRy6/7Pypp4/SjMB
+D4nQzUITuQHcM0HamQriYMcNuuKCL5fE3SJji09hfnOYSrO7bOeoBJWSQbbseZy
/WJzl+35oAZPb4L3HYZWxEazbthaRE5TyHFOAFd4wmIc4qRcY9rxIdDRA5kuiv89
UvBHH6kk+SE+/mayZP5qZ1a5JusyLoZIY6zRbqxi908ZCPG3GsLNJOT3dDPb5SDB
JXqwKxce5pQKOjBw021nqLZ+C4RemyljG7uP+wIDAQABAoIBABHp2rk34lVtf/xk
TigRDIQVpkGS2Z1NAUyOShYtyI74Pd4+xlvpQ84XcjP3hTJoXrRmYq7Kc3/HruKK
/GydYdr0xm19nU0193cZn7QiiZI3zMqc9wkIiG+qAiSH9KrOXNFfLAwVm7FTYhlF
HYr62MU4KOuJOvhZLw117lSLHcnFnVmVkjiFzHJX9ZmRoCFxc9ccRw4oXcnmkwMs
7gm+kYWzQMyjPiMD5f1k9mvxiF7rQQLei+qdn4yo+3VY6nzpZBce8X8oOzkS0fv8
PhRWxCynXhZeWEIW//C96WnQEcJ1C51icEvfJSQIdKMhdUrUsDzjWSbAAtEMjbVD
wBXh6DECgYEA8pnUEcgiZVffFn40Hc0CCIRu1PteA8ltwFwShl9KEOK9rXomdDs5
VErF+HzlJwdJDBdufXEv4YZqX7WphABzDcmi+6zS0Nv2Q8dXL7Y5IsIFaVCNZGB/
wqvdDK2do5gmx83JKTdsOZpmowbo0MlmQcR2NKJ/oDiV56J5MK+ivtECgYEA5bDd
KFE6yd7tKpaxGgSVzY9I6OF/0NW959UDYXHDVkJTQwRDBsmja1UaZBWsvB6NgnFO
4QEfrJGByO0ozgJ9hwMc8JxLEwUoeZogWwdztJZpwhtPHsqzyWUmiJbqIKTiAEEb
wX5+bnC3qqtt+Zxc9vOlTCDbovD7k5PT/gnwzQsCgYAO8aTbl41u2rPWSd3h/A/l
AGtnWTiYWR8Wm1VUy6ffVGhEuGKIBGHqrFR3kxH2jn9UbFkVBxTg+ouw65rOk8yC
i+orQKEX1oTb9fqL6NiqKHN24kxjY4JbNoT+U++C9UtmQWnjzRMwlS8/WZybx9wx
ru1tHploADRTuXFnq1oGEQKBgQC0q3/qXKqfa4il/U5lJsImpNQ2ylldjSMJnlZA
adm6mgUgK9QFHMo8fP57R0lN18J7nmDrP5UIipPJ1jJIiVDvyBUVdfrfhSknLYLR
13S90apykkST9eGhQr0ip4KWFtvmU1BfzP3qJSNzTdD9jG7bmR6mWRoqet+IX7la
k7sjrQKBgQCV5FqCoZ2TGptykGztZewLU/SbbdlEQtty67yzBQKHJlJmDKMI9rRr
cVX/B17Zcoy96lU2kmImFPxbXkodo6WxkO76xn0CEeE+7W5FSeykAFczkXoM8pMi
0c0FSj2fFG0nUGUXua8PyB0qflAeOFesYoLkvAzDMLKx3Y2VGL6DoA==
-----END RSA PRIVATE KEY-----
''';

  static Uint8List base64ToBytes(String base64Str) => base64.decode(base64Str);
  static String bytesToBase64(Uint8List bytes) => base64.encode(bytes);

  static Uint8List pkcs7Pad(Uint8List data, int blockSize) {
    final pad = blockSize - (data.length % blockSize);
    final padded = Uint8List(data.length + pad)..setAll(0, data);
    for (int i = data.length; i < padded.length; i++) {
      padded[i] = pad;
    }
    return padded;
  }

  static Uint8List pkcs7Unpad(Uint8List padded) {
    if (padded.isEmpty) {
      throw ArgumentError('Padded data is empty. Decryption might have failed.');
    }
    
    final pad = padded.last;
    if (pad < 1 || pad > 16) {
      print('Warning: Invalid PKCS7 padding value ($pad). Data might be corrupted or key might be wrong.');
      // Return raw data if padding looks invalid, or throw
      return padded; 
    }
    
    if (pad > padded.length) {
      throw ArgumentError('Invalid PKCS7 padding: pad value ($pad) greater than data length (${padded.length})');
    }
    
    return padded.sublist(0, padded.length - pad);
  }

  static Uint8List aesCbcEncrypt(Uint8List plainData, Uint8List key, Uint8List iv) {
    final cipher = CBCBlockCipher(AESFastEngine());
    final params = ParametersWithIV(KeyParameter(key), iv);
    cipher.init(true, params);
    final padded = pkcs7Pad(plainData, cipher.blockSize);
    final output = Uint8List(padded.length);
    for (int offset = 0; offset < padded.length; offset += cipher.blockSize) {
      cipher.processBlock(padded, offset, output, offset);
    }
    return output;
  }

  static Uint8List aesCbcDecrypt(Uint8List cipherData, Uint8List key, Uint8List iv) {
    if (cipherData.isEmpty) {
      throw ArgumentError('Cipher data cannot be empty');
    }
    final cipher = CBCBlockCipher(AESFastEngine());
    final params = ParametersWithIV(KeyParameter(key), iv);
    cipher.init(false, params);
    
    final output = Uint8List(cipherData.length);
    int offset = 0;
    while (offset < cipherData.length) {
      offset += cipher.processBlock(cipherData, offset, output, offset);
    }
    
    return pkcs7Unpad(output);
  }

  static Uint8List rsaOaepEncrypt(Uint8List data, RSAPublicKey publicKey) {
    final encryptor = OAEPEncoding(RSAEngine())..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final inputBlockSize = encryptor.inputBlockSize;
    final output = BytesBuilder();
    for (int offset = 0; offset < data.length; offset += inputBlockSize) {
      final end = (offset + inputBlockSize).clamp(0, data.length);
      final block = data.sublist(offset, end);
      output.add(encryptor.process(block));
    }
    return output.toBytes();
  }

  static Uint8List rsaOaepDecrypt(Uint8List data, RSAPrivateKey privateKey) {
    if (data.isEmpty) {
      throw ArgumentError('RSA data cannot be empty');
    }
    
    // The C# backend usually uses RSA-OAEP with SHA-1
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
      
    final keySize = (privateKey.n!.bitLength + 7) ~/ 8;
    final output = BytesBuilder();

    try {
      for (int offset = 0; offset < data.length; offset += keySize) {
        final end = (offset + keySize).clamp(0, data.length);
        final block = data.sublist(offset, end);
        output.add(decryptor.process(block));
      }
    } catch (e) {
      print('RSA Decryption Error: $e');
      rethrow;
    }
    
    return output.toBytes();
  }

  static Uint8List generateRandomBytes(int length) {
    final secureRandom = FortunaRandom();
    final seed = Uint8List.fromList(List<int>.generate(32, (i) => DateTime.now().microsecondsSinceEpoch.remainder(256)));
    secureRandom.seed(KeyParameter(seed));
    return secureRandom.nextBytes(length);
  }

  static Uint8List generateAESKey() => generateRandomBytes(32);
  static Uint8List generateIV() => generateRandomBytes(16);

  static Future<Map<String, String>> encrypt({
    required dynamic data, // String or Map
  }) async {
    final publicKey = CryptoUtils.rsaPublicKeyFromPem(rsaPublicKeyPem);
    final aesKey = generateAESKey();
    final iv = generateIV();
    final plainBytes = utf8.encode(data is String ? data : jsonEncode(data));
    final encryptedData = aesCbcEncrypt(Uint8List.fromList(plainBytes), aesKey, iv);
    final encryptedAESKey = rsaOaepEncrypt(aesKey, publicKey);

    return {
      'EncryptedAESKey': bytesToBase64(encryptedAESKey),
      'EncryptedData': bytesToBase64(encryptedData),
      'IV': bytesToBase64(iv),
    };
  }

  static Future<HybridEncryptionResult> encryptWithSession({
    required dynamic data,
  }) async {
    final publicKey = CryptoUtils.rsaPublicKeyFromPem(rsaPublicKeyPem);
    final aesKey = generateAESKey();
    final iv = generateIV();
    final plainBytes = utf8.encode(data is String ? data : jsonEncode(data));
    final encryptedData = aesCbcEncrypt(Uint8List.fromList(plainBytes), aesKey, iv);
    final encryptedAESKey = rsaOaepEncrypt(aesKey, publicKey);
    final payload = <String, String>{
      'EncryptedAESKey': bytesToBase64(encryptedAESKey),
      'EncryptedData': bytesToBase64(encryptedData),
      'IV': bytesToBase64(iv),
    };
    return HybridEncryptionResult(
      payloadForServer: payload,
      aesKeyBytes: aesKey,
      ivBytes: iv,
    );
  }

  static Future<String> decrypt({
    required String encryptedAESKeyBase64,
    required String encryptedDataBase64,
    required String ivBase64,
  }) async {
    final privateKey = CryptoUtils.rsaPrivateKeyFromPem(rsaPrivateKeyPem);

    final encryptedAESKeyBytes = base64ToBytes(encryptedAESKeyBase64);
    final encryptedDataBytes = base64ToBytes(encryptedDataBase64);
    final ivBytes = base64ToBytes(ivBase64);
    
    final aesKeyBytes = rsaOaepDecrypt(encryptedAESKeyBytes, privateKey);
    final decryptedBytes = aesCbcDecrypt(encryptedDataBytes, aesKeyBytes, ivBytes);
    return utf8.decode(decryptedBytes);
  }
}
