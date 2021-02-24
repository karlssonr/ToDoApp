//
//  Encryption.swift
//  ToDoApp
//
//  Created by robin karlsson on 2021-01-04.
//

import Foundation
import CryptoKit

class Encryption {
    
 
    struct User: Codable {
      let name: String
      let password: String
    }

    

    
    init() {
        
        
        
        let myPassword = "password"
        let key = keyFromPassword(myPassword)
        
        
        let user = User(name: "Robin", password: "password")
        let base64EncodedString = try? encryptCodableObject(user, usingKey: key)
    
        
        print("!!!", base64EncodedString)
        
        let newObject = try! decryptStringToCodableOject(User.self, from: base64EncodedString!, usingKey: key)
        print("Name: " ,newObject.name)
        print("Password: ", newObject.password)
    }


func keyFromPassword(_ password: String) -> SymmetricKey {
  // Create a SHA256 hash from the provided password
  let hash = SHA256.hash(data: password.data(using: .utf8)!)
  // Convert the SHA256 to a string. This will be a 64 byte string
  let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
  // Convert to 32 bytes
  let subString = String(hashString.prefix(32))
  // Convert the substring to data
  let keyData = subString.data(using: .utf8)!

  // Create the key use keyData as the seed
  return SymmetricKey(data: keyData)
}


func encryptCodableObject<T: Codable>(_ object: T, usingKey key: SymmetricKey) throws -> String {
  // Convert to JSON in a Data record
  let encoder = JSONEncoder()
  let userData = try encoder.encode(object)

  // Encrypt the userData
  let encryptedData = try ChaChaPoly.seal(userData, using: key)

  // Convert the encryptedData to a base64 string which is the
  // format that it can be transported in
  return encryptedData.combined.base64EncodedString()
    
}


func decryptStringToCodableOject<T: Codable>(_ type: T.Type, from string: String,
                                             usingKey key: SymmetricKey) throws -> T {
  // Convert the base64 string into a Data object
  let data = Data(base64Encoded: string)!
  // Put the data in a sealed box
  let box = try ChaChaPoly.SealedBox(combined: data)
  // Extract the data from the sealedbox using the decryption key
  let decryptedData = try ChaChaPoly.open(box, using: key)
  // The decrypted block needed to be json decoded
  let decoder = JSONDecoder()
  let object = try decoder.decode(type, from: decryptedData)
  // Return the new object
  return object
}



}
