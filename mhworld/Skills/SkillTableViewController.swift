//
//  SkillTableViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 11/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import UIKit
import Moya
import ObjectMapper
import Moya_ObjectMapper

class SkillTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var searchBar: UISearchBar!
    var provider = MoyaProvider<MyService>()
    var skillArray = [Skill]()
    var filteredSkillArray = [Skill]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSkills()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search skills"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func fetchSkills() {
        provider.request(.skills) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let skills = try moyaResponse.mapArray(Skill.self)
                    self.skillArray = skills
                } catch {
                    print("skill array nothing")
                }
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredSkillArray.count
        }
        
        return skillArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillTableViewCell
        let skill: Skill
        if isFiltering() {
            skill = filteredSkillArray[indexPath.row]
        } else {
            skill = skillArray[indexPath.row]
        }
        cell.skillLabel.text = skill.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResults = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(searchResults)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSkillArray = skillArray.filter({(skill: Skill) -> Bool in
            return skill.name!.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

