import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @EnvironmentObject var HomePageModel: HomePageViewViewModel
    @EnvironmentObject var fullCalendarModel: FullCalendarViewViewModel
    
    @State var customUnit = String()
    
    @Binding var currentDate: Date
    @Binding var tasksTotal: Int
    @Binding var tasksFinished: Int
    
    let initialGoal: String
    
    var distance = ["steps", "m", "mi"]
    var time = ["min", "hr"]
    var amount = ["l", "g"]
    var combined = ["steps", "m", "mi", "min", "hr", "l", "g"]
    
    var pickerSections = ["Distance", "Time", "Amount"]
    var sectionItems: [[String]] {
        return [distance, time, amount]
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Win", text: $viewModel.title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .onAppear {
                                viewModel.title = initialGoal
                            }
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        TextField("Optional", text: $viewModel.description)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    // Reminder
                    ReminderView()
                        .environmentObject(viewModel)
                    
                    // Tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tracking")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 10) {
                            TextField("Goal Value", value: $viewModel.tracking, formatter: numberFormatter)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                            
                            UnitPickerView(selectedUnit: $viewModel.selectedUnit)
                                .environmentObject(viewModel)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onChange(of: viewModel.selectedUnit) {
                            if !combined.contains(viewModel.selectedUnit) {
                                viewModel.useCustomUnit = true
                            } else {
                                viewModel.useCustomUnit = false
                            }
                        }
                        
                        if viewModel.useCustomUnit && (combined.contains(viewModel.selectedUnit) || viewModel.selectedUnit == "custom") {
                            TextField("Enter custom unit", text: $customUnit)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Save Button
                    Button(action: {
                        if viewModel.canSave {
                            if viewModel.useCustomUnit && customUnit != "" {
                                viewModel.selectedUnit = customUnit
                            }
                            tasksTotal += 1
                            fullCalendarModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                            fullCalendarModel.loadProgress()
                            viewModel.save()
                            presentationMode.wrappedValue.dismiss()
                            
                            for index in 0..<viewModel.reminder.count {
                                NotificationManager.shared.scheduleNotification(
                                    title: "Daily Wins",
                                    body: "Complete your win!",
                                    date: Date(timeIntervalSince1970: viewModel.reminder[index])
                                )
                            }
                        } else {
                            viewModel.showAlert = true
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text("Please enter a goal"))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            // Removed the back button from here
        }
        .onDisappear {
            fullCalendarModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
            fullCalendarModel.loadProgress()
        }
    }
}

struct UnitPickerView: View {
    @EnvironmentObject var viewModel: NewItemViewViewModel
    @Binding var selectedUnit: String
    
    var distance = ["steps", "m", "mi"]
    var time = ["min", "hr"]
    var amount = ["l", "g"]
    var combined = ["steps", "m", "mi", "min", "hr", "l", "g"]
    
    var pickerSections = ["Distance", "Time", "Amount", "Custom"]
    var sectionItems: [[String]] {
        return [distance, time, amount]
    }
    
    var body: some View {
        Picker("Unit", selection: $selectedUnit) {
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
            if !combined.contains(viewModel.selectedUnit) && viewModel.selectedUnit != "count" {
                Section {
                    Text(viewModel.selectedUnit).tag(viewModel.selectedUnit)
                } header: {
                    Text("Custom Unit")
                }
            }

            Section {
                Text("custom").tag("custom")
            } header: {
                Text("Custom")
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
}
