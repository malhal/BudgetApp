//
//  Transaction+CoreDataClass.swift
//  BudgetApp
//
//  Created by Malcolm Hall on 02/08/2022.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
}
