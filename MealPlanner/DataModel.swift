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
    
    private let dataKey = "savedFoodList"
    private let loginKey = "isLogin"
    private let loginArrayKey = "loginMyArray"
    
    @Published var isLogin: Bool = false {
        didSet {
            saveLoginData()
        }
    }
  
    
    @Published var loginMyArray: [String] = [] {
        didSet {
            saveLoginArrayData()
        }
    }
  
    
    @Published var foodList: [Food] = [] {
        didSet {
            saveFoodData()
        }
    }
    @Published var usersList: [Users] = [] {
        didSet {
            saveUsersData()
        }
    }
    
    init() {
        loadFoodData()
        loadUsersData()
        loadLoginData()
        loadLoginArrayData()
        subscribeToAppLifecycle()
    }
    
    private func subscribeToAppLifecycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc private func saveDataOnAppExit() {
        saveLoginData()
        saveLoginArrayData()
    }
    
    private func saveFoodData() {
        if let encodedData = try? JSONEncoder().encode(foodList) {
            UserDefaults.standard.set(encodedData, forKey: dataKey)
        }
    }
     private func saveUsersData() {
        if let encodedData = try? JSONEncoder().encode(usersList) {
            UserDefaults.standard.set(encodedData, forKey: dataKey)
        }
    }
    
    private func saveLoginData() {
        UserDefaults.standard.set(isLogin, forKey: loginKey)
    }
    
    private func saveLoginArrayData() {
        UserDefaults.standard.set(loginMyArray, forKey: loginArrayKey)
    }
    
    
    
    private func loadFoodData() {
        if let encodedData = UserDefaults.standard.data(forKey: dataKey) {
            if let decodedData = try? JSONDecoder().decode([Food].self, from: encodedData) {
                foodList = decodedData
            }
        }
    }
    private func loadUsersData() {
        if let encodedData = UserDefaults.standard.data(forKey: dataKey) {
            if let decodedData = try? JSONDecoder().decode([Users].self, from: encodedData) {
                usersList = decodedData
            }
        }
    }
    
    private func loadLoginData() {
        isLogin = UserDefaults.standard.bool(forKey: loginKey)
    }
    
    private func loadLoginArrayData() {
        loginMyArray = UserDefaults.standard.stringArray(forKey: loginArrayKey) ?? []
    }
   
}

