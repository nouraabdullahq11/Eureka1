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
import  Lottie
import Firebase

//import SwiftUI

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
    @State private var shuffledWords: [Word] = []
    @Environment(\.colorScheme) var colorScheme
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(items: [DataItem], sessionName: String, generaterSelection: Binding<Int>) {
        self.items = items
        self.sessionName = sessionName
        self._generaterSelection = generaterSelection
        
        // Initialize the shuffled words
        _shuffledWords = State(initialValue: [])
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray1
                    .ignoresSafeArea()
                
                Image("backgrund")
                    .resizable()
                    .frame(width: 400 , height: 150)
                    .padding(.bottom,770)
                
                VStack {
                    Text("Random Word")
                        .font(.system(size: 29, weight: .semibold))
                        .padding(.bottom,680)
                        .padding(.trailing, 170)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                }
                
                VStack {
                    Text(timerString)
                        .font(.system(size: 60, weight: .bold))
                        .padding(.top, 100)
                        .padding(.bottom, 20)
                        .onReceive(timer) { _ in
                            if isTimerRunning {
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                } else {
                                    isTimerRunning = false
                                    navigateToNextPage = true
                                }
                            }
                        }
                    
                    Text("Double-tap meaningful words or swipe to change.")
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    if !shuffledWords.isEmpty {
                        ZStack {
                            ForEach(shuffledWords.indices.reversed(), id: \.self) { index in
                                CardView(word: shuffledWords[index].text)
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
                                .foregroundColor(Color.white1)
                                .shadow(color: colorScheme == .dark ? Color.gray.opacity(0.1) : Color.gray.opacity(0.5), radius: 10, x: 0, y: 2)
                                .frame(width: 300, height: 280)
                                .rotationEffect(.degrees(7))
                        }
                        .onTapGesture(count: 2) {
                            if likedWords.count < 3 {
                                let word = shuffledWords[currentIndex].text
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
                    .padding(.bottom, 20)
                    .padding(.top, 30)
                    
                    Button(action: {
                        navigateToNextPage = likedWords.count >= 3
                    }) {
                        Text("Next Step")
                            .font(.system(size: 18))
                            .padding()
                            .frame(width: 337, height: 39)
                            .background(Color.button)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .opacity(likedWords.count >= 3 ? 1.0 : 0.5)
                            .disabled(likedWords.count < 3)
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(
                NavigationLink(destination: session_RandomWords2(likedWords: likedWords, items: items, sessionName: sessionName, generaterSelection: $generaterSelection), isActive: $navigateToNextPage) {
                    EmptyView()
                }
                .hidden()
            )
            .onAppear {
                // Shuffle the words once when the view appears
                shuffledWords = dataManager.words.shuffled()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var timerString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        
        if minutes < 10 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func startTimerIfNeeded() {
        if (!isTimerRunning) {
            isTimerRunning = true
        }
    }
    
    func getNextIndex() -> Int {
        let nextIndex = currentIndex + 1
        return nextIndex < shuffledWords.count ? nextIndex : 0
    }
    
    func getPreviousIndex() -> Int {
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? previousIndex : shuffledWords.count - 1
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
    }
}


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
    @State private var isTimerRunning = false
    @State private var timeRemaining = 6

    var items: [DataItem]
    var sessionName: String
    @Environment(\.modelContext) private var context
    @Binding var generaterSelection: Int
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @EnvironmentObject var dataManager: DataManager
    @State private var navigateToNextPage = false

    init(likedWords: [String], items: [DataItem], sessionName: String, generaterSelection: Binding<Int>) {
        self.likedWords = likedWords
        self.items = items
        self.sessionName = sessionName
        self._generaterSelection = generaterSelection
        self._enteredValues = State(initialValue: Array(repeating: "", count: likedWords.count))
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
                                        navigateToNextPage = true
                                        isTimerRunning = false
                                    }
                                }
                            }

                        Text("Place these words into possible ideas or solutions:")
                            .font(.system(size: 20, weight: .semibold))

                        VStack {
                            ForEach(0..<likedWords.count, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    Text(likedWords[index])
                                        .font(.system(size: 18))
                                    HStack {
                                        Image(systemName: selectedWord == likedWords[index] ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.blue)
                                            .onTapGesture {
                                                selectedWord = likedWords[index]
                                            }
                                        TextField("Enter a value", text: $enteredValues[index])
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .onChange(of: enteredValues[index]) { newValue in
                                                startTimerIfNeeded()
                                            }
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        
                        if selectedWord != nil {
                            if generaterSelection == 1 {
                                NavigationLink(
                                    destination: session_Crazy8(
                                        likedWords: likedWords, items: items,
                                        sessionName: sessionName,
                                        userInputs: enteredValues,
                                        displayedQuestion: dataManager.questions.first?.text ?? "", selectedWord: selectedWord ?? ""
                                    ), isActive: $navigateToNextPage
                                ) {
                                    Text("Go To Crazy 8")
                                        .font(.system(size: 18))
                                        .padding()
            //                            .background(likedWords.count >= 3 ? Color.orange : Color.gray)
                                        .frame(width: 337, height: 39)
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            } else {
                                NavigationLink(
                                    destination: Session_ReverseBrainstorming(
                                        items: items,
                                        sessionName: sessionName,
                                        userInputs: enteredValues,
                                        displayedQuestion: dataManager.questions.first?.text ?? "", selectedWord: selectedWord ?? "",
                                        likedWords: likedWords
                                    ), isActive: $navigateToNextPage
                                ) {
                                    Text("Go To Reverse Brainstorming")
                                        .font(.system(size: 18))
                                        .padding()
            //                            .background(likedWords.count >= 3 ? Color.orange : Color.gray)
                                        .frame(width: 337, height: 39)
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
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
    @State private var navigateTonext: Bool = false
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
    @State private var shuffledQuestions: [Question] = []

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

                    if !shuffledQuestions.isEmpty {
                        Text(shuffledQuestions[currentIndex].text)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(nil) // Allow multiple lines
                            .padding(.trailing)
                            .fixedSize(horizontal: false, vertical: true) // Expand vertically

                        Button("New Question >>") {
                            currentIndex = getNextIndex()
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
                                        displayedQuestion: shuffledQuestions[currentIndex].text,
                                        selectedWord: checkedIndex != nil ? userInputs[checkedIndex!] : ""
                                    ), isActive: $navigateTonext
                                ) {
                                    Text("Next to Crazy 8")
                                        .font(.system(size: 18))
                                        .padding()
                                        .frame(width: 337, height: 39)
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                                .disabled(!isNextStepButtonEnabled || checkedIndex == nil)
                            } else {
                                NavigationLink(
                                    destination: Session_ReverseBrainstorming(
                                        items: items,
                                        sessionName: sessionName,
                                        userInputs: enteredValues,
                                        displayedQuestion: shuffledQuestions[currentIndex].text,
                                        selectedWord: checkedIndex != nil ? userInputs[checkedIndex!] : "",
                                        likedWords: likedWords
                                    ), isActive: $navigateTonext
                                ) {
                                    Text("Next to Reverse Brainstorming")
                                        .font(.system(size: 18))
                                        .padding()
                                        .frame(width: 337, height: 39)
                                        .background(Color.button)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
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
        .onAppear {
            shuffledQuestions = dataManager.questions.shuffled()
            currentIndex = 0
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished, reset
                    navigateTonext = true
                    isTimerRunning = false
                    timeRemaining = 6  // Reset timer for the next question
                }
            }
        }
        .environmentObject(DataManager())
    }

    func getNextIndex() -> Int {
        let nextIndex = currentIndex + 1
        return nextIndex < shuffledQuestions.count ? nextIndex : 0
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
                        LottieView(animation: .named("Animation5"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 140)
                     
                            .offset(x:140 , y: 120)
                        
                        LottieView(animation: .named("Animation10"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                      
                            .frame(width: 150)
                            .opacity(0.5)
                                                      
                            .offset(x:100 , y: -150)
                        
                        LottieView(animation: .named("Animation2"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 100)
                     
                            .offset(x:10 , y: -190)
                        
                        LottieView(animation: .named("Animation6"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                            .frame(width: 150)
                     
                            .offset(x:-100 , y: -160)
                        
                        
                        LottieView(animation: .named("Animation11"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                .frame(width: 290 )
                       
                                                      
                            .offset(x:-150 , y: 50)
                        
                        LottieView(animation: .named("Animation13"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                .frame(width: 290 )
               .opacity(0.3)
                                                      
                            .offset(x:-150 , y: -50)
                        
                        
                        LottieView(animation: .named("Animation6"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                      
                            .frame(width: 90)
                       
                                                      
                            .offset(x:-150 , y: 150)
                        
                        
                        LottieView(animation: .named("Animation6"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                      
                            .frame(width: 90)
                       
                                                      
                            .offset(x:150 , y: 20)
                        
                        
                        LottieView(animation: .named("Animation15"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                      
                            .frame(width: 90)
                       
                                                      
                            .offset(x:-160 , y: 90)
                        LottieView(animation: .named("Animation15"))
                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                            .resizable()
                      
                            .frame(width: 90)
                       
                            .opacity(0.5)
                            .offset(x:160 , y: -30)
                       
                        
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
    
    struct TopLeadingTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .multilineTextAlignment(.leading)
                .padding(.leading) // Push text to the left
                .padding(.bottom , 10) // Push text to the top
        }
    }
    
    
    var items: [DataItem]
    var sessionName: String  // This should hold the value across this view's lifecycle
    @Environment(\.modelContext) private var context
    @State private var problemStatement: String = ""
    @State private var navigatehome: Bool = false // Track if session started
    @Environment(\.presentationMode) var presentationMode // Environment to control the view presentation
    var userInputs: [String]
    var displayedQuestion: String
    var selectedWord: String
    @State private var statement = ""
    @State public var answer1: String = ""
    @State public var Answer2: String = ""
    @State public var Answer3: String = ""
    var likedWords: [String]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray1
                    .ignoresSafeArea()
                ZStack{
                    
                    VStack {
                        ZStack{
                            Image("backgrund")
                                .resizable()
                            
                                .overlay(
                                    
                                    Text("Revers Brainstorming")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.trailing , 120)
                                        .padding(.top ,70)
                                )
                                .frame(width: 400 , height: 150)
                            
                            
                        } //.padding()
                        VStack(alignment: .leading, spacing: 8){
                            Text("Find a Problem of your Idea or Solution statement:")
                                .bold()
                                .frame(maxWidth: .infinity , alignment: .leading)
                                .lineLimit(nil) // Allow multiple lines
                                .padding(.trailing)
                                .fixedSize(horizontal: false, vertical: true) // Expand vertically
                            Text("Identify potential issues or problems with your solution or idea,and exaggerate them to uncover areas that need improvement.")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(nil) // Allow multiple lines
                                            .padding(.trailing)
                                            .fixedSize(horizontal: false, vertical: true) // Expand vertically
                                           // .font(.system(size: 15))
                                           
                                          
                                         

                        
                        Text("How can we make \(enteredValueForSelectedWord()) worse ?")
                            .bold()
                            .padding(.trailing)
                        }.padding()
                        //      Text("Selected Word: \(selectedWord)")
                        
                        //                        NavigationLink(destination: ReversAnswers1(statement: statement, answer1: $answer1, answer2: $Answer2, answer3: $Answer3, items: items, sessionName: sessionName)) {
                        //                            ZStack {
                        //                                Rectangle()
                        //                                    .frame(width: 337, height: 39)
                        //                                    .cornerRadius(5)
                        //                                    .foregroundColor(areAllFieldsFilled() ? .laitOrange : .gray) // Change color based on field state
                        //                                Text("Next")
                        //                                    .foregroundColor(.white)
                        //                            }
                        //                        }
                        //      .disabled(!areAllFieldsFilled()) // Disable button if not all fields are filled
                        
                        //                        Text("How can you make it worse?")
                        //                            .padding(.trailing, 100)
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 343 , height: 70)
                                .cornerRadius(10)
                                .foregroundColor(.orange2)
                            ZStack(alignment: .topLeading) {
                                TextField("Worse", text: $answer1)
                                
                                    .frame(width: 330 , height: 50)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                        }
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 343 , height: 70)
                                .cornerRadius(10)
                                .foregroundColor(.orange3)
                            ZStack(alignment: .topLeading) {
                                TextField("much worse", text: $Answer2)
                                
                                    .frame(width: 330 , height: 50)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                            
                        }
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 343 , height: 70)
                                .cornerRadius(10)
                                .foregroundColor(.orange4)
                            ZStack(alignment: .center) {
                                TextField("Worst", text: $Answer3)
                                    .frame(width: 330 , height: 50)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                            
                        }
                        
                        NavigationLink(destination: ReversAnswers1(statement: statement, answer1: $answer1, answer2: $Answer2, answer3: $Answer3, items: items, sessionName: sessionName)) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 337, height: 39)
                                    .cornerRadius(5)
                                    .foregroundColor(areAllFieldsFilled() ? .laitOrange : .gray) // Change color based on field state
                                Text("Next")
                                    .foregroundColor(.white)
                            }.padding(.top , 50)
                        }
                        .disabled(!areAllFieldsFilled()) // Disable button if not all fields are filled
                        
                    }
                }.padding(.bottom , 200)
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func enteredValueForSelectedWord() -> String {
        if let index = likedWords.firstIndex(of: selectedWord) {
            return userInputs[index]
        }
        return ""
    }
    
    func areAllFieldsFilled() -> Bool {
        return !answer1.isEmpty && !Answer2.isEmpty && !Answer3.isEmpty
    }
    
    
    struct ReversAnswers1: View {
        var statement: String
        @State public var Answer4 = ""
        @State public var Answer5 = ""
        @State public var Answer6 = ""
        @Binding var answer1: String
        @Binding var answer2: String
        @Binding var answer3: String
        var items: [DataItem]
        var sessionName: String  // This should hold the value across this view's lifecycle
        @Environment(\.modelContext) private var context
        
        var body: some View {
            NavigationStack {
                ZStack {
                    Color.gray1
                        .ignoresSafeArea()
                    ZStack{
                        VStack {
                            ZStack{
                                Image("backgrund")
                                    .resizable()
                                
                                
                                    .overlay(
                                        
                                        Text("Revers Brainstorming")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.trailing , 120)
                                            .padding(.top ,70)
                                    )
                                    .frame(width: 400 , height: 150)
                                
                                
                            }
                            
                            
                            
                            Text("Revers your answers :")
                                .padding(.trailing , 175)
                                .padding()
                            
                            
                            Text("First Answer: \(answer1)")
                                .foregroundColor(.gray)
                                .bold()
                                .padding(.trailing , 175)
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Better", text: $Answer4)
                                
                                    .frame(width: 331,height: 58)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                            
                            
                            
                            Text("Second Answer: \(answer2)")
                                .foregroundColor(.gray)
                                .bold()
                                .padding(.trailing , 175)
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Much better", text: $Answer5)
                                
                                    .frame(width: 331,height: 58)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                            
                           
                            
                            Text("Third Answer: \(answer3)")
                                .foregroundColor(.gray)
                                .bold()
                                .padding(.trailing , 175)
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Best", text: $Answer6)
                                
                                    .frame(width: 331,height: 58)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            }
                           
                            
                            NavigationLink(destination: ReversAnswers21(answer4: $Answer4, answer5: $Answer5, answer6: $Answer6, items: items, sessionName: sessionName)) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 337, height: 39)
                                        .cornerRadius(5)
                                        .foregroundColor(areAllFieldsFilled() ? .laitOrange : .gray) // Change color based on field state
                                    Text("Next")
                                        .foregroundColor(.white)
                                }
                            }
                            .disabled(!areAllFieldsFilled()) // Disable button if not all fields are filled
                        }
                    }.padding(.bottom, 240)
                }
            }.navigationBarBackButtonHidden(true)
        }
        
        func areAllFieldsFilled() -> Bool {
            return !Answer4.isEmpty && !Answer5.isEmpty && !Answer6.isEmpty
        }
    }
    
    struct ReversAnswers21: View {
        @State private var isSummaryPresented = false
        @State private var statement2 = ""
        @Binding var answer4: String
        @Binding var answer5: String
        @Binding var answer6: String
        @State private var savedTexts: [String] = []
        var items: [DataItem]
        var sessionName: String  // This should hold the value across this view's lifecycle
        @Environment(\.modelContext) private var context
        @State private var problemStatement: String = ""
        @State private var navigateSummary: Bool = false // Track if session started
        
        var body: some View {
            NavigationStack {
                ZStack {
                    Color.gray1
                        .ignoresSafeArea()
                    ZStack{
                        VStack {
                            ZStack{
                                Image("backgrund")
                                    .resizable()
                                
                                
                                    .overlay(
                                        
                                        Text("Revers Brainstorming")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding(.trailing , 120)
                                            .padding(.top ,70)
                                    )
                                    .frame(width: 400 , height: 150)
                                
                                
                            }.padding(.bottom)
                            ZStack(alignment: .topLeading) {
                            Text("The Reversed Answers: \(answer4) \(answer5) \(answer6)")
                                    .padding(.trailing , 90)
                                    .padding(.bottom , 100)
                                    .multilineTextAlignment(.leading) // Align text to the left
                                    .frame(width: 336, height: 156)
                                        .background(Color.white)
                                        .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                                    )
                            }.padding(.bottom , 50)
                            
                            VStack{
            Text("How can we combine all the the answers into solution ?")
                    .multilineTextAlignment(.leading)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil) // Allow multiple lines
                    .padding(.trailing)
                    .fixedSize(horizontal: false, vertical: true) // Expand vertically
                   // .font(.system(size: 15))
                  //  .padding(.horizontal)
                                
                            }.padding()
                            
                            //                        NavigationLink(destination: BrainstormingSummary(problemStatement: problemStatement), isActive: $isSummaryPresented) {
                            //                            EmptyView() // Empty view to trigger navigation
                            //                        }
                            //                        .hidden()
                            //
                            //                        Button("Save") {
                            //                            saveSession()
                            //                        }
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Enter problem statement", text: $problemStatement)
                                
                                    .frame(width: 331,height: 58)
                                    .background(Color.white)
                                    .overlay(
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                        
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                                    .onSubmit {
                                        
                                    }
                            } .padding()
                            
                           
//                            TextField("Enter problem statement", text: $problemStatement)
//                                .frame(width: 322, height: 63)
//                                .textFieldStyle(.roundedBorder)
//                                .padding()
                            
                            NavigationLink(destination: BrainstormingSummary(problemStatement: problemStatement), isActive: $isSummaryPresented) {
                                EmptyView() // Empty view to trigger navigation
                            }
                            .hidden()
                            Button(action: {
                                           saveSession()
                                       }) {
                                           ZStack{
                                               Rectangle()
                                                   .frame(width: 337 , height: 39)
                                                   .cornerRadius(5)
                                                   .foregroundColor(.laitOrange)
                                               Text("Next")
                                                   .foregroundColor(.white)
                                           }
                                       } .padding(.top , 50)
//                            Button("Save") {
//                                saveSession()
//                            }
                        }
                    }.padding(.bottom , 180)
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
            print("navigatehome set to true")
        }
    }
}
struct BrainstormingSummary: View {
  //  var texts: [String]
    @State private var showAllTexts = false
    @State private var additionalTexts: [String] = []

var problemStatement: String
    @State private var move1: Bool = false
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
                                Text("Solution :")
                                    .font(.title)
                                    .bold()
                                    .padding()
                                Text("\(problemStatement) ")
                            
                                //.padding()
                            }
//                            if problemStatement.count > 3 {
//                                Button(action: {
//                                    showAllTexts.toggle()
//                                    if showAllTexts {
//                                        additionalTexts = Array(problemStatement.dropFirst(3))
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
    }.navigationBarBackButtonHidden(true)
    }
}

struct crazy8Summary: View {
    //var problemStatement: String
    //var texts: [String]
    @State private var showAllTexts = false
    @State private var additionalTexts: [String] = []

    var problemStatement: [String]
    var body: some View {
        NavigationView{
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
                                 //   Text("Problem Statement: \(problemStatement)")
                                       // .font()
                                        //.bold()
                                       // .padding()
                                    
                                    VStack {
                                        ForEach(0..<min(problemStatement.count, 3)) { index in
                                            Text(problemStatement[index])
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
                                if problemStatement.count > 3 {
                                    Button(action: {
                                        showAllTexts.toggle()
                                        if showAllTexts {
                                            additionalTexts = Array(problemStatement.dropFirst(3))
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
                        }.navigationBarBackButtonHidden(true)
                        
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
          
           )}.navigationBarBackButtonHidden(true)
        }.navigationBarBackButtonHidden(true)
}
}
