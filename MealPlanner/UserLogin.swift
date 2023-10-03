import SwiftUI

struct ToastDeleteUserView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "hand.thumbsup")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.bottom, 10)
                
                Text("Hesap başarılı bir şekilde silindi")
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(20)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct UserLogin: View {
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var checkBoxOn = false
    @FocusState private var isFocusedUserName: Bool
    @FocusState private var isFocusedPassword: Bool
    @State private var showingDeleteAccountPopup = false
    @State private var showToastMessage = false

    var isLoginEnabled: Bool {
        return !userName.isEmpty && checkBoxOn
    }

    func addUser() {
        if isLoginEnabled {
            dataModel.isLogin = true
            dataModel.loginMyArray.append(userName)
            userName = ""
        }
    }

    func deleteUser() {
        print("delete hesap")
        showToastMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showToastMessage = false
            dataModel.loginMyArray.removeAll()
            dataModel.isLogin = false
        }
    }

    func changePassword() {
    }

    func appSetting() {
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                if dataModel.isLogin {
                    NavigationStack {
                        List {
                            Section {
                                Button(action: changePassword) {
                                    HStack {
                                        Text("Şifreyi Değiştir")
                                        Spacer()
                                        Image(systemName: "greaterthan")
                                    }
                                }

                                Button(action: {
                                    self.showingDeleteAccountPopup = true
                                }) {
                                    HStack {
                                        Text("Hesabı Sil")
                                        Spacer()
                                        Image(systemName: "greaterthan")
                                    }
                                }
                                .alert(isPresented: $showingDeleteAccountPopup) {
                                    Alert(
                                        title: Text("Hesabı Sil"),
                                        message: Text("Hesabınızı Silmek İstediğinizden Emin'misiniz"),
                                        primaryButton: .destructive(Text("Evet")) {
//                                            self.deletingAccount = true
                                            deleteUser()
                                        },
                                        secondaryButton: .cancel(Text("Hayır")) {
                                            self.showingDeleteAccountPopup = false
                                        }
                                    )
                                }

                                Button(action: deleteUser) {
                                    HStack {
                                        Text("Çıkış Yap")
                                        Spacer()
                                        Image(systemName: "greaterthan")
                                    }
                                }
                            }
                            Section {
                                Button(action: appSetting) {
                                    HStack {
                                        Text("Ayarlar")
                                        Spacer()
                                        Image(systemName: "greaterthan")
                                    }
                                }
                                Button(action: appSetting) {
                                    HStack {
                                        Text("Uygulama Hakkında")
                                        Spacer()
                                        Image(systemName: "greaterthan")
                                    }
                                }
                            }
                        }
                        .navigationTitle("")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 25))

                                    Text(dataModel.loginMyArray.first ?? "")
                                        .font(.system(size: 25))
                                    Spacer()
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 20) {
                        Section(header: Text("Giriş")
                                    .font(.system(size: 25, weight: .medium))) {
                            TextField("Kullanıcı Adı", text: $userName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(isFocusedUserName ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                )
                                .focused($isFocusedUserName)
                            ZStack {
                                if isPasswordVisible {
                                    TextField("Şifre", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(isFocusedPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                        )
                                        .focused($isFocusedPassword)
                                } else {
                                    SecureField("Şifre", text: $password)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(isFocusedPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                        )
                                        .focused($isFocusedPassword)
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                        isFocusedUserName = false
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 15)
                                    .buttonStyle(BorderedButtonStyle())
                                }
                            }
                        }
                        HStack {
                            Toggle(isOn: $checkBoxOn) {
                                Text("KVKK metnini okudum kabul ediyorum.")
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .onChange(of: checkBoxOn) { _ in
                            isFocusedPassword = false
                            isFocusedUserName = false
                        }
                        Button(action: addUser) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                                    .foregroundColor(.white)
                                Text("Giriş Yap")
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin))
                            .foregroundColor(.white)
                            .padding()
                            .background(isLoginEnabled ? Color.orange : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(!isLoginEnabled)
                        Spacer()
                    }
                    .padding(25)
                }
            }

            if showToastMessage {
                ToastDeleteUserView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4))
            }
        }
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin()
    }
}
