//
//  ProfileViewViewModel.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/26/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import FirebaseStorage

class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    //@Published var selectedImage: UIImage? = nil
    @Published var selectedImage: UIImage? {
        didSet {
            saveImage()
        }
    }
    
    static let shared = ProfileViewViewModel()
    
    init() {
        loadImage()
    }
    
    private func saveImage() {
            guard let image = selectedImage else {
                UserDefaults.standard.removeObject(forKey: "profileImage")
                return
            }
            
            if let data = image.pngData() {
                UserDefaults.standard.set(data, forKey: "profileImage")
            }
        }
        
    private func loadImage() {
        if let data = UserDefaults.standard.data(forKey: "profileImage"),
           let image = UIImage(data: data) {
            self.selectedImage = image
        }
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                    )
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

