//
//  MoreInfoView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/16/24.
//

import SwiftUI

struct MoreInfoView: View {
    //@StateObject var viewModel = NewItemViewViewModel()
    @StateObject var todoModel = ToDoListItemViewViewModel()
    @Binding var item: ToDoListItem
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Text(item.description)
                        .padding()
                }
                
//                HStack {
//                    ForEach(item.reminder, id: \.self) { reminder in
//                        Text(dateToString(reminder))
//                    }
//                }
                
                HStack {
                    ForEach(item.reminder.indices, id: \.self) { index in
                        DatePicker("", selection: $item.reminder[index], displayedComponents: .hourAndMinute)
                            .frame(height: 50)
                            .labelsHidden()
                    }
                }
                
                HStack {
                    Text("\(item.tracking)")
                        .padding()
                }
                
                Button(action: {
                    withAnimation {
                        todoModel.deleteItem(item: item)
                    }
                }) {
                    Text("Delete")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                    /*Image(systemName: "trash")
                        .font(.system(size: 24))
                        .foregroundColor(.red)*/
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle(item.title)
        }

    }
    // Helper function to format Date to String
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    @State var previewItem = ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [Date()], isDone: false)
    return MoreInfoView(item: $previewItem)
}
