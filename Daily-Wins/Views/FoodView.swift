import SwiftUI

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let satiation: Int
}

struct FoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var foodItems = [
        FoodItem(name: "Food 1", price: 10, satiation: 2),
        FoodItem(name: "Food 2", price: 15, satiation: 3),
        FoodItem(name: "Food 3", price: 20, satiation: 5),
        FoodItem(name: "Food 4", price: 25, satiation: 7),
        FoodItem(name: "Food 5", price: 30, satiation: 10)
    ]
    @EnvironmentObject var sharedData: SharedData // Access shared data
    
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
            
            List(foodItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("Price: \(item.price) coins")
                    Text("Satiation: \(item.satiation)")
                }
                .onDrag {
                    // Drag the food item as an object
                    return NSItemProvider(object: String(item.id.uuidString) as NSString)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

#Preview {
    FoodView().environmentObject(SharedData())
}
