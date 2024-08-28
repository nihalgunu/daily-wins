//
//  FullCalendarView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/1/24.
//

import SwiftUI

struct FullCalendarView: View {
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
    

    var body: some View {
        VStack(spacing: 20) {
            let days: [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
            
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(extraDate[0])
                        .font(.system(size: 12))
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate[1])
                        .font(.title3.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                
                Button {
                    withAnimation{
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                }
            }
            .padding(.horizontal, 10)
            
            // Day View
            HStack(spacing: 5) {
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.blue)
                }
            }
            // Dates
            // Lazy Grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(extractDate) { value in
                    VStack {
                        CardView(value: value)
                    }
                    
                }
            }
        }
        .padding(.top, -50)
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

                            // Progress Circle
                            if let progress = fullCalendarViewModel.dailyProgress.first(where: { Calendar.current.isDate($0.date, inSameDayAs: value.date) }) {
                                Circle()
                                    .trim(from: 0.0, to: Double(progress.tasksFinished) / Double(progress.tasksTotal))
                                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color.blue)
                                    .rotationEffect(Angle(degrees: 90.0))
                                    .animation(.linear, value: Double(progress.tasksFinished))
                            }
                            else {
                               // Display a placeholder or zero progress until data is loaded
                               Circle()
                                   .trim(from: 0.0, to: 0.0)  // Placeholder with zero progress
                                   .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                   .foregroundColor(Color.blue)
                                   .rotationEffect(Angle(degrees: 90.0))
                           }
                        }
                        Text("\(value.day)")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        // Gray indicator circle
                        if Calendar.current.isDate(value.date, inSameDayAs: Date()) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 10, height: 10)
                                .offset(y: 30)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .frame(height: 50, alignment: .top)
        .onAppear {
            fullCalendarViewModel.loadProgress(for: currentDate)
        }
    }
}

// Preview
struct FullCalendarView_Previews: PreviewProvider {
    @State static var previewTasksTotal = 0
    @State static var previewTasksFinished = 0
    @State static var previewCurrentMonth = 8
    @State static var previewCurrentDate = Date()
    
    static var previewExtraDate = ["2024-08-26", "Monday"] // Example data
    static var previewExtractDate = [DateValue(day: 26, date: Date())]

    
    static var previews: some View {
        FullCalendarView(currentMonth: $previewCurrentMonth, currentDate: $previewCurrentDate, tasksTotal: $previewTasksTotal, tasksFinished: $previewTasksFinished, extraDate: previewExtraDate, extractDate: previewExtractDate)
            .environmentObject(HomePageViewViewModel())

    }
}

//func isToday(date: Date) -> Bool {
//    let calendar = Calendar.current
//    return calendar.isDate(currentDate, inSameDayAs: date)
//}
//
//func isCurrentMonth(date: Date) -> Bool {
//    let calendar = Calendar.current
//    let components = calendar.dateComponents([.year, .month], from: date)
//    let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
//    return components.month == currentComponents.month && components.year == currentComponents.year
//}
