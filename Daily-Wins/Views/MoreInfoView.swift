//
//  MoreInfoView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/16/24.
//

import SwiftUI

struct MoreInfoView: View {
    @ObservedObject var reminderModel = ReminderViewViewModel()
    @StateObject var todoModel = ToDoListItemViewViewModel()
    
    @Binding var item: ToDoListItem
    @Binding var description: String

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ForEach(reminderModel.reminders.indices, id: \.self) { index in
                        Text(dateToString(reminderModel.reminders[index]))
                    }
                }
                
                HStack {
                    Text(description)
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
    @State var previewItem = ToDoListItem(id: "1", title: "Sample Task", isDone: false)
    @State var previewDescription = String()
    
    return MoreInfoView(item: $previewItem, description: $previewDescription)
}
