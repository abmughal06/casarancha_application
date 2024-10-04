import 'dart:typed_data';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asn1.dart';

class RSAKeyParser {
  RSAPrivateKey? parse(Uint8List keyDER) {
    var asn1Parser = ASN1Parser(keyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // Check for PKCS#8 format
    var privateKeyInfo = topLevelSeq.elements![2]; // PKCS#8
    if (privateKeyInfo is ASN1OctetString) {
      var privateKeySeq =
          ASN1Parser(privateKeyInfo.octets).nextObject() as ASN1Sequence;

      var modulus = privateKeySeq.elements![1] as ASN1Integer?;
      var privateExponent = privateKeySeq.elements![3] as ASN1Integer?;

      // Ensure that the elements are not null before accessing them
      if (modulus != null && privateExponent != null) {
        return RSAPrivateKey(
          modulus.integer!, // Use intValue instead of valueAsBigInteger
          privateExponent.integer!, // Use intValue instead of valueAsBigInteger
          null, // Ignore for now
          null, // Ignore for nows
        );
      } else {
        throw Exception('Modulus or Private Exponent is null');
      }
    } else {
      throw Exception('Unexpected format: not a valid PKCS#8 RSA private key');
    }
  }
}
