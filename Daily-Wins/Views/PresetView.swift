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
        NavigationView{
            ScrollView {
                VStack {
                    Text("Exercise")
                        .bold()
                    ForEach(Exercises, id: \.self) { item in
                        NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: item)) {
                            HStack{
                                Text(item)
                            }
                        }
                        .padding()
                    }
                }
                Text("Health")
                    .bold()
                ForEach(Health, id: \.self) { item in
                    NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: item)) {
                        HStack{
                            Text(item)
                        }
                    }
                    .padding()
                }
                
                Text("Chores")
                    .bold()
                ForEach(Chores, id: \.self) { item in
                    NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: item)) {
                        HStack{
                            Text(item)
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            NavigationLink(destination: NewItemView(newItemPresented: .constant(false), Exercises: $Exercises, Health: $Health, Chores: $Chores, initialGoal: "")) {
                Text("Custom")
            }
        }
        
    }
}

#Preview {
    PresetView()
}

