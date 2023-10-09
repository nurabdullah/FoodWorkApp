import Foundation
import UIKit

struct Food: Codable, Hashable {
    var foodName: String
    var caloryType: Int
    var time: Date
}

struct Users: Codable, Hashable {
    var userName: String
    var userPassword: String
}

class DataModel: ObservableObject {
    private let dataFoodKey = "savedFoodList"
    private let dataLoginArrayKey = "savedUsersList"
    private let loginKey = "isLogin"
    private let loginStringKey = "someLoginStringKey"
    

    
    @Published var isLogin: Bool = false {
        didSet {
            saveLoginData()
        }
    }
    
    @Published var someLoginStringKey: String = "" {
        didSet {
            saveStringData()
        }
    }
    
    @Published var foodList: [Food] = [] {
        didSet {
            saveFoodData()
        }
    }
    
    @Published var userList: [Users] = [] {
        didSet {
            saveUsersData()
        }
    }
    
    init() {
        getFoodData()
        getUserData()
        getLoginData()
        subscribeToAppLifecycle()
        getStringData()
    }
    
    private func subscribeToAppLifecycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc private func saveDataOnAppExit() {
        saveLoginData()
    }
    
    private func saveFoodData() {
        if let encodedData = try? JSONEncoder().encode(foodList) {
            UserDefaults.standard.set(encodedData, forKey: dataFoodKey)
        }
    }
    private func saveUsersData() {
        if let encodedData = try? JSONEncoder().encode(userList) {
            UserDefaults.standard.set(encodedData, forKey: dataLoginArrayKey)
        }
    }
    
    private func saveLoginData() {
        UserDefaults.standard.set(isLogin, forKey: loginKey)
    }
    
    private func saveStringData() {
        UserDefaults.standard.set(someLoginStringKey, forKey: loginStringKey)
    }
    
    private func getFoodData() {
        if let encodedData = UserDefaults.standard.data(forKey: dataFoodKey) {
            if let decodedData = try? JSONDecoder().decode([Food].self, from: encodedData) {
                foodList = decodedData
            }
        }
    }
    private func getUserData() {
        if let encodedData = UserDefaults.standard.data(forKey: dataLoginArrayKey) {
            if let decodedData = try? JSONDecoder().decode([Users].self, from: encodedData) {
                userList = decodedData
            }
        }
    }
    
    private func getLoginData() {
        isLogin = UserDefaults.standard.bool(forKey: loginKey)
    }
    private func getStringData() {
        someLoginStringKey = UserDefaults.standard.string(forKey: loginStringKey) ?? ""
    }

    
}

