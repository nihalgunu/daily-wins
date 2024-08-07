import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var viewModel = ProfileViewViewModel.shared
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showingImagePicker = false

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                    VStack {
                        if let image = viewModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        }
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text("Profile Image")
                        }
                        .onChange(of: selectedItem) {
                            Task {
                                if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    viewModel.selectedImage = uiImage
                                }
                            }
                        }
                    }
                    .padding()

                    // Info: Name, email, Member since
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Name:")
                                .font(.headline)
                            Spacer()
                            Text(user.name)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Email:")
                                .font(.headline)
                            Spacer()
                            Text(user.email)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Member Since:")
                                .font(.headline)
                            Spacer()
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .omitted))")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 20)

                    Spacer()
                    
                    // Sign out Button
                    Button(action: {
                        viewModel.logOut()
                    }) {
                        Text("Log Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                } else {
                    ProgressView("Loading Profile...")
                        .padding()
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

#Preview {
    ProfileView(/*viewModel: ProfileViewViewModel()*/)
}

//                    VStack {
//                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
//                            if let avatarImage = avatarImage {
//                                avatarImage
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 150, height: 150)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
//                                    .shadow(radius: 10)
//                                    .padding(.top, 50)
//                            } else {
//                                Image(systemName: "person.circle")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 150, height: 150)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
//                                    .shadow(radius: 10)
//                                    .padding(.top, 50)
//                            }
//
//                        }
//                    }
//                    .onChange(of: photosPickerItem) {
//                        Task {
//                            if let loaded = try? await photosPickerItem?.loadTransferable(type: Image.self) {
//                                avatarImage = loaded
//                            } else {
//                                print("Failed")
//                            }
//                        }
//                    }
