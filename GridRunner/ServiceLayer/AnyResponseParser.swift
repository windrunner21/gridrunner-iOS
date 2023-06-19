//
//  AnyResponseParser.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

protocol AnyResponseParser {
    static func toJSONAndDecode<T: Decodable>(data: [String: Any], type: T.Type) -> T?
    static func decode<T: Decodable>(data: Data, type: T.Type) -> T?
    static func convertToJSON(_ data: [String: Any]) -> Data?
}
