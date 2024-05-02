//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Taras Pushkar on 01.05.2024.
//

import SwiftUI
import NukeUI

struct CharacterDetailView: View {
    
    let character: RaMCharacter
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .center) {
                
                LazyImage(url: URL(string: character.image)) { state in
                    if let image = state.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 16))
                .shadow(color: .gray, radius: 16, x: 10, y: 10)
                

            }
            
            Text(character.name)
                .font(.largeTitle)
                .bold()

            Text("Gender: ") + Text(character.gender)
                .font(.title)
                .fontWeight(.light)
            
            Text("Status: ") + Text(character.status)
                .font(.title)
                .fontWeight(.light)
            
            Text("Species: ") + Text(character.species)
                .font(.title)
                .fontWeight(.light)
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(character.name)
    }
}
