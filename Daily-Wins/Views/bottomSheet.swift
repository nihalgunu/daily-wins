//
//  bottomSheet.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//

import SwiftUI

struct bottomSheet: View {
    @Binding var showSheet: Bool
    @Binding var selectedDate: Date
    @Binding var displaySelectedTime: Bool
    @Binding var tentativeDate: Date
    @Binding var reminders: [Date]

    var body: some View {
        VStack {
            HStack {
                Text("Select Time")
                    .bold()
                    .padding(.leading, 80)
                
                Spacer()
                
                Button {
                    showSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                        .contentShape(Rectangle())
                }
            }

            DatePicker("",
                       selection: $tentativeDate,
                       displayedComponents: [.hourAndMinute])
            
            TLButton(title: "Confirm", background: .blue) {
                selectedDate = tentativeDate
                displaySelectedTime = true
                showSheet = false
                reminders.append(selectedDate)
            }
            .padding(.top, 20)
            .frame(width: 200, height: 50)
            .cornerRadius(8)
        }
        .datePickerStyle(WheelDatePickerStyle())
        .padding()
        .multilineTextAlignment(.center)
        .frame(width: 300, height: 360)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct bottomSheet_Previews: PreviewProvider {
    @State static var previewDate = Date()
    @State static var previewBool = Bool()
    @State static var previewShowSheet = Bool()
    @State static var previewTentativeDate = Date()
    @State static var previewReminders: [Date] = []

    static var previews: some View {
        bottomSheet(showSheet: $previewShowSheet, selectedDate: $previewDate, displaySelectedTime: $previewBool, tentativeDate: $previewTentativeDate, reminders: $previewReminders)
    }
}
