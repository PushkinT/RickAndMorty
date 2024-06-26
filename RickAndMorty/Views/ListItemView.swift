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
            CharacterDetailView(character: character)
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
