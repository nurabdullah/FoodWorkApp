import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
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
    @Environment(\.dismiss) var dismiss
    @State private var someErorMatchText: String = ""
    
    var isPasswordMatch: Bool {
        return newPassword == newPasswordConfirm
    }
    
    var buttonCheck: Bool {
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
        } else {
            isPasswordMatchError = true
            someErorMatchText = "Yeni şifreler eşleşmiyor."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                someErorMatchText = ""
            }
        }
    }
    
    func clickEyeIcon(eyeType: String) {
        switch eyeType {
        case "oldPassword":
            isOldPasswordVisible.toggle()
            isFocusedNewPassword = false
            isFocusedNewConfirmPassword = false
        case "newPassword":
            isNewPasswordVisible.toggle()
            isFocusedOldPassword = false
            isFocusedNewConfirmPassword = false
        case "newPasswordConfirm":
            isNewConfirmPasswordVisible.toggle()
            isFocusedOldPassword = false
            isFocusedNewPassword = false
        default:
            break
        }
    }

    var body: some View {
        VStack {
            ZStack {
                if isOldPasswordVisible {
                    TextField("Eski Şifre", text: $oldPassword)
                        .focused($isFocusedOldPassword)
                        .textFieldStyle(isFocused: isFocusedOldPassword)

                    
                } else {
                    SecureField("Eski Şifre", text: $oldPassword)
                        .focused($isFocusedOldPassword)
                        .textFieldStyle(isFocused: isFocusedOldPassword)
                }
                HStack {
                    Spacer()
                    Button(action: {clickEyeIcon(eyeType:"oldPassword")}) {
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
                        .focused($isFocusedNewPassword)
                        .textFieldStyle(isFocused: isFocusedNewPassword)
                    
                } else {
                    SecureField("Yeni Şifre", text: $newPassword)
                        .focused($isFocusedNewPassword)
                        .textFieldStyle(isFocused: isFocusedNewPassword)
                }
                HStack {
                    Spacer()
                    Button(action: {clickEyeIcon(eyeType: "newPassword")
                       
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
                        .focused($isFocusedNewConfirmPassword)
                        .textFieldStyle(isFocused: isFocusedNewConfirmPassword)
                    
                } else {
                    SecureField("Yeni Şifre Tekrar", text: $newPasswordConfirm)
                        .focused($isFocusedNewConfirmPassword)
                        .textFieldStyle(isFocused: isFocusedNewConfirmPassword)
                    
                }
                HStack {
                    Spacer()
                    Button(action: { clickEyeIcon(eyeType: "newPasswordConfirm")}) {
                        Image(systemName: isNewConfirmPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                    .buttonStyle(BorderedButtonStyle())
                    
                }
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
            
            if isPasswordMatchError {
                Text(someErorMatchText)
                    .foregroundColor(.red)
                    .padding(.top, 5)
                    .padding(.bottom, 10)
            } else{
                Text("")
            }
            
            
            Spacer()
            if showToastMessage {
                ToastView(message: "Şifre başarılı bir şekilde değiştirildi", iconName: "hand.thumbsup", showToastMessage: $showToastMessage)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4))
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                    oldPassword = ""
                    newPasswordConfirm = ""
                    newPassword = ""
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        
                        Text("Geri Dön")
                        Spacer()
                    }
                }
            }
        }
        .padding()
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}

