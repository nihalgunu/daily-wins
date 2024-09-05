//
//  ReminderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//


//@State private var dates: [Date] = []

import SwiftUI

struct ReminderView: View {
    @EnvironmentObject var viewModel: NewItemViewViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Reminder")
                    .font(.headline)
                
                Button {
                    viewModel.reminder.append(Date().timeIntervalSince1970)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                        .contentShape(Rectangle())
                }
            }
            //.padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.reminder.indices, id: \.self) { index in
                        Button(action: {
                            viewModel.reminder.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                        
                        DatePicker("reminder", selection: Binding(
                            get: {
                                Date(timeIntervalSince1970: viewModel.reminder[index])
                            },
                            set: { newValue in
                                viewModel.reminder[index] = newValue.timeIntervalSince1970
                            }
                        ), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding(.vertical, 5)
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
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
        .environmentObject(NewItemViewViewModel())
}
