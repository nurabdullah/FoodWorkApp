import SwiftUI

struct ToastContentView: View {
    var message: String
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "hand.thumbsup")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                    .padding(.bottom, 10)
                
                Text(message)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(20)
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.4))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView: View {
    @State private var foodName: String = ""
    @State private var selectedCalorieTypeIndex: Int? = nil
    private var options = ["Az Kalorili", "Orta Kalorili", "Çok Kalorili"]
    private var currentDate = Date()
    @EnvironmentObject private var dataModel: DataModel
    @FocusState private var isFocusedFoodName: Bool
    @State private var showToastMessage = false
    @State private var showSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    var isAddFoodButtonDisabled: Bool {
        return !(!foodName.isEmpty && selectedCalorieTypeIndex != nil)
    }
    
    func rejectCalories() {
        selectedCalorieTypeIndex = nil
        showSheet = false
    }
    
    func addFood() {
            isFocusedFoodName = false
            let trimmedString = foodName.trimmingCharacters(in: .whitespaces)
            let food = Food(foodName: trimmedString, caloryType: selectedCalorieTypeIndex ?? 0, time: currentDate)
            dataModel.foodList.append(food)
            selectedCalorieTypeIndex = nil
            foodName = ""
            showToastMessage = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showToastMessage = false
            }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 30) {
                
                //  TO-DO
                //  firstItem: global bir deger olacak. kullanici dataModel'de duracak.
                let firstItem = "Ahmet"
                if !firstItem.isEmpty {
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
                
                Button(action: {
                    showSheet = true
                    isFocusedFoodName = false

                }) {
                    HStack {
                        Text("Kalori Seçiniz")
                        Spacer()
                        if let selectedCalorieIndex = selectedCalorieTypeIndex {
                            Text(options[selectedCalorieIndex])
                        } else {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .foregroundColor(Color.gray)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    
                    
                }
                .sheet(isPresented: $showSheet) {
                    VStack {
                        VStack(spacing: 16) {
                            Divider()
                                .frame(height: 5)
                                .frame(width: 110)
                                .background(Color.gray)
                                .cornerRadius(5)
                            
                            Text("Kalori Seçiniz")
                                .font(.system(size: 18, weight: .heavy, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        ForEach(0..<options.count, id: \.self) { index in
                                  HStack {
                                      Rectangle()
                                          .frame(width: 4, height: 20)
                                          .foregroundColor(index == 0 ? .green : (index == 1 ? .blue : .red))
                                      
                                      Toggle(options[index], isOn: Binding(
                                          get: {
                                    selectedCalorieTypeIndex == index
                                },
                                set: { isSelected in
                                    selectedCalorieTypeIndex = isSelected ? index : nil
                                    isFocusedFoodName = false
                                }
                            ))
                        }
                    }
                        Divider()
                            .padding(1)
                        
                        HStack {
                            Button(action: rejectCalories) {
                                HStack {
                                    Text("Vazgeç")
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin)
                                    .disabled(isAddFoodButtonDisabled))
                                .foregroundColor(.orange)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.orange, lineWidth: 1)
                                )
                                Spacer()
                            }
                            Button(action: {showSheet = false}) {
                                HStack {
                                    Text("Onayla")
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin)
                                    .disabled(isAddFoodButtonDisabled))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                            }
                        }
                        .padding(.top, 5)
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
                
                Button(action: addFood) {
                    HStack {
                        Text("EKLE")
                            .foregroundColor(.white)
                    }
                
                .frame(maxWidth: .infinity, alignment: .center)
                    .background(NavigationLink("", destination: ContentView(), isActive: $dataModel.isLogin))
                    .foregroundColor(.white)
                    .padding()
                    .background(!isAddFoodButtonDisabled ? Color.orange : Color.gray)
                    .cornerRadius(10)
                }
                .disabled(isAddFoodButtonDisabled)
                Spacer()
            }
            .padding()
            
            if showToastMessage {
                ToastContentView(message: "Yemek başarıyla eklendi!")
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
