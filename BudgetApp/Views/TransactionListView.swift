//
//  TransactionListView.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/31/22.
//

import SwiftUI

struct TransactionListView: View {
    
    var fetchRequest: FetchRequest<Transaction>
    private var transactions: FetchedResults<Transaction> {
        fetchRequest.wrappedValue
    }
    
    var body: some View {
        if transactions.isEmpty {
            Text("No transactions.")
        }
        ForEach(transactions) { item in
            HStack {
                Text(item.name ?? "")
                Spacer()
                Text(item.total as NSNumber, formatter: NumberFormatter.currency)
            }
        }
    }
}

//struct TransactionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionListView(transactions: [])
//    }
//}
