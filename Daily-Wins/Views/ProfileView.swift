import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State private var avatarImage: Image?
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                    VStack {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            if let avatarImage = avatarImage {
                                avatarImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .padding(.top, 50)
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .padding(.top, 50)
                            }

                        }
                    }
                    .onChange(of: photosPickerItem) {
                        Task {
                            if let loaded = try? await photosPickerItem?.loadTransferable(type: Image.self) {
                                avatarImage = loaded
                            } else {
                                print("Failed")
                            }
                        }
                    }
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
    ProfileView()
}

