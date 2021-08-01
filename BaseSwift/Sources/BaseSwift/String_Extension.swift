//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation

public extension String {
    public func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    public func base64Decoded() -> String? {
        print("decode base64")

        var localData: Data?
        localData = Data(base64Encoded: self)
        var temp: String = self
        if localData == nil {
            temp = self + "=="
        }
        guard let data = Data(base64Encoded: temp, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
