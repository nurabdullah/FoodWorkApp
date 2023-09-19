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
    @State private var selectedTab = 0 // Varsayılan sekme indeksi

    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                            ContentView()
                                .tabItem {
                                    HStack {
                                        Image(systemName: "house")
                                        Text("Menü")
                                    }
                                }
                                .tag(1) 
                            
                            UserLogin()
                                .tabItem {
                                    HStack {
                                        Image(systemName: "person.fill")
                                        Text("Hesabım")
                                    }
                                }
                                .tag(0)
                
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
            }
            .environmentObject(dataModel)
            .onAppear {
                UITabBar.appearance().backgroundColor = .lightGray
                selectedTab = dataModel.isLogin ? 1 : 0

            }
        }
    }
}


