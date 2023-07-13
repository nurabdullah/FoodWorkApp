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
    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .tabItem{
                        HStack{
                            Image(systemName: "house")
                            Text("Menü")
                        }
                    }
                Filter()
                    .tabItem{
                        HStack{
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text("Filter")
                        }
                    }
                ListingView()
                    .tabItem {
                        HStack{
                            Image(systemName: "list.clipboard")
                            Text("Listele")
                        }
                    }
            }
            .environmentObject(dataModel)
        }
    }
}
