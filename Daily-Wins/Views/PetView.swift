import SwiftUI

struct PetView: View {
    @EnvironmentObject var sharedData: SharedData
    
    @State private var dogImage = "dog"
    @State private var dogPosition = CGSize.zero
    @State private var showStore = false
    @State private var showFood = false
    @State private var showInventory = false

    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Coins: \(sharedData.coins)")
                    Spacer()
                    Button(action: {
                        showInventory.toggle()
                    }) {
                        Text("Inventory")
                    }
                }
                .padding()
                
                Spacer()
                
                Image(dogImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .offset(dogPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.dogPosition = value.translation
                            }
                            .onEnded { _ in
                                self.dogPosition = .zero
                            }
                    )
                    .animation(.spring())
                
                Spacer()
                
                HStack {
                    Text("Hunger: \(sharedData.petHunger)")
                    Spacer()
                    Text("Likeness: \(sharedData.petLikeness)")
                }
                .padding()
                
                HStack {
                    Button(action: {
                        showFood.toggle()
                    }) {
                        Text("Food")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        showStore.toggle()
                    }) {
                        Text("Store")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showStore) {
            StoreView()
        }
        .sheet(isPresented: $showFood) {
            FoodView()
        }
        .sheet(isPresented: $showInventory) {
            InventoryView()
        }
    }
}

struct InventoryView: View {
    @EnvironmentObject var sharedData: SharedData
    
    var body: some View {
        List {
            ForEach(Array(sharedData.inventory.keys), id: \.self) { item in
                HStack {
                    Text(item)
                    Spacer()
                    Text("Quantity: \(sharedData.inventory[item] ?? 0)")
                    Button(action: {
                        useItem(item)
                        sharedData.savePetData()
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
    
    private func useItem(_ item: String) {
        sharedData.removeFromInventory(itemName: item)
        if let foodItem = getFoodItem(name: item) {
            sharedData.petHunger = max(0, sharedData.petHunger - foodItem.satiation)
        } else if let storeItem = getStoreItem(name: item) {
            sharedData.petLikeness = min(10, sharedData.petLikeness + storeItem.likeness)
        }
    }
    
    private func getFoodItem(name: String) -> FoodItem? {
        // This should be replaced with actual logic to fetch food items
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
        // This should be replaced with actual logic to fetch store items
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
