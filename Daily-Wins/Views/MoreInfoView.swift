//
//  MoreInfoView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/16/24.
//

import SwiftUI

struct MoreInfoView: View {
    @StateObject var todoModel = HomePageViewViewModel(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
    var item: ToDoListItem
    //@Binding var item: ToDoListItem
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text(item.description)
                        .padding()
                }
                
                HStack {
                    VStack {
                        Text("Reminders: ")
                        ForEach(item.reminder.indices, id: \.self) { index in
                            Text("\(formattedDate(from: item.reminder[index]))")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }
                VStack {
                    Text("Tracking")
                    HStack {
                        Text("\(item.tracking)")
                            .padding()
                    }
                }
                
                
                Button(action: {
                    withAnimation {
                        todoModel.delete(id: item.id)
                    }
                }) {
                    Text("Delete")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle(item.title)
        }

    }
    
    private func formattedDate(from timeInterval: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: timeInterval)
            return dateFormatter.string(from: date)
        }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
//    @State var previewItem = ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false)
    MoreInfoView(item: ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false))
}
