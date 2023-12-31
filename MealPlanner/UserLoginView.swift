import SwiftUI



struct UserLoginView: View {
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @FocusState private var isFocusedUserName: Bool
    @FocusState private var isFocusedPassword: Bool
    @State private var errorMessage: String = ""
    
    var isLoginButtonDisabled: Bool {
        return !(!userName.isEmpty && !password.isEmpty)
    }
    
    func loginUser() {        
        if let user = dataModel.userList.first(where: { $0.userName == userName && $0.userPassword == password }) {
            dataModel.isLogin = true
            dataModel.someLoginStringKey = userName
            userName = ""
            password = ""
        } else {
            errorMessage = "Kullanıcı adı veya şifre yanlış"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Section(header: Text("Giriş")
                    .font(.system(size: 25, weight: .medium))) {
                        TextField("Kullanıcı Adı", text: $userName)
                            .focused($isFocusedUserName)
                            .textFieldStyle(isFocused: isFocusedUserName)
    
                        ZStack {
                            if isPasswordVisible {
                                TextField("Şifre", text: $password)
                                    .textFieldStyle(isFocused: isFocusedPassword)
                                    .focused($isFocusedPassword)
                            } else {
                                SecureField("Şifre", text: $password)
                                    .textFieldStyle(isFocused: isFocusedPassword)
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
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding(.top, 5)
                    .opacity(!errorMessage.isEmpty ? 1 : 0)
                
                Button(action: loginUser) {
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
                    .background(!isLoginButtonDisabled ? Color.orange : Color.gray)
                    .cornerRadius(10)
                }
                .disabled(isLoginButtonDisabled)
                
                NavigationLink(destination: UserRegisterView()) {
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
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView()
    }
}
