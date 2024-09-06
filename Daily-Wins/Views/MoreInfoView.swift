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
    
    var distance = ["steps", "meters", "kilometers", "miles"]
    var time = ["seconds", "minutes", "hours"]
    var amount = ["mililiters", "liters", "ounces", "miligrams","grams"]
    var combined = ["steps", "meters", "kilometers", "miles", "seconds", "minutes", "hours", "mililiters", "liters", "ounces", "miligrams","grams"]
    
    var pickerSections = ["Distance", "Time", "Amount"]
    
    var sectionItems: [[String]] {
        var items = [distance, time, amount]
//        if NewItemModel.useCustomUnit {
//            items.append([customUnitInput])
//        }
        return items
    }
    
    var item: ToDoListItem
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    // Title
                    Text(item.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                        .onAppear {
                            NewItemModel.title = item.title
                        }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.primary)
                        
                        TextField("Optional", text: $NewItemModel.description)
                            .onAppear {
                                NewItemModel.description = initialDescription
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Reminders
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Reminders")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.primary)
                            Button {
                                NewItemModel.reminder.append(Date().timeIntervalSince1970)
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyVGrid(columns: columns) {
                                ForEach(NewItemModel.reminder.indices, id: \.self) { index in
                                    
                                    Button(action: {
                                        NewItemModel.reminder.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle")
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
                    .padding(.horizontal)
                    
                    // Progress Tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tracking")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.primary)
                        
                        HStack {
                            TextField("Enter number", value: $NewItemModel.progress, formatter: numberFormatter)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onAppear {
                                    NewItemModel.progress = initialProgress
                                }
                            
                            Text("/")
                          
                    // Total Tracking
                            TextField("Goal Value", value: $NewItemModel.tracking, formatter: numberFormatter)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .onAppear {
                                    NewItemModel.tracking = initialTracking
                        
                                    NewItemModel.useCustomUnit = initialUseCustom
                                    NewItemModel.selectedUnit = initialSelectedUnit
                                    
                                    print(initialUseCustom)
                                    print(NewItemModel.useCustomUnit)
                                    print(initialSelectedUnit)
                                    print(NewItemModel.selectedUnit)
                                }
                            
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
                                if !combined.contains(NewItemModel.selectedUnit) {
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
                        //Custom Unit Tracking
//                                .onChange(of: NewItemModel.selectedUnit) {
//                                    NewItemModel.useCustomUnit = (NewItemModel.selectedUnit == "custom")
//                                    print("here testing rn:", NewItemModel.selectedUnit)
//                                    print("here testing rn: ", NewItemModel.useCustomUnit)
//                                }
                            }
                            .onAppear {

                            }
                            .onDisappear {
                            }
                            .labelsHidden()
                            .pickerStyle(MenuPickerStyle())
                        }
                        .onChange(of: NewItemModel.selectedUnit) {
                            if !combined.contains(NewItemModel.selectedUnit) {
                                NewItemModel.useCustomUnit = true
                            } else {
                                NewItemModel.useCustomUnit = false
                            }
                            print(NewItemModel.useCustomUnit)
                        }
                        
                        .onAppear {
                            if !combined.contains(NewItemModel.selectedUnit) {
                                NewItemModel.useCustomUnit = false
                                print("ON APPEAR HERE: ", NewItemModel.useCustomUnit)
                            }
                        }
                        
                        if NewItemModel.useCustomUnit && (combined.contains(NewItemModel.selectedUnit) || NewItemModel.selectedUnit == "custom") {
                            TextField("Enter custom unit", text: $customUnit)
                                .onAppear {
                                    print("ONE APPEAR HERE 2: ", NewItemModel.useCustomUnit)
                                }
                        }
                    }

                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    

                    
                    // Save Button
                    TLButton(title: "Save Changes", background: .blue) { // Changed background to blue
                        if NewItemModel.canSave {
                            NewItemModel.isDone = item.isDone
                            if NewItemModel.useCustomUnit && customUnit != "" {
                                NewItemModel.selectedUnit = customUnit
                            }
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
                    }
                    .onDisappear {
                        print("HERE AFTER:", NewItemModel.useCustomUnit)
                    }
                    .onAppear {
                        
                    }
                    .padding()
                    .font(.headline)
                    .frame(width: 300, height: 60)
                    .background(Color.clear) // Set the background to clear to remove the red background
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .alert(isPresented: $NewItemModel.showAlert) {
                        Alert(title: Text("Error"), message: Text("Please enter a goal"))
                    }


                    // Delete Button
                    Button(action: {
                        withAnimation {
                            HomePageModel.delete(id: item.id)
                        }
                    }) {
                        Text("Delete Task")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: 150)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        print("\(NewItemModel.tracking)")
                        print("\(NewItemModel.progress)")
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onDisappear {
                fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
            }
        }
    }
    
    private func formattedDate(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}
