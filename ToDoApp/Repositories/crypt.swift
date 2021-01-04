//
//  crypt.swift
//  ToDoApp
//
//  Created by Magnus Ahlqvist on 2021-01-03.
//

import Foundation
import CryptoKit


let myName = "Robin"
let key = keyFromName(myName)


func keyFromName(_ myName: String) -> SymmetricKey {
  let hash = SHA256.hash(data: myName.data(using: .utf8)!)
  let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
  let subString = String(hashString.prefix(32))
  let keyData = subString.data(using: .utf8)!

  return SymmetricKey(data: keyData)
}


func encryptCodableObject<T: Codable>(_ object: T, usingKey key: SymmetricKey) throws -> String {
  let encoder = JSONEncoder()
  let userData = try encoder.encode(object)

  let encryptedData = try ChaChaPoly.seal(userData, using: key)

  return encryptedData.combined.base64EncodedString()
}


func decryptStringToCodableOject<T: Codable>(_ type: T.Type, from string: String, usingKey key: SymmetricKey) throws -> T {
  let data = Data(base64Encoded: string)!
  let box = try ChaChaPoly.SealedBox(combined: data)
  let decryptedData = try ChaChaPoly.open(box, using: key)
  let decoder = JSONDecoder()
  let object = try decoder.decode(type, from: decryptedData)
  return object
}

// A sample structure to encode
struct Name: Codable {
  let name: String
}

let user = Name(name: "Robin")
//let base64EncodedString = try encryptCodableObject(user, usingKey: key)


//let newName = try decryptStringToCodableOject(Name.self, from: base64EncodedString, usingKey: key)
//print(newName.name)      // J.Doe

