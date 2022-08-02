//
//  AddBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    
    //@EnvironmentObject private var model: Model
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var childViewContext
    @ObservedObject var budgetCategory: BudgetCategory
    
    //@State private var name: String = ""
    //@State private var total: Double = 100
    //@State private var messages: [String] = []
    @State private var errorMessage = ""
    @State private var errorMessages: [String] = []
    
    let onSave: () -> Void
    
    private func saveBudgetCategory() {

//        messages = []
//
//        // validate the form
//        if isFormValid {
//            do {
//                try model.addCategory(name: name, total: total)
//                dismiss()
//            } catch BudgetCategoryError.alreadyExists {
//                messages.append("Category already exists.")
//            }
//            catch {
//                messages.append(error.localizedDescription)
//            }
//        }
        
        do {
            try childViewContext.save()
            onSave()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            errorMessage = nsError.localizedDescription
            errorMessages = nsError.underlyingErrors.map { e in
                e.localizedDescription
            }
            
        }
        
    }
    
//    var isFormValid: Bool {
//
//        if name.isEmpty {
//            messages.append("Name is required")
//        }
//
//        if total <= 0 {
//            messages.append("Total should be greater than 1.")
//        }
//
//        return messages.count == 0
//    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Name", text: Binding($budgetCategory.name)!)
                Slider(value: $budgetCategory.total, in: 0...500, step: 50) {
                    Text("Total")
                } minimumValueLabel: {
                    Text("$0")
                } maximumValueLabel: {
                    Text("$500")
                }
                Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(errorMessage)
                
                ForEach(errorMessages, id: \.self) { message in
                    Text(message)
                }
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBudgetCategory()
                    }
                }
            }
        }
        
        
    }
}

//struct AddBudgetCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            AddBudgetCategoryView()
//        }
//    }
//}
