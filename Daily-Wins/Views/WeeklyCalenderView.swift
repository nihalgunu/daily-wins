//
//  WeeklyCalenderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/27/24.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @EnvironmentObject var fullCalendarViewModel: FullCalendarViewViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var HomePageModel: HomePageViewViewModel

    @Binding var currentMonth: Int
    @Binding var currentDate: Date

    @Binding var tasksTotal: Int
    @Binding var tasksFinished: Int
    
    var date = Date()
    var extraDate: [String]
    var extractDate: [DateValue]
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]


    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
            VStack {
                HStack() {
                    Text(extraDate[0])
                        .font(.system(size: 12))
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate[1])
                        .font(.caption)
                        .fontWeight(.semibold)
                        .font(.system(size: 12))
                }
                .padding(.top)
                
                HStack {
                    ForEach(days, id: \.self) { day in
                        VStack {
                            Text(day)
                                .font(.headline)
                                .foregroundColor(.blue)
                            Spacer()
                            // Add additional components for each day, like events or markers
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
        }
        .frame(height: 150)
        .cornerRadius(10)
    }
}

struct WeeklyCalendarView_Previews: PreviewProvider {
    @State static var previewTasksTotal = 0
    @State static var previewTasksFinished = 0
    @State static var previewCurrentMonth = 8
    @State static var previewCurrentDate = Date()
    
    static var previewExtraDate = ["2024-08-26", "Monday"]
    static var previewExtractDate = [DateValue(day: 26, date: Date())]
    
    static var previews: some View {
        WeeklyCalendarView(currentMonth: $previewCurrentMonth, currentDate: $previewCurrentDate, tasksTotal: $previewTasksTotal, tasksFinished: $previewTasksFinished, extraDate: previewExtraDate, extractDate: previewExtractDate)
            .environmentObject(HomePageViewViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(FullCalendarViewViewModel())
    }
}

