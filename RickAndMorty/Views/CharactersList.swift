//
//  CharactersList.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 30.04.2024.
//

import SwiftUI
import NukeUI

struct CharactersList: View {
    
    @StateObject private var viewModel = CharactersListViewModel(charactersAPI: CharactersAPI(networkSevice: NetworkService()))
    @State private var showAlert = false
    @State private var error: LocalizedError?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.shownCharacters, id: \.id) { character in
                    ListItemView(character: character)
                }
                if viewModel.searchText.isEmpty && viewModel.filtersType == (.all, .all) { lastItemView }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Rick & Morty")
            .listRowSpacing(16)
            .task {
                do {
                    try await viewModel.getFirstPageCharacters()
                } catch {
                    
                }
            }
            .toolbar {
                filterMenu
            }
            .tint(.gray)
            .alert("Some error", isPresented: $showAlert) {
                Button("Ok") {
                    // handle
                }
            } message: {
                Text(error?.localizedDescription ?? "")
            }
        }
    }
    
    private var filterMenu: some View {
        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle.fill") {
            
            Text("Status")
            ForEach(StatusFilter.allCases, id: \.rawValue) { status in
                Button {
                    viewModel.filtersType.status = status
                } label: {
                    Label {
                        Text(status.rawValue.capitalized)
                    } icon: {
                        if viewModel.filtersType.status == status { Image(systemName: "checkmark") }
                    }
                }
            }
            
            Text("Gender").foregroundStyle(.red)
            ForEach(GenderFilter.allCases, id: \.rawValue) { gender in
                Button {
                    viewModel.filtersType.gender = gender
                } label: {
                    Label {
                        Text(gender.rawValue.capitalized)
                    } icon: {
                        if viewModel.filtersType.gender == gender { Image(systemName: "checkmark") }
                    }
                }
            }
        }
    }
    
    private var lastItemView: some View {
        ProgressView(label: {
            Text("The End")
        })
        .onAppear {
            Task(priority: .userInitiated) {
                try? await viewModel.getNextPageCharacters()
            }
        }
    }
}
