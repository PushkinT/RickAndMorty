//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 30.04.2024.
//

import Foundation
import Combine
import RealmSwift

enum StatusFilter: String, CaseIterable {
    case all
    case alive
    case dead
    case unknown
}

enum GenderFilter: String, CaseIterable {
    case all
    case male
    case female
    case genderless
    case unknown
}

class CharactersListViewModel: ObservableObject {
    @Published private var allCharacters: [RaMCharacter] = []
    @Published var filteredCharacters: [RaMCharacter] = []
    @Published var searchText = ""
    @Published var filtersType: (gender: GenderFilter, status: StatusFilter) = (gender: .all, status: .all)
    private var anyCancellable = Set<AnyCancellable>()
    
    var shownCharacters: [RaMCharacter] {
        filtersType == (.all, .all) && searchText.isEmpty ? allCharacters : filteredCharacters
    }
    
    private let charactersAPI: CharactersAPI
    private var nextPageURLString: String?
    
    // Realm
    @ObservedResults(RaMCharacter.self) var charactersLists
    private var token: NotificationToken?
    
    // MARK: - Object life
    
    init(charactersAPI: CharactersAPI) {
        self.charactersAPI = charactersAPI
        setupObserver()
        
        $filtersType
            .map { $0 }
            .sink { [weak self] types in
                self?.filterCharacters(gender: types.gender, status: types.status)
            }
            .store(in: &anyCancellable)
        
        $searchText
            .flatMap(maxPublishers: .max(1), { Just($0).delay(for: .seconds(1.5), scheduler: RunLoop.main)})
            .sink(receiveValue: { [weak self] text in
                self?.searchCharacters(text: text)
            })
            .store(in: &anyCancellable)
        
        
    }
    
    deinit {
        token?.invalidate()
    }
    
    // MARK: - Private methods
    
    private func searchCharacters(text: String) {
        guard !text.isEmpty else { return }
        filteredCharacters = filteredCharacters.isEmpty ? allCharacters.filter { $0.name.contains(text) } : filteredCharacters.filter { $0.name.contains(text) }
    }
    
    private func filterCharacters(gender: GenderFilter, status: StatusFilter) {
        filteredCharacters = allCharacters.filter { ($0.status.lowercased() == status.rawValue || status == .all)  && ($0.gender.lowercased() == gender.rawValue || gender == .all) }
    }
    
    // MARK: - API methods
    
    func getFirstPageCharacters() async throws {
        let result = try await charactersAPI.getCharactersByPage(number: 1)
        await MainActor.run {
            allCharacters.append(contentsOf: result.result)
            nextPageURLString = result.nextPageURLString
        }
    }
    
    func getNextPageCharacters() async throws {
        let result = try await charactersAPI.getNextURLCharacters(urlString: nextPageURLString ?? "")
        await MainActor.run {
            allCharacters.append(contentsOf: result.result)
            nextPageURLString = result.nextPageURLString
        }
    }
    
    // MARK: - Realm methods
    
    // fetch and update charactersList
    private func setupObserver() {
        do {
            let realm = try Realm()
            let results = realm.objects(RaMCharacter.self)
            
            token = results.observe({ [weak self] changes in
                self?.allCharacters = results.map(RaMCharacter.init)
                    .sorted(by: { $0.name > $1.name })
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // Add character
    private func addContact(characters: [RaMCharacter]) {
        for character in characters {
            $charactersLists.append(character)
        }
    }
    
    // Delete character
    private func remove(id: String) {
        do {
            let realm = try Realm()
            let objectId = try ObjectId(string: id)
            if let character = realm.object(ofType: RaMCharacter.self, forPrimaryKey: objectId) {
                try realm.write {
                    realm.delete(character)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
