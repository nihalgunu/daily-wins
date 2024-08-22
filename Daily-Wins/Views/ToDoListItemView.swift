import SwiftUI

struct ToDoListItemView: View {
    @EnvironmentObject var sharedData: SharedData
    @StateObject var viewModel: ToDoListItemViewViewModel
    @StateObject var viewModel2: HomePageViewViewModel
    @StateObject var viewModel3: NewItemViewViewModel
    @State var showSheet = false
    @State var progressNum = String()
    var item: ToDoListItem
    
    var body: some View {
        let viewModel = ToDoListItemViewViewModel(/*sharedData: sharedData*/)
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(item.isDone ? .gray : .primary)

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
                    viewModel.toggleIsDone(item: item)
                    if item.isDone {
                        sharedData.coins -= 10 // Update shared coins
                    }
                    else {
                        sharedData.coins += 10
                    }
                }
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isDone ? .green : .orange)
                }
                .buttonStyle(PlainButtonStyle())
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
            MoreInfoView(todoModel: viewModel2, initialGoal: item.title, initialDescription: item.description, initialTracking: item.tracking, initialReminder: item.reminder, item: item)
                .onAppear {
                    progressNum = viewModel3.progress
                }
        }
    }
}
