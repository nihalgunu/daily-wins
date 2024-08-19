import FirebaseAuth
import FirebaseFirestore
import Foundation

// ViewModel for a single to do list item view (each row in items list)
class ToDoListItemViewViewModel: ObservableObject {
    //@Published var sharedData: SharedData
    
    init(/*sharedData: SharedData*/) {
        //self.sharedData = sharedData
    }
    
    func toggleIsDone(item: ToDoListItem) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary()) { [weak self] error in
                if error == nil {
                    // Increase the coins by 10 when the item is marked as done
//                    if itemCopy.isDone {
//                        self?.sharedData.addCoins(10)
//                    }
                }
            }
    }
}
