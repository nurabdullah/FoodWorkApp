import SwiftUI
import Foundation


struct ListingView: View {
    @EnvironmentObject private var dataModel : DataModel
    @State private var isAscending: Bool = true;
    @State var foodList : [Food] = []
    @State private var searchTerm: String = ""
    @State private var averageCalorieText: String = ""
    @State private var calorie: Double = 0
    @State private var selectedItem: Food? = nil
    @State private var isShowingAlert: Bool = false
    @State private var isSearching = false
    @State private var isKeyboardVisible = false
    
    
    public func calculateAverageCalories() -> Color{
        let totalCalories = foodList.reduce(0) { $0 + $1.caloryType }
        calorie = Double(totalCalories) / Double(foodList.count)
        averageCalorieText = ""
        if calorie < 0.7 {
            averageCalorieText = "Düşük düzeyde kalorili bir liste."
            return Color.green
            
        } else if calorie >= 0.7 && calorie < 1.5  {
            averageCalorieText = "Orta düzeyde kalorili bir liste."
            return Color.blue
            
        } else if calorie >= 1.5 && calorie < 10  {
            averageCalorieText = "Yüksek düzeyde kalorili bir liste."
            return Color.red
            
        }else{
            averageCalorieText = "Liste boş yemek yeme vakti."
            return Color.orange
            
        }
                
    }
    
    func calculateTextForCaloryType(_ caloryType: Int) -> String {
        switch caloryType {
        case 0:
            return "Düşük"
        case 1:
            return "Orta"
        case 2:
            return "Yüksek"
        default:
            return ""
        }
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
            VStack{
            HStack {
                Text("Liste")
                    .font(.system(size: 25))
                Spacer()
            }
            .padding(.top, 5)
            
            HStack {
                TextField("Ara", text: $searchTerm)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .onTapGesture {
                        isSearching = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                        isKeyboardVisible = true
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                        isSearching = false
                        isKeyboardVisible = false
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: searchTerm.isEmpty ? "magnifyingglass" : "magnifyingglass")
                                .foregroundColor(searchTerm.isEmpty && !isSearching ? .gray : .orange)
                                .padding(.trailing, 1)
                                .onTapGesture {
                                    isSearching = true
                                }
                        }
                    )
                
                Spacer()
                
                
                if !isSearching {
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
                            Label("Sıfırla", systemImage: "gobackward")
                        }
                    }
                } else {
                    Button("Vazgeç") {
                        isSearching = false
                        searchTerm = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                }
                
                
            }.padding()
            
            List {
                ForEach(foodList, id: \.self) { item in
                    
                    HStack {
                            Rectangle()
                                .frame(width: 4, height: 60)
                                .foregroundColor(getBorderColorForCaloryType(item.caloryType))
                            
                            Text(truncateText(item.foodName, maxLength: 15))
                            
                            Spacer()
                            
                            Text("\(formatDate(date: item.time))")
                                .font(.system(size: 12))
                        
//                                .swipeActions {
//                                    Button(action: {
//                   deleteItem(at: IndexSet([foodList.firstIndex(of: item)!]))
//                                        
//                                    }) {
//                                        Text("Sil")
//                                    }
//                                    .tint(.red)
//                                }
                    }
                    .onTapGesture {
                        selectedItem = item
                        isShowingAlert = true
                    }
                    
                }
                .onDelete(perform: deleteItem)
                .listRowInsets(EdgeInsets())
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
            .background(calculateAverageCalories())
            .foregroundColor(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(width: .infinity, height: 45)
            .onChange(of: foodList) { _ in
                calculateAverageCalories()
            }
            
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text(selectedItem?.foodName ?? ""),
                message: Text("Kalori Seviyesi: \(calculateTextForCaloryType(selectedItem?.caloryType ?? 0))"),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }
}






struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
        
    }
}
