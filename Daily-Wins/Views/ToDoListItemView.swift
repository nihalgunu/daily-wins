import SwiftUI

struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel()
    @State private var showSheet = false
    var item: ToDoListItem
    
//    init(item: Binding<ToDoListItem>) {
//        self._item = item
//    }
    
    var body: some View {
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
                    Text("Pending")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            Spacer()
            
            Button(action: {
                withAnimation {
                    viewModel.toggleIsDone(item: item)
                    print("Toggled isDone to \(item.isDone)")
                }
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isDone ? .green : .orange)
                }
                .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 1, x: 0, y: 1)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onTapGesture {
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            
        } content: {
            MoreInfoView(item: /*$*/item)
        }
    }
    
}

#Preview {
//    @State var previewItem = ToDoListItem(id: "123", title: "Get Milk", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false)

    ToDoListItemView(item: ToDoListItem(id: "123", title: "Get Milk", description: "", tracking: 0, reminder: [Date().timeIntervalSince1970], isDone: false))
}
