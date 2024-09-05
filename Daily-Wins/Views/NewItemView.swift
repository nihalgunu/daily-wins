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
    
    let initialGoal: String
    
    var distance = ["steps", "meters", "kilometers", "miles"]
    var time = ["seconds", "minutes", "hours"]
    var amount = ["mililiters", "liters", "ounces", "miligrams","grams"]
    
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
            VStack {
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
                                                        
                            Picker("Unit", selection: $viewModel.selectedUnit) {
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
                                Section {
                                    Text("custom").tag("custom")
                                } header: {
                                    Text("custom")
                                }
                            }
                            .labelsHidden()
                            .onChange(of: viewModel.selectedUnit) { oldValue, newValue in
                                viewModel.useCustomUnit = (newValue == "custom")
                            }
                        }
                        if viewModel.useCustomUnit {
                            TextField("Enter custom unit", text: $viewModel.customUnit)
                                .padding()
                        }
                    }
                    
                    // Button
                    TLButton(title: "Save", background: .pink) {
                        if viewModel.canSave {
                            
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
                    .padding()
                    .frame(width: 450)
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"), message: Text("Please enter a goal"))
                    }
                }
            }
        }
        .onDisappear {
            print("selected Unit:", "\(viewModel.$selectedUnit)")
        }
    }
}

private func formattedDate(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewNavigationPath = NavigationPath()
    
    static var previews: some View {
        NewItemView(initialGoal: "test")
    }
}
