//
//  PresetView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 7/11/24.
//

import SwiftUI

struct PresetView: View {
    @State private var newItemPresented = false
    @State private var selectedItem = ""

    @State private var Exercises = ["Walk", "Run", "Swim", "Stretch", "Lift Weights"]
    @State private var Health = ["Drink Water", "Take Vitamins", "Eat Fruits"]
    @State private var Chores = ["Wash Dishes", "Make Bed"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CategoryView(categoryName: "Exercise", items: $Exercises, Exercises: $Exercises, Health: $Health, Chores: $Chores)
                    CategoryView(categoryName: "Health", items: $Health, Exercises: $Exercises, Health: $Health, Chores: $Chores)
                    CategoryView(categoryName: "Chores", items: $Chores, Exercises: $Exercises, Health: $Health, Chores: $Chores)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Daily Wins")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: "")) {
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
    @Binding var Exercises: [String]
    @Binding var Health: [String]
    @Binding var Chores: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(categoryName)
                .font(.title2)
                .bold()
            ForEach(items, id: \.self) { item in
                NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: item)) {
                    Text(item)
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
    PresetView()
}
