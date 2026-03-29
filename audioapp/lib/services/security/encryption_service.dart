import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encryption service for sensitive data
/// Uses AES-256 encryption for data at rest
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  static const String _encryptionKeyName = 'audioapp_encryption_key';
  static const String _ivKeyName = 'audioapp_encryption_iv';
  
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  encrypt.Key? _key;
  encrypt.IV? _iv;
  encrypt.Encrypter? _encrypter;

  /// Initialize encryption service
  /// Generates or retrieves encryption key from secure storage
  Future<void> initialize() async {
    // Try to load existing key
    final existingKey = await _secureStorage.read(key: _encryptionKeyName);
    final existingIv = await _secureStorage.read(key: _ivKeyName);

    if (existingKey != null && existingIv != null) {
      // Use existing key
      _key = encrypt.Key.fromBase64(existingKey);
      _iv = encrypt.IV.fromBase64(existingIv);
    } else {
      // Generate new key
      _key = encrypt.Key.fromSecureRandom(32); // 256-bit key
      _iv = encrypt.IV.fromSecureRandom(16);    // 128-bit IV
      
      // Store securely
      await _secureStorage.write(key: _encryptionKeyName, value: _key!.base64);
      await _secureStorage.write(key: _ivKeyName, value: _iv!.base64);
    }

    _encrypter = encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
  }

  /// Encrypt a string
  /// Returns base64 encoded encrypted string
  String encryptString(String plainText) {
    if (_encrypter == null || _iv == null) {
      throw StateError('EncryptionService not initialized');
    }
    if (plainText.isEmpty) return plainText;
    
    final encrypted = _encrypter!.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt a base64 encoded encrypted string
  String decryptString(String encryptedText) {
    if (_encrypter == null || _iv == null) {
      throw StateError('EncryptionService not initialized');
    }
    if (encryptedText.isEmpty) return encryptedText;
    
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return _encrypter!.decrypt(encrypted, iv: _iv);
    } catch (e) {
      // If decryption fails, the data might not be encrypted
      // This can happen during migration
      return encryptedText;
    }
  }

  /// Encrypt a JSON map
  String encryptJson(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    return encryptString(jsonString);
  }

  /// Decrypt a JSON map
  Map<String, dynamic>? decryptJson(String encryptedJson) {
    try {
      final decrypted = decryptString(encryptedJson);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Hash a password with salt
  /// Uses SHA-256 for consistent hashing (Firebase handles password storage)
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a random salt
  String generateSalt([int length = 32]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Encode(Uint8List.fromList(values));
  }

  /// Generate a secure session ID
  String generateSessionId() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(Uint8List.fromList(values));
  }

  /// Generate a secure token (for password reset, etc.)
  String generateSecureToken([int length = 64]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(Uint8List.fromList(values));
  }

  /// Clear all stored keys (for logout or security reset)
  Future<void> clearKeys() async {
    await _secureStorage.delete(key: _encryptionKeyName);
    await _secureStorage.delete(key: _ivKeyName);
    _key = null;
    _iv = null;
    _encrypter = null;
  }

  /// Check if encryption is initialized
  bool get isInitialized => _encrypter != null;

  /// Mask sensitive data for logging (e.g., show only last 4 digits)
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) {
      return '*' * data.length;
    }
    final masked = '*' * (data.length - visibleChars);
    return masked + data.substring(data.length - visibleChars);
  }

  /// Mask email for logging
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***';
    
    final name = parts[0];
    final domain = parts[1];
    
    final maskedName = name.length > 2 
        ? '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}'
        : '*' * name.length;
    
    return '$maskedName@$domain';
  }
}

/// Global encryption service instance
final encryptionService = EncryptionService();
