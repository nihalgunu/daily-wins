//
//  ReminderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//

import SwiftUI

struct ReminderView: View {
    
    @State private var reminders: [Date] = []
    
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
                HStack {
                    ForEach(dates.indices, id: \.self) { index in
                        
                        Button(action: {
                            dates.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                        
                        DatePicker("", selection: $dates[index], displayedComponents: .hourAndMinute)
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
