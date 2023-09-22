//
//  MealPlannerApp.swift
//  MealPlanner
//
//  Created by F13  on 11.07.2023.
//

import SwiftUI

@main
struct YemekApp: App {
    
    @StateObject private var dataModel = DataModel()
    
    init () {
        print(dataModel.isLogin)
    }
    
    var body: some Scene {
        WindowGroup {
            if dataModel.isLogin {
                TabView() {
                    ContentView()
                        .tabItem {
                            HStack {
                                Image(systemName: "house")
                                Text("Menü")
                            }
                        }
                    
                    Filter()
                        .tabItem {
                            HStack {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                Text("Filter")
                            }
                        }
                    
                    ListingView()
                        .tabItem {
                            HStack {
                                Image(systemName: "list.clipboard")
                                Text("Listele")
                            }
                        }
                    UserLogin()
                        .tabItem {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("Hesabım")
                            }
                        }
                }
                .environmentObject(dataModel)
                .onAppear {
                    UITabBar.appearance().backgroundColor = .lightGray
                    
                }
            } else {
                UserLogin()
                    .environmentObject(dataModel)
            }
        }
    }
}


