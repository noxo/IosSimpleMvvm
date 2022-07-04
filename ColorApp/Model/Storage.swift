//
//  Storage.swift
//  ColorApp
//
//  Created by Erkki Nokso-Koivisto on 4.7.2022.
//

import Foundation

public struct Storage : Decodable, Encodable {
    let id : String?
    let data : String?
    let token : String?
}
