import SwiftUI
import Foundation


struct ListingView: View {
    @EnvironmentObject private var dataModel : DataModel
    @State private var isAscending: Bool = true;
    @State var foodList : [Food] = []
    @State private var searchTerm: String = ""
    @State private var averageCalorieText: String = ""
    @State private var calorie: Double = 0
    
    
    public func calculateAverageCalories() -> String{
        let totalCalories = foodList.reduce(0) { $0 + $1.caloryType }
        calorie = Double(totalCalories) / Double(foodList.count)
        averageCalorieText = ""
        if calorie < 0.7 {
            averageCalorieText = "Düşük düzeyde kalorili bir liste."
        } else if calorie >= 0.7 && calorie < 1.5  {
            averageCalorieText = "Orta düzeyde kalorili bir liste."
        } else if calorie >= 1.5 && calorie < 10  {
            averageCalorieText = "Yüksek düzeyde kalorili bir liste."
        }else{
            averageCalorieText = "Liste boş yemek yeme vakti."
        }
        
        return averageCalorieText
        
    }
    
    
    
    func getBorderColorForCaloryType(_ caloryType: Int) -> Color {
        switch caloryType {
        case 0:
            return Color.green
        case 1:
            return Color.blue
        case 2:
            return Color.red
        default:
            return Color.orange
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
            
            isAscending = Bool(array[1]) ?? false
            
            switch array[0]{
                
            case "name":
                sortFoodListByName(isCurrentAsceding: isAscending)
                break
            case "date":
                sortFoodListByDate(isCurrentAsceding: isAscending)
                break
            case "calory":
                sortFoodListByCaloryType(isCurrentAsceding: isAscending)
                
            default:
                break
            }
            
        }
    }
    
    
    
    private  func sortFoodListByDate(isCurrentAsceding: Bool){
        isAscending = isCurrentAsceding
        
        if !isAscending {
            foodList = foodList.sorted(by:{$1.time < $0.time})
        }
        else {
            foodList = foodList.sorted(by:{$1.time > $0.time})
        }
        
        saveSortingPreference(sortKey: ["date",String(isAscending)])
        
    }
    
    private func sortFoodListByName(isCurrentAsceding:Bool){
        isAscending = isCurrentAsceding
        
        if !isAscending {
            foodList = foodList.sorted(by:{$0.foodName < $1.foodName})
        }
        else {
            foodList = foodList.sorted(by:{$0.foodName > $1.foodName})
        }
        saveSortingPreference(sortKey: ["name",String(isAscending)])
        
    }
    private func sortFoodListByCaloryType(isCurrentAsceding:Bool){
        isAscending = isCurrentAsceding
        
        if !isAscending {
            foodList = foodList.sorted(by:{$0.caloryType < $1.caloryType})
        }
        else {
            foodList = foodList.sorted(by:{$0.caloryType > $1.caloryType})
        }
        saveSortingPreference(sortKey: ["calory",String(isAscending)])
        
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
    
    func truncateText(_ text: String, maxLength: Int) -> String {
        if text.count > maxLength {
            let truncatedIndex = text.index(text.startIndex, offsetBy: maxLength)
            return String(text[..<truncatedIndex]) + "..."
        }
        return text
    }
    var body: some View {
            VStack {
                HStack {
                    Text("Liste")
                        .font(.system(size: 25))
                    Spacer()
                }
                .padding(.top, 5)
                
                HStack {
                    TextField("Arama", text: $searchTerm)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: searchTerm.isEmpty ? "magnifyingglass" : "magnifyingglass")
                                    .foregroundColor(!searchTerm.isEmpty ? .orange : .gray)
                                    .padding(.trailing, 10)
                            }
                        )
                    
                    Spacer()
                    
                    if searchTerm.isEmpty {
                        Menu("Sırala") {
                            Button {
                                sortFoodListByName(isCurrentAsceding: !isAscending)
                            } label: {
                                Label("Ad", systemImage: "textformat.alt")
                            }
                            Button {
                                sortFoodListByDate(isCurrentAsceding: !isAscending)
                            } label: {
                                Label("Tarih", systemImage: "arrow.up.and.down.text.horizontal")
                            }
                            Button {
                                sortFoodListByCaloryType(isCurrentAsceding: !isAscending)
                            } label: {
                                Label("Kalori", systemImage: "greaterthan.circle.fill")
                            }
                            Button {
                                resetList()
                            } label: {
                                Label("Reset", systemImage: "gobackward")
                            }
                        }
                    }
                }
                
                List {
                    ForEach(foodList, id: \.self) { item in
                        HStack {
                                Rectangle()
                                    .frame(width: 12, height: 45)
                                    .foregroundColor(getBorderColorForCaloryType(item.caloryType))
                                Text(truncateText(item.foodName, maxLength: 10))
                                Spacer()
                                Text("\(formatDate(date: item.time))")
                                    .font(.system(size: 12))
                            }

                        
                    }
                    .onDelete(perform: deleteItem)
                }
                .onAppear {
                    foodList = dataModel.foodList
                    calculateAverageCalories()
                    getSortingPreference()
                }
                
                .listStyle(PlainListStyle())
                .environment(\.horizontalSizeClass, .compact)
                .onChange(of: searchTerm) { newValue in
                    performSearch(with: newValue)
                }
                
                Spacer()
                
                HStack {
                    Text(averageCalorieText)
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                .background(Color.orange)
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 435, height: 45)

            }
            .padding()
        }
        
}



struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
        
    }
}
