import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var sharedData: SharedData
    
    var useItemCallback: () -> Void
    
    var body: some View {
        if sharedData.inventory.isEmpty {
            Text("Inventory Empty, Buy Items From the Store")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        } else {
            List {
                ForEach(Array(sharedData.inventory.keys), id: \.self) { item in
                    HStack {
                        Text(item)
                        Spacer()
                        Text("Quantity: \(sharedData.inventory[item] ?? 0)")
                        Button(action: {
                            useItem(item)
                            sharedData.savePetData()
                            useItemCallback() // Trigger the animation when an item is used
                        }) {
                            Text("Use")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
    }
    
    private func useItem(_ item: String) {
        sharedData.removeFromInventory(itemName: item)
        if let foodItem = getFoodItem(name: item) {
            sharedData.petHunger = min(20, sharedData.petHunger + foodItem.satiation)
        } else if let storeItem = getStoreItem(name: item) {
            sharedData.petLikeness = min(20, sharedData.petLikeness + storeItem.likeness)
        }
    }
    
    private func getFoodItem(name: String) -> FoodItem? {
        let foodItems = [
            FoodItem(name: "Food 1", price: 10, satiation: 2),
            FoodItem(name: "Food 2", price: 15, satiation: 3),
            FoodItem(name: "Food 3", price: 20, satiation: 5),
            FoodItem(name: "Food 4", price: 25, satiation: 7),
            FoodItem(name: "Food 5", price: 30, satiation: 10)
        ]
        return foodItems.first { $0.name == name }
    }
    
    private func getStoreItem(name: String) -> StoreItem? {
        let storeItems = [
            StoreItem(name: "Toy 1", price: 10, likeness: 2),
            StoreItem(name: "Toy 2", price: 15, likeness: 3),
            StoreItem(name: "Toy 3", price: 20, likeness: 5),
            StoreItem(name: "Toy 4", price: 25, likeness: 7),
            StoreItem(name: "Toy 5", price: 30, likeness: 10)
        ]
        return storeItems.first { $0.name == name }
    }
}
