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
    
    init(budgetCategory: BudgedCategory, persistentContainer: NSPersistentContainer) {
        self.budgetCategory = budgetCategory
        self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
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
     


    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
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
        
    }
  
}



    //MARK: - Extensions
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath)
        
        return cell
    }
    
    
    
}
