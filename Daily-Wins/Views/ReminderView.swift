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
    @State private var displaySelectedTime = false
    @State private var tentativeDate = Date()
    
    @State private var reminders: [Date] = []
    
    
    //@Binding var selectedOption: String
    //@Binding var options: [String]
    
    @State private var currentTime = Date()
    @State private var dates: [Date] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Reminder")
                    .fontWeight(.bold)
                    .padding()
                
                Button {
                    dates.append(Date())
                } label: {
                    Image(systemName: "plus")
                }
                .padding()
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(dates, id: \.self) { item in
                        DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
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


/*if displaySelectedTime {
    ForEach(reminders, id: \.self) { item in
        Text("\(item, formatter: dateFormatter)")
                .padding()
    }
}
            
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

Spacer()*/

// Separate VStack for bottomSheet
/*if showSheet {
    VStack {
        Spacer()
        bottomSheet(showSheet: $showSheet, selectedDate: $selectedDate, displaySelectedTime: $displaySelectedTime, tentativeDate: $tentativeDate, reminders: $reminders)
            .transition(.move(edge: .bottom))
            .animation(.easeInOut, value: showSheet)
    }
}*/
