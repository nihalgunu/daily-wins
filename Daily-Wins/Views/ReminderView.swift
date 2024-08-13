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
                }
                Spacer()
            }
            .padding(.trailing, 20)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.reminder.indices, id: \.self) { index in
                        DatePicker("", selection: Binding(
                            get: {
                                Date(timeIntervalSince1970: viewModel.reminder[index])
                            },
                            set: { newValue in
                                viewModel.reminder[index] = newValue.timeIntervalSince1970
                            }
                        ), displayedComponents: .hourAndMinute)
                        .frame(height: 50)
                        .labelsHidden()
                        
                        Button(action: {
                            viewModel.reminder.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
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
        .environmentObject(NewItemViewViewModel())
}
