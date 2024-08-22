import SwiftUI

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedData: SharedData
    @State private var storeItems = [
        StoreItem(name: "Toy 1", price: 10, likeness: 2),
        StoreItem(name: "Toy 2", price: 15, likeness: 3),
        StoreItem(name: "Toy 3", price: 20, likeness: 5),
        StoreItem(name: "Toy 4", price: 25, likeness: 7),
        StoreItem(name: "Toy 5", price: 30, likeness: 10)
    ]
    @State private var foodItems = [
        FoodItem(name: "Food 1", price: 10, satiation: 2),
        FoodItem(name: "Food 2", price: 15, satiation: 3),
        FoodItem(name: "Food 3", price: 20, satiation: 5),
        FoodItem(name: "Food 4", price: 25, satiation: 7),
        FoodItem(name: "Food 5", price: 30, satiation: 10)
    ]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedSegment = 0
    
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
            
            Text("Store")
                .font(.headline)
                .padding(.top, 10)
            VStack {
                Picker("Store Options", selection: $selectedSegment) {
                    Text("Food").tag(0)
                    Text("Toys").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedSegment == 1 {
                    List(storeItems) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("Price: \(item.price) coins")
                            Button(action: {
                                purchaseItem(item)
                                sharedData.savePetData()
                            }) {
                                Text("Buy")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                } else {
                    List(foodItems) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("Price: \(item.price) coins")
                            Button(action: {
                                purchaseFood(item)
                                sharedData.savePetData()
                            }) {
                                Text("Buy")
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
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Purchase"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func purchaseItem(_ item: StoreItem) {
        if sharedData.coins >= item.price {
            sharedData.coins -= item.price
            sharedData.addToInventory(itemName: item.name)
            alertMessage = "You purchased \(item.name) for \(item.price) coins!"
        } else {
            alertMessage = "Not enough coins to purchase \(item.name)!"
        }
        showAlert = true
    }
    
    private func purchaseFood(_ item: FoodItem) {
        if sharedData.coins >= item.price {
            sharedData.coins -= item.price
            sharedData.addToInventory(itemName: item.name)
            alertMessage = "You purchased \(item.name) for \(item.price) coins!"
        } else {
            alertMessage = "Not enough coins to purchase \(item.name)!"
        }
        showAlert = true
    }
}
