
import SwiftUI
import Foundation


struct ListingView: View {
    @EnvironmentObject private var dataModel : DataModel
    @State private var isAsceding: Bool = true;
    @State var foodList : [Food] = []
    @State private var searchTerm: String = ""
    @State private var resultText: String = ""
    @State private var calorie: Double = 0
    
    
    public func calculateAverageCalories() -> String{
        let totalCalories = foodList.reduce(0) { $0 + $1.caloryType }
        calorie = Double(totalCalories) / Double(foodList.count)
        print("Ortalama Kalori:", calorie)
        resultText = ""
        if calorie < 0.7 {
            resultText = "Düşük düzeyde kalorili bir liste."
        } else if calorie >= 0.7 && calorie < 1.5  {
            resultText = "Orta düzeyde kalorili bir liste."
        } else if calorie >= 1.5 && calorie < 10  {
            resultText = "Yüksek düzeyde kalorili bir liste."
        }else{
            resultText = "Liste boş yemek yeme vakti."
        }
            
        return resultText

        }
    
    
    
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
    
    private  func sortFoodListByDate(){
        isAsceding = !isAsceding
       
        if !isAsceding {
            foodList = foodList.sorted(by:{$1.time < $0.time})
        }
        else {
            foodList = foodList.sorted(by:{$1.time > $0.time})
        }
    }
    
    private func sortFoodListByName(){
       isAsceding = !isAsceding

        if !isAsceding {
            foodList = foodList.sorted(by:{$0.foodName < $1.foodName})
        }
        else {
            foodList = foodList.sorted(by:{$0.foodName > $1.foodName})
        }
      
    }
    private func sortFoodListByCaloryType(){
       isAsceding = !isAsceding
        
        if !isAsceding {
            foodList = foodList.sorted(by:{$0.caloryType < $1.caloryType})
        }
        else {
            foodList = foodList.sorted(by:{$0.caloryType > $1.caloryType})
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
           foodList.remove(atOffsets: offsets)
            dataModel.foodList.remove(atOffsets: offsets)
       }
    private func resetList(){
        foodList = dataModel.foodList;
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
                Text(resultText)
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
                           
                        }
                    }
                    
                }.onDelete(perform: deleteItem)
                
            }
            .onAppear{
                foodList = dataModel.foodList
                calculateAverageCalories()

            }.toolbar {
                EditButton()
                Menu("Sırala"){
                    Button {
                        sortFoodListByName()
                    } label: {
                        Label("Ad", systemImage: "textformat.alt" )
                    }
                    Button {
                        sortFoodListByDate()
                    } label: {
                        Label("Tarih", systemImage: "arrow.up.and.down.text.horizontal" )
                    }
                    Button {
                        sortFoodListByCaloryType()
                    } label: {
                        Label("Kalori", systemImage: "greaterthan.circle.fill" )
                    }
                     Button {
                        resetList()
                    } label: {
                        Label("Reset", systemImage: "gobackward" )
                    }
                    
                }
               

            }
            .listStyle(.plain)
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


