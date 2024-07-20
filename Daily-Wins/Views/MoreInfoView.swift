//
//  MoreInfoView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/16/24.
//

//@StateObject var todoModel = ToDoListItemViewViewModel()

import SwiftUI

struct MoreInfoView: View {
    @ObservedObject var reminderModel = ReminderViewViewModel()
    
    //@Binding var item: ToDoListItem

    var body: some View {
        VStack {
            //Text(item.title)
            
            HStack {
                ForEach(reminderModel.reminders.indices, id: \.self) { index in
                    Text(dateToString(reminderModel.reminders[index]))
                }
                
            }
            
            Button(action: {
                withAnimation {
                    //todoModel.deleteItem(item: item)
                    print("button pressed")
                }
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())

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
    //@State var previewItem = ToDoListItem(id: "1", title: "Sample Task", isDone: false)
    //return MoreInfoView(item: $previewItem)
    MoreInfoView()
}
