//
//  Petition.swift
//  WhitehosePetitions
//
//  Created by Egor Chernakov on 06.03.2021.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}

struct Petitions: Codable {
    var results: [Petition]
}
