//
//  Two.swift
//  HZ
//
//  Created by Алик on 01.10.2025.
//

import UIKit

class Two: UIViewController, UISearchBarDelegate {
    
    //поиск
    private let searchBar = UISearchBar()
    private let searchButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGreen
        setupSearchBar()
    }
    
    
    private func setupSearchBar() {
        view.backgroundColor = .white
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .default
        view.addSubview(searchBar)// Добавление на view
        view.addSubview(searchButton)// Добавление на view
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
    
    
    
    
    
}
