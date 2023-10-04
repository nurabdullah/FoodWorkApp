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

struct ToastChangePasswordView: View {
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "hand.thumbsup")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.bottom, 10)
                
                Text("Şifre başarılı bir şekilde değiştirildi")
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



struct changePassword: View {
    @Binding var oldPassword: String
    @State private var newPassword: String = ""
    @State private var newPasswordConfirm: String = ""
    @State private var isPasswordMatchError = false
    @State private var isOldPasswordVisible = false
    @State private var isNewPasswordVisible = false
    @State private var isNewConfirmPasswordVisible = false
    @FocusState private var isFocusedOldPassword: Bool
    @FocusState private var isFocusedNewPassword: Bool
    @FocusState private var isFocusedNewConfirmPassword: Bool
    @State private var showToastMessage = false


    
    var isPasswordMatch: Bool {
        return newPassword == newPasswordConfirm
    }
    
    var buttonCheck: Bool{
        return !oldPassword.isEmpty && !newPassword.isEmpty && !newPasswordConfirm.isEmpty

    }
    
    func changePasswordButton() {
        isFocusedOldPassword = false
        isFocusedNewPassword = false
        isFocusedNewConfirmPassword = false

        if isPasswordMatch {
            isPasswordMatchError = false
            newPassword = ""
            newPasswordConfirm = ""
            oldPassword = ""
            showToastMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToastMessage = false
            }
            
        }else{
            isPasswordMatchError = true
            Text("Yeni şifreler eşleşmiyor.")
                .foregroundColor(.red)
                .padding(.top, 5)
                .padding(.bottom, 10)

        }

    }
    
    var body: some View {
        VStack {
            
            ZStack {
                if isOldPasswordVisible {
                    TextField("Eski Şifre", text: $oldPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedOldPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedOldPassword)

                } else {
                    SecureField("Eski Şifre", text: $oldPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedOldPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedOldPassword)

                }
                HStack {
                    Spacer()
                    Button(action: {
                        isOldPasswordVisible.toggle()
                        isFocusedNewPassword = false
                        isFocusedNewConfirmPassword = false
                        
                    }) {
                        Image(systemName: isOldPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                    .buttonStyle(BorderedButtonStyle())
                }
            }


            ZStack {
                if isNewPasswordVisible {
                    TextField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewPassword)

                } else {
                    SecureField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)                                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewPassword)

                }
                HStack {
                    Spacer()
                    Button(action: {
                        isNewPasswordVisible.toggle()
                        isFocusedOldPassword = false
                        isFocusedNewConfirmPassword = false
                        
                    }) {
                        Image(systemName: isNewPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                    .buttonStyle(BorderedButtonStyle())
                }
            }

            
            ZStack {
                if isNewConfirmPasswordVisible {
                    TextField("Yeni Şifre Tekrar", text: $newPasswordConfirm)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewConfirmPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewConfirmPassword)

                } else {
                    SecureField("Yeni Şifre Tekrar", text: $newPasswordConfirm)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewConfirmPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewConfirmPassword)

                }
                HStack {
                    Spacer()
                    Button(action: {
                        isNewConfirmPasswordVisible.toggle()
                        isFocusedOldPassword = false
                        isFocusedNewPassword = false
                    }) {
                        Image(systemName: isNewConfirmPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                    .buttonStyle(BorderedButtonStyle())

                }
            }
          
            
            if isPasswordMatchError {
                Text("Yeni şifreler eşleşmiyor.")
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .padding(.bottom, 10)
            }else{
                Text("")
            }
    
            Button(action: changePasswordButton) {
                HStack {
                    Text("Şifreyi Değiştir")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(NavigationLink("", destination: ContentView()))
                .foregroundColor(.white)
                .padding()
                .background(buttonCheck ? Color.orange : Color.gray)
                .cornerRadius(10)

            }
            .disabled(!buttonCheck)
            
            Spacer()
            if showToastMessage {
                ToastChangePasswordView()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4))
            }

        }
        .padding()
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

    
    func appSetting() {
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                if dataModel.isLogin {
                    NavigationStack {
                        List {
                            Section {
                                
                                NavigationLink(destination: changePassword( oldPassword : $password )) {
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
