//
//  PresetView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/11/24.
//

import SwiftUI

struct PresetView: View {
    @EnvironmentObject var HomePageModel: HomePageViewViewModel

    @State private var newItemPresented = false
    @State private var Exercises = ["Walk", "Run", "Swim", "Stretch", "Lift Weights"]
    @State private var Health = ["Drink Water", "Take Vitamins", "Eat Fruits"]
    @State private var Chores = ["Wash Dishes", "Make Bed"]
    @State private var Productivity = ["Sleep", "Journal", "Read", "Study", "Meditate"]
    @State private var Health2 = ["Less Alchohol", "Less Sugar", "Less Junk Food", "Less Smoking", "Less Caffeine"]
    @State private var ScreenTime = ["Less Video Games", "Less Social Media", "Less TV"]
    @State private var selectedSegment = 0
        
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
                        CategoryView(categoryName: "Exercise", items: $Exercises).environmentObject(HomePageModel)
                        CategoryView(categoryName: "Health", items: $Health).environmentObject(HomePageModel)
                        CategoryView(categoryName: "Cleaning", items: $Chores).environmentObject(HomePageModel)
                        CategoryView(categoryName: "Productivity", items: $Productivity).environmentObject(HomePageModel)
                    }
                    else {
                        CategoryView(categoryName: "Health", items: $Health2).environmentObject(HomePageModel)
                        CategoryView(categoryName: "Screen Time", items: $ScreenTime).environmentObject(HomePageModel)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Daily Wins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewItemView(initialGoal: "")                    .environmentObject(HomePageModel)) {
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
    @EnvironmentObject var HomePageModel: HomePageViewViewModel
    
    @Binding var items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(categoryName)
                .font(.title2)
                .bold()
            ForEach(items, id: \.self) { i in
                NavigationLink(destination: NewItemView(initialGoal: i).environmentObject(HomePageModel)) {
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
    @State var previewItem = ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], progress: 0, isDone: false, unit: "count", useCustom: false)
    
    return PresetView()
}
