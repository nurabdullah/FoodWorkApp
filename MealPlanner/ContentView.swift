//
//  ContentView.swift
//  MealPlanner
//
//  Created by F13  on 11.07.2023.
//

import SwiftUI

// Boş isim kaydedilmemeli
// listelemede istediğimiz silme (click)
// 1 buton olacak listingde biri eskiden yeniye diğeri yeniden eskiye sıralayacak

struct ContentView: View {
    @State private var foodName: String = ""
    @State private var calorieType = 0
    @State private var options = ["Az Kalorili" , "Orta Kalorili" , "Çok kalorili"]
    private var currentDate = Date()
    @EnvironmentObject private var dataModel: DataModel
    

    func addItem(){
        let trimmedString = foodName.trimmingCharacters(in: .whitespaces)
        let food = Food(foodName: trimmedString, caloryType: calorieType,time: currentDate)
        dataModel.foodList.append(food)
        calorieType = 0
        foodName = ""

    }
   

    var body: some View {
        VStack(alignment: .leading, spacing: 60){
            Spacer()
            VStack(alignment: .leading, spacing:7) {
                Section(header: Text("Yemek Adı")){
                    TextField("Kuru Fasülye", text:
                    $foodName).padding(10).overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.red, style:
                        StrokeStyle(lineWidth: 0.6)))
                    
                }
            }
            VStack(alignment: .leading, spacing: 7){
                
                Section(header: Text("Kalori Seviyesi Seçiniz")
                    .font(.caption)){
                    Picker(selection: $calorieType,label: Text("")){
                        ForEach(0 ..< options.count){
                            Text(self.options[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            Spacer()
            Button("EKLE" , action: addItem).frame(maxWidth: .infinity)
            
        }
        .padding()
       
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
