import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var dataModel: DataModel
    @State private var isLoggingOut = false
    @State private var showingDeleteAccountPopup = false
    @State private var showToastMessage = false
    @State private var password = ""

    func deleteAccount() {
        let loggedInUserName = dataModel.someLoginStringKey
            if let index = dataModel.userList.firstIndex(where: { $0.userName == loggedInUserName }) {
                dataModel.userList.remove(at: index)
                dataModel.isLogin = false
                showToastMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showToastMessage = false
                    }
                }
        for user in dataModel.userList {
            print("User: \(user.userName), Password: \(user.userPassword)")
        }
            }
        
    func logoutUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dataModel.isLogin = false
        }
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                
                NavigationStack {
                    List {
                        Section {
                            HStack {
                                Text("Şifreyi Değiştir")

                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor((showingDeleteAccountPopup || isLoggingOut) ? Color.gray.opacity(0.3) : .orange)
                            .overlay {
                                 NavigationLink(destination: {ChangePasswordView()}, label: { EmptyView() })
                                 .opacity(0)
                            }

                            Button(action: {
                                self.showingDeleteAccountPopup = true
                                isLoggingOut = true
                            }) {
                                HStack {
                                    Text("Hesabı Sil")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .alert(isPresented: $showingDeleteAccountPopup) {
                                Alert(
                                    title: Text("Hesabı Sil"),
                                    message: Text("Hesabınızı Silmek İstediğinizden Emin'misiniz"),
                                    primaryButton: .destructive(Text("Evet")) {
                                        deleteAccount()
                                    },
                                    secondaryButton: .cancel(Text("Hayır")) {
                                        self.showingDeleteAccountPopup = false
                                        isLoggingOut = false
                                    }
                                )
                            }

                            Button(action: logoutUser) {
                                HStack {
                                    Text("Çıkış Yap")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                        Section {
                            Button(action: {}) {
                                HStack {
                                    Text("Ayarlar")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                            Button(action: {}) {
                                HStack {
                                    Text("Uygulama Hakkında")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            HStack {
                                Image(systemName: "person")
                                Text(dataModel.someLoginStringKey)
                                Spacer()
                            }
                            .padding(.top, 25)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }

            if showToastMessage {
                ToastView(message: "Hesap başarılı bir şekilde silindi", iconName: "hand.thumbsup", showToastMessage: $showToastMessage)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4))
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
