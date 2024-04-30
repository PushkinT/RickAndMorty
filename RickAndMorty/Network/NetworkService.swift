//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 30.04.2024.
//

import Foundation


enum NetworkErrors: Error {
    case badURL
    case badStatusCode
}

enum APIUrl {
    static private let baseURL = "https://rickandmortyapi.com/api/"
    
    case getCharactersByPage(number: Int)
    case getCharacterByID(id: Int)
    case getAllCharacters
    
    var url: String {
        switch self {
        case .getCharactersByPage(number: let number):
            Self.baseURL + "character/" + "?page=" + "\(number)"
        case .getCharacterByID(id: let id):
            Self.baseURL + "character/" + "\(id)"
        case .getAllCharacters:
            Self.baseURL + "character"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchData(for urlString: String) async throws -> Data
}

struct NetworkService: NetworkServiceProtocol {
    func fetchData(for urlString: String) async throws -> Data {
        guard let validURL = URL(string: urlString) else { throw NetworkErrors.badURL }
        
        let (data, responce) = try await URLSession.shared.data(from: validURL)
        
        guard let statusCode = (responce as? HTTPURLResponse)?.statusCode,
              200..<299 ~= statusCode else { throw NetworkErrors.badStatusCode }
        
        return data
    }
}

struct CharactersAPI {
    // MARK: - Info
    struct Info: Decodable {
        let count, pages: Int
        let next: String?
    }

    // MARK: - CraractersArray
    struct CraractersArray: Decodable {
        let info: Info
        let results: [RaMCharacter]
    }
    
    private let networkSevice: NetworkServiceProtocol
    
    init(networkSevice: NetworkServiceProtocol) {
        self.networkSevice = networkSevice
    }
    
    func getCharacterByID(id: Int) async throws -> RaMCharacter {
        let data = try await networkSevice.fetchData(for: APIUrl.getCharacterByID(id: id).url)
        let character = try JSONDecoder().decode(RaMCharacter.self, from: data)
        
        return character
    }
    
    func getCharactersByPage(number: Int) async throws -> (result: [RaMCharacter], nextPageURLString: String?)  {
        let data = try await networkSevice.fetchData(for: APIUrl.getCharactersByPage(number: number).url)
        let charactersResult: CraractersArray = try JSONDecoder().decode(CraractersArray.self, from: data)

        return (charactersResult.results, charactersResult.info.next)
    }
    
    func getNextURLCharacters(urlString: String) async throws -> (result: [RaMCharacter], nextPageURLString: String?) {
        let data = try await networkSevice.fetchData(for: urlString)
        let charactersResult: CraractersArray = try JSONDecoder().decode(CraractersArray.self, from: data)
        
        return (charactersResult.results, charactersResult.info.next)
    }
}


