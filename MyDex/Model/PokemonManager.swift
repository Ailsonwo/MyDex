//
//  PokemonManager.swift
//  MyDex
//
//  Created by Ailson Pereira on 19/07/23.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemonList(pokemonList: [String])
}

struct PokemonManager{
    
    var pokemonURLString = "https://pokeapi.co/api/v2/pokemon?limit=151"
    
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(){
        request(url: pokemonURLString)
    }
    
    func request(url: String){
        
        if let url = URL(string: url){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error: \(error.debugDescription)")
                    return
                }
                
                if let safeData = data {
                    
                    let pokemonList = self.parseJSON(pokemonData: safeData)
                    
                    self.delegate?.didUpdatePokemonList(pokemonList: pokemonList)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(pokemonData: Data) -> [String] {
        let decoder = JSONDecoder()
        
        var pokemonNames: [String] = []
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            
            for pokemon in decodedData.results {
                
                if let name = pokemon["name"] {
                    let nameWithFirstLetterUpper = name.prefix(1).uppercased() + name.lowercased().dropFirst()
                    
                    pokemonNames.append(nameWithFirstLetterUpper)
                }
            }
            
        } catch {
            print(error)
        }
        return pokemonNames
    }
}
