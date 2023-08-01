//
//  Listing.swift
//  MealPlanner
//
//  Created by F13  on 12.07.2023.
//

import SwiftUI
import Foundation


struct ListingView: View {
    @EnvironmentObject private var dataModel : DataModel
    @State private var isAsceding: Bool = true;
    @State var foodList : [Food] = []
    @State private var searchTerm: String = ""
    
    
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
    
    private  func sortFoodList(){
        isAsceding = !isAsceding
        
        if !isAsceding {
            foodList = foodList.sorted(by:{$1.time < $0.time})
        }
        else {
            foodList = foodList.sorted(by:{$1.time > $0.time})
        }
    }
    
    func deleteItem(_ item: Food) {
        dataModel.foodList.removeAll { $0 == item }
        foodList.removeAll { $0 == item }
       }
    
    func performSearch(with newValue: String) {

        if newValue.isEmpty {
            foodList = dataModel.foodList
        }
        else {
            foodList = dataModel.foodList.filter({$0.foodName.localizedCaseInsensitiveContains(newValue)})
        }
     }
    
    var body: some View {
        NavigationView{
            List{
                HStack{
                    Spacer()
                    Button {
                        sortFoodList()
                    } label: {
                        Label("", systemImage: "arrow.up.and.down.text.horizontal" )
                    }
                }
                
                ForEach(foodList, id: \.self){ item in
                    Section{
                        HStack{
                            Image(systemName: "staroflife")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20)
                                .foregroundColor(item.caloryType==2 ? Color.red:item.caloryType==1 ? Color.blue : Color.green)
                            Text(item.foodName)
                            Spacer()
                            Text("\(formatDate(date:item.time))")
                                .font(.system(size: 12))
                            Spacer()
                            Text("\(caloryCheck(erc:item.caloryType))")
                            Spacer(minLength: 10)
                            Button {
                                deleteItem(item)
                            }
                        label: {
                            Label("", systemImage: "trash.circle")
                        }
                        .foregroundColor(.red)
                            
                        }
                    }
                    //                    .listRowBackground(item.caloryType==2 ? Color.red:item.caloryType==1 ? Color.blue : Color.green)
                }
                
                //Button("Sırala", action: sortFoodList).frame(maxWidth: .infinity)
                
                
            }.onAppear{
                foodList = dataModel.foodList
            }.listStyle(.plain)
                .navigationTitle("Kalori Kontrol")
                .listStyle(InsetGroupedListStyle())
                .environment(\.horizontalSizeClass, .compact)
                .searchable(text: $searchTerm)
                .onChange(of: searchTerm) { newValue in
                    performSearch(with: newValue)
                        }
        }
        
    }
    
}
 
    
    
    struct ListingView_Previews: PreviewProvider {
        static var previews: some View {
            ListingView()
            
        }
    }


