//
//  CategoryTableViewController.swift
//  Budged
//
//  Created by Baris on 31.12.2022.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    private var persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        }
    
    //MARK: - Functions -
    @objc func showAddBudgetCategory(_ sender: UIBarButtonItem) {
        let navController = UINavigationController(rootViewController: AddBudgetViewController(persistentContainer: persistentContainer))
        present(navController, animated: true)
    }
    
    private func setupUI() {
        
        let addBudgetCategoryButton = UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(showAddBudgetCategory))
        self.navigationItem.rightBarButtonItem = addBudgetCategoryButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Budget"
    }
   
}
