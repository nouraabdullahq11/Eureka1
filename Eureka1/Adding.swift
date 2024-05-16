//
//  Adding.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//
//
//  NewWordView.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//

import SwiftUI


struct NewWordView: View {
@EnvironmentObject var dataManager: DataManager
@State private var newWord = ""
var body: some View {
    VStack{
        TextField("Word", text: $newWord)
        
        Button{
            dataManager.addWord(wordText: newWord)
        }label: {
            Text("Save")
        }
    }
    .padding()
}
}

#Preview {
NewWordView()
}



struct NewQuestionView: View {
@EnvironmentObject var dataManager: DataManager
@State private var newQuestion = ""
var body: some View {
    VStack{
        TextField("Question", text: $newQuestion)
        
        Button{
            dataManager.addQuestion(questionText: newQuestion)
        }label: {
            Text("Save")
        }
    }
    .padding()
}
}

#Preview {
NewQuestionView()
}
