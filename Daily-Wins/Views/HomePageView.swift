import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewViewModel
    @StateObject var fullCalendarViewModel = FullCalendarViewViewModel()

    @EnvironmentObject var sharedData: SharedData
    @EnvironmentObject var userViewModel: UserViewModel
    
    @FirestoreQuery var items: [ToDoListItem]
    
    @State var navigationPath = NavigationPath()
    @State var currentDate = Date()
    @State var currentMonth: Int = 0

    @State var tasksTotal = 0
    @State var tasksFinished = 0
    
    var date = Date()
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel())
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }
    
    var fullCalendarView: some View {
        FullCalendarView(
            currentMonth: $currentMonth,
            currentDate: $currentDate,
            tasksTotal: $tasksTotal,
            tasksFinished: $tasksFinished,
            extraDate: extraDate(),
            extractDate: extractDate()
        )
        .environmentObject(viewModel)
        .environmentObject(userViewModel)
        .environmentObject(fullCalendarViewModel)
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
            
            NavigationStack(path: $navigationPath) {
                VStack(spacing: 10) {
                    Spacer().frame(height: 10)
                    
                    // Navigate to FullCalendarView
                    NavigationLink(destination: fullCalendarView) {
                        WeeklyCalendarView(currentMonth: $currentMonth,
                                           currentDate: $currentDate,
                                           tasksTotal: $tasksTotal,
                                           tasksFinished: $tasksFinished,
                                           extraDate: extraDate(),
                                           extractDate: extractDate())
                            .background(Color(UIColor.white)
                            .cornerRadius(10))
                    }
                    .padding(.horizontal)
                    Spacer()

                    HStack {
                        Text("Wins")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Spacer()
                        
                        // Navigate to PresetView
                        NavigationLink(destination: PresetView().environmentObject(viewModel)) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                   .padding(.horizontal)
                    
                    // Navigate to ToDoListItemView
                    ScrollView {
                        VStack(spacing: 10) {
                            if items.isEmpty {
                                Text("Tap '+' to add your first win")
                                    .foregroundColor(.black)
                                    .padding(.vertical, 150)
                            } else {
                                // Sort the items so that "In Progress" tasks are above "Completed" tasks
                                let sortedItems = items.sorted { !$0.isDone && $1.isDone }
                                
                                ForEach(sortedItems) { item in
                                    ToDoListItemView(ToDoListItemModel: ToDoListItemViewViewModel(), NewItemModel: NewItemViewViewModel(), currentDate: $currentDate, tasksTotal: $tasksTotal, tasksFinished: $tasksFinished, item: item)
                                        .environmentObject(fullCalendarViewModel)
                                        .cornerRadius(10)
                                        .shadow(color: .white, radius: 1, x: 0, y: 1)
                                        .environmentObject(viewModel)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer().frame(height: 50)
                }
                .foregroundColor(.primary)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView(viewModel: viewModel.profileViewModel)) {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onAppear {
                    viewModel.saveItems()
                    viewModel.checkForDailyUpdate()
                    
                    fullCalendarViewModel.loadProgress(for: currentDate)
                    fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                }
                .onDisappear() {
                    fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                }
                .onChange(of: items) {
                    tasksTotal = items.count
                    tasksFinished = 0
                    for item in items {
                        if item.isDone == true {
                            tasksFinished += 1
                        }
                    }
                    print("Tasks Total: \(tasksTotal)")
                    print("Tasks Finished: \(tasksFinished)")
                }
                .onChange(of: currentMonth) {
                    currentDate = getCurrentMonth()
                    fullCalendarViewModel.loadProgress(for: currentDate)
                }
            }
        }
    }
        
        
    
    // extracting Year And Month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
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

//#Preview {
//    HomePageView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
//        .environmentObject(SharedData())
//        .environmentObject(HomePageViewViewModel())
//}

//    func startMidnightTimer() {
//        let midnight = Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: 0), matchingPolicy: .nextTime)!
//        let timer = Timer(fire: midnight, interval: 86400, repeats: true) { _ in
//            fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
//            currentDate = Date()
//            fullCalendarViewModel.loadProgress(for: currentDate)
//        }
//        RunLoop.main.add(timer, forMode: .common)
//    }
//
//    func checkAndUpdateDate() {
//        let today = Date()
//        if !Calendar.current.isDate(currentDate, inSameDayAs: today) {
//            currentDate = today
//        }
//    }
