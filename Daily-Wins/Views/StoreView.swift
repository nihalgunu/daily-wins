import SwiftUI

struct StoreItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let likeness: Int // Attribute for how much the item is liked
}

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var storeItems = [
        StoreItem(name: "Toy 1", price: 10, likeness: 2),
        StoreItem(name: "Toy 2", price: 15, likeness: 3),
        StoreItem(name: "Toy 3", price: 20, likeness: 5),
        StoreItem(name: "Toy 4", price: 25, likeness: 7),
        StoreItem(name: "Toy 5", price: 30, likeness: 10)
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
            
            Text("Store Items")
                .font(.headline)
                .padding(.top, 10)
            
            List(storeItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("Price: \(item.price) coins")
                    Text("Likeness: \(item.likeness)")
                }
                .onDrag {
                    // Drag the store item as an object
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

// Preview
struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView().environmentObject(SharedData())
    }
}
