//
//  FullCalendarView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/1/24.
//

import SwiftUI

struct FullCalendarView: View {
    @EnvironmentObject var HomePageModel: HomePageViewViewModel
    
    @State var currentMonth: Int = 0
    @State private var currentDate = Date()

    @Binding var tasksTotal: Int
    @Binding var tasksFinished: Int
    
    var date = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            let days: [String] = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
            
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(extraDate()[0])
                        .font(.system(size: 12))
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1])
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
                ForEach(extractDate()) { value in
                    VStack {
                        CardView(value: value)
                    }
                    
                }
            }
        }
        .padding(.top, -50)
        .onAppear {
            checkAndUpdateDate()
            startMidnightTimer()
            print(currentDate)
            print(date)
        }
        .onChange(of: currentMonth) {
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                VStack {
                    ZStack {
                        ZStack {
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                .fill(Color.red)
                                .opacity(0.3)
                                .foregroundColor(.blue)

                            if Calendar.current.isDate(value.date, inSameDayAs: Date()) {
                                Circle()
                                    .trim(from: 0.0, to: Double(tasksFinished) / Double(tasksTotal))
                                    .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color.blue)
                                    .rotationEffect(Angle(degrees: 90.0))
                                    .animation(.linear, value: Double(tasksFinished))
                            }
                        }
                        Text("\(value.day)")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
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
    }
    
    // extracting Year And Month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }

    
    // Getting Current Month Date
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current

        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current

        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
            
        }
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
    func startMidnightTimer() {
        let midnight = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0), matchingPolicy: .nextTime)!
        let timer = Timer(fire: midnight, interval: 86400, repeats: true) { _ in
            currentDate = Date()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func checkAndUpdateDate() {
        let today = Date()
        if !Calendar.current.isDate(currentDate, inSameDayAs: today) {
            currentDate = today
        }
    }
}

// Preview
struct FullCalendarView_Previews: PreviewProvider {
    @State static var previewTasksTotal = 0
    @State static var previewTasksFinished = 0
    
    static var previews: some View {
        FullCalendarView(tasksTotal: $previewTasksTotal, tasksFinished: $previewTasksFinished)
            .environmentObject(HomePageViewViewModel(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2"))

    }
}

// Extanding Date to get Current Month Dates...
extension Date {
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        // getting date
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
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
