//
//  Encrypt.swift
//  GXDriver
//
//  Created by DuongLe on 12/1/17.
//

import Foundation
import CryptoSwift

class Encrypt {
    static let key = "a6e5989b69f97def21666dbfcdb88983"
    static let iv = "9999999999999999"
    
    public static func encript(input : String!) -> String{
        
        do {
            
            let i = try input.aesEncrypt(key: Encrypt.key,iv : Encrypt.iv)
            return i
        }
        catch {
            return ""
        }
    }
    
    public static func decript(input : String!) -> String{
        do {
            
            let i = try input.aesDecrypt(key: Encrypt.key,iv : Encrypt.iv)
            return i
        }
        catch {
            return ""
        }
        
    }
    
    
    
}


extension String {
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try AES(key: Array(key.utf8), blockMode: .CBC(iv: Array(iv.utf8)), padding: .pkcs7).encrypt(Array(data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        let decrypted = try! AES(key: Array(key.utf8), blockMode: .CBC(iv: Array(iv.utf8)), padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    
}

