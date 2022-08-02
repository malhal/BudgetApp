//
//  ContentView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI
import CoreData

struct AddBudgetConfig: Identifiable {
    var id: NSManagedObjectContext {
        return context
    }
    let context: NSManagedObjectContext
    let budgetCategory: BudgetCategory
    
    init(viewContext: NSManagedObjectContext) {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.context.parent = viewContext
        
        self.budgetCategory = BudgetCategory(context: self.context)
    }
    
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //@State private var isPresented: Bool = false
    @State private var addBudgetConfig: AddBudgetConfig?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BudgetCategory.dateCreated, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<BudgetCategory>
    
    var total: Double {
        categories.reduce(0) { result, category in
            return category.total + result
        }
    }
    
    
    var body: some View {
        NavigationStack {
            
            List {
                
                if !categories.isEmpty {
                    Text("Total budget \(total as NSNumber, formatter: NumberFormatter.currency)")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                    
                    ForEach(categories) { category in
                        NavigationLink(value: category) {
                            HStack {
                                Text(category.name ?? "")
                                Spacer()
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text("Total")
                                    Text(category.total as NSNumber, formatter: NumberFormatter.currency)
                                    Text("\(category.overSpent ? "Overspent": "Remaining") \(category.remainingBudgetTotal as NSNumber, formatter: NumberFormatter.currency)")
                                        .fontWeight(.bold)
                                    // .foregroundColor(category.overSpent ? .red: .green)
                                        .font(.caption)
                                }
                                
                            }
                        }
                    }
                } else {
                    Text("No budget categories found.")
                }
            }
            .navigationDestination(for: BudgetCategory.self) { category in
                //switch route {
                //case .detail(let category):
             //   let category = viewContext.object(with: id as! NSManagedObjectID) as! BudgetCategory
                BudgetDetailView(budgetCategory: category)
                
                //}
            }
            .listStyle(.plain)
            .sheet(item: $addBudgetConfig) { newAddBudgetConfig in
                AddBudgetCategoryView(budgetCategory: newAddBudgetConfig.budgetCategory)
                    .environment(\.managedObjectContext, newAddBudgetConfig.context)
            }
            // .navigationTitle("Budget")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Budget")
                        .font(.largeTitle)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Add Category") {
                        //isPresented = true
                        addBudgetConfig = AddBudgetConfig(viewContext: viewContext)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
