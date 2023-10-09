// TO-DO
// *** 1. SecureField ve TextField'larin style'lari ayni. Tekrar etmesini onle!

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
            Text("Yeni şifreler eşleşmiyor.")
                .foregroundColor(.red)
                .padding(.top, 5)
                .padding(.bottom, 10)
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
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedOldPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedOldPassword)
                        .autocapitalization(.none)

                    
                } else {
                    SecureField("Eski Şifre", text: $oldPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedOldPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedOldPassword)
                    
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
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewPassword)
                        .autocapitalization(.none)

                    
                } else {
                    SecureField("Yeni Şifre", text: $newPassword)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewPassword)
                    
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
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedNewConfirmPassword ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedNewConfirmPassword)
                        .autocapitalization(.none) 

                    
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
                    Button(action: { clickEyeIcon(eyeType: "newPasswordConfirm")}) {
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
            } else{
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

