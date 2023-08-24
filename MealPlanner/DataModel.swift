
import Foundation

struct Food :  Codable,Hashable {
    var foodName: String
    var caloryType: Int
    var time: Date
}

class DataModel: ObservableObject{
   
    private let dataKey = "savedFoodList"

    
    @Published var foodList: [Food] = [] {
           didSet {
               saveData()
           }
    }
    
    
    init() {
            loadData()
        }

    private func saveData() {
            if let encodedData = try? JSONEncoder().encode(foodList) {
                UserDefaults.standard.set(encodedData, forKey: dataKey)
            }
        }
        
        private func loadData() {
            if let encodedData = UserDefaults.standard.data(forKey: dataKey) {
                if let decodedData = try? JSONDecoder().decode([Food].self, from: encodedData) {
                    foodList = decodedData
                }
            }
        }
        
}

