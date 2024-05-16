//
//  Sheets.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//

//
//  Sheets.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//


// // // // // All The Sheets // // // //


import SwiftUI

// // // // // Qrazy8 // // // //

struct sheetsCrazy8: View {

@Binding var isSheetPresented4: Bool
@Binding var destinationViewIsActive4: Bool


var body: some View {
    NavigationView{
    VStack{
        Text("Welcome to Answer the Question Technique 👋 ")
            .font(.title2)
            .bold()
            .frame(width: 350 , height: 80)
            .padding(.trailing, 5)
            .padding(.top, 30)
        
        Text("It’s a straightforward approach used in problem-solving and learning contexts.This method involves directly addressing specific questions that arise during brainstorming, research, or educational activities to generate relevant information or solutions.  ")
            .padding(.horizontal, 20.6)
            .font(.system(size: 14))
            .frame(height: 110)
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .padding(.bottom, 20)
        
        
        
        
        Text("How Answer the question works ?")
            .font(.system(size: 16))
            .fontWeight(.medium)
            .padding(.trailing,95)
            .padding(.bottom, 20)
        
        
        Text("Answer the provided question within 3 minutes, or feel free to substitute it with another. Complete all three answer boxes, and mark the one you find most appealing.")
            .font(.system(size: 14))
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .frame(width: 350 , height: 67 )
            .padding(.leading, 3)
        
        
        Button(action: {
           destinationViewIsActive4 = true
            isSheetPresented4  = false
        }) {
            Rectangle()
                .frame(width: 337 , height: 39)
                .cornerRadius(5)
                .foregroundColor(.laitOrange)
                .overlay(
                    Text("Try")
                        .foregroundColor(.white)
                )
        }
        .padding(.top, 30)
        
    }
    
}
}
}


// // // // // Answer The Quesions // // // //


struct SheetQuestion: View {

@Binding var isSheetPresented2: Bool
@Binding var destinationViewIsActive2: Bool


var body: some View {
    NavigationView{
    VStack{
        Text("Welcome to Answer the Question Technique 👋 ")
            .font(.title2)
            .bold()
            .frame(width: 350 , height: 80)
            .padding(.trailing, 5)
            .padding(.top, 30)
        
        Text("It’s a straightforward approach used in problem-solving and learning contexts.This method involves directly addressing specific questions that arise during brainstorming, research, or educational activities to generate relevant information or solutions.  ")
            .padding(.horizontal, 20.6)
            .font(.system(size: 14))
            .frame(height: 110)
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .padding(.bottom, 20)
        
        
        
        
        Text("How Answer the question works ?")
            .font(.system(size: 16))
            .fontWeight(.medium)
            .padding(.trailing,95)
            .padding(.bottom, 20)
        
        
        Text("Answer the provided question within 3 minutes, or feel free to substitute it with another. Complete all three answer boxes, and mark the one you find most appealing.")
            .font(.system(size: 14))
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .frame(width: 350 , height: 67 )
            .padding(.leading, 3)
        
        
        Button(action: {
           destinationViewIsActive2 = true
            isSheetPresented2  = false
        }) {
            Rectangle()
                .frame(width: 337 , height: 39)
                .cornerRadius(5)
                .foregroundColor(.laitOrange)
                .overlay(
                    Text("Try")
                        .foregroundColor(.white)
                )
        }
        .padding(.top, 30)
        
    }
    
}
}
}

#Preview {
SheetQuestion(isSheetPresented2: .constant(true), destinationViewIsActive2: .constant(false))
}


// // // // // Random Words // // // //



struct SheetRandomWords: View {

@Binding var isSheetPresented: Bool
@Binding var destinationViewIsActive: Bool

var body: some View {
 NavigationView{
        VStack{
            Text("Welcome to Random Words Technique 👋  ")
                .font(.title2)
                .bold()
                .frame(width: 300 , height: 100)
                .padding(.trailing, 70)
            
            
            Text("Our Random words template can help you generate ideas and solutions outside the box ")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundColor(.gray)
                .frame(width: 355 ,height: 34)
                .padding(.trailing, 13)
                .padding(.bottom, 25)
            
            
            
            Text("How Random Words works ?")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
                .padding(.trailing,152)
                .padding(.bottom, 20)
            
            Text("Within 3 minutes, you must choose 3 words from the generator by clicking on themThen click on Next and come up with new ideas and possible solutions around the three words that were chosen.")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .frame(width: 350 )
                .foregroundColor(.gray)
                .padding(.trailing, 10)
            

            Button(action: {
               destinationViewIsActive = true
                isSheetPresented  = false

                
            }) {
                Rectangle()
                    .frame(width: 337 , height: 39)
                    .cornerRadius(5)
                    .foregroundColor(.laitOrange)
                    .overlay(
                        Text("Try")
                            .foregroundColor(.white)
                    )
            }
            .padding(.top, 100)

            
            
        }

    }
}
}


// // // // // Brain Storming // // // //


import SwiftUI

struct SheetBrainstorming: View {

@Binding var isSheetPresented3: Bool
@Binding var destinationViewIsActive3: Bool

var body: some View {
    NavigationStack{
        VStack{
            Text("Welcome to Reverse Brainstorming Technique  👋  ")
                .font(.title2)
                .bold()
                .frame(width: 300 , height: 70)
                .padding(.trailing, 70)
            
            Text("Reverse brainstorming is a creative problem-solving technique that flips the traditional brainstorming approach by focusing on the negatives instead of the positives. It encourages participants to think about how a problem could be caused or worsened, rather than how it can be solved.")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundColor(.gray)
                .frame(width: 355 ,height: 100.6)
                .padding(.trailing, 13)
                .padding(.bottom, 10)
            
            
            Text("How Reverse brainstorming works ?")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
                .padding(.trailing,90)

            VStack{
                Text("1. Identify the problem. \n2. Consider ways to exacerbate the problem instead of solving it.\n3. Transform negative ideas into potential solutions.\n4.Evaluate these solutions for viability and impact, and refine the most promising ones into actionable strategies. ")
                    .font(.system(size: 14))
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }.frame(width: 350 , height: 120 )
             
            
            Button(action: {
               destinationViewIsActive3 = true
                isSheetPresented3  = false
            }) {
                Rectangle()
                    .frame(width: 337 , height: 39)
                    .cornerRadius(5)
                    .foregroundColor(.laitOrange)
                    .overlay(
                        Text("Try")
                            .foregroundColor(.white)
                    )
            }

            }.padding(.top, 50)

        }
    }
}






// // // // // Previews // // // //

#Preview {
SheetBrainstorming(isSheetPresented3: .constant(true), destinationViewIsActive3: .constant(false))
}


//
//#Preview {
//    sheetsCrazy8()
//}

//
//#Preview {
//    SheetsQuestion()
//}
//
//
//#Preview {
//    SheetsBrainstorming()
//}
//
//
//#Preview {
//    SheetsRandomWords()
//}
