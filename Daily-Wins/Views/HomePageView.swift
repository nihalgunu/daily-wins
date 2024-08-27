import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewViewModel
    @EnvironmentObject var sharedData: SharedData
    @FirestoreQuery var items: [ToDoListItem]
    
    @State private var navigationPath = NavigationPath()
    
    @State var tasksTotal = 0
    @State var tasksFinished = 0

    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel(userId: userId))
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 10) {
                Spacer().frame(height: 10)
                
                // Navigate to FullCalendarView
                NavigationLink(destination: FullCalendarView(tasksTotal: $tasksTotal, tasksFinished: $tasksFinished).environmentObject(viewModel)) {
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
                    
                    // Navigate to PresetView
                    NavigationLink(destination: PresetView().environmentObject(viewModel)) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
               .padding(.horizontal)
                
                // Navigate to ToDoListItemView
                ScrollView {
                    VStack(spacing: 10) {
                        if items.isEmpty {
                            Text("Tap '+' to add your first win")
                                .foregroundColor(.black)
                                .padding(.vertical, 150)
                        } else {
                            // Sort the items so that "In Progress" tasks are above "Completed" tasks
                            let sortedItems = items.sorted { !$0.isDone && $1.isDone }
                            
                            ForEach(sortedItems) { item in
                                ToDoListItemView(ToDoListItemModel: ToDoListItemViewViewModel(), NewItemModel: NewItemViewViewModel(), item: item)
                                    .cornerRadius(10)
                                    .shadow(color: .white, radius: 1, x: 0, y: 1)
                                    .environmentObject(viewModel)
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
            .onChange(of: items) {
                tasksTotal = items.count
                tasksFinished = 0
                for item in items {
                    if item.isDone == true {
                        tasksFinished += 1
                    }
                }
                print("Tasks Total: \(tasksTotal)")
                print("Tasks Finished: \(tasksFinished)")
            }
        }
    }
}

#Preview {
    HomePageView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
}
