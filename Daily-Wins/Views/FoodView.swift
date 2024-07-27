import SwiftUI

struct FoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var foodItems = [
        "Food 1",
        "Food 2",
        "Food 3",
        "Food 4",
        "Food 5"
    ]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .font(.headline)
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                }
            }
            
            Text("Food Items")
                .font(.headline)
                .padding(.top, 10)
            
            List(foodItems, id: \.self) { item in
                Text(item)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

#Preview {
    FoodView()
}
