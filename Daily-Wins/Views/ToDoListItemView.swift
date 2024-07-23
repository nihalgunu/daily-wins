import SwiftUI

struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel()
    @State private var item: ToDoListItem

    init(item: ToDoListItem) {
        self._item = State(initialValue: item)
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: MoreInfoView(item: $item)) {
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
                    
                }
                Button(action: {
                    withAnimation {
                        item.isDone.toggle()
                    }
                }) {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(item.isDone ? .green : .orange)
                }
                .buttonStyle(PlainButtonStyle())
                
                /*Button(action: {
                    withAnimation {
                        viewModel.deleteItem(item: item)
                    }
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())*/
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(color: .gray, radius: 1, x: 0, y: 1)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }}

#Preview {
    ToDoListItemView(item: .init(id: "123", title: "Get Milk", isDone: false))
}
