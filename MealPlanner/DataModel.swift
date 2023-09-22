import Foundation
import UIKit

struct Food: Codable, Hashable {
    var foodName: String
    var caloryType: Int
    var time: Date
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
        subscribeToAppLifecycle()
    }

    private func subscribeToAppLifecycle() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataOnAppExit), name: UIApplication.willTerminateNotification, object: nil)
    }

    @objc private func saveDataOnAppExit() {
        saveLoginData()
        saveArrayData()
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
        UserDefaults.standard.set(loginMyArray, forKey: loginArrayKey)
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
        loginMyArray = UserDefaults.standard.stringArray(forKey: loginArrayKey) ?? []
    }
}
