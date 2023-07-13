//
//  Listing.swift
//  MealPlanner
//
//  Created by F13  on 12.07.2023.
//

import SwiftUI

struct Listing: View {
    @EnvironmentObject private var dataModel: DataModel
    
    func caloryCheck(erc: Int)->String{
        switch erc{
        case 0:
            return "-Az Kalorili"
            
        case 1:
            return  "-Orta Kalorili"
            
        case 2:
            return  "-Çok kalorili"
            
        default:
            return ""
        }
    }
    
    var body: some View {
        List{
            ForEach(dataModel.foodList, id: \.self){ item in
                HStack{
                    Text(item.foodName)
                    Text("\(caloryCheck(erc:item.caloryType))")
                    
                }
                
            }
            
        }
    }
}

struct Listing_Previews: PreviewProvider {
    static var previews: some View {
        Listing()
    }
}
