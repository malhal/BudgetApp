//
//  BudgetDetailView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI
import CoreData

struct BudgetDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var budgetCategory: BudgetCategory
    @State var addTransactionConfig: AddTransactionConfig?
    
    var body: some View {
        VStack(alignment: .leading) {
//
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(budgetCategory.name ?? "")
//                        .font(.largeTitle)
//                    Text("Budget: \(budgetCategory.total.formatAsCurrency())")
//                        .fontWeight(.bold)
//                }
//                Spacer()
//            }
            
        if let addTransactionConfig {
            AddTransactionView(transaction: addTransactionConfig.transaction)
                .environment(\.managedObjectContext, addTransactionConfig.context)
        }
        
        TransactionListView(fetchRequest: FetchRequest(fetchRequest: budgetCategory.transactionsFetchRequest))
//            Spacer()
//
        }
        .padding()
        .onAppear {
//                model.budgetCategory = budgetCategory
            addTransactionConfig = AddTransactionConfig(parentContext: viewContext)
        }
    }
}

struct AddTransactionConfig {
    let context: NSManagedObjectContext
    let transaction: Transaction
    
    init(parentContext: NSManagedObjectContext) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = parentContext
        self.transaction = Transaction(context: self.context)
    }
    
    
}

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var transaction: Transaction
    
    var body: some View {
        Form {
            Section(header: Text("Add Transaction")) {
                TextField("Name", text: Binding($transaction.name)!)
                TextField("Total", value: Binding($transaction.total), formatter: NumberFormatter.currency)

                Button {
                    // action
                   // saveTransaction()
                } label: {
                    Text("Save Transaction")
                        .frame(maxWidth: .infinity)
                }
                .disabled(!isFormValid)

            }
        }.frame(maxHeight: 200)
    }
    
    var isFormValid: Bool {
        do {
            try transaction.validateForInsert()
            return true
        }
        catch {
            return false
        }
    }
    
    private func saveTransaction() {
//        if isFormValid {
//            do {
//                
//                
//                // clear fields
//                name = ""
//                total = ""
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView(budgetCategory: BudgetCategory.preview).environmentObject(Model())
//    }
//}
