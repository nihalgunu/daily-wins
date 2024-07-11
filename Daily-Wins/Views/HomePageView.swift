import FirebaseFirestore
import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel: HomePageViewViewModel
    @FirestoreQuery var items: [ToDoListItem]
    @State private var currentDate = Date()

    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: HomePageViewViewModel(userId: userId))
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/todos")
    }

    var body: some View {
        NavigationStack {
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
                    Text("To Dos")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    NavigationLink(destination: ToDoListView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
               .padding(.horizontal)


                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(items) { item in
                            ToDoListItemView(item: item)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 1, x: 0, y: 1)
                        }
                    }
                    .padding(.vertical, 5) // Adjust vertical spacing between items
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Spacer().frame(height: 50)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(UIColor.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2")
    }
}
