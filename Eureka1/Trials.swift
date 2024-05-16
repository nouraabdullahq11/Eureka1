//
//  Trials.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//


import SwiftUI
import CoreHaptics


struct try_Crazy8: View {
@State private var text: String = ""
@State private var savedTexts: [String] = []
@State private var isShowingSavedTexts = false
@State private var timeRemaining = 1 * 6 // 8 minutes in seconds
@State private var timerActive = false
@State private var hasStartedTimer = false // Tracks if the timer has started
@State private var vibrationTimer: Timer? // Timer for continuous vibration
//

let totalDuration = 1 * 6 // Total duration in seconds for progress calculation
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

@Environment(\.managedObjectContext) private var viewContext
var body: some View {
NavigationView {
NavigationView {
    NavigationStack {
        ZStack{
            Color.gray1
                .ignoresSafeArea()
            
            ZStack{
                Image("backgrund")
                    .resizable()
                    .frame(width: 395 , height: 150)
                
                
                Text("Crazy 8")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.trailing , 100)
            }.offset(x:0,y: -365)
            
            
            VStack {
                ZStack{
                    Circle()
                        .stroke(Color.orange ,style: StrokeStyle(lineWidth: 10,lineCap: .butt , dash: [5]))
                        .frame(width: 270,height: 270)
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
                                moveToNextPage() // Automatically move to the next page
                            }
                        }
                    }
                }
                .padding()
                Text("Generate an ideas for solving a problem ")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("input text ", text: $text)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        // Trigger haptic feedback when user presses Enter
                        HapticsManager.shared.triggerHapticFeedback(style: .heavy)
                        
                        // Save the text and clear the text field
                        savedTexts.append(text)
                        text = ""
                        
                        // Start the timer only once when the first text is submitted
                        if !hasStartedTimer {
                            timerActive = true
                            hasStartedTimer = true // Ensure timer starts only once
                        }
                    }
                
                NavigationLink(destination: SavedTextsView(texts: savedTexts), isActive: $isShowingSavedTexts) {
                    EmptyView()
                }
                .hidden()
                // Hide the navigation bar (including the back button) in the current view controller
                
                
            }
            }
        }
    }}.navigationBarBackButtonHidden(true)
}
private func startVibrationTimer() {
vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
    HapticsManager.shared.triggerHapticFeedback(style: .heavy)
}
}
private func stopTimers() {
timerActive = false
hasStartedTimer = false // Reset the timer flag
timeRemaining = totalDuration // Reset timer
vibrationTimer?.invalidate() // Stop vibration timer
vibrationTimer = nil
}
// This function navigates to the SavedTextsView after the timer ends
private func moveToNextPage() {
isShowingSavedTexts = true
}
}
struct SavedTextsView: View {
var texts: [String]
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []

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
class HapticsManager {
static let shared = HapticsManager()

private init() {}

func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
let generator = UIImpactFeedbackGenerator(style: style)
generator.impactOccurred()
}
}



struct try_AnsQuestions: View {
@EnvironmentObject var dataManager: DataManager
@State private var showPopup = false
@State private var currentIndex = 0
@State private var userInputs = ["", "", ""]
@State private var checkedIndex: Int? = nil  // Optional Int to keep track of which checkbox is checked

@State private var isTimerRunning = false
@State private var timeRemaining = 180  // 3 minutes in seconds

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
                        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    NavigationLink("Next", destination: AnsQuestions_Summ(texts: [""], userInputs: userInputs, checkedInput: checkedIndex != nil ? userInputs[checkedIndex!] : "None", displayedQuestion: dataManager.questions[currentIndex].text))
                        .frame(width: 337, height: 39)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
           // NewQuestionView()
        }
    }
}.navigationBarBackButtonHidden(true)
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

private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

private func startTimer() {
isTimerRunning = true
}

private func formattedTime(_ seconds: Int) -> String {
let minutes = seconds / 60
let remainingSeconds = seconds % 60
return String(format: "%02d:%02d", minutes, remainingSeconds)
}
}

struct AnsQuestions_Summ: View {
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []
var texts: [String]
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
                            
                               
                            Text(" the Question you chose to answer : \(displayedQuestion) ")
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
                            Text("The answer you resonates with the most :")
                            
                                .font(.title)
                                .bold()
                                .padding()
                            Text("\(checkedInput)")
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
}.navigationBarBackButtonHidden(true)
}
}




struct try_RandomWords: View {
@EnvironmentObject var dataManager: DataManager
@State private var currentIndex = 0
@State private var likedWords: [String] = []
@State private var dragState = CGSize.zero
@State private var likedWordBoxes: [String?] = Array(repeating: nil, count: 3)
@State private var isTimerRunning = false
@State private var timeRemaining = 6
@State private var navigateToNextPage = false

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

            Text("Double-tap meaningful words or swipe to change.")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)

            if !dataManager.words.isEmpty {
                ZStack {
                    ForEach(dataManager.words.indices.reversed(), id: \.self) { index in
                        CardView1(word: dataManager.words[index].text)
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
                    LikedWordBox(word: likedWordBoxes[index] ?? "")
                }
            }
            .padding(.top, 50)

            HStack {
                NavigationLink(
                                        destination: try_RandomWords2(likedWords: likedWords),
                                        isActive: .constant(likedWords.count >= 3),
                                        label: {
                                            Text("")
                                                .font(.system(size: 18))
                                                .padding()
                                                .background(Color.clear)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    )
            }
            .padding(.top, 30)
        }
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
    }
    .background(
        NavigationLink(destination: try_RandomWords2(likedWords: likedWords), isActive: $navigateToNextPage) {
            EmptyView()
        }
    )
}.navigationBarBackButtonHidden(true)
}

var timerString: String {
let minutes = timeRemaining / 6
let seconds = timeRemaining % 6

if minutes < 10 {
    return String(format: "%d:%02d", minutes, seconds)
} else {
    return String(format: "%02d:%02d", minutes, seconds)
}
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
return nextIndex
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

struct try_RandomWords2: View {
var likedWords: [String]
@State private var enteredValues: [String]
@State private var selectedWord: String?
@State private var showCheckmarks: Bool = false
@State private var showNextButton: Bool = false
@State private var navigateToSummary: Bool = false
@State private var isTimerRunning = false
@State private var timeRemaining = 6

init(likedWords: [String]) {
self.likedWords = likedWords
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
                
                Text("Place these words into possible ideas or solutions:")
                    .font(.system(size: 20, weight: .semibold))
                  //  .padding(.bottom, 60)
                
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
                    Text("Place these words into possible ideas or solutions:")
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
                    Button(action: {
                        navigateToSummary = true
                    }) {
                        Text("Next")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .foregroundColor(.white)
                            .background(showNextButton ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .opacity(showNextButton ? 1.0 : 0.5)
                            .disabled(!showNextButton)
                }
                }
                
                NavigationLink(
                    destination: RWSummary( texts: [""], selectedWord: selectedWord, enteredValue: enteredValues[likedWords.firstIndex(of: selectedWord ?? "") ?? 0]),
                    isActive: $navigateToSummary
                ) {
                    EmptyView()
                }
                
            }
        }
    }
}.navigationBarBackButtonHidden(true)
}
var timerString: String {
let minutes = timeRemaining / 6
let seconds = timeRemaining % 6

if minutes < 10 {
    return String(format: "%d:%02d", minutes, seconds)
} else {
    return String(format: "%02d:%02d", minutes, seconds)
}
}

func startTimerIfNeeded() {
if !isTimerRunning {
    isTimerRunning = true
    timeRemaining = 6
}
}
}



struct CardView1: View {
var word: String

var body: some View {
Text(word)
    .font(.largeTitle)
    .frame(width: 300, height: 200)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(radius: 5)
    .foregroundColor(.black)
    .overlay(
        RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)
    )
}
}

struct LikedWordBox: View {
var word: String

var body: some View {
RoundedRectangle(cornerRadius: 10)
    .stroke(Color.orange, lineWidth: 2) // Orange border
    .frame(width: 100, height: 50)
    .foregroundColor(.white) // White background
    .overlay(
        Text(word)
            .foregroundColor(.black) // Text color
    )
}
}
struct RWSummary: View {
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []
var texts: [String]
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
                            
                            if let selectedWord = selectedWord {
                                Text(" Through your experience, you have come to big idea: \(selectedWord) ")
                                    .font(.caption)
                                    .padding(.horizontal)
                            }}
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
                            Text("Your statement:")
                            
                                .font(.title)
                                .bold()
                                .padding()
                            Text("\(enteredValue)")
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
}.navigationBarBackButtonHidden(true)
}
}

struct try_ReverseBrainstorming: View {


   
    @State private var statement = ""
    @State public var answer1 : String = ""
    @State public var Answer2 : String = ""
    @State public var Answer3 : String = ""

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
                     
                    
                    
                    Text("Enter your problem statements :")
                        .padding(.trailing , 100)
                    TextField("name", text: $statement)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .onSubmit {
                            print(statement)
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
                                               }
                                           
                                       }
                                       
                    NavigationLink(destination: ReversAnswers( statement: statement, answer1: $answer1 , answer2: $Answer2 , answer3: $Answer3)) {
                                           ZStack{
                                               Rectangle()
                                                   .frame(width: 337 , height: 39)
                                                   .cornerRadius(5)
                                                   .foregroundColor(.laitOrange)
                                               Text("Next")
                                                   .foregroundColor(.white)
                                           }
                                       }

                    
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    struct ReversAnswers: View {
      
       var statement: String
        @State public var Answer4 = ""
        @State public var Answer5 = ""
        @State public var Answer6 = ""
       @Binding var answer1 : String
        @Binding var answer2 : String
        @Binding var answer3 : String
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
                        }.offset(x:0,y: -120)
                         
                        
                            
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
                            
                       
                            NavigationLink(destination: ReversAnswers2(answer4: $Answer4, answer5: $Answer5, answer6: $Answer6)){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 337 , height: 39)
                                        .cornerRadius(5)
                                        .foregroundColor(.laitOrange)
                                    Text("Next")
                                        .foregroundColor(.white)
                                }
                            }
                        
                        
                    }
               
                }

            }.navigationBarBackButtonHidden(true)
        }
    }
    
    
    struct  ReversAnswers2: View {
        @State private var statement2 = ""
        @Binding var answer4 : String
         @Binding var answer5 : String
         @Binding var answer6 : String
        
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
                     
                        Text("How can we combine all the the answers into solution ?")

                                TextField("name", text: $statement2)
                                    .frame(width: 322 , height: 63)
                                    .textFieldStyle(.roundedBorder)
                                    .padding()
                                    .onSubmit {
                                        print(statement2)
                                    }
                                
                
                            
                       
                        NavigationLink(destination: ReverseBSum(texts: [""], statement2:statement2) ){
                                ZStack{
                                    Rectangle()
                                        .frame(width: 337 , height: 39)
                                        .cornerRadius(5)
                                        .foregroundColor(.laitOrange)
                                    Text("Next")
                                        .foregroundColor(.white)
                                }
                            }
                        
                        
                    }
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
}
struct ReverseBSum: View {
var texts: [String]
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []
 var statement2 = ""
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
                            Text("\(statement2) ")
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
}.navigationBarBackButtonHidden(true)
}
}



#Preview {
try_ReverseBrainstorming()
}



struct try_AnsQuestions_Previews: PreviewProvider {
static var previews: some View {
try_AnsQuestions().environmentObject(DataManager())
}
}


struct try_Crazy8_Previews: PreviewProvider {
static var previews: some View {
try_Crazy8().environmentObject(DataManager())
}
}



struct SummaryView1: View {
@EnvironmentObject var dataManager: DataManager
var userInputs: [String]
var checkedInput: String
var displayedQuestion: String

var body: some View {
VStack(spacing: 20) {
    Text("Checked Input: \(checkedInput)")
        .padding()
    Text("Displayed Question: \(displayedQuestion)")
        .padding()
    Button("Save Summary") {
        let summary = SummaryQ(userInput: checkedInput, displayedQuestion: displayedQuestion)
        dataManager.saveSummaryQ(summary: summary)
    }
    .padding()
}
.navigationTitle("Summary")
.navigationBarTitleDisplayMode(.inline)
}
}


struct UrSummary: View {
var selectedWord: String?
var enteredValue: String

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
