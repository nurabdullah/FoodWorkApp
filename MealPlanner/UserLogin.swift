import SwiftUI

struct UserLogin: View {
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @FocusState private var isFocusedUserName: Bool
    @FocusState private var isFocusedPassword: Bool

    var isLoginEnabled: Bool {
        return !userName.isEmpty && !password.isEmpty
    }

    func addUser() {
        if isLoginEnabled {
            dataModel.isLogin = true
            dataModel.loginMyArray.append(userName)
            userName = ""
        }
    }

    var body: some View {
        NavigationView {
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

                    NavigationLink(destination: UserRegister()) {
                        HStack{
                        Text("Üye değil misin?")
                            .foregroundColor(.black)
                        Text("Üye ol")
                            .foregroundColor(.orange)
                    }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin()
    }
}
