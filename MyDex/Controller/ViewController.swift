//
//  ViewController.swift
//  MyDex
//
//  Created by Ailson Pereira on 19/07/23.
//

import UIKit

class ViewController: UIViewController {
    
    var pokemonManager = PokemonManager()

    var pokemonData: [String] = []
    
    var filterPokemonData: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        pokemonManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        pokemonManager.fetchPokemon()
        
        
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false)
        { (var) in
            self.tableView.reloadData()
            
            self.loadingSpinner.isHidden = true
            
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPokemonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = filterPokemonData[indexPath.row]
        
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPokemonData = []
        
        if searchText == ""{
            filterPokemonData = pokemonData
        } else {
            
            for pokemonName in pokemonData {
                if pokemonName.uppercased().contains(searchText.uppercased()) {
                    filterPokemonData.append(pokemonName)
                }
            }
        }
        
        self.tableView.reloadData()
        
    }
}

extension ViewController: PokemonManagerDelegate {
    func didUpdatePokemonList(pokemonList: [String]) {
        
        pokemonData = pokemonList
        filterPokemonData = pokemonData
        print("pokemoned")
    }
}

