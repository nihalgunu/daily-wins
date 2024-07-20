import SwiftUI

struct TreeView: View {
    @State private var dogImage = "dog" // Placeholder for dog's image
    @State private var likeYouMeter = 0 // Initial value for "like you" meter
    @State private var hungerMeter = 0 // Initial value for hunger meter
    @State private var dogPosition = CGSize.zero // Position for animation
    
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
                // Meters at the top
                HStack {
                    VStack {
                        Text("Like You: \(likeYouMeter)")
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        ProgressView(value: Double(likeYouMeter), total: 10)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .padding(.horizontal)
                    }
                    
                    VStack {
                        Text("Hunger: \(hungerMeter)")
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        ProgressView(value: Double(hungerMeter), total: 10)
                            .progressViewStyle(LinearProgressViewStyle(tint: .red))
                            .padding(.horizontal)
                    }
                }
                .padding([.top])
                
                Spacer()
                
                // Buttons at the bottom
                HStack {
                    Button(action: {
                        feedDog()
                    }) {
                        Text("Food")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding([.bottom, .leading])
                    
                    Spacer()
                    
                    Button(action: {
                        navigateToStore()
                    }) {
                        Text("Store")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding([.bottom, .trailing])
                }
            }
        }
    }
    
    // Function to increase the "like you" meter when the dog is fed
    private func feedDog() {
        likeYouMeter += 1
        hungerMeter -= 1 // Decrease hunger when fed
        // Trigger some animation or change in the dog image
        // Example: dogImage = "dog_happy"
    }
    
    // Function to navigate to the store view
    private func navigateToStore() {
        // Navigate to the store view code
    }
    
    // Function to navigate to the food view
    private func navigateToFood() {
        // Navigate to the food view code
    }
}

#Preview {
    TreeView()
}
