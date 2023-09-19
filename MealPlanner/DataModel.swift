import Foundation

struct Food: Codable, Hashable {
    var foodName: String
    var caloryType: Int
    var time: Date
}

class DataModel: ObservableObject {
   
    private let dataKey = "savedFoodList"
    private let loginKey = "isLogin"
    private let arrayKey = "myArray"
    
    @Published var isLogin: Bool = false {
        didSet {
            saveLoginData()
        }
    }
    
    @Published var myArray: [String] = [] {
        didSet {
            saveArrayData()
        }
    }
    
    @Published var foodList: [Food] = [] {
        didSet {
            saveFoodData()
        }
    }
    
    init() {
        loadData()
        loadLoginData()
        loadArrayData()
    }
    
    private func saveFoodData() {
        if let encodedData = try? JSONEncoder().encode(foodList) {
            UserDefaults.standard.set(encodedData, forKey: dataKey)
        }
    }
    
    private func saveLoginData() {
        UserDefaults.standard.set(isLogin, forKey: loginKey)
    }
    
    private func saveArrayData() {
        UserDefaults.standard.set(myArray, forKey: arrayKey)
    }
    
    private func loadData() {
        if let encodedData = UserDefaults.standard.data(forKey: dataKey) {
            if let decodedData = try? JSONDecoder().decode([Food].self, from: encodedData) {
                foodList = decodedData
            }
        }
    }
    
    private func loadLoginData() {
        isLogin = UserDefaults.standard.bool(forKey: loginKey)
    }

    private func loadArrayData() {
        myArray = UserDefaults.standard.stringArray(forKey: arrayKey) ?? []
    }
}
