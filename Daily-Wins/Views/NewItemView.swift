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
    @State private var options: [String] = ["Select", "Run", "Drink Water", "Take Vitamins", "Gym", "Read", "Journal"]

    var body: some View {
        VStack {
            Text("New Daily")
                .font(.system(size: 30))
                .bold()

            Form {
                // Title
                TextField("Goal", text: $viewModel.title)

                // Reminder
                ReminderView(selectedOption: $viewModel.title, options: $options)

                // Button
                TLButton(title: "Save", background: .pink) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false


                    } else {
                        viewModel.showAlert = true
                    }
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a goal"))
            }
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    @State static var previewNewItemPresented = false

    static var previews: some View {
        NewItemView(newItemPresented: $previewNewItemPresented)
    }
}
