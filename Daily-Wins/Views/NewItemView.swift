//
//  NewItemView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

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
    var combined = ["steps", "m", "mi", "min", "hr", "l", "oz", "g"]
    
    var pickerSections = ["Distance", "Time", "Amount", "Custom"]
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
            Form {
                // Title
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                    TextField("Win", text: $viewModel.title)
                        .onAppear {
                            viewModel.title = initialGoal
                        }
                }
                
                // Description
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                    TextField("Optional", text: $viewModel.description)
                }
                
                // Reminder
                ReminderView()
                    .environmentObject(viewModel)
                
                //Tracking
                VStack(alignment: .leading) {
                    Text("Tracking")
                        .font(.headline)
                    
                    HStack {
                        TextField("Goal Value", value: $viewModel.tracking, formatter: numberFormatter)
                            .padding()                           
                // Unit Picker
                        UnitPickerView(selectedUnit: $viewModel.selectedUnit)
                            .environmentObject(viewModel)
                            .onChange(of: viewModel.selectedUnit) {
                                if !combined.contains(viewModel.selectedUnit) {
                                    viewModel.useCustomUnit = true
                                } else {
                                    viewModel.useCustomUnit = false
                                }
                                print(viewModel.useCustomUnit)
                            }
//                            .onAppear {
//                                if !combined.contains(viewModel.selectedUnit) {
//                                    viewModel.useCustomUnit = false
//                                }
//                            }
                    }
                    
                    if viewModel.useCustomUnit && (combined.contains(viewModel.selectedUnit) || viewModel.selectedUnit == "custom") {
                        TextField("Enter custom unit", text: $customUnit)
                    }
                }
                
                // Button
                TLButton(title: "Save", background: .pink) {
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
                }
                .onDisappear {
                    fullCalendarModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                    fullCalendarModel.loadProgress()
                }
                .padding()
                .frame(width: 450)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please enter a goal"))
                }
            }
        }
    }
}

struct UnitPickerView: View {
    @EnvironmentObject var viewModel: NewItemViewViewModel
    @Binding var selectedUnit: String
    
    //@State var customUnit = String()

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
            if !combined.contains(viewModel.selectedUnit) && viewModel.selectedUnit != "count"{
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
        .labelsHidden()

    }
}

struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewNavigationPath = NavigationPath()
    @State static var previewCustomUnit = ""
    
    @State static var previewCD = Date()
    @State static var previewTT = 5
    @State static var previewTF = 5
    
    static var previews: some View {
        NewItemView(currentDate: $previewCD, tasksTotal: $previewTT, tasksFinished: $previewTF, initialGoal: "test")
    }
}
