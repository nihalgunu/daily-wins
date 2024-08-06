//
//  PresetView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/11/24.
//

import SwiftUI

struct PresetView: View {
    @State private var newItemPresented = false
    
    @State private var Exercises = ["Walk", "Run", "Swim", "Stretch", "Lift Weights"]
    @State private var Health = ["Drink Water", "Take Vitamins", "Eat Fruits"]
    @State private var Chores = ["Wash Dishes", "Make Bed"]
    @State private var Productivity = ["Sleep", "Journal", "Read", "Study"]
    @State private var Health2 = ["Less Alchohol", "Less Sugar", "Less Junk Food", "Less Smoking", "Less Caffeine"]
    @State private var ScreenTime = ["Less Video Games", "Less Social Media", "Less TV"]
    @State private var selectedSegment = 0
    
    //@Binding var item: ToDoListItem
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("Habit Type", selection: $selectedSegment) {
                                        Text("Build").tag(0)
                                        Text("Quit").tag(1)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding()
                    if selectedSegment == 0 {
                        CategoryView(categoryName: "Exercise", items: $Exercises/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                        CategoryView(categoryName: "Health", items: $Health/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                         CategoryView(categoryName: "Cleaning", items: $Chores/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                        CategoryView(categoryName: "Productivity", items: $Productivity/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                    }
                    else {
                        CategoryView(categoryName: "Health", items: $Health2/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                        CategoryView(categoryName: "Screen Time", items: $ScreenTime/*, item: $item*/, Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, navigationPath: $navigationPath)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Daily Wins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewItemView(/*item: $item,*/ newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, initialGoal: "", navigationPath: $navigationPath)) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct CategoryView: View {
    var categoryName: String
    @Binding var items: [String]
    //@Binding var item: ToDoListItem
    @Binding var Exercises: [String]
    @Binding var Health: [String]
    @Binding var Chores: [String]
    @Binding var Productivity: [String]
    @Binding var Health2: [String]
    @Binding var ScreenTime: [String]
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(categoryName)
                .font(.title2)
                .bold()
            ForEach(items, id: \.self) { i in
                NavigationLink(destination: NewItemView(/*item: $item,*/ newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, Productivity: $Productivity, Health2: $Health2, ScreenTime: $ScreenTime, initialGoal: i, navigationPath: $navigationPath)) {
                    Text(i)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                }
            }
        }
    }
}

#Preview {
   @State var previewItem = ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false)
    
    return PresetView(/*item: $previewItem, */navigationPath: .constant(NavigationPath()))
}
