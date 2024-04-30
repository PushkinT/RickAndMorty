//
//  ListItemView.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 02.05.2024.
//

import SwiftUI
import NukeUI

struct ListItemView: View {
    let character: RaMCharacter
    
    var body: some View {
        NavigationLink {
            CharacterDetailview(character: character)
        } label: {
            HStack {
                VStack {
                    LazyImage(url: URL(string: character.image)) { state in
                        if let image = state.image {
                            image.resizable().aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(width: 150, height: 150)
                    .clipShape(.rect(cornerRadius: 16))
                    .shadow(color: .gray, radius: 16, x: 10, y: 10)
                    .padding()
                    Spacer()
                }
                
                
                VStack(alignment: .leading,spacing: 8) {
                    Text(character.name)
                        .font(.title3)
                        .bold()
                    Text(character.status)
                        .font(.callout)
                    Text(character.gender)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

class Coordinator: ObservableObject {
    
    //    enum NavigationTranisitionStyle {
    //        case push
    //        case presentModally
    //        case presentFullscreen
    //    }
    
    enum Destinations {
        case toCaracterDetailView(caracter: RaMCharacter)
        
        @ViewBuilder
        public func view() -> some View {
            switch self {
            case .toCaracterDetailView(caracter: let character):
                CharacterDetailview(character: character)
            }
        }
        
        private func goToCaracterDetailView(character: RaMCharacter) {
            
        }
    }
    

}
