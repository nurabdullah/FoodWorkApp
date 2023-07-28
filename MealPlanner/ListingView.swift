//
//  Listing.swift
//  MealPlanner
//
//  Created by F13  on 12.07.2023.
//

import SwiftUI
import Foundation


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
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM - HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func deleteItem(at indexSet: IndexSet){
        dataModel.foodList.remove(atOffsets: indexSet)
    }
    
    
    var body: some View {
        NavigationView{
            List{
                ForEach(dataModel.foodList.sorted(by:{$1.time<$0.time}), id: \.self){ item in
                    Section{
                        HStack{
                            Text(item.foodName)
                            Spacer()
                            Text("\(formatDate(date:item.time))")
                                .font(.system(size: 12))
                            Spacer()
                            Text("\(caloryCheck(erc:item.caloryType))")

                        }
                    }.listRowBackground(item.caloryType==2 ? Color.red:item.caloryType==1 ? Color.blue : Color.green)
                    
                }.onDelete(perform: {indexSet in
                    deleteItem(at: indexSet)

                })
                    
            }.navigationBarItems(trailing: EditButton())
            
            .listStyle(.plain)
            .navigationTitle("Kalori Kontrol")
            .listStyle(InsetGroupedListStyle())
            .environment(\.horizontalSizeClass, .compact)
            
        }
      
    }
 
    
    
    struct ListingView_Previews: PreviewProvider {
        static var previews: some View {
            ListingView()
            
        }
    }
}

