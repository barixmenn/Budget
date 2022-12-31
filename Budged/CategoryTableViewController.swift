//
//  CategoryTableViewController.swift
//  Budged
//
//  Created by Baris on 31.12.2022.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    private var persistenContainer: NSPersistentContainer
    
    init(persistenContainer: NSPersistentContainer) {
        self.persistenContainer = persistenContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}
