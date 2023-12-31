
import SwiftUI

struct UserRegisterView: View {
    
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    @State private var userPassword: String = ""
    @State private var userPasswordConfirm: String = ""
    @FocusState private var isFocusedUserName: Bool
    @FocusState private var isFocusedPassword: Bool
    @FocusState private var isFocusedPasswordVisable: Bool
    @State private var isUserPasswordVisible = false
    @State private var isUserPasswordConfirmVisible = false
    @State private var checkBoxOn = false
    @State private var someErorMatchText: String = ""
    
    
    var isButtonDisabled: Bool {
        return !(!userName.isEmpty && !userPassword.isEmpty && !userPasswordConfirm.isEmpty && checkBoxOn)
    }
    
    private func registerUser() {
        if dataModel.userList.contains(where: { $0.userName == userName }) {
            someErorMatchText = "Kullanıcı adı kullanılıyor!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                someErorMatchText = ""
            }
            
        } else {
            let users = Users(userName: userName, userPassword: userPassword)
            dataModel.userList.append(users)
            dataModel.someLoginStringKey = userName
            userName = ""
            userPassword = ""
            userPasswordConfirm = ""
            isFocusedUserName = false
            isFocusedPassword = false
            isFocusedPasswordVisable = false
            dataModel.isLogin = true
            someErorMatchText = ""
        }
    }
    
    private func clickField(eyeType: String) {
        switch eyeType {
        case "password":
            isUserPasswordVisible.toggle()
            isFocusedUserName = false
            isFocusedPasswordVisable = false
        case "passwordConfirm":
            isUserPasswordConfirmVisible.toggle()
            isFocusedUserName = false
            isFocusedPassword = false
        default:
            break
        }
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 20) {
                Section(header: Text("Kayıt Ol").font(.system(size: 25, weight: .medium))) {
                    TextField("Kullanıcı Adı", text: $userName)
                        .focused($isFocusedUserName)
                        .textFieldStyle(isFocused: isFocusedUserName)
                    
                    ZStack {
                        if isUserPasswordVisible {
                            TextField("Şifre", text: $userPassword)
                                .focused($isFocusedPassword)
                                .textFieldStyle(isFocused: isFocusedPassword)
                        } else {
                            SecureField("Şifre", text: $userPassword)
                                .focused($isFocusedPassword)
                                .textFieldStyle(isFocused: isFocusedPassword)
                        }
                        HStack {
                            Spacer()
                            Button(action: {clickField(eyeType: "password")}) {
                                Image(systemName: isUserPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                
                            }
                            .padding(.trailing, 15)
                            .buttonStyle(BorderedButtonStyle())
                        }
                    }
                    
                    ZStack {
                        if isUserPasswordConfirmVisible {
                            TextField("Şifre Tekrar", text: $userPasswordConfirm)
                                .focused($isFocusedPasswordVisable)
                                .textFieldStyle(isFocused: isFocusedPasswordVisable)
                            
                        } else {
                            SecureField("Şifre Tekrar", text: $userPasswordConfirm)
                                .focused($isFocusedPasswordVisable)
                                .textFieldStyle(isFocused: isFocusedPasswordVisable)
                        }
                        HStack {
                            Spacer()
                            Button(action: {clickField(eyeType: "passwordConfirm")}) {
                                Image(systemName: isUserPasswordVisible ? "eye.slash" : "eye")
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
                    .background(!isButtonDisabled ? Color.orange : Color.gray)
                    .cornerRadius(10)
                }
                .disabled(isButtonDisabled)
                
                NavigationLink(destination: UserLoginView()) {
                    HStack{
                        Text("Üye misin?")
                            .foregroundColor(.black)
                        Text("Giriş yap")
                            .foregroundColor(.orange)
                    }
                }
                Text(someErorMatchText)
                    .foregroundColor(.red)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.top, 5)
                    .opacity(someErorMatchText.isEmpty ? 0 : 1)
                    .padding(.top, 10)
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct UserRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegisterView()
    }
}
