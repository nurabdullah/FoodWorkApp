//
//  Listing.swift
//  MealPlanner
//
//  Created by F13  on 12.07.2023.
//

import SwiftUI

struct ListingView: View {
    @EnvironmentObject private var dataModel: DataModel
    
    func caloryCheck(erc: Int)->String{
        switch erc{
        case 0:
            return "Az Kalorili"
            
        case 1:
            return  "Orta Kalorili"
            
        case 2:
            return  "Çok kalorili"
            
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationView{
        List{
            ForEach(dataModel.foodList, id: \.self){ item in
                Section{
                HStack{
                    Text(item.foodName)
                    Spacer()
                    Text("\(caloryCheck(erc:item.caloryType))")
                        
                }
                }.listRowBackground(item.caloryType==2 ? Color.red:item.caloryType==1 ? Color.blue : Color.green)
            
            }



            
        }
        .listStyle(.plain)
        .navigationTitle("Kalori Kontrol")
                            .listStyle(InsetGroupedListStyle())
                            .environment(\.horizontalSizeClass, .compact)
            
        }
    }
}


struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
            ListingView()

    }
}
