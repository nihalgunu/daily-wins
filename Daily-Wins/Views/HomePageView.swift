import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewViewModel
    @StateObject private var parentViewModel = HomePageViewViewModel(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
    @FirestoreQuery var items: [ToDoListItem]
    @State private var currentDate = Date()
    @State private var navigationPath = NavigationPath()
    //@State private var item: ToDoListItem

    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel(userId: userId))
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
//        self._item = State(initialValue: ToDoListItem(id: "1", title: "Sample Task", description: "", tracking: 0, reminder: [], isDone: false))
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)

                NavigationLink(destination: FullCalendarView(currentDate: $currentDate)) {
                    WeeklyCalendarView()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        .border(Color.clear, width: 0)
                }
                .padding(.horizontal)
                Spacer()

                HStack {
                    Text("Wins")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()
                    
                    NavigationLink(destination: PresetView(/*item: $item,*/navigationPath: $navigationPath)) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
               .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if items.isEmpty {
                            Text("Tap '+' to add your first todo")
                                .foregroundColor(.gray)
                                .padding(.vertical, 150)
                        } else {
                            ForEach(items) { item in
                                ToDoListItemView(item: item)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer().frame(height: 50)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(viewModel: parentViewModel.profileViewModel)) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    HomePageView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
