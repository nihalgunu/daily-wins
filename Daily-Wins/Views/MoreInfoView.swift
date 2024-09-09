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
    
    @State private var customUnit = String()
    @State private var currentProgressText: String
    @State private var goalValueText: String
    
    var distance = ["steps", "m", "km", "mi"]
    var time = ["sec", "min", "hr"]
    var amount = ["ml", "l", "oz", "mg","g"]
    var combined = ["steps", "m", "km", "mi", "sec", "min", "hr", "ml", "l", "oz", "mg","g"]
    
    var pickerSections = ["Distance", "Time", "Amount"]
    
    var sectionItems: [[String]] {
        return [distance, time, amount]
    }
    
    var item: ToDoListItem
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
        
        _currentProgressText = State(initialValue: String(initialProgress))
        _goalValueText = State(initialValue: String(initialTracking))
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
                        .onAppear {
                            NewItemModel.title = item.title
                        }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Optional", text: $NewItemModel.description)
                            .onAppear {
                                NewItemModel.description = initialDescription
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // Reminders
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Reminders")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Button {
                                NewItemModel.reminder.append(Date().timeIntervalSince1970)
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyVGrid(columns: columns) {
                                ForEach(NewItemModel.reminder.indices, id: \.self) { index in
                                    Button(action: {
                                        NewItemModel.reminder.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                    
                                    DatePicker("", selection: Binding(
                                        get: {
                                            Date(timeIntervalSince1970: NewItemModel.reminder[index])
                                        },
                                        set: { newValue in
                                            NewItemModel.reminder[index] = newValue.timeIntervalSince1970
                                        }
                                    ), displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding(.vertical, 5)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .onAppear {
                        NewItemModel.reminder = initialReminder
                    }
                    
                    // Progress Tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Progress")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            TextField("Current", text: $currentProgressText)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                            
                            Text("/")
                                .font(.title2)
                            
                            TextField("Goal", text: $goalValueText)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                            
                            Picker("Unit", selection: $NewItemModel.selectedUnit) {
                                Section {
                                    Text("count").tag("count")
                                } header: {
                                    Text("Count")
                                }
                                
                                ForEach(0..<sectionItems.count, id: \.self) { i in
                                    Section {
                                        ForEach(sectionItems[i], id: \.self) { item in
                                            Text(item).tag(item)
                                        }
                                    } header: {
                                        Text(pickerSections[i])
                                    }
                                }
                                if !combined.contains(NewItemModel.selectedUnit) && NewItemModel.selectedUnit != "count" {
                                    Section {
                                        Text(NewItemModel.selectedUnit).tag(NewItemModel.selectedUnit)
                                    } header: {
                                        Text("Custom Unit")
                                    }
                                }

                                Section {
                                    Text("custom").tag("custom")
                                } header: {
                                    Text("Create Custom")
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: NewItemModel.selectedUnit) {
                            if !combined.contains(NewItemModel.selectedUnit) {
                                NewItemModel.useCustomUnit = true
                            } else {
                                NewItemModel.useCustomUnit = false
                            }
                        }
                        .onAppear {
                            NewItemModel.selectedUnit = initialSelectedUnit
                            NewItemModel.useCustomUnit = initialUseCustom
                        }
                        
                        if NewItemModel.useCustomUnit && (combined.contains(NewItemModel.selectedUnit) || NewItemModel.selectedUnit == "custom") {
                            TextField("Enter custom unit", text: $customUnit)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Save Button
                    Button(action: {
                        if NewItemModel.canSave {
                            NewItemModel.isDone = item.isDone
                            if NewItemModel.useCustomUnit && customUnit != "" {
                                NewItemModel.selectedUnit = customUnit
                            }
                            NewItemModel.progress = Int(currentProgressText) ?? 0
                            NewItemModel.tracking = Int(goalValueText) ?? 1
                            NewItemModel.save()
                            dismiss()
                            HomePageModel.delete(id: item.id)
                            
                            for index in 0..<NewItemModel.reminder.count {
                                NotificationManager.shared.scheduleNotification(
                                    title: "Daily Wins",
                                    body: "Complete your win!",
                                    date: Date(timeIntervalSince1970: NewItemModel.reminder[index])
                                )
                            }
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
                            fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                            fullCalendarViewModel.loadProgress()
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
            fullCalendarViewModel.loadProgress()
        }
    }
}
