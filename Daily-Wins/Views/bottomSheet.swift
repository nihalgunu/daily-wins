//
//  bottomSheet.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/8/24.
//

import SwiftUI

struct bottomSheet: View {
    @State private var showingDatePicker = false
    @Binding var selectedTime: Date
    @Binding var showTime: Bool

    
    var body: some View {
        VStack {
            HStack {
                Text("Select Time")
                    .bold()
                    .padding(.leading, 80)
                Spacer()
                Button {
                    showingDatePicker.toggle()
                } label: {
                    Image(systemName: "xmark")
                }
            }

            DatePicker("",
                       selection: $selectedTime,
                       displayedComponents: [.hourAndMinute])
            
            TLButton(title: "Confirm", background: .blue) {
                showingDatePicker.toggle()
                showTime = true
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

    static var previews: some View {
        bottomSheet(selectedTime: $previewDate, showTime: $previewBool)
    }
}
