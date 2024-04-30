//
//  RaMCharacter.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 30.04.2024.
//

import Foundation
import RealmSwift

// MARK: - RaMCharacter
class RaMCharacter: Object, Decodable, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var status: String
    @Persisted var species: String
    @Persisted var type: String
    @Persisted var gender: String
    @Persisted var image: String
    @Persisted var url: String
    @Persisted var created: String
}
