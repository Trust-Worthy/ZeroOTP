import Foundation
import CryptoKit
import Security

enum SecureEnclaveHelper {
    static let keyTag = "com.zerootp.symmetrickey"

    // Generate or retrieve private key from Secure Enclave
    static func generateAndStoreSecureEnclaveKey() -> SecKey? {
        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     [.privateKeyUsage, .biometryCurrentSet], nil)!

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecAttrLabel as String: keyTag,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: keyTag,
                kSecAttrAccessControl as String: access
            ]
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("Secure Enclave Key Generation Failed:", error!.takeRetainedValue())
            return nil
        }

        return privateKey
    }

    static func getSecureEnclaveKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]

        var keyRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keyRef)
        return (status == errSecSuccess) ? (keyRef as! SecKey) : nil
    }

    // Wrap (encrypt) symmetric key data using Secure Enclave public key
    static func wrapKey(_ symmetricKey: SymmetricKey) -> Data? {
        guard let publicKey = SecKeyCopyPublicKey(getSecureEnclaveKey() ?? generateAndStoreSecureEnclaveKey()!) else {
            print("Failed to get Secure Enclave public key")
            return nil
        }

        let keyData = symmetricKey.withUnsafeBytes { Data($0) }

        var error: Unmanaged<CFError>?
        guard let encrypted = SecKeyCreateEncryptedData(publicKey,
                                                        .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                        keyData as CFData,
                                                        &error) else {
            print("Key Wrapping Failed:", error!.takeRetainedValue())
            return nil
        }
        return encrypted as Data
    }

    // Unwrap (decrypt) symmetric key data using Secure Enclave private key
    static func unwrapKey(_ wrappedKey: Data) -> SymmetricKey? {
        guard let privateKey = getSecureEnclaveKey() else {
            print("Failed to get Secure Enclave private key")
            return nil
        }

        var error: Unmanaged<CFError>?
        guard let decrypted = SecKeyCreateDecryptedData(privateKey,
                                                        .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                        wrappedKey as CFData,
                                                        &error) else {
            print("Key Unwrapping Failed:", error!.takeRetainedValue())
            return nil
        }

        return SymmetricKey(data: decrypted as Data)
    }
}

