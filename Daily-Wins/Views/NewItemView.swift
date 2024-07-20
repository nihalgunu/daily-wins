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
    let initialGoal: String

    @State private var navigateToHomePage = false

    @Environment(\.presentationMode) var presentationMode
    
    
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
                    
                    // Button
                    TLButton(title: "Save", background: .pink) {
                        if viewModel.canSave {
                            viewModel.save()
                        } else {
                            viewModel.showAlert = true
                        }
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



struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false
    @State static var previewExercises: [String] = []
    @State static var previewHealth: [String] = []
    @State static var previewChores: [String] = []

    static var previews: some View {
        NewItemView(newItemPresented: $previewNewItemPresented, Exercises: $previewExercises, Health:$previewHealth, Chores: $previewChores, initialGoal: "test")
    }
}
