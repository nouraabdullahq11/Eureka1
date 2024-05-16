//
//  DataManager.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//

//
//  DataManager.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//


import SwiftUI
import Firebase

class DataManager: ObservableObject{
@Published var words: [Word] = []
@Published var questions: [Question] = []
@Published var summaries: [SummaryW] = []
@Published var summariesQ: [SummaryQ] = []

init() {
fetchWords()
fetchQuestions()
}

func saveSummary(summary: SummaryW) {
   summaries.append(summary)
}
func saveSummaryQ(summary: SummaryQ) {
   summariesQ.append(summary)
}

func fetchWords(){
words.removeAll()
let db = Firestore.firestore()
let ref = db.collection("Words")
ref.getDocuments{ snapshot, error in guard error == nil else {
    print(error!.localizedDescription)
    return
}
    
    if let snapshot = snapshot {
        for document in snapshot.documents{
            let data = document.data()
            
            let id = data["id"] as? String ?? ""
            let text = data["text"] as? String ?? ""
            
            let word = Word(id: id, text: text)
            self.words.append(word)
        }
    }
}
}

func fetchQuestions(){
questions.removeAll()
let db = Firestore.firestore()
let ref = db.collection("Questions")
ref.getDocuments{ snapshot, error in guard error == nil else {
    print(error!.localizedDescription)
    return
}
    
    if let snapshot = snapshot {
        for document in snapshot.documents{
            let data = document.data()
            
            let id = data["id"] as? String ?? ""
            let text = data["text"] as? String ?? ""
            
            let question = Question(id: id, text: text)
            self.questions.append(question)
        }
    }
}
}


func addWord(wordText: String){
let db = Firestore.firestore()

// Generate a random UUID
let randomID = UUID().uuidString

// Reference to the "Words" collection with the random ID
let ref = db.collection("Words").document(randomID)

// Set the data including the random ID
ref.setData(["text": wordText, "id": randomID]) { error in
    if let error = error {
        print(error.localizedDescription)
    } else {
        print("Word added successfully with ID: \(randomID)")
    }
}
}

func addQuestion(questionText: String){
let db = Firestore.firestore()

// Generate a random UUID
let randomID = UUID().uuidString

// Reference to the "Words" collection with the random ID
let ref = db.collection("Questions").document(randomID)

// Set the data including the random ID
ref.setData(["text": questionText, "id": randomID]) { error in
    if let error = error {
        print(error.localizedDescription)
    } else {
        print("Question added successfully with ID: \(randomID)")
    }
}
}

}


//
//#Preview {
//    DataManager()
//}
