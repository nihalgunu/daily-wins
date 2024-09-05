import SwiftUI
import AVKit

struct PetView: View {
    @EnvironmentObject var sharedData: SharedData
    
    @State private var dogImage = "file"
    @State private var dogPosition = CGSize.zero
    @State private var showStore = false
    @State private var showInventory = false
    
    @State private var isPlayingVideo = false
    @State private var player: AVPlayer?
    @State private var shouldPlayAnimation = false
    
    private let calendar = Calendar.current
    private let dateKey = "lastUpdateDate"
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground) // This automatically adapts to light or dark mode
                    .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("Coins: \(sharedData.coins)")
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        showInventory.toggle()
                    }) {
                        Text("Inventory")
                    }
                }
                .padding()
                
                Spacer()
                
                if isPlayingVideo, let player = player {
                    VideoPlayer(player: player)
                        .frame(height: 200)
                        .onDisappear {
                            player.pause()
                        }
                } else {
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
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hunger: \(sharedData.petHunger)/20")
                            .foregroundColor(.primary)
                        ProgressView(value: Double(sharedData.petHunger), total: 20)
                            .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Likeness: \(sharedData.petLikeness)/20")
                            .foregroundColor(.primary)
                        ProgressView(value: Double(sharedData.petLikeness), total: 20)
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    }
                }
                .padding()
                
                HStack {
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
        .sheet(isPresented: $showInventory) {
            InventoryView(useItemCallback: {
                shouldPlayAnimation = true
            })
        }
        .onAppear {
            checkForDailyUpdate()
            if shouldPlayAnimation {
                playAnimation()
                shouldPlayAnimation = false
            }
        }
    }
    
    private func playAnimation() {
        guard let videoDataAsset = NSDataAsset(name: "animation") else {
            print("Animation file not found in assets")
            return
        }

        // Create a temporary URL for the video
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempAnimation.mp4")
        
        do {
            // Write the data to a temporary file
            try videoDataAsset.data.write(to: tempURL)
            player = AVPlayer(url: tempURL)
            player?.play()
            isPlayingVideo = true
            
            // Remove the temporary file after playback finishes
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
                self.isPlayingVideo = false
                self.player = nil
                try? FileManager.default.removeItem(at: tempURL)
                print("Animation finished and temp file removed")
            }
            
        } catch {
            print("Failed to write video data to temporary file: \(error)")
        }
    }
    
    private func checkForDailyUpdate() {
        let lastUpdateDate = UserDefaults.standard.object(forKey: dateKey) as? Date ?? Date.distantPast
        if !calendar.isDateInToday(lastUpdateDate) {
            sharedData.petHunger = max(0, sharedData.petHunger - 10)
            sharedData.petLikeness = max(0, sharedData.petLikeness - 10)
            sharedData.savePetData()
            UserDefaults.standard.set(Date(), forKey: dateKey)
        }
    }
    
    
}
