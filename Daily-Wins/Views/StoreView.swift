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
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
            
            Text("Store Items")
                .font(.headline)
                .padding(.top, 10)
            
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
}
