//
//  ParserExtension.swift
//  MessagingApp
//
//  Created by YUSUF KESKİN on 8.10.2022.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func parseJsonToString (from object : Any) -> String? {
        
        guard let data = parseDataToJson(from: object) else {
            print("Json to Stirng convertion failed")
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func parseDataToJson (from object : Any) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            print("Data to json convertion failed")
            return nil
        }
        return data
    }
}
