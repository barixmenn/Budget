//
//  CategoryTableViewController.swift
//  Budged
//
//  Created by Baris on 31.12.2022.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {

    //MARK: - Properties
    private var persistentContainer: NSPersistentContainer
    private var fetchedResultsController: NSFetchedResultsController<BudgedCategory>!
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = BudgedCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BudgetTableViewCell")
    }
    
    
    //MARK: - Functions
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
    
    private func deleteTransaction(_ category: BudgedCategory) {
        persistentContainer.viewContext.delete(category)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            debugPrint("Unable to delete category.")
        }
    }
    
    // UITableViewDataSource delegate functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetTableViewCell", for: indexPath)
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = budgetCategory.name
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let budgetCategory = fetchedResultsController.object(at: indexPath)
        // perform navigation
        self.navigationController?.pushViewController(DetailsViewController(budgetCategory: budgetCategory, persistentContainer: persistentContainer), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let transaction = fetchedResultsController.object(at: indexPath)
            deleteTransaction(transaction)
        }
        
    }

}

//MARK: - Extensions 
extension CategoryTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
