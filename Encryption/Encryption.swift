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

        let newObject = try! decryptStringToCodableOject(User.self, from: base64EncodedString!, usingKey: key)
    }

func keyFromPassword(_ password: String) -> SymmetricKey {
  let hash = SHA256.hash(data: password.data(using: .utf8)!)
  let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
  let subString = String(hashString.prefix(32))
  let keyData = subString.data(using: .utf8)!

  return SymmetricKey(data: keyData)
}


func encryptCodableObject<Triss: Codable>(_ object: Triss, usingKey key: SymmetricKey) throws -> String {
  let encoder = JSONEncoder()
  let userData = try encoder.encode(object)

  let encryptedData = try ChaChaPoly.seal(userData, using: key)

  return encryptedData.combined.base64EncodedString()
    
}


func decryptStringToCodableOject<T: Codable>(_ type: T.Type, from string: String,
                                             usingKey key: SymmetricKey) throws -> T {
  let data = Data(base64Encoded: string)!
  let box = try ChaChaPoly.SealedBox(combined: data)
  let decryptedData = try ChaChaPoly.open(box, using: key)
  let decoder = JSONDecoder()
  let object = try decoder.decode(type, from: decryptedData)
  return object
}



}
