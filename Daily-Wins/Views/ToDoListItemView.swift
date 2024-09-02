import SwiftUI

struct ToDoListItemView: View {
    @State var showSheet = false

    @StateObject var ToDoListItemModel: ToDoListItemViewViewModel
    @StateObject var NewItemModel: NewItemViewViewModel

    @EnvironmentObject var fullCalendarViewModel: FullCalendarViewViewModel
    @EnvironmentObject var HomePageModel: HomePageViewViewModel
    @EnvironmentObject var sharedData: SharedData

    @Binding var currentDate: Date

    @Binding var tasksTotal: Int
    @Binding var tasksFinished: Int
    
    var item: ToDoListItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(item.isDone ? .gray : .primary)
                    .foregroundColor(.primary)

                if item.isDone {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("In Progress")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            Spacer()
            
            Button(action: {
                withAnimation {
                    ToDoListItemModel.toggleIsDone(item: item)
                    if item.isDone {
                        sharedData.coins -= 10
                        sharedData.savePetData()
                    }
                    else {
                        sharedData.coins += 10
                        sharedData.savePetData()
                    }
                    fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
                    fullCalendarViewModel.loadProgress(/*for: currentDate*/)

                }
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isDone ? .green : .orange)
                }
                .buttonStyle(PlainButtonStyle())
        }
        .onChange(of: item.isDone) {
            fullCalendarViewModel.saveProgress(date: currentDate, tasksTotal: tasksTotal, tasksFinished: tasksFinished)
        }
        .padding()
        .background(Color(UIColor.white))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 1, x: 0, y: 1)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onTapGesture {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            
        } content: {
            MoreInfoView(HomePageModel: HomePageModel, currentDate: $currentDate, tasksTotal: $tasksTotal, tasksFinished: $tasksFinished, initialGoal: item.title, initialDescription: item.description, initialTracking: item.tracking, initialReminder: item.reminder, initialProgress: item.progress, item: item)
                .environmentObject(NewItemModel)
                .environmentObject(HomePageModel)
                .environmentObject(fullCalendarViewModel)
        }
    }
}
