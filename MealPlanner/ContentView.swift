
import SwiftUI


// control + i ye basarak kodu hizala

struct ContentView: View {
    @State private var foodName: String = ""
    @State private var calorieType = 0
    @State private var options = ["Az Kalorili" , "Orta Kalorili" , "Çok kalorili"]
    private var currentDate = Date()
    @EnvironmentObject private var dataModel: DataModel
    @State private var showingAlert = false
//    @State private var timerBool: Bool = false
//    @State private var timeInterval: TimeInterval = 15
    
//    public func foodTimer(){
//        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
//            //            print("Yarım saat geçti, elemanı kontrol et.")
//            timerBool = true;
//            //            print(timerBool)
//            let delay = 1
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(delay)) {
//                timerBool = false
//                //                print(timerBool)
//
//            }
//
//        }
//        RunLoop.current.add(timer, forMode: .common)
//
//    }
//
    func addItem(){
        if !foodName.isEmpty {
            showingAlert = false
            let trimmedString = foodName.trimmingCharacters(in: .whitespaces)
            let food = Food(foodName: trimmedString, caloryType: calorieType,time: currentDate)
            dataModel.foodList.append(food)
            calorieType = 0
            foodName = ""
//            foodTimer()
            
            
        }else {
            showingAlert = true
        }
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 60){
            Spacer()
            VStack(alignment: .leading, spacing:7) {
                Section(header: Text("Yemek Adı")){
                    TextField("Kuru Fasülye", text:
                                $foodName).padding(10).overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.red, style:StrokeStyle(lineWidth: 0.6)))
                    
                    
                }
            }
            VStack(alignment: .leading, spacing: 7){
                
                Section(header: Text("Kalori Seviyesi Seçiniz")
                    .font(.caption)){
                        Picker(selection: $calorieType,label: Text("")){
                            ForEach(0 ..< options.count){
                                Text(self.options[$0])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Eksik Bilgi"), message: Text("Yemek Adını Girmediniz!"), dismissButton: .default(Text("Geri Dön!")))
            }
            
            Spacer()
            Button("EKLE" , action: addItem).frame(maxWidth: .infinity)
            
        }
        .padding()
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
