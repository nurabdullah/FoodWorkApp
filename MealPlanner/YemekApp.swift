//
//  MealPlannerApp.swift
//  MealPlanner
//
//  Created by Abdullah Nur  on 11.07.2023.
//
//
import SwiftUI


@main
struct YemekApp: App {
    @StateObject  var dataModel = DataModel()
    

    
    var body: some Scene {
        WindowGroup{
            TabBarView()
                .environmentObject(dataModel)
        }
    }
}
