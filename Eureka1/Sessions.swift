//
//  Sessions.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//

//
//  Sessions.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//


import SwiftUI
import CoreHaptics
import SwiftData

struct session_RandomWords: View {
    var items: [DataItem]
    var sessionName: String
    @Environment(\.modelContext) private var context
    @Binding var generaterSelection: Int
    
    @EnvironmentObject var dataManager: DataManager
    @State private var currentIndex = 0
    @State private var likedWords: [String] = []
    @State private var dragState = CGSize.zero
    @State private var likedWordBoxes: [String?] = Array(repeating: nil, count: 3)
    @State private var isTimerRunning = false
    @State private var timeRemaining = 6
    @State private var navigateToNextPage = false
    @Environment(\.colorScheme) var colorScheme
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea(.all)
                
                VStack {
                    Text("Random Word")
                        .font(.system(size: 33, weight: .semibold))
                        .padding(.bottom, 60)
                        .padding(.trailing, 130)
                    
                    Text(timerString)
                        .font(.system(size: 60, weight: .bold))
                        .padding(.bottom, 50)
                        .onReceive(timer) { _ in
                            if isTimerRunning {
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                } else {
                                    isTimerRunning = false
                                    // Timer completed actions here
                                }
                            }
                        }
                    
                    Text("Double-tap meaningful words or swipe to change.")
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                    
                    if !dataManager.words.isEmpty {
                        ZStack {
                            ForEach(dataManager.words.indices.reversed(), id: \.self) { index in
                                CardView(word: dataManager.words[index].text)
                                    .zIndex(currentIndex == index ? 1 : 0)
                                    .offset(x: index == currentIndex ? dragState.width : 0, y: index == currentIndex ? dragState.height : 0)
                                    .rotationEffect(.degrees(Double(dragState.width / 20)), anchor: .bottom)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                if index == currentIndex {
                                                    dragState = value.translation
                                                    startTimerIfNeeded()
                                                }
                                            }
                                            .onEnded { value in
                                                if index == currentIndex {
                                                    if value.translation.width < -100 {
                                                        currentIndex = getNextIndex()
                                                    } else if value.translation.width > 100 {
                                                        currentIndex = getPreviousIndex()
                                                    }
                                                    dragState = .zero
                                                }
                                            }
                                    )
                                    .animation(.spring(), value: dragState)
                                    .animation(.spring(), value: currentIndex)
                            } 
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white1) // Background color of the card
                                .shadow(color: colorScheme == .dark ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 2) // Add shadow
                                .frame(width: 300, height: 280)
                                .rotationEffect(.degrees(7))
                        }
                        .onTapGesture(count: 2) {
                            if likedWords.count < 3 {
                                let word = dataManager.words[currentIndex].text
                                if !likedWords.contains(word) {
                                    likedWords.append(word)
                                    updateLikedWordBoxes()
                                    currentIndex = getNextIndex()
                                }
                                startTimerIfNeeded()
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No words available").padding()
                    }
                    
                    HStack(spacing: 20) {
                        ForEach(0..<3) { index in
                            LikedWordBox1(word: likedWordBoxes[index] ?? "")
                        }
                    }
                    .padding(.top, 50)
                    
                    Button(action: {
                        navigateToNextPage = likedWords.count >= 3
                    }) {
                        Text("Next Step")
                            .font(.system(size: 18))
                            .padding()
                            .background(likedWords.count >= 3 ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .opacity(likedWords.count >= 3 ? 1.0 : 0.5)
                            .disabled(likedWords.count < 3)
                    }
                    .padding(.top, 30)
                }
            }.navigationBarBackButtonHidden(true)
            .background(
                NavigationLink(destination: session_RandomWords2(likedWords: likedWords, items: items, sessionName: sessionName, generaterSelection: $generaterSelection), isActive: $navigateToNextPage) {
                    EmptyView()
                }
                .hidden()
            )
        }.navigationBarBackButtonHidden(true)
    }
    
    var timerString: String {
        let minutes = timeRemaining / 6
        let seconds = timeRemaining % 6

        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func startTimerIfNeeded() {
        if !isTimerRunning {
            isTimerRunning = true
            timeRemaining = 6
        }
    }
    
    func getNextIndex() -> Int {
        let nextIndex = currentIndex + 1
        return nextIndex < dataManager.words.count ? nextIndex : 0
    }
    
    func getPreviousIndex() -> Int {
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? previousIndex : dataManager.words.count - 1
    }
    
    func updateLikedWordBoxes() {
        for (index, word) in likedWords.enumerated() {
            likedWordBoxes[index] = word
        }
    }
}

struct CardView: View {
    var word: String
        @Environment(\.colorScheme) var colorScheme
    var body: some View {
    Text(word)
        .font(.largeTitle)
        .frame(width: 300, height: 280)
        .background(Color.white1)
        .cornerRadius(10)
    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.02) : Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
    .foregroundColor(colorScheme == .dark ? .white : .black)

    //    .overlay(
    //        RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)
    //    )
    }}

struct LikedWordBox1: View {
    var word: String

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.orange, lineWidth: 2)
            .frame(width: 100, height: 50)
            .foregroundColor(.white)
            .overlay(
                Text(word)
                    .foregroundColor(.black)
            )
    }
}
struct session_RandomWords2: View {
    var likedWords: [String]
    @State private var enteredValues: [String]
    @State private var selectedWord: String?
    @State private var showCheckmarks: Bool = false
    @State private var showNextButton: Bool = false
    @State private var navigateToSummary: Bool = false
    @State private var isTimerRunning = false
    @State private var timeRemaining = 6

    var items: [DataItem]
    var sessionName: String
    @Environment(\.modelContext) private var context
    @Binding var generaterSelection: Int
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @EnvironmentObject var dataManager: DataManager

    init(likedWords: [String], items: [DataItem], sessionName: String, generaterSelection: Binding<Int>) {
        self.likedWords = likedWords
        self.items = items
        self.sessionName = sessionName
        self._generaterSelection = generaterSelection
        self._enteredValues = State(initialValue: Array(repeating: "", count: likedWords.count))
    }

    var isNextStepButtonEnabled: Bool {
        return enteredValues.allSatisfy { !$0.isEmpty }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea(.all)
                Spacer()
                ScrollView {
                    VStack {
                        Text("Random Word")
                            .font(.system(size: 33, weight: .semibold))
                            .padding(.top, 60)
                            .padding(.trailing, 130)

                        Text(timerString)
                            .font(.system(size: 60, weight: .bold))
                            .padding(.top, 20)
                            .onReceive(timer) { _ in
                                if isTimerRunning {
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    } else {
                                        isTimerRunning = false
                                    }
                                }
                            }

                        Text("Place these words into possible ideas or solutions:")
                            .font(.system(size: 20, weight: .semibold))

                        VStack {
                            ForEach(0..<likedWords.count, id: \.self) { index in
                                VStack {
                                    Text(likedWords[index])
                                        .font(.system(size: 18))
                                        .padding(.bottom, 10)
                                        .padding(.trailing, 220)
                                    TextField("Enter a value", text: $enteredValues[index])
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                            Button(action: {
                                showCheckmarks = true
                            }) {
                                Text("Next Step")
                                    .frame(width: 337, height: 39)
                                    .background(isNextStepButtonEnabled ? Color.orange : Color.gray)
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .font(.system(size: 20, weight: .bold))
                                    .opacity(isNextStepButtonEnabled ? 1.0 : 0.5)
                                    .disabled(!isNextStepButtonEnabled)
                            }
                        }
                        if showCheckmarks {
                            Text("Select a word")
                                .font(.system(size: 20, weight: .semibold))

                            ForEach(likedWords, id: \.self) { word in
                                HStack {
                                    Image(systemName: selectedWord == word ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            selectedWord = word
                                            showNextButton = true
                                        }

                                    Text(word)
                                        .font(.system(size: 18))
                                }
                            }

                            if showNextButton {
                                if generaterSelection == 1 {
                                    NavigationLink(
                                        destination: session_Crazy8(
                                            likedWords: likedWords, items: items,
                                            sessionName: sessionName,
                                            userInputs: enteredValues,
                                            displayedQuestion: dataManager.questions.first?.text ?? "", selectedWord: selectedWord ?? ""
                                        )
                                    ) {
                                        Text("Next to Crazy 8")
                                    }
                                } else {
                                    NavigationLink(
                                        destination: Session_ReverseBrainstorming(
                                            items: items,
                                            sessionName: sessionName,
                                            userInputs: enteredValues,
                                            displayedQuestion: dataManager.questions.first?.text ?? "", selectedWord: selectedWord ?? "",
                                            likedWords: likedWords
                                        )
                                    ) {
                                        Text("Next to Reverse Brainstorming")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
    }

    var timerString: String {
        let minutes = timeRemaining / 6
        let seconds = timeRemaining % 6

        return String(format: "%d:%02d", minutes, seconds)
    }

    func startTimerIfNeeded() {
        if !isTimerRunning {
            isTimerRunning = true
            timeRemaining = 6
        }
    }
}





// // // // // // // // /// // /// // / / /  / /// // /



// // // // // // // // /// // /// // / / /  / /// // /


struct session_AnsQuestions: View {
    var likedWords: [String]
    @State private var enteredValues: [String]
    @State private var selectedWord: String?
    @State private var showCheckmarks: Bool = false
    @State private var showNextButton: Bool = false
    @State private var navigateToSummary: Bool = false
    @State private var isTimerRunning = false
    @State private var timeRemaining = 6

    var items: [DataItem]
    var sessionName: String
    @Environment(\.modelContext) private var context
    @Binding var generaterSelection: Int
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @EnvironmentObject var dataManager: DataManager

    init(likedWords: [String], items: [DataItem], sessionName: String, generaterSelection: Binding<Int>) {
        self.likedWords = likedWords
        self.items = items
        self.sessionName = sessionName
        self._generaterSelection = generaterSelection
        self._enteredValues = State(initialValue: Array(repeating: "", count: likedWords.count))
    }

    var isNextStepButtonEnabled: Bool {
        return enteredValues.allSatisfy { !$0.isEmpty }
    }

    @State private var showPopup = false
    @State private var currentIndex = 0
    @State private var userInputs = ["", "", ""]
    @State private var checkedIndex: Int? = nil  // Optional Int to keep track of which checkbox is checked

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text(formattedTime(timeRemaining))
                        .font(.system(size: 60, weight: .bold))
                        .padding(.bottom, 20)

                    if !dataManager.questions.isEmpty {
                        Text(dataManager.questions[currentIndex].text)
                            .font(.largeTitle)
                            .padding(.bottom, 10)

                        Button("New Question >>") {
                            // Generate a new index and clear the text fields and checkbox
                            currentIndex = generateRandomIndex(excluding: currentIndex)
                            userInputs = ["", "", ""]
                            checkedIndex = nil
                        }
                        .padding(.bottom, 10)
                        .foregroundColor(.orange)

                        VStack {
                            ForEach(0..<3, id: \.self) { index in
                                HStack {
                                    if !userInputs[index].isEmpty {
                                        Image(systemName: checkedIndex == index ? "checkmark.square" : "square")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .onTapGesture {
                                                if checkedIndex == index {
                                                    checkedIndex = nil  // Uncheck if already checked
                                                } else {
                                                    checkedIndex = index  // Check new index
                                                }
                                            }
                                    }

                                    TextField("Type something...", text: $userInputs[index], onEditingChanged: { editing in
                                        if editing && !isTimerRunning {
                                            startTimer()
                                        }
                                    })
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                }
                            }
                        }.padding(.bottom, 80)

                        VStack {
                            Text("* check mark the one that resonates with you the most.")
                                .foregroundColor(.gray)
                                .frame(alignment: .center)

                            if generaterSelection == 1 {
                                NavigationLink(
                                    destination: session_Crazy8(
                                        likedWords: likedWords,
                                        items: items,
                                               sessionName: sessionName,
                                               userInputs: enteredValues,
                                               displayedQuestion: dataManager.questions.first?.text ?? "",
                                               selectedWord: checkedIndex != nil ? userInputs[checkedIndex!] : ""
                                           )
                                ) {
                                    Text("Next to Crazy 8")
                                }
                                .disabled(!isNextStepButtonEnabled || checkedIndex == nil)
                            } else {
                                NavigationLink(
                                    destination: Session_ReverseBrainstorming(
                                                    items: items,
                                                    sessionName: sessionName,
                                                    userInputs: enteredValues,
                                                    displayedQuestion: dataManager.questions.first?.text ?? "",
                                                    selectedWord: checkedIndex != nil ? userInputs[checkedIndex!] : "",
                                                    likedWords: likedWords
                                                )
                                            ){
                                    Text("Next to Reverse Brainstorming")
                                }
                                .disabled(!isNextStepButtonEnabled || checkedIndex == nil)
                            }
                        }

                    } else {
                        Text("No questions available")
                            .padding()
                    }
                }
                .navigationTitle("Questions")
                .navigationBarItems(trailing: Button(action: {
                    showPopup.toggle()
                }, label: {
                    Image(systemName: "plus")
                }))
                .sheet(isPresented: $showPopup) {
                    NewQuestionView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished, reset
                    isTimerRunning = false
                    timeRemaining = 180  // Reset timer for the next question
                }
            }
        }
        .environmentObject(DataManager())
    }

    func generateRandomIndex(excluding currentIndex: Int) -> Int {
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: 0..<dataManager.questions.count)
        } while newIndex == currentIndex && dataManager.questions.count > 1
        return newIndex
    }

    private func startTimer() {
        isTimerRunning = true
    }

    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct session_Crazy8: View
{
    var likedWords: [String]
@State private var isSummaryPresented = false

//@State private var text: String = ""
@State private var savedTexts: [String] = []
@State private var isShowingSavedTexts = false
@State private var timeRemaining = 1 * 6 // 8 minutes in seconds
@State private var timerActive = false
@State private var timerNotActive = false
@State private var hasStartedTimer = false // Tracks if the timer has started
@State private var vibrationTimer: Timer? // Timer for continuous vibration
//

let totalDuration = 1 * 6 // Total duration in seconds for progress calculation
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

//@Environment(\.managedObjectContext) private var viewContext
var items: [DataItem]
var sessionName: String  // This should hold the value across this view's lifecycle
@Environment(\.modelContext) private var context
var userInputs: [String]
//var checkedInput: String
var displayedQuestion: String
@State private var problemStatement: String = ""
@State private var navigatehome: Bool = false // Track if session started

// @Environment(\.presentationMode) var presentationMode // Environment to control the view presentation

@State private var text: String = ""
// @State private var savedTexts: [String] = []
    var selectedWord: String
var body: some View {
    NavigationView {
        ZStack {
            Color.gray1.ignoresSafeArea()
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.orange, style: StrokeStyle(lineWidth: 10, lineCap: .butt, dash: [5]))
                        .frame(width: 270, height: 270)
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.3)
                            .foregroundColor(Color.orange1)
                        Circle()
                            .trim(from: 0.0, to: CGFloat(1.0 - Double(timeRemaining) / Double(totalDuration)))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.orange)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear(duration: 1), value: timeRemaining)
                        Text("minutes")
                            .foregroundColor(.gray)
                            .padding(.top,70)
                        Text("\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))")
                            .font(.largeTitle)
                            .bold()
                    }
                    .frame(width: 200, height: 200)
                    .onReceive(timer) { _ in
                        if timerActive {
                            
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                if timeRemaining == 10 {
                                    startVibrationTimer()
                                }
                            } else {
                                stopTimers()
                              
                              // isSummaryPresented = true
                            }
                        }
                    }

                }
                
                // مفروض نوحد جملتهم 
                Text("Entered Value: \(enteredValueForSelectedWord())")
                Text("Selected Word: \(selectedWord)")
                               .font(.largeTitle)
                               .padding()

                .padding()
                Text("Session: \(sessionName)")  // Debugging display
                    .onAppear {
                        print("Session Name on Appear in TheNextPage: \(sessionName)")
                    }
                Text("Generate an ideas for solving a problem ")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter problem statement", text: $problemStatement)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        HapticsManager1.shared.triggerHapticFeedback(style: .heavy)
                        saveSession()
                        problemStatement = ""
                        if !hasStartedTimer {
                            timerActive = true
                            hasStartedTimer = true
                        }
                    }
                NavigationLink(destination: crazy8Summary(problemStatement: savedTexts), isActive: $isSummaryPresented) {
                    EmptyView()
                }
                .hidden()
//                Button("Save") {
//                    saveSession()
//                }
            }
        }
    }.navigationBarBackButtonHidden(true)
}

    func enteredValueForSelectedWord() -> String {
         if let index = likedWords.firstIndex(of: selectedWord) {
             return userInputs[index]
         }
         return ""
     }
private func startVibrationTimer() {
vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    HapticsManager1.shared.triggerHapticFeedback(style: .heavy)
}
}

func saveSession() {
    guard !problemStatement.isEmpty else {
        print("Problem statement is empty")
        return
    }
    
    // Check if there's already a DataItem with the same session name
    if let existingItem = items.first(where: { $0.name == sessionName }) {
        // If found, append the new problem statement to the existing ones
        existingItem.problemStatements.append(problemStatement)
        print("Updated item with session name: \(sessionName) with new problem statement: \(problemStatement)")
    } else {
        // If not found, create a new DataItem
        let newItem = DataItem(name: sessionName, problemStatements: [problemStatement])
        context.insert(newItem)
        print("Saved new item with session name: \(sessionName) and problem statement: \(problemStatement)")
    }
    
    // Append the problem statement to the list of saved texts
    savedTexts.append(problemStatement)
    
    // Clear the text field after saving
    // problemStatement = ""
    
    //presentationMode.wrappedValue.dismiss() // Dismiss the view to return to the previous ContentView
  //  isSummaryPresented = true
    navigatehome = true
    print("navigatehome set to true")
}





private func stopTimers() {
timerActive = false
hasStartedTimer = false // Reset the timer flag
timeRemaining = totalDuration // Reset timer
vibrationTimer?.invalidate() // Stop vibration timer
vibrationTimer = nil
timerNotActive = true
    isSummaryPresented = true
}
// This function navigates to the SavedTextsView after the timer ends
private func moveToNextPage() {
isShowingSavedTexts = true
}
}

class HapticsManager1 {
static let shared = HapticsManager1()

private init() {}

func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
let generator = UIImpactFeedbackGenerator(style: style)
generator.impactOccurred()
}
}






struct Session_ReverseBrainstorming: View {
    
var items: [DataItem]
var sessionName: String  // This should hold the value across this view's lifecycle
@Environment(\.modelContext) private var context
@State private var problemStatement: String = ""
@State private var navigatehome: Bool = false // Track if session started
// @State private var navigatehome: Bool = false

@Environment(\.presentationMode) var presentationMode // Environment to control the view presentation
var userInputs: [String]
//var checkedInput: String
var displayedQuestion: String
    var selectedWord: String
@State private var statement = ""
@State public var answer1 : String = ""
@State public var Answer2 : String = ""
@State public var Answer3 : String = ""

    var likedWords: [String]
var body: some View {
    NavigationStack{
        ZStack{
            Color.gray1
                .ignoresSafeArea()
            VStack{
                ZStack{
                    Image("backgrund")
                        .resizable()
                        .frame(width: 395 , height: 150)
                    
                       
                    Text("Revers Brainstorming")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    .padding(.trailing , 100)
                  
                }.offset(x:0,y: -100)
                 
                // مفروض نوحد جملتهم
                Text("Entered Value: \(enteredValueForSelectedWord())")
                               .font(.largeTitle)
                               .padding()
                Text("Selected Word: \(selectedWord)")
                NavigationLink(destination: ReversAnswers(statement: statement, answer1: $answer1 , answer2: $Answer2 , answer3: $Answer3, items: items, sessionName: sessionName)) {
                                       ZStack{
                                           Rectangle()
                                               .frame(width: 337 , height: 39)
                                               .cornerRadius(5)
                                               .foregroundColor(.laitOrange)
                                           Text("Next")
                                               .foregroundColor(.white)
                                       }
                                   }
        Text("How can you make it worse ?")
                    .padding(.trailing , 100)
                
                ZStack{
                            Rectangle()
                        .frame(width: 343 , height: 82)
                                    .cornerRadius(10)
                            .foregroundColor(.orange2)
            
                        TextField("name", text: $answer1)
                                .frame(width: 322 , height: 63)
                            .textFieldStyle(.roundedBorder)
                                           .padding()
                                    .onSubmit {
               //                                    savedTexts
               //                            text = ""
                                           }
                                       
                                   }
                                   
                                   ZStack{
                                       Rectangle()
                                           .frame(width: 343 , height: 82)
                                           .cornerRadius(10)
                                           .foregroundColor(.orange3)
                                       TextField("name", text: $Answer2)
                                           .frame(width: 322 , height: 63)
                                           .textFieldStyle(.roundedBorder)
                                           .padding()
                                           .onSubmit {
               //                                    savedTexts
               //                            text = ""
                                           }
                                       
                                   }
                                   ZStack{
                                       Rectangle()
                                           .frame(width: 343 , height: 82)
                                           .cornerRadius(10)
                                           .foregroundColor(.orange4)
                                       TextField("Much Worse ", text: $Answer3)
                                           .frame(width: 322 , height: 63)
                                           .textFieldStyle(.roundedBorder)
                                           .padding()
                                           .onSubmit {
               //                                    savedTexts
               //                            text = ""
                                           }
                                       
                                   }
                                   
                

                
            }
        }
    }.navigationBarBackButtonHidden(true)
}
    func enteredValueForSelectedWord() -> String {
         if let index = likedWords.firstIndex(of: selectedWord) {
             return userInputs[index]
         }
         return ""
     }
struct ReversAnswers: View {
  
   var statement: String
    @State public var Answer4 = ""
    @State public var Answer5 = ""
    @State public var Answer6 = ""
   @Binding var answer1 : String
    @Binding var answer2 : String
    @Binding var answer3 : String
    
    var items: [DataItem]
    var sessionName: String  // This should hold the value across this view's lifecycle
    @Environment(\.modelContext) private var context
    var body: some View {
        NavigationStack{
            ZStack{
                Color.gray1
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Image("backgrund")
                            .resizable()
                            .frame(width: 395 , height: 150)
                        
                           // .padding(.bottom,630)
                        Text("Revers Brainstorming")
                      
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        .padding(.trailing , 100)
                          //  .padding(.bottom,600)
                    }.offset(x:0,y: -120)
                     
                    
                    NavigationLink(destination: ReversAnswers2(answer4: $Answer4, answer5: $Answer5, answer6: $Answer6, items: items, sessionName: sessionName)){
                            ZStack{
                                Rectangle()
                                    .frame(width: 337 , height: 39)
                                    .cornerRadius(5)
                                    .foregroundColor(.laitOrange)
                                Text("Next")
                                    .foregroundColor(.white)
                            }
                        }
                    Text("Revers your answers :")
                        .padding(.trailing , 100)
                       
                            Text("First Answer : \(answer1)")
                                .foregroundColor(.gray)
                                .bold()
                               .padding(.trailing , 100)
                           
                        
                    TextField("name", text: $Answer4)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .onSubmit {
                            print(Answer4)
                        }
                 
                    Text("Second Answer:\(answer2)")
                        .foregroundColor(.gray)
                        .bold()
                    
                          
                             
                            TextField("name", text: $Answer5)
                                .frame(width: 322 , height: 63)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                                .onSubmit {
                                    print(Answer5)
                                }
                            
                    Text("Third Answer : \(answer3)")
                        .foregroundColor(.gray)
                        .bold()
                        
                       
                            TextField("name", text: $Answer6)
                                .frame(width: 322 , height: 63)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                                .onSubmit {
                                    print(Answer6)
                                }
                        
                   
                    
                    
                    
                }
           
            }

        }.navigationBarBackButtonHidden(true)
    }
}


struct  ReversAnswers2: View {
    @State private var isSummaryPresented = false
    @State private var statement2 = ""
    @Binding var answer4 : String
     @Binding var answer5 : String
     @Binding var answer6 : String
    @State private var savedTexts: [String] = []
    var items: [DataItem]
    var sessionName: String  // This should hold the value across this view's lifecycle
    @Environment(\.modelContext) private var context
    @State private var problemStatement: String = ""
    @State private var navigateSummary: Bool = false // Track if session started
    // @State private var navigatehome: Bool = false

 //   @Environment(\.presentationMode) var presentationMode // Environment to control the view presentation
    var body: some View {
        NavigationStack{
            ZStack{
                Color.gray1
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Image("backgrund")
                            .resizable()
                            .frame(width: 395 , height: 150)
                        
                        VStack{
                            Text("Revers Brainstorming ")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.trailing , 100)
                            //  .padding(.bottom,600)
                        }
                    }.offset(x:0,y: -120)
                     
                    
                    
                    ZStack{
                        Rectangle()
                            .frame(width: 361 , height: 156)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Text("The Reversed Answers :\(answer4) \(answer5) \(answer6)")
                    } .padding()
                    NavigationLink(destination: BrainstormingSummary(problemStatement: problemStatement), isActive: $isSummaryPresented) {
                        EmptyView() // Empty view to trigger navigation
                    }

                    .hidden()
                    Button("Save") {
                        saveSession()
                    }

                    Text("How can we combine all the the answers into solution ?")

                    TextField("Enter problem statement", text: $problemStatement)
                                .frame(width: 322 , height: 63)
                                .textFieldStyle(.roundedBorder)
                                .padding()
                                .onSubmit {
                                    print(problemStatement)
                                }
                            
            
                        
                    
                    
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func saveSession() {
        guard !problemStatement.isEmpty else {
            print("Problem statement is empty")
            return
        }
        
        // Check if there's already a DataItem with the same session name
        if let existingItem = items.first(where: { $0.name == sessionName }) {
            // If found, append the new problem statement to the existing ones
            existingItem.problemStatements.append(problemStatement)
            print("Updated item with session name: \(sessionName) with new problem statement: \(problemStatement)")
        } else {
            // If not found, create a new DataItem
            let newItem = DataItem(name: sessionName, problemStatements: [problemStatement])
            context.insert(newItem)
            print("Saved new item with session name: \(sessionName) and problem statement: \(problemStatement)")
        }
        
        // Append the problem statement to the list of saved texts
        savedTexts.append(problemStatement)
        
        // Clear the text field after saving
        // problemStatement = ""
        
        //presentationMode.wrappedValue.dismiss() // Dismiss the view to return to the previous ContentView
        isSummaryPresented = true
       // navigatehome = true
        print("navigatehome set to true")
    }
}
//    #Preview {
//        ReversAnswers2()
//    }

}
struct BrainstormingSummary: View {
var problemStatement: String
    @State private var move1: Bool = false
var body: some View {
    NavigationView{
    VStack {
        Text("Brainstorming Summary")
            .font(.title)
            .padding()
        Text("Problem Statement: \(problemStatement)")
            .padding()
        NavigationLink(destination: HomePage(),isActive: $move1){
           EmptyView()
        }
        Button("done"){
           
              move1 = true
            
        }
        .frame(width: 337 , height: 39)
        .cornerRadius(5)
        .foregroundColor(.laitOrange)
        .foregroundColor(.white)
    }
}.navigationBarBackButtonHidden(true)
}
}

struct crazy8Summary: View {
    //var problemStatement: String
    var problemStatement: [String]
    var body: some View {
        NavigationView{
        VStack {
            Text("crazy8 Summary")
                .font(.title)
                .padding()
            Text("Problem Statement: \(problemStatement)")
                .padding()
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
    }.navigationBarBackButtonHidden(true)
}
}
