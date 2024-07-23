//
//  NewItemView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    @Binding var Exercises: [String]
    @Binding var Health: [String]
    @Binding var Chores: [String]
    @Binding var Productivity: [String]
    @Binding var Health2: [String]
    @Binding var ScreenTime: [String]
    
    let initialGoal: String
    
    @State private var navigateToHomePage = false
    @State private var goalValue: Int? = nil
    @State private var unit = ""
    var distance = ["steps", "meters", "kilometers", "miles"]
    var time = ["seconds", "minutes", "hours"]
    var amount = ["mililiters", "liters", "ounces", "miligrams","grams"]
    //@State private var customOption: [String] = []
    
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
                    TextField("Win", text: $viewModel.title)
                        .onAppear {
                            viewModel.title = initialGoal
                        }
                    
                    // Reminder
                    ReminderView()
                    
                    VStack {
                        Text("Tracking")
                            .fontWeight(.bold)
                            .padding(.trailing, 240)
                        
                        HStack {
                            TextField("Goal Value", value: $goalValue, formatter: numberFormatter)
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
    
    
    
struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewExercises: [String] = []
    @State static var previewHealth: [String] = []
    @State static var previewChores: [String] = []
    @State static var previewProductivity: [String] = []
    @State static var previewHealth2: [String] = []
    @State static var previewScreenTime: [String] = []
    
    
    static var previews: some View {
        NewItemView(newItemPresented: $previewNewItemPresented, Exercises: $previewExercises, Health:$previewHealth, Chores: $previewChores, Productivity: $previewProductivity, Health2: $previewHealth2, ScreenTime: $previewScreenTime, initialGoal: "test")
    }
}


/*Section {
 Text("count")
 }
 Section {
 ForEach(distance, id: \.self) { item in
 Text(item)
 }
 } header: {
 Text("Distance")
 }
 Section {
 ForEach(time, id: \.self) { item in
 Text(item)
 }
 } header: {
 Text("Time")
 }
 Section {
 ForEach(volume, id: \.self) { item in
 Text(item)
 }
 } header: {
 Text("Amount")
 }
 Section {
 //
 } header: {
 Text("Custom")
 }*/
