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
    @Binding var finalMonth: Int

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
                .padding(.vertical)
                
                HStack {
                    ForEach(days, id: \.self) { day in
                        VStack {
                            Text(day)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal)

                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(extractDate.prefix(7)) { value in
                        VStack {
                            CardView(value: value)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 160)
        .cornerRadius(10)
        .onAppear {
            currentMonth = finalMonth
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                VStack {
                    ZStack {
                        ZStack {
                            // Base Circle
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                .fill(Color.red)
                                .opacity(0.3)
                                .foregroundColor(.blue)
                                .frame(width: 35, height: 35)

                            // Progress Circle
                            if let progress = fullCalendarViewModel.dailyProgress.first(where: {
                                Calendar.current.isDate($0.date, inSameDayAs: value.date) &&
                                Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .month)
                            }), progress.tasksTotal > 0 {
                                Circle()
                                    .trim(from: 0.0, to: Double(progress.tasksFinished) / Double(progress.tasksTotal))
                                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color.blue)
                                    .rotationEffect(Angle(degrees: 90.0))
                                    .animation(.linear, value: Double(progress.tasksFinished))
                                    .frame(width: 35, height: 35)
                            }
                            else {
                               // Display a placeholder or zero progress until data is loaded
                               Circle()
                                   .trim(from: 0.0, to: 0.0)
                                   .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                   .foregroundColor(Color.blue)
                                   .rotationEffect(Angle(degrees: 90.0))
                           }
                        }
                        .onAppear {
                            fullCalendarViewModel.loadProgress()
                        }
                        
                        Text("\(value.day)")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Gray indicator circle
                        if Calendar.current.isDate(value.date, inSameDayAs: Date()) {
                            Circle()
                                //.fill(Color.gray)
                                .foregroundColor(.primary)
                                .frame(width: 6, height: 6)
                                .offset(y: 30)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
    func formattedDateString() -> String {
        let date = currentDate // Current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Set the date style (e.g., .short, .medium, .long, .full)
        dateFormatter.timeStyle = .none   // Set the time style (e.g., .short, .medium, .long, .full, .none)
        
        return dateFormatter.string(from: date)
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
        WeeklyCalendarView(currentMonth: $previewCurrentMonth, currentDate: $previewCurrentDate, finalMonth: $previewCurrentMonth, tasksTotal: $previewTasksTotal, tasksFinished: $previewTasksFinished, extraDate: previewExtraDate, extractDate: previewExtractDate)
            .environmentObject(HomePageViewViewModel())
            .environmentObject(UserViewModel())
            .environmentObject(FullCalendarViewViewModel())
    }
}

