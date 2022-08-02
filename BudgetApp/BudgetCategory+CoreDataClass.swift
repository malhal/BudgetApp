//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Malcolm Hall on 02/08/2022.
//
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {

    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
    // add transaction to the budget
    func addTransaction(name: String, total: Double)  {
        
        let transaction = Transaction(context: self.managedObjectContext!)
        transaction.name = name
        transaction.total = total
        self.addToTransactions(transaction)
    }
    
    var overSpent: Bool {
        remainingBudgetTotal < transactionsTotal
    }

    var transactionsTotal: Double {
        guard let transactions = transactions?.allObjects as? [Transaction] else { return 0.0 }
        return transactions.reduce(0) { result, transaction in
            result + transaction.total
        }
    }

    var remainingBudgetTotal: Double {
        self.total - transactionsTotal
    }
    
    lazy var transactionsFetchRequest: NSFetchRequest<Transaction> = {
        let fr = Transaction.fetchRequest()
        fr.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.dateCreated, ascending: true)]
        fr.predicate = NSPredicate(format: "category = %@", self)
        return fr
    }()
}
