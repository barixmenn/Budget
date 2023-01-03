//
//  DetailsViewController.swift
//  Budget
//
//  Created by Baris on 1.01.2023.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    private var persistentContainer: NSPersistentContainer
    private var budgetCategory : BudgedCategory
    private var fetchedResultsController: NSFetchedResultsController<Transaction>!

    init(budgetCategory: BudgedCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
        
        let request = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
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
    
    //MARK: - UI Elements
    lazy var nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction name"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Transaction amount"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textfield.leftViewMode = .always
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    lazy var saveTransactionButton: UIButton = {
        
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Transaction Save", for: .normal)
        return button
      
    }()
    lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = budgetCategory.amount.formatAsCurrency()
        return label
    }()
    
    lazy var transactionTotalLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var transactionTotal :Double {
        let transaction = fetchedResultsController.fetchedObjects ?? []
        return transaction.reduce(0) { result, transaction  in
            result + transaction.amount
        }
    }
    
    
     


    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        updateTransactionTotal()
    }
    
   //MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = budgetCategory.name
        
        // stackview
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        stackView.addArrangedSubview(amountLabel)
        stackView.setCustomSpacing(50, after: amountLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(amountTextField)
        stackView.addArrangedSubview(transactionTotalLabel)
        stackView.addArrangedSubview(saveTransactionButton)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(tableView)
        
        view.addSubview(stackView)
        
        // add constraints
        nameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        amountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveTransactionButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        
        
        //Target
        saveTransactionButton.addTarget(self, action: #selector(saveTransactionButtonPressed), for: .touchUpInside)
    }
    
    private var isFormValid : Bool {
        guard let name = nameTextField.text, let amount = amountTextField.text else {return false}
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreatorThan(0)
    }
    
    
    
    private func saveTransaction() {
        guard let name = nameTextField.text, let amount = amountTextField.text else {return}
        let transaction = Transaction(context: persistentContainer.viewContext)
        transaction.name = name
        transaction.amount = Double(amount) ?? 0.0
        transaction.category = budgetCategory
        transaction.dateCreated = Date()
        
        do {
            try persistentContainer.viewContext.save()
            tableView.reloadData()
            resetForm()
        } catch {
            debugPrint(error.localizedDescription)
            errorMessageLabel.text = "Unable to save transaction"
        }

    }
    
    @objc func saveTransactionButtonPressed(_ sender: UIButton) {
        if isFormValid {
            saveTransaction()
        } else {
            errorMessageLabel.text = "Make sure name and amount"
        }
    }
    private func updateTransactionTotal() {
        transactionTotalLabel.text = transactionTotal.formatAsCurrency()
    }
    private func resetForm() {
        nameTextField.text = ""
        amountTextField.text = ""
        errorMessageLabel.text = ""
    }
   
}



    //MARK: - Extensions
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (fetchedResultsController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        let transaction = fetchedResultsController.object(at: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = transaction.name
        configuration.secondaryText = transaction.amount.formatAsCurrency()
        cell.contentConfiguration = configuration
        return cell
        
    }
}

extension DetailsViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateTransactionTotal()
        tableView.reloadData()
    }
}
