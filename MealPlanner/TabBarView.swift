import SwiftUI

struct TabBarView: View {
    
    @StateObject private var dataModel = DataModel()
    
    var body: some View {
        if dataModel.isLogin {
            TabView() {
                Group{
                    ContentView()
                        .tabItem {
                            Label("Menü" , systemImage: "house")
                            
                        }
                    ListingView()
                        .tabItem {
                            Label("Listele" , systemImage: "list.clipboard")
                        }
                    
                    AccountView()
                        .tabItem {
                            Label("Hesabım" , systemImage: "person.fill")
                        }
                }
                .toolbarBackground(.white, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            .environmentObject(dataModel)
            .onAppear {
                UITabBar.appearance()}
            .accentColor(.orange)
            
        } else {
            UserRegisterView()
                .environmentObject(dataModel)
        }
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(DataModel())
        
        
    }
}
