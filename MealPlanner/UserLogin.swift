

import SwiftUI

struct UserLogin: View {
    @EnvironmentObject private var dataModel: DataModel
    @State private var userName: String = ""
    
    
    
    
    func addUser(){
        if !userName.isEmpty{
            
            dataModel.isLogin = true
            dataModel.myArray.append(userName)
            userName = ""
            
        }
        
    }
    
    func userDelete(){
        
        dataModel.myArray.removeAll()
        dataModel.isLogin = false
        
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            if dataModel.isLogin{
                Text("Active User  \(dataModel.myArray.first ?? "")")
                    .font(.headline)
                    .padding()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Section(header: Text("Kullanıcı Adı Giriniz")) {
                        TextField("Abdullah", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10.0)
                                    .strokeBorder(Color.red, style: StrokeStyle(lineWidth: 0.6))
                            )
                    }
                    
                    Button("Login", action: addUser)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin))
                }
            }
            
            Button("Logout", action: userDelete)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .padding(25)
    }
}


struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin()
    }
}
