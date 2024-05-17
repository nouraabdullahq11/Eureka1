//
//  SummaryListView.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//

//
//  SummaryListView.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//

import SwiftUI
struct DetailsView: View {
var item: DataItem

var body: some View {
    NavigationView{
        VStack {
            Text(item.name)
                .font(.title)
            ForEach(item.problemStatements, id: \.self) { statement in
                Text(statement)
            }
            // Add more details about the item here
        }
        .navigationBarTitle("Details", displayMode: .inline)
    }
}
}

struct SummaryListView: View {
var items: [DataItem]
@Environment(\.modelContext) private var context

var body: some View {
    NavigationView {
        List {
            ForEach(reversedItems()) { item in
                NavigationLink(destination: DetailsView(item: item)) {
                    Text(item.name)
                }
            }.onDelete { indexes in
                for index in indexes {
                    deleteItem(items[index])
                }
            }
        }
        .navigationBarTitle("Sessions")
    }
}

func deleteItem(_ item: DataItem) {
    context.delete(item)
}

// Function to return items array with the last added session at the top
private func reversedItems() -> [DataItem] {
    var reversed = items
    reversed.reverse() // Reverse the array to have the last added session at the top
    return reversed
}
}
struct Session_Summary: View {
var texts: [String]
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []

var selectedWord: String?
var enteredValue: String

    

var body: some View {
NavigationStack{
    ScrollView{(
        ZStack{
            Color.gray1
                .ignoresSafeArea()
            VStack{
                ZStack{
                    Image("backgrund")
                        .resizable()
                        .frame(width: 395 , height: 150)
                    
                    Text("Activity Summery")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.trailing , 100)
                    //  .padding(.bottom,600)
                }.offset(x:0,y: -100)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .frame(width: 351,height: 132)
                    HStack{
                        
                        Image(systemName: "lightbulb.min")
                            .resizable()
                            .frame(width: 41 , height: 53)
                            .foregroundColor(.orange1)
                        VStack{
                            Text(" Research time :")
                                .bold()
                                .font(.title3)
                            Text(" By exploring, researching, and iterating, you're paving the way for success. Dive deeper into your big idea and you're on the path to something remarkable!")
                                .font(.caption)
                                .padding(.horizontal)
                        }
                    } .padding(.horizontal)
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .frame(width: 361,height: 132)
                    HStack{
                        Image(systemName: "doc.text")
                            .resizable()
                            .frame(width: 41 , height: 53)
                            .foregroundColor(.orange1)
                        
                        VStack{
                            Text("Answers :")
                                .font(.title)
                                .bold()
                                .padding()
                            
                            VStack {
                                ForEach(0..<min(texts.count, 3)) { index in
                                    Text(texts[index])
                            .foregroundColor(.orange1)
                                }
                                
                                if showAllTexts {
                                    ForEach(additionalTexts.indices, id: \.self) { index in
                                        Text(additionalTexts[index])
                            .foregroundColor(.orange1)
                                    }
                                }
                            }
                            .padding()
                        }
                        if texts.count > 3 {
                            Button(action: {
                                showAllTexts.toggle()
                                if showAllTexts {
                                    additionalTexts = Array(texts.dropFirst(3))
                                } else {
                                    additionalTexts.removeAll()
                                }
                            }) {
                                Text(showAllTexts ? "See Less" : "See all answer")
                                    .font(.caption)
                                    .underline(true , color: .orange1)
                                    .foregroundColor(.orange1)
                            }  .padding()
                        }
                        
                        
                        
                        Spacer()
                        
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .frame(width: 361,height: 200)
                    HStack{
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 41 , height: 53)
                            .foregroundColor(.orange1)
                        VStack{
                            Text("Fantastic work on sparking your big idea! Are you ready to dive even deeper and expand your creative horizons? ")
                                .font(.callout)
                                .bold()
                            Text("Let's keep the momentum going try the other technique, it will enhance your ability to think outside the box and refine your concepts.")
                                .font(.caption)
                        }
                    }
                }
                
                NavigationLink(destination: HomePage()){
                    
                    ZStack{
                        Rectangle()
                            .frame(width: 337 , height: 39)
                            .cornerRadius(5)
                            .foregroundColor(.laitOrange)
                        Text("done")
                            .foregroundColor(.white)
                    } .padding()
                }
               
            }
      
            }
  
   )}
}
}

}
//
//struct trials_Summary: View {
//var texts: [String]
//@State private var showAllTexts = false
//@State private var additionalTexts: [String] = []
//
//    var selectedWord: String?
//    var enteredValue: String
//
//
//
//var body: some View {
//    NavigationStack{
//        ScrollView{(
//            ZStack{
//                Color.gray1
//                    .ignoresSafeArea()
//                VStack{
//                    ZStack{
//                        Image("backgrund")
//                            .resizable()
//                            .frame(width: 395 , height: 150)
//
//                        Text("Activity Summery")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(.white)
//                            .padding(.trailing , 100)
//                        //  .padding(.bottom,600)
//                    }.offset(x:0,y: -100)
//
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(.white)
//                            .shadow(radius: 3)
//                            .frame(width: 351,height: 132)
//                        HStack{
//
//                            Image(systemName: "lightbulb.min")
//                                .resizable()
//                                .frame(width: 41 , height: 53)
//                                .foregroundColor(.orange1)
//                            VStack{
//                                Text(" Research time :")
//                                    .bold()
//                                    .font(.title3)
//                                Text(" By exploring, researching, and iterating, you're paving the way for success. Dive deeper into your big idea and you're on the path to something remarkable!")
//                                    .font(.caption)
//                                    .padding(.horizontal)
//                            }
//                        } .padding(.horizontal)
//                    }
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(.white)
//                            .shadow(radius: 3)
//                            .frame(width: 361,height: 132)
//                        HStack{
//                            Image(systemName: "doc.text")
//                                .resizable()
//                                .frame(width: 41 , height: 53)
//                                .foregroundColor(.orange1)
//
//                            VStack{
//                                Text("Answers :")
//                                    .font(.title)
//                                    .bold()
//                                    .padding()
//
//                                VStack {
//                                    ForEach(0..<min(texts.count, 3)) { index in
//                                        Text(texts[index])
//                                .foregroundColor(.orange1)
//                                    }
//
//                                    if showAllTexts {
//                                        ForEach(additionalTexts.indices, id: \.self) { index in
//                                            Text(additionalTexts[index])
//                                .foregroundColor(.orange1)
//                                        }
//                                    }
//                                }
//                                .padding()
//                            }
//                            if texts.count > 3 {
//                                Button(action: {
//                                    showAllTexts.toggle()
//                                    if showAllTexts {
//                                        additionalTexts = Array(texts.dropFirst(3))
//                                    } else {
//                                        additionalTexts.removeAll()
//                                    }
//                                }) {
//                                    Text(showAllTexts ? "See Less" : "See all answer")
//                                        .font(.caption)
//                                        .underline(true , color: .orange1)
//                                        .foregroundColor(.orange1)
//                                }  .padding()
//                            }
//
//
//
//                            Spacer()
//
//                        }
//                    }
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(.white)
//                            .shadow(radius: 3)
//                            .frame(width: 361,height: 200)
//                        HStack{
//                            Image(systemName: "checkmark.circle")
//                                .resizable()
//                                .frame(width: 41 , height: 53)
//                                .foregroundColor(.orange1)
//                            VStack{
//                                Text("Through your experience, you have come to big idea :")
//                                    .font(.callout)
//                                    .bold()
//                                Text("Let's keep the momentum going try the other technique, it will enhance your ability to think outside the box and refine your concepts.")
//                                    .font(.caption)
//                            }
//                        }
//                    }
//
//                    NavigationLink(destination: HomePage()){
//
//                        ZStack{
//                            Rectangle()
//                                .frame(width: 337 , height: 39)
//                                .cornerRadius(5)
//                                .foregroundColor(.laitOrange)
//                            Text("done")
//                                .foregroundColor(.white)
//                        } .padding()
//                    }
//
//                }
//
//                }
//
//       )}
//    }
//}
//}


struct trials_Summary1: View {
var selectedWord: String?
var enteredValue: String


var texts: [String]
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []


var body: some View {
VStack {
    Text("Summary view")
        .font(.system(size: 24, weight: .bold))
        .padding(.bottom, 20)
    
    if let selectedWord = selectedWord {
        Text("Selected Word: \(selectedWord)")
            .font(.system(size: 18))
            .padding(.bottom, 10)
    }
    
    Text("Entered Value: \(enteredValue)")
        .font(.system(size: 18))
        .padding(.bottom, 10)
    
    Spacer()
}
.padding()
}
}
struct Summary: View {
var selectedWord: String?
var enteredValue: String
var texts: [String]
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []

@EnvironmentObject var dataManager: DataManager
var userInputs: [String]
var checkedInput: String
var displayedQuestion: String


var body: some View {
    NavigationStack{
        ScrollView{(
            ZStack{
                Color.gray1
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Image("backgrund")
                            .resizable()
                            .frame(width: 395 , height: 150)
                        
                        // .padding(.bottom,630)
                        Text("Activity Summery")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.trailing , 100)
                        //  .padding(.bottom,600)
                    }.offset(x:0,y: -100)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .frame(width: 351,height: 132)
                        HStack{
                            
                            Image(systemName: "lightbulb.min")
                                .resizable()
                                .frame(width: 41 , height: 53)
                                .foregroundColor(.orange1)
                            VStack{
                                Text(" Research time :")
                                    .bold()
                                    .font(.title3)
                                Text(" By exploring, researching, and iterating, you're paving the way for success. Dive deeper into your big idea and you're on the path to something remarkable!")
                                    .font(.caption)
                                    .padding(.horizontal)
                            }
                        } .padding(.horizontal)
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .frame(width: 361,height: 132)
                        HStack{
                            Image(systemName: "doc.text")
                                .resizable()
                                .frame(width: 41 , height: 53)
                                .foregroundColor(.orange1)
                            
                            VStack{
                                Text("Answers :")
                                    .font(.title)
                                    .bold()
                                    .padding()
                                
                                VStack {
                                    ForEach(0..<min(texts.count, 3)) { index in
                                        Text(texts[index])
                                .foregroundColor(.orange1)
                                    }
                                    
                                    if showAllTexts {
                                        ForEach(additionalTexts.indices, id: \.self) { index in
                                            Text(additionalTexts[index])
                                .foregroundColor(.orange1)
                                        }
                                    }
                                }
                                .padding()
                            }
                            if texts.count > 3 {
                                Button(action: {
                                    showAllTexts.toggle()
                                    if showAllTexts {
                                        additionalTexts = Array(texts.dropFirst(3))
                                    } else {
                                        additionalTexts.removeAll()
                                    }
                                }) {
                                    Text(showAllTexts ? "See Less" : "See all answer")
                                        .font(.caption)
                                        .underline(true , color: .orange1)
                                        .foregroundColor(.orange1)
                                }  .padding()
                            }
                            
                            
                            
                            Spacer()
                            
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                            .frame(width: 361,height: 200)
                        HStack{
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width: 41 , height: 53)
                                .foregroundColor(.orange1)
                            VStack{
                                Text("Fantastic work on sparking your big idea! Are you ready to dive even deeper and expand your creative horizons? ")
                                    .font(.callout)
                                    .bold()
                                Text("Let's keep the momentum going try the other technique, it will enhance your ability to think outside the box and refine your concepts.")
                                    .font(.caption)
                            }
                        }
                    }
                    
                    NavigationLink(destination: HomePage()){
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 337 , height: 39)
                                .cornerRadius(5)
                                .foregroundColor(.laitOrange)
                            Text("done")
                                .foregroundColor(.white)
                        } .padding()
                    }
                   
                }
          
                }
      
       )}
    }
}
//var body: some View {
//    VStack {
//        Text("Summary view")
//            .font(.system(size: 24, weight: .bold))
//            .padding(.bottom, 20)
//
//        if let selectedWord = selectedWord {
//            Text("Selected Word: \(selectedWord)")
//                .font(.system(size: 18))
//                .padding(.bottom, 10)
//        }
//
//        Text("Entered Value: \(enteredValue)")
//            .font(.system(size: 18))
//            .padding(.bottom, 10)
//
//        Spacer()
//    }
//    .padding()
//}
}
