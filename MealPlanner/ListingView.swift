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
        dateFormatter.dateFormat = "d MMM, HH:mm "
        return dateFormatter.string(from: date)
        
        
    }
    
    private let sortingPreferenceKey = "sortingPreference"
    
    private let userDefaults = UserDefaults.standard
    
    
    
    func saveSortingPreference(sortKey: [String] ) {
        userDefaults.set(sortKey, forKey: sortingPreferenceKey)
    }
    
    func getSortingPreference() {
        
        let array : [String]  = userDefaults.stringArray(forKey: sortingPreferenceKey) ?? [String]()
        
        if array.count > 1 {
            
            isAsceding = Bool(array[1]) ?? false
            
            switch array[0]{
                
            case "name":
                sortFoodListByName(isCurrentAsceding: isAsceding)
                break
            case "date":
                sortFoodListByDate(isCurrentAsceding: isAsceding)
                break
            case "calory":
                sortFoodListByCaloryType(isCurrentAsceding: isAsceding)
        
            default:
                break
            }
            
        }
    }
    
    
    
    private  func sortFoodListByDate(isCurrentAsceding: Bool){
        isAsceding = isCurrentAsceding
        
        if !isAsceding {
            foodList = foodList.sorted(by:{$1.time < $0.time})
        }
        else {
            foodList = foodList.sorted(by:{$1.time > $0.time})
        }
        
        saveSortingPreference(sortKey: ["date",String(isAsceding)])
        
    }
    
    private func sortFoodListByName(isCurrentAsceding:Bool){
        isAsceding = isCurrentAsceding
        
        if !isAsceding {
            foodList = foodList.sorted(by:{$0.foodName < $1.foodName})
        }
        else {
            foodList = foodList.sorted(by:{$0.foodName > $1.foodName})
        }
        saveSortingPreference(sortKey: ["name",String(isAsceding)])
        
    }
    private func sortFoodListByCaloryType(isCurrentAsceding:Bool){
        isAsceding = isCurrentAsceding
        
        if !isAsceding {
            foodList = foodList.sorted(by:{$0.caloryType < $1.caloryType})
        }
        else {
            foodList = foodList.sorted(by:{$0.caloryType > $1.caloryType})
        }
        saveSortingPreference(sortKey: ["calory",String(isAsceding)])
        
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
                           
                            Text(item.foodName)
                            
                            Spacer()
                            Text("\(formatDate(date:item.time))")
                                .font(.system(size: 12))
//                            Spacer()
//                            Text("\(caloryCheck(erc:item.caloryType))")
                            
                        }
                    }
                    
                }.onDelete(perform: deleteItem)
                
            }
            .onAppear{
                foodList = dataModel.foodList
                calculateAverageCalories()
                getSortingPreference()
            }
            .toolbar {
                EditButton()
                Menu("Sırala"){
                    Button {
                        sortFoodListByName(isCurrentAsceding: !isAsceding)
                    } label: {
                        Label("Ad", systemImage: "textformat.alt" )
                    }
                    Button {
                        sortFoodListByDate(isCurrentAsceding: !isAsceding)
                    } label: {
                        Label("Tarih", systemImage: "arrow.up.and.down.text.horizontal" )
                    }
                    Button {
                        sortFoodListByCaloryType(isCurrentAsceding: !isAsceding)
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
