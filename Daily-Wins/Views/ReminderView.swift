//
//  ReminderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//

import SwiftUI

struct ReminderView: View {
    @State private var showSheet = false
    @State private var selectedDate = Date()
    @State private var selectedBool = false
    
    @Binding var selectedOption: String
    @Binding var options: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminder")
                    .fontWeight(.bold)
                Spacer()

                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                                
                if selectedBool {
                    Text("\(selectedDate, formatter: dateFormatter)")
                            .padding()
                }
                
                Spacer()
            }
            .padding(.horizontal)

            ZStack {
                if showSheet {
                    bottomSheet(selectedTime: $selectedDate, showTime: $selectedBool)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.easeInOut, value: showSheet)

            
            HStack {
                Text("Seed")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            
            
            // Dropdown
            HStack {
                Text("Options")
                    .fontWeight(.bold)
                Spacer()
                Picker("", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ReminderView(selectedOption: .constant("Running"), options: .constant(["Run", "Drink Water", "Take Vitamins", "Gym", "Read", "Journal"]))
}
