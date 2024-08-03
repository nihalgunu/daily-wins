//
//  NewItemView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var item: ToDoListItem
    @Binding var newItemPresented: Bool
    
    @Binding var Exercises: [String]
    @Binding var Health: [String]
    @Binding var Chores: [String]
    @Binding var Productivity: [String]
    @Binding var Health2: [String]
    @Binding var ScreenTime: [String]
    
    let initialGoal: String
    
    @State private var goalValue: Int? = nil
    @State private var unit = ""
    @State private var description: String = ""
    
    var distance = ["steps", "meters", "kilometers", "miles"]
    var time = ["seconds", "minutes", "hours"]
    var amount = ["mililiters", "liters", "ounces", "miligrams","grams"]
    
    var pickerSections = ["Distance", "Time", "Amount", "Custom"]
    var sectionItems: [[String]] {
        return [distance, time, amount]
    }
    
    @Binding var navigationPath: NavigationPath
    
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
                    }
                    
                    // Reminder
                    ReminderView()
                        .environmentObject(viewModel)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Tracking")
                            .font(.headline)
                        
                        HStack {
                            TextField("Goal Value", value: $viewModel.tracking, formatter: numberFormatter)
                                .padding()
                                                        
                            Picker("", selection: $unit) {
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
                            }
                        }
                    }
                    
                    // Button
                    TLButton(title: "Save", background: .pink) {
                        if viewModel.canSave {
                            viewModel.save()
                            presentationMode.wrappedValue.dismiss()
                            item.title = viewModel.title
                            item.description = viewModel.description
                            item.tracking = viewModel.tracking
                            item.reminder = viewModel.reminder
                            print(item.isDone)
                            // Append the HomePageView to the navigation path
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                navigationPath.removeLast(navigationPath.count)
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewExercises: [String] = []
    @State static var previewHealth: [String] = []
    @State static var previewChores: [String] = []
    @State static var previewProductivity: [String] = []
    @State static var previewHealth2: [String] = []
    @State static var previewScreenTime: [String] = []
    @State static var previewNavigationPath = NavigationPath()
    @State static var previewDescription = String()
    @State static var previewItem = ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [], isDone: false)
    
    static var previews: some View {
        NewItemView(item: $previewItem, newItemPresented: $previewNewItemPresented, Exercises: $previewExercises, Health:$previewHealth, Chores: $previewChores, Productivity: $previewProductivity, Health2: $previewHealth2, ScreenTime: $previewScreenTime, initialGoal: "test", navigationPath: $previewNavigationPath)
    }
}
