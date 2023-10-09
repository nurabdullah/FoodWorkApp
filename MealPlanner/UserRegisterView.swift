
// Nice to have: Toggle onchange icin icerisi fonksiyon aliyor mu arastirilacak? Aliyorsa icindeki kodlar bir fonksiyona atanacak.
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
    @State private var someString: String = ""



    var isButtonDisabled: Bool {
        return !(!userName.isEmpty && !userPassword.isEmpty && !userPasswordConfirm.isEmpty && checkBoxOn)
    }
    
    private func registerUser() {
        if dataModel.userList.contains(where: { $0.userName == userName }) {
            someString = "Kullanıcı adı kullanılıyor"
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
            someString = ""
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
                    if isUserPasswordVisible {
                        TextField("Şifre", text: $userPassword)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isFocusedPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .focused($isFocusedPassword)
                    } else {
                        SecureField("Şifre", text: $userPassword)
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
                            isUserPasswordVisible.toggle()
                            isFocusedUserName = false
                            isFocusedPasswordVisable = false
                        }) {
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
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isFocusedPasswordVisable ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .focused($isFocusedPasswordVisable)
                    } else {
                        SecureField("Şifre Tekrar", text: $userPasswordConfirm)
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
                            isUserPasswordConfirmVisible.toggle()
                            isFocusedUserName = false
                            isFocusedPassword = false
                        }) {
                            Image(systemName: isUserPasswordConfirmVisible ? "eye.slash" : "eye")
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
            Text(someString)
                .foregroundColor(.red)
                .font(.system(size: 15, weight: .medium))
                .padding(.top, 5)
                .opacity(someString.isEmpty ? 0 : 1)
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
