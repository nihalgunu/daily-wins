//
//  ReminderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//


//@State private var dates: [Date] = []

import SwiftUI

struct ReminderView: View {
    
    @StateObject var viewModel = ReminderViewViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminder")
                    .fontWeight(.bold)
                    .padding()
                
                Button {
                    viewModel.reminders.append(Date())
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
            }
            
            ScrollView {
                HStack {
                    ForEach(viewModel.reminders.indices, id: \.self) { index in
                        
                        Button(action: {
                            viewModel.reminders.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                        
                        DatePicker("", selection: $viewModel.reminders[index], displayedComponents: .hourAndMinute)
                            .frame(height: 50)
                            .labelsHidden()
                        
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            //MoreInfoView(reminderModel: viewModel) // Directly passing the view model
                //.padding()
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
