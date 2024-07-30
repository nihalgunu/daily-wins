//
//  ReminderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//


//@State private var dates: [Date] = []

import SwiftUI

struct ReminderView: View {
    //@StateObject var reminderModel = ReminderViewViewModel()
    //@Binding var item: ToDoListItem
    @EnvironmentObject var viewModel: NewItemViewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Reminder")
                    .font(.headline)
                
                Button {
                    viewModel.reminder.append(Date())
                    print("Added reminder, total reminders: \(viewModel.reminder.count)")
                } label: {
                    Image(systemName: "plus")
                }
                Spacer()
            }
            .padding(.trailing, 20)

            ScrollView {
                HStack {
                    ForEach(viewModel.reminder.indices, id: \.self) { index in
                        Button(action: {
                            viewModel.reminder.remove(at: index)
                            print("Removed reminder, total reminders: \(viewModel.reminder.count)")

                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                        
                        DatePicker("", selection: $viewModel.reminder[index], displayedComponents: .hourAndMinute)
                            .frame(height: 50)
                            .labelsHidden()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ReminderView()
}
