//
//  StartSession.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//


import SwiftUI
import SwiftData

struct StartSession: View {
//@State private var isSessionStarted: Bool = false // Track if session started

@State private var TextInbut = ""
@State private var TextInbut2 = ""

//    @State public var stepOneChoice: Int
//    @State public var stepTwoChoice: Int

@State private var conditionMetOneChoice = false
@State private var conditionMetTwoChoice = false

@State private var selectedButtonIndex: Int?
@State private var selectedButtonIndex1: Int?


@State private var isPressed1 = false
@State private var isPressed2 = false
@State private var isPressed3 = false
@State private var isPressed4 = false

// // // // // //

@Environment(\.modelContext) private var context
@Query private var items: [DataItem] // Query to fetch all items

@State private var sessionName: String = ""
@State private var isSessionStarted: Bool = false // Track if session started
@State private var navigateToSummary: Bool = false // Track if navigation to SummaryListView is triggered
@State var promtSelection: Int
@State var generaterSelection: Int

var body: some View {
    NavigationView{
        VStack{
            ZStack{
                Color.gray1
                    .ignoresSafeArea()
                
                ZStack{
                    Image("backgrund")
                        .resizable()
                        .frame(width: 399, height: 150)
                        .ignoresSafeArea()
                    Text("Start Session")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .offset(x: -80, y: 20)
                    
                }   .padding(.bottom,700)
                VStack{
                    Text("Enter session name")
                        .font(.callout)
                        .padding(.trailing , 180)
                    
                    TextField("Enter session name", text: $sessionName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 332)
                        .cornerRadius(10)
                        .font(.system(size: 27))
                        .padding(.bottom , 40)
                        .onSubmit {
                            print(TextInbut)
                        }
                    Text("Enter session type")
                        .font(.callout)
                        .padding(.trailing , 180)
                    
                    TextField("", text: $TextInbut2)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 332)
                        .cornerRadius(10)
                        .font(.system(size: 27))
                        .padding(.bottom , 40)
                        .onSubmit {
                            print(TextInbut2)
                        }
                    // هذي لازم تنشال بعدين ضفتها للاختصار فقط مفروض تكون مع النافقيشن حق زر ال start الي تحت !!!!!!!!!!!!
//                        Button("Start session") {
//                            addItem(sessionName: sessionName)
//                            sessionName = ""
//                        }
//                        .disabled(sessionName.isEmpty)
//
                    HStack {
                        Text("Step 1")
                            .font(.callout)
                            .fontWeight(.bold) // Make "Step One Idea list prompts :" bold
                        Text("Idea list prompts :")
                            .font(.callout)
                    }
                    .frame(width: 500)
                    .padding(.trailing, 130)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    HStack{
                        
                        
                        Button(action: {
                            
                            promtSelection = 1
                            selectedButtonIndex = 0
                            
                        }, label: {
                            
             
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 160,height: 51)
                                .foregroundColor(selectedButtonIndex == 0 ? Color.orange2 : Color.white).overlay(
                                    Text(" Random words")
                                        .font(.caption)
                                        .foregroundStyle(Color.black
                                                        )
                                )
                            
                            
                        }   )
                        
                        ///
                        
                        Button(action: {
                            
                            promtSelection = 2
                            selectedButtonIndex = 1
                            
                        }, label: {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 160,height: 51)
                                .foregroundColor(selectedButtonIndex == 1 ? Color.orange2 : Color.white)
                                .overlay(
                                    Text(" answer the question")
                                        .font(.caption)
                                        .foregroundStyle(Color.black
                                                        ))
                        })
                    }
                    
                    
                    
                    
                    HStack {
                        Text("Step 2 ")
                            .font(.callout)
                            .fontWeight(.bold) // Make "Step 2" bold
                        
                        Text("Brainstorming list :") // The rest of the text remains regular
                            .font(.callout)
                    }.frame(width: 500)
                        .padding(.trailing ,120)
                        .padding(.top ,20)
                        .padding(.bottom ,10)
                    
                    HStack{
                        
                        Button(action: {
                            
                            generaterSelection = 1
                            selectedButtonIndex1 = 0
                        }, label: {
                            
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 160,height: 51)
                                .foregroundColor(selectedButtonIndex1 == 0 ? Color.orange2 : Color.white)
                                .overlay(
                                    Text("Crazy 8")
                                        .font(.caption)
                                        .foregroundStyle(Color.black
                                                        ))
                        })
                        
                        
                        
                        Button(action: {
                            
                            generaterSelection = 2
                            selectedButtonIndex1 = 1
                            
                        }, label: {
                            
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 160,height: 51)
                                .foregroundColor(selectedButtonIndex1 == 1 ? Color.orange2 : Color.white)
                                .overlay(
                                    Text("reverse brainstorming")
                                        .font(.caption)
                                        .foregroundStyle(Color.black)
                                    
                                )
                        })
                        
                    } //.padding()
                }
                
                VStack{
                    if promtSelection == 1{
                        NavigationLink(destination: session_RandomWords(items: items, sessionName: sessionName, generaterSelection:$generaterSelection), isActive: $isSessionStarted) {
                                   EmptyView() // Empty view to trigger navigation
                              }
                    }
                    else{
                        NavigationLink(destination: session_AnsQuestions(items: items, sessionName: sessionName, generaterSelection:$generaterSelection), isActive: $isSessionStarted) {
                                   EmptyView() // Empty view to trigger navigation
                              }
                    }
                      
                    Button("Save") {
                        startSession()
                        // Check the session name right after it's supposed to be set
                        print("Session Name on Save: \(sessionName)")
                    }

                    .disabled(sessionName.isEmpty)
                    
                    
                }.padding(.top,650)
                
                
                // }
                // }
                
                
                
                
            }
            
        }
        
        
        
    }
}

func addItem(sessionName: String) {
    let item = DataItem(name: sessionName)
    context.insert(item)
}


func startSession() {
print("Starting session with name: \(sessionName)")
addItem(sessionName: sessionName)
isSessionStarted = true
}

}



//
//#Preview {
//    StartSession()
//}
