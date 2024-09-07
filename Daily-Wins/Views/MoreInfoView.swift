import SwiftUI

struct MoreInfoView: View {
    @StateObject var HomePageModel: HomePageViewViewModel
    @EnvironmentObject var fullCalendarViewModel: FullCalendarViewViewModel
    @EnvironmentObject var NewItemModel: NewItemViewViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var currentDate: Date
    @Binding var tasksTotal: Int
    @Binding var tasksFinished: Int
    
    let initialGoal: String
    let initialDescription: String
    let initialTracking: Int
    let initialReminder: [TimeInterval]
    let initialProgress: Int
    let initialSelectedUnit: String
    let initialUseCustom: Bool
    
    @State var customUnit = String()
    @State private var currentProgress: Int
    @State private var goalValue: Int
    
    var item: ToDoListItem
    
    init(HomePageModel: HomePageViewViewModel, currentDate: Binding<Date>, tasksTotal: Binding<Int>, tasksFinished: Binding<Int>, initialGoal: String, initialDescription: String, initialTracking: Int, initialReminder: [TimeInterval], initialProgress: Int, initialSelectedUnit: String, initialUseCustom: Bool, item: ToDoListItem) {
        _HomePageModel = StateObject(wrappedValue: HomePageModel)
        _currentDate = currentDate
        _tasksTotal = tasksTotal
        _tasksFinished = tasksFinished
        self.initialGoal = initialGoal
        self.initialDescription = initialDescription
        self.initialTracking = initialTracking
        self.initialReminder = initialReminder
        self.initialProgress = initialProgress
        self.initialSelectedUnit = initialSelectedUnit
        self.initialUseCustom = initialUseCustom
        self.item = item
        
        // Initialize the @State properties
        _currentProgress = State(initialValue: initialProgress)
        _goalValue = State(initialValue: initialTracking)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text(item.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .onAppear { NewItemModel.title = item.title }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Optional", text: $NewItemModel.description)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onAppear { NewItemModel.description = initialDescription }
                    }
                    
                    // Progress Tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Progress")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Picker("Current", selection: $currentProgress) {
                                ForEach(0...1000, id: \.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 100)
                            .clipped()
                            
                            Text("/")
                                .font(.title2)
                            
                            Picker("Goal", selection: $goalValue) {
                                ForEach(1...1000, id: \.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 100)
                            .clipped()
                            
                            Picker("Unit", selection: $NewItemModel.selectedUnit) {
                                Text("count").tag("count")
                                ForEach(["km", "steps", "mins"], id: \.self) { unit in
                                    Text(unit).tag(unit)
                                }
                                Text("custom").tag("custom")
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .onAppear {
                            currentProgress = initialProgress
                            goalValue = initialTracking
                            NewItemModel.selectedUnit = initialSelectedUnit
                        }
                        
                        if NewItemModel.selectedUnit == "custom" {
                            TextField("Enter custom unit", text: $customUnit)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Reminders
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Reminders")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: { NewItemModel.reminder.append(Date().timeIntervalSince1970) }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ForEach(NewItemModel.reminder.indices, id: \.self) { index in
                            HStack {
                                DatePicker("", selection: Binding(
                                    get: { Date(timeIntervalSince1970: NewItemModel.reminder[index]) },
                                    set: { NewItemModel.reminder[index] = $0.timeIntervalSince1970 }
                                ), displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                
                                Spacer()
                                
                                Button(action: { NewItemModel.reminder.remove(at: index) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onAppear { NewItemModel.reminder = initialReminder }
                    
                    // Save Button
                    Button(action: {
                        if NewItemModel.canSave {
                            NewItemModel.isDone = item.isDone
                            if NewItemModel.selectedUnit == "custom" && !customUnit.isEmpty {
                                NewItemModel.selectedUnit = customUnit
                            }
                            NewItemModel.progress = currentProgress
                            NewItemModel.tracking = goalValue
                            NewItemModel.save()
                            HomePageModel.delete(id: item.id)
                            for reminderTime in NewItemModel.reminder {
                                NotificationManager.shared.scheduleNotification(
                                    title: "Daily Wins",
                                    body: "Complete your win!",
                                    date: Date(timeIntervalSince1970: reminderTime)
                                )
                            }
                            dismiss()
                        } else {
                            NewItemModel.showAlert = true
                        }
                    }) {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $NewItemModel.showAlert) {
                        Alert(title: Text("Error"), message: Text("Please enter a goal"))
                    }

                    // Delete Button
                    Button(action: {
                        withAnimation {
                            HomePageModel.delete(id: item.id)
                            dismiss()
                        }
                    }) {
                        Text("Delete Task")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            })
        }
        .onDisappear {
            fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
        }
    }
}
