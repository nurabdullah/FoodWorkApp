import SwiftUI




struct ContentView: View {
    @State private var foodName: String = ""
    @State private var selectedCalorieTypeIndex: Int? = 0
    private var currentDate = Date()
    @EnvironmentObject private var dataModel: DataModel
    @FocusState private var isFocusedFoodName: Bool
    
    private var options = ["Az Kalorili", "Orta Kalorili", "Çok kalorili"]
    
    var isFoodAddedEnabled: Bool {
        return !foodName.isEmpty
    }
    
    func addItem() {
        if isFoodAddedEnabled {
            let trimmedString = foodName.trimmingCharacters(in: .whitespaces)
            let food = Food(foodName: trimmedString, caloryType: selectedCalorieTypeIndex ?? 0, time: currentDate)
            dataModel.foodList.append(food)
            selectedCalorieTypeIndex = 0
            foodName = ""
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            if let firstItem = dataModel.loginMyArray.first {
                Text("Hoşgeldin " + firstItem)
                    .font(.system(size: 25))
            }
            
            VStack(alignment: .leading, spacing: 30) {
                Section(header: Text("Yemek Adı Giriniz")
                    .font(.system(size: 25))) {
                    TextField("Kuru Fasülye, Yumurta", text: $foodName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedFoodName ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedFoodName)
                }
            }
            
            VStack {
                VStack(alignment: .leading, spacing: 30) {
                        Text("Kalori Seviyesi Seçiniz ")
                            .font(.system(size: 25))

                ForEach(0..<options.count, id: \.self) { index in
                    Toggle(options[index], isOn: Binding(
                        get: {
                            selectedCalorieTypeIndex == index
                        },
                        set: { isSelected in
                            if isSelected {
                                selectedCalorieTypeIndex = index
                            }
                        }
                    ))
                }
                }
            }
            
            Button(action: addItem) {
                HStack {
                    Text("EKLE")
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin)
                .disabled(!isFoodAddedEnabled))
            .foregroundColor(.white)
            .padding()
            .background(isFoodAddedEnabled ? Color.orange : Color.gray)
            .cornerRadius(10)
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
