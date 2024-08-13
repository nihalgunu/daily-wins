import SwiftUI

struct MoreInfoView: View {
    @StateObject var todoModel: HomePageViewViewModel
    @EnvironmentObject var viewModel: NewItemViewViewModel
    @Environment(\.presentationMode) var presentationMode
    var item: ToDoListItem
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    Text(item.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Description")
                            .font(.headline).bold()
                            .foregroundColor(.primary)
                        Text(item.description)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Reminders")
                            .font(.headline).bold()
                            .foregroundColor(.primary)
                        ForEach(item.reminder.indices, id: \.self) { index in
                            Text(formattedDate(from: item.reminder[index]))
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tracking")
                            .font(.headline).bold()
                            .foregroundColor(.primary)
                        Text("\(item.tracking) \(item.unit)")
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        withAnimation {
                            todoModel.delete(id: item.id)
                        }
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EditItemView(todoModel: todoModel, initialGoal: item.title, initialDescription: item.description, initialReminder: item.reminder, item: item)) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                    .environmentObject(todoModel)
                }
            }
        }
    }
    
    private func formattedDate(from timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoView(todoModel: HomePageViewViewModel(userId: "FJqNlo9PyBbGfe7INZcrjlpEmaw2"), item: ToDoListItem(id: "1", title: "Sample Task", description: "Detailed description here...", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false, unit: "count"))
            .environmentObject(NewItemViewViewModel())

    }
}
