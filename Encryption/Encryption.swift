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
        
        print("!!!")
        
        let myPassword = "password"
        let key = keyFromPassword(myPassword)
        
        
        let user = User(name: "Robin", password: "password")
        let base64EncodedString = try? encryptCodableObject(user, usingKey: key)
    
        
        print(base64EncodedString)
        
        let newObject = try! decryptStringToCodableOject(User.self, from: base64EncodedString!, usingKey: key)
        print("Name: " ,{newObject.name})
        print("Password: ", {newObject.password})
    }

// skapar en SHA256 algoritm som lägger lösenordet i en SymmetricKey som används i krypteringstillfället och dekrypterings tillfället
func keyFromPassword(_ password: String) -> SymmetricKey {
  let hash = SHA256.hash(data: password.data(using: .utf8)!)
  let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
  let subString = String(hashString.prefix(32))
  let keyData = subString.data(using: .utf8)!
  return SymmetricKey(data: keyData)
}

//kryptera datan i en försluten box med hjälp av ChaChaPoly algoritmen, där lagras även nyckeln som används till att möjligöra att mottagen kan ta emot den krypterade datan
func encryptCodableObject<T: Codable>(_ object: T, usingKey key: SymmetricKey) throws -> String {
  let encoder = JSONEncoder()
  let userData = try encoder.encode(object)
  let encryptedData = try ChaChaPoly.seal(userData, using: key)
  return encryptedData.combined.base64EncodedString()
}

// tar emot boxen och använder nyckeln för att öppna boxen och komma åt datan
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
