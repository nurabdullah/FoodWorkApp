//
//  File.swift
//  MealPlanner
//
//  Created by F13  on 13.07.2023.
//

import Foundation

struct Food :  Hashable {
    var foodName: String
    var caloryType: Int
    var time: Date
}

class DataModel: ObservableObject{
    
    @Published var foodList: [Food] = []
    

}
