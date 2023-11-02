//
//  AnyResponseParserExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

extension AnyResponseParser {
    static func toJSONAndDecode<T: Decodable>(data: [String: Any], type: T.Type) -> T? {
        guard let data = self.convertToJSON(data) else {
            return nil
        }
        
        return self.decode(data: data, type: type)
    }
    
    static func decode<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return nil
    }
    
    static func convertToJSON(_ data: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            print("Failed to convert to JSON: \(error)")
            return nil
        }
    }
}
