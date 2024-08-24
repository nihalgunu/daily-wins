import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewViewModel
    @EnvironmentObject var sharedData: SharedData
    @FirestoreQuery var items: [ToDoListItem]
    @State private var currentDate = Date()
    @State private var navigationPath = NavigationPath()
    @State var completedTasks = 5
    @State var totalTasks = 10

    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel(userId: userId))
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)

                NavigationLink(destination: FullCalendarView(currentDate: $currentDate)) {
                    WeeklyCalendarView()
                        .background(Color(UIColor.white)
                        .cornerRadius(10))
                }
                .padding(.horizontal)
                Spacer()

                HStack {
                    Text("Wins")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()
                    
                    NavigationLink(destination: PresetView()) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
               .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if items.isEmpty {
                            Text("Tap '+' to add your first win")
                                .foregroundColor(.gray)
                                .padding(.vertical, 150)
                        } else {
                            // Sort the items so that "In Progress" tasks are above "Completed" tasks
                            let sortedItems = items.sorted { !$0.isDone && $1.isDone }
                            
                            ForEach(sortedItems) { item in
                                ToDoListItemView(ToDoListItemModel: ToDoListItemViewViewModel(/*sharedData: sharedData*/), HomePageModel: viewModel, NewItemModel: NewItemViewViewModel(), item: item)
                                    .cornerRadius(10)
                                    .shadow(color: .white, radius: 1, x: 0, y: 1)
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
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(viewModel: viewModel.profileViewModel)) {
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
