//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation

@propertyWrapper
struct Base64EncryptedString {
    private var value: String?

    init(wrappedValue: String?) {
        self.wrappedValue = wrappedValue
    }

    var wrappedValue: String? {
        get {
            value?.base64Decoded()
        }
        set {
            value = newValue?.base64Encoded()
        }
    }
}
