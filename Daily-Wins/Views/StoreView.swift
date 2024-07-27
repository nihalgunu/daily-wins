import SwiftUI

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var storeItems = [
        "Toy 1",
        "Toy 2",
        "Toy 3",
        "Toy 4",
        "Toy 5"
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
            
            Text("Store Items")
                .font(.headline)
                .padding(.top, 10)
            
            List(storeItems, id: \.self) { item in
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
    StoreView()
}
