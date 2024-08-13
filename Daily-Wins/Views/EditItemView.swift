//
//  EditItemView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 8/12/24.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var viewModel: NewItemViewViewModel
    @StateObject var todoModel: HomePageViewViewModel

    let initialGoal: String
    let initialDescription: String
    let initialReminder: [TimeInterval]
    
    @State private var goalValue: Int? = nil
    @State private var unit = ""
    @State private var description: String = ""
    
    var item: ToDoListItem
    
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
                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.headline)
                        TextField("Optional", text: $viewModel.description)
                            .onAppear {
                                viewModel.description = initialDescription
                            }
                    }
                    
                    // Reminder
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Reminder")
                                .font(.headline)
                            
                            Button {
                                viewModel.reminder.append(Date().timeIntervalSince1970)
                            } label: {
                                Image(systemName: "plus")
                            }
                            Spacer()
                        }
                        .padding(.trailing, 20)
                        
                        ScrollView {
                            HStack {
                                ForEach(viewModel.reminder.indices, id: \.self) { index in
                                    
                                    Button(action: {
                                        viewModel.reminder.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.red)
                                    }
                                    
                                    DatePicker("", selection: Binding(
                                        get: {
                                            Date(timeIntervalSince1970: viewModel.reminder[index])
                                        },
                                        set: { newValue in
                                            viewModel.reminder[index] = newValue.timeIntervalSince1970
                                        }
                                    ), displayedComponents: .hourAndMinute)
                                    .frame(height: 50)
                                    .labelsHidden()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .onAppear {
                        viewModel.reminder = initialReminder
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text("Tracking")
                            .font(.headline)
                        
                        HStack {
                            TextField("Goal Value", value: $viewModel.tracking, formatter: numberFormatter)
                                .padding()
                                                        
                            Picker("", selection: $viewModel.selectedUnit) {
                                Section {
                                    Text("count")
                                } header: {
                                    Text("Count")
                                }
                                
                                ForEach(0..<sectionItems.count, id: \.self) { i in
                                    Section {
                                        ForEach(sectionItems[i], id: \.self) { item in
                                            Text(item)
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
                            todoModel.delete(id: item.id)
                            
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

struct EditItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewNavigationPath = NavigationPath()
    
    static var previews: some View {
        NewItemView(initialGoal: "test")
    }
}
