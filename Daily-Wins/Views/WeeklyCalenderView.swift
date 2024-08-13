//
//  WeeklyCalenderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import SwiftUI

struct WeeklyCalendarView: View {
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                VStack {
                    Text(day)
                        .font(.headline)
                    Spacer()
                    // Add additional components for each day, like events or markers
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 60) // Adjust the height as needed
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    WeeklyCalendarView()
}
