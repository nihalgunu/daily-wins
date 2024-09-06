import SwiftUI
import FirebaseFirestore

struct DailyRecapView: View {
    @EnvironmentObject var contentModel: ContentViewViewModel
    
    @State private var isNavigating = false
    @State var streaks = Int()
    
    @Binding var showDailyRecap: Bool
    
    private let dateKey = "lastRecapDate"
    
    @FirestoreQuery var items: [ToDoListItem]
    
    init(showDailyRecap: Binding<Bool>, userId: String) {
        self._showDailyRecap = showDailyRecap
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Daily Wins Recap")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            ScrollView {
                VStack(spacing: 15) {
                    let sortedItems = items.sorted { !$0.isDone && $1.isDone }
                    let completedItems = sortedItems.filter { $0.isDone }
                    let incompleteItems = sortedItems.filter { !$0.isDone }
                    
                    if items.isEmpty {
                        Text("You have no tasks set!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                            .padding(.vertical, 20)
                        
                        Text("It's a great time to set some tasks for the day!")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)
                    } else {
                        if !completedItems.isEmpty {
                            SectionView(title: "Yesterday's Wins", items: completedItems, isComplete: true)
                                .padding(.vertical, 10)
                        }
                        
                        if !incompleteItems.isEmpty {
                            SectionView(title: "Yesterday's Misses", items: incompleteItems, isComplete: false)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .background(Color(.systemGroupedBackground))
            
            Spacer()

            Button(action: {
                isNavigating = true
                showDailyRecap = false
            }) {
                HStack {
                    Spacer()
                    Text("Back to Home")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .shadow(radius: 4)
            }
            .fullScreenCover(isPresented: $isNavigating) {
                HomePageView(userId: contentModel.currentUserId)
            }
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}

struct SectionView: View {
    let title: String
    let items: [ToDoListItem]
    let isComplete: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            
            ForEach(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.title)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Text(isComplete ? "Completed" : "Incomplete")
                            .font(.system(size: 14))
                            .foregroundColor(isComplete ? .green : .red)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
        }
        .padding()
    }
}

#Preview {
    @State var showingDailyRecap = Bool()
    
    return DailyRecapView(showDailyRecap: $showingDailyRecap, userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
