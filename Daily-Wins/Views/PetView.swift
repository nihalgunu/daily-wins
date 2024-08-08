import SwiftUI

struct PetView: View {
    @EnvironmentObject var sharedData: SharedData // Use the shared data model
    
    @State private var dogImage = "dog" // Placeholder for dog's image
    @State private var likeYouMeter = 0 // Initial value for "like you" meter
    @State private var hungerMeter = 0 // Initial value for hunger meter
    @State private var dogPosition = CGSize.zero // Position for animation
    @State private var showStore = false // State to show store view
    @State private var showFood = false // State to show food view
    
    var body: some View {
        ZStack {
            // Background - can be customized further to add toys or other items
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Image(dogImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(dogPosition)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.dogPosition = value.translation
                        }
                        .onEnded { value in
                            self.dogPosition = .zero
                        }
                )
                .animation(.spring()) // Animation for dog's position
            
            VStack {
                // Meters and coins at the top
                VStack {
                    Text("Coins: \(sharedData.coins)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    
                    HStack {
                        VStack {
                            Text("Hunger: \(hungerMeter)")
                                .padding()
                                .background(Color.brown.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            ProgressView(value: Double(hungerMeter), total: 10)
                                .progressViewStyle(LinearProgressViewStyle(tint: .brown))
                                .padding(.horizontal)
                        }
                        
                        VStack {
                            Text("Like You: \(likeYouMeter)")
                                .padding()
                                .background(Color.red.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                            ProgressView(value: Double(likeYouMeter), total: 10)
                                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                                .padding(.horizontal)
                        }
                    }
                }
                .padding([.top])
                
                Spacer()
                
                // Buttons at the bottom
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
                    .padding([.bottom, .leading])
                    .sheet(isPresented: $showFood) {
                        FoodView()
                            .presentationDetents([.height(UIScreen.main.bounds.height / 3)])
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
                    .padding([.bottom, .trailing])
                    .sheet(isPresented: $showStore) {
                        StoreView()
                            .presentationDetents([.height(UIScreen.main.bounds.height / 3)])
                    }
                }
            }
        }
    }
    
    // Function to increase the "like you" meter when the dog is fed
    private func feedDog() {
        hungerMeter -= 1
        // Trigger some animation or change in the dog image
        // Example: dogImage = "dog_happy"
    }
    // Function to increase the "like you" meter when the dog is given toy
    private func playDog() {
        likeYouMeter += 1
        // Trigger some animation or change in the dog image
        // Example: dogImage = "dog_happy"
    }
}

#Preview {
    PetView()
        .environmentObject(SharedData())
}
