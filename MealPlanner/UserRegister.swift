import SwiftUI

struct UserRegister: View {
    
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    @FocusState private var isFocusedUserName: Bool
    @FocusState private var isFocusedPassword: Bool
    @FocusState private var isFocusedPasswordVisable: Bool
    @State private var isPasswordVisible = false
    @State private var isPasswordConfirmVisible = false
    @State private var checkBoxOn = false

    var isLoginEnabled: Bool {
        return !userName.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty && checkBoxOn
    }
    
    private func registerUser() {
        if isLoginEnabled {

            dataModel.isLogin = true
            dataModel.loginMyArray.append(userName)
            userName = ""
            password = ""
            passwordConfirm = ""
            isFocusedUserName = false
            isFocusedPassword = false
            isFocusedPasswordVisable = false
            print("Kayıt başarılı")
        }
    }
    
    var body: some View {
        NavigationView{
        VStack(alignment: .leading, spacing: 20) {
            Section(header: Text("Kayıt Ol").font(.system(size: 25, weight: .medium))) {
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
                            isFocusedPasswordVisable = false
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
                
                ZStack {
                    if isPasswordConfirmVisible {
                        TextField("Şifre Tekrar", text: $passwordConfirm)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isFocusedPasswordVisable ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .focused($isFocusedPasswordVisable)
                    } else {
                        SecureField("Şifre Tekrar", text: $passwordConfirm)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isFocusedPasswordVisable ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .focused($isFocusedPasswordVisable)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            isPasswordConfirmVisible.toggle()
                            isFocusedUserName = false
                            isFocusedPassword = false
                        }) {
                            Image(systemName: isPasswordConfirmVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 15)
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
            
            Toggle("KVKK metnini okudum kabul ediyorum.", isOn: $checkBoxOn)
                .font(.system(size: 15, weight: .medium))
                .onChange(of: checkBoxOn) { newValue in
                    isFocusedPassword = false
                    isFocusedUserName = false
                }
            
            Button(action: registerUser) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .foregroundColor(.white)
                    Text("Kayıt Ol")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(NavigationLink("", destination: ContentView()))
                .foregroundColor(.white)
                .padding()
                .background(isLoginEnabled ? Color.orange : Color.gray)
                .cornerRadius(10)
            }
            .disabled(!isLoginEnabled)
           
            NavigationLink(destination: UserLogin()) {
                HStack{
                Text("Üye misin?")
                    .foregroundColor(.black)
                Text("Giriş yap")
                    .foregroundColor(.orange)
            }
            }
            .padding(.top, 10)

            
            Spacer()
        }
        }

        .padding()

        .navigationBarBackButtonHidden(true)

    }
    
    
}

struct UserRegister_Previews: PreviewProvider {
    static var previews: some View {
        UserRegister()
    }
}
