import SwiftUI

struct ToastView: View {
    var message: String
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "hand.thumbsup")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 10)
                
                Text(message)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(20)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView: View {
    @State private var foodName: String = ""
    @State private var selectedCalorieTypeIndex: Int? = 0
    private var currentDate = Date()
    @EnvironmentObject private var dataModel: DataModel
    @FocusState private var isFocusedFoodName: Bool
    private var options = ["Az Kalorili", "Orta Kalorili", "Çok Kalorili"]
    @State private var showToastMessage = false
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    var isFoodAddedEnabled: Bool {
        return !foodName.isEmpty
    }
    
    
    func confirmCalories(){
        
    }
    func rejectCalories(){
        
    }
    
    func addItem() {
        if isFoodAddedEnabled {
            let trimmedString = foodName.trimmingCharacters(in: .whitespaces)
            let food = Food(foodName: trimmedString, caloryType: selectedCalorieTypeIndex ?? 0, time: currentDate)
            dataModel.foodList.append(food)
            selectedCalorieTypeIndex = 0
            foodName = ""
            showToastMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToastMessage = false
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 30) {
                if let firstItem = dataModel.loginMyArray.first {
                    HStack {
                        
                        Text("Hoşgeldin " + firstItem)
                            .font(.system(size: 25))
                        
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    TextField("Yemek adı", text: $foodName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isFocusedFoodName ? Color.orange : Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        )
                        .focused($isFocusedFoodName)
                }
                
                
                
                
                
                Button("Kalori Seçiniz") {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    VStack {
                        VStack {
                            Divider()
                                .frame(height: 3)
                                .frame(width: 110)
                                .background(Color.gray)
                                .cornerRadius(5)
                            
                            Text("Kalori Seçiniz")
                                        .font(.system(size: 18, weight: .heavy, design: .default))

                        }
                        
                        ForEach(0..<options.count, id: \.self) { index in
                            Toggle(options[index], isOn: Binding(
                                get: {
                                    selectedCalorieTypeIndex == index
                                },
                                set: { isSelected in
                                    if isSelected {
                                        selectedCalorieTypeIndex = index
                                        isFocusedFoodName=false
                                    }
                                }
                            ))
                        }
                        Divider()
                        HStack{
                            
                            Button(action: rejectCalories) {
                                HStack {
                                    Text("Vazgeç")
                                    
                                    
                                }   .frame(maxWidth: .infinity, alignment: .center)
                                    .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin)
                                        .disabled(!isFoodAddedEnabled))
                                    .foregroundColor(.orange)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.orange, lineWidth: 1))
                                
                                
                                Spacer()
                            }
                            Button(action: confirmCalories) {
                                HStack {
                                    Text("Onayla")
                                    
                                }   .frame(maxWidth: .infinity, alignment: .center)
                                    .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin)
                                        .disabled(!isFoodAddedEnabled))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                
                            }
                            
                        }
                        
                        
                    }
                    .padding()
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }
                    .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                        sheetHeight = newHeight
                    }
                    .presentationDetents([.height(sheetHeight)])
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
            
            if showToastMessage {
                ToastView(message: "Yemek başarıyla eklendi!")
                    .onDisappear {
                        showToastMessage = false
                    }
            }
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
