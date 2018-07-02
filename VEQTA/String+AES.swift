import Foundation
import CryptoSwift

extension String {
    
    //    func aesEncrypt(key: String, iv: String) throws -> String{
    //        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
    //        let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data!.arrayOfBytes(),padding: PKCS7())
    //        let encData = NSData(bytes: enc, length: Int(enc.count))
    //        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
    //        let result = String(base64String)
    //        return result
    //    }
    //  PKCS7(128).padder()
    
    func aesEncryptWithoutPaddingWithStaticIV(key: String, iv: String) -> String {
        let data = self.data(using: String.Encoding.utf8)
        let enc = try!AES(key: key, iv: iv, blockMode:.CFB).encrypt([UInt8](data!))
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result!
    }
    /*
     guard let data = self.data(using: String.Encoding.utf8) else {
     return nil
     }
     let enc = try AES(key: key, iv: iv, blockMode:.CBC).encrypt(data)
     let encData = Data(bytes: enc, count: Int(enc.count))
     let base64String: String = encData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
     let result = String(base64String)
     return result
     */
    /*
     func aesEncrypt(key: String) -> String {
     let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
     let keyData = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!//.arrayOfBytes()
     let ivData = AES.randomIV(keyData.count)
     do
     {
     let encrypted = try!AES(key: keyData, iv: ivData, blockMode:.CBC).encrypt(data!)
     let encryptedData = NSData(bytes: encrypted, length: Int(encrypted.count))
     let sendData = NSMutableData(bytes: ivData, length: Int(ivData.count))
     sendData.appendData(encryptedData)
     let base64String: String = sendData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0));
     let result = String(base64String)
     return result!
     }
     catch
     {
     print("dssd")
     }
     }
     */
    
    func aesDecrypt(key: String) -> String
    {
        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let keyData = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!.bytes
        let ivData = data!.subdata(with: NSRange(location: 0, length: AES.blockSize)).bytes
        let encryptedData = data!.subdata(with: NSRange(location: AES.blockSize, length: (data!.length - AES.blockSize) as Int))
        let decrypted = try!AES(key: keyData, iv: ivData, blockMode:.CBC).decrypt([UInt8](encryptedData))
        let decryptedData = NSData(bytes: decrypted, length: Int(decrypted.count))
        let decryptedString = NSString(data: decryptedData as Data, encoding: String.Encoding.utf8.rawValue)!
        return String(decryptedString)
        
//        let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))
//        let keyData = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!//.arrayOfBytes()
//        let ivData = data?.subdata(in: AES.blockSize..<(0))//.arrayOfBytes()
//        let encryptedData = data!.subdata(in: AES.blockSize..<(AES.blockSize + Int(AES.blockSize)))
//        let decrypted = try!AES(key: keyData, iv: ivData, blockMode:.CBC).decrypt(encryptedData!)
//        let decryptedData = NSData(bytes: decrypted, length: Int(decrypted.count))
//        let decryptedString = NSString(data: decryptedData, encoding: NSUTF8StringEncoding)!
//        return String(decryptedString)
    }
    
    /*
     func aesDecrypt(_ key: String, iv: String) throws -> String? {
     guard let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0)) else {
     return nil
     }
     let dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data)
     let decData = Data(bytes: dec, count: Int(dec.count))
     let result = NSString(data: decData, encoding: String.Encoding.utf8.rawValue)
     return String(result!)
     }
     */
    
    func aesDecryptWithStaticIV(key: String, iv: String) -> String {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try!AES(key: key, iv: iv, blockMode:.CBC).decrypt([UInt8](data!))
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(result!)
    }
    
    func aesDecryptWithoutPaddingWithStaticIV(key: String, iv: String) -> String  {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let dec = try!AES(key: key, iv: iv, blockMode:.CBC).decrypt([UInt8](data!))
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData as Data, encoding: String.Encoding.utf8.rawValue)
        return String(describing: result)
    }
    
    func aesDecrypt(key: String, iv: String) throws -> String {
        let jie = try! AES(key: key, iv:iv,blockMode: .CFB)
        let nsdata = Data(base64Encoded:self,options:Data.Base64DecodingOptions(rawValue:0))
        let byte = nsdata
        let jieres =  try!jie.decrypt([UInt8](byte!))
        let resData = NSData(bytes:jieres, length: jieres.count)
        
        // let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        // let dec = try AES(key: key, iv: iv, blockMode:.ECB).decrypt(data!.arrayOfBytes())
        // let decData = NSData(bytes: dec, length: Int(dec.count))
        let jiestrres = resData.base64EncodedString(options: NSData.Base64EncodingOptions())
        let dddd = NSData(base64Encoded: jiestrres, options:NSData.Base64DecodingOptions(rawValue: 0))
        let result = NSString(data: dddd! as Data, encoding: String.Encoding.utf8.rawValue)
        return String(describing: result)
    }
}
