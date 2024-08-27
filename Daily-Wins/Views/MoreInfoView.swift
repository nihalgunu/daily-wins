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
    
    var distance = ["steps", "meters", "kilometers", "miles"]
    var time = ["seconds", "minutes", "hours"]
    var amount = ["mililiters", "liters", "ounces", "miligrams","grams"]
    
    var pickerSections = ["Distance", "Time", "Amount", "Custom"]
    var sectionItems: [[String]] {
        return [distance, time, amount]
    }
    
    var item: ToDoListItem
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    // Title
                    Text(item.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                        .onAppear {
                            NewItemModel.title = item.title
                        }
                    
                    //Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline).bold()
                            .foregroundColor(.primary)
                        
//                        Text(item.description)
                        TextField("Optional", text: $NewItemModel.description)
                            .onAppear {
                                NewItemModel.description = initialDescription
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    //Reminders
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Reminders")
                                .font(.headline).bold()
                                .foregroundColor(.primary)
                            Button {
                                NewItemModel.reminder.append(Date().timeIntervalSince1970)
                            } label: {
                                Image(systemName: "plus")
                            }
                            .padding()
                        }
                        .padding(.trailing, 20)
                        
                        ScrollView {
                            HStack {
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
                                    .frame(height: 50)
                                    .labelsHidden()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    .onAppear {
                        NewItemModel.reminder = initialReminder
                    }
                    
                    .padding(.horizontal)
                    .font(.body)
                    .foregroundColor(.blue)
                    
                    //Tracking
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tracking")
                            .font(.headline).bold()
                            .foregroundColor(.primary)
                        
                        HStack {
                            TextField("Enter number", value: $NewItemModel.progress, formatter: numberFormatter)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(minWidth: 10, maxWidth: .infinity, alignment: .trailing)
                                .onAppear {
                                    NewItemModel.progress = initialProgress
                                }
                            
                            Text("/")
                            
                            TextField("Goal Value", value: $NewItemModel.tracking, formatter: numberFormatter)
                                .onAppear {
                                    NewItemModel.tracking = initialTracking
                                }
                            
                            Picker("", selection: $NewItemModel.selectedUnit) {
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
                            .onChange(of: NewItemModel.selectedUnit) { oldValue, newValue in
                                NewItemModel.useCustomUnit = (newValue == "custom")
                            }
                        }
                        if NewItemModel.useCustomUnit {
                            TextField("Enter custom unit", text: $NewItemModel.customUnit)
                                .padding()
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Save Button
                    
                    TLButton(title: "Save", background: .pink) {
                        if NewItemModel.canSave {
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
                    .padding()
                    .frame(width: 350)
                    .alert(isPresented: $NewItemModel.showAlert) {
                        Alert(title: Text("Error"), message: Text("Please enter a goal"))
                    }
                    
                    // Delete Button
                    
                    Button(action: {
                        withAnimation {
                            HomePageModel.delete(id: item.id)

                        }
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
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


//struct MoreInfoView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        MoreInfoView(HomePageModel: HomePageViewViewModel(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2"), updatedProgress: updatedProgress, item: ToDoListItem(id: "1", title: "Sample Task", description: "Detailed description here...", tracking: 0, reminder: [Date().timeIntervalSince1970], progress: 0, isDone: false, unit: "count"))
//            .environmentObject(NewItemViewViewModel())
//    }
//}
