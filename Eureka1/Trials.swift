//
//  Trials.swift
//  Eureka
//
//  Created by Noura Alqahtani on 14/05/2024.
//



import SwiftUI
import CoreHaptics
import Lottie
import Firebase

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
                  
                    .overlay(

                
                Text("Crazy 8")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.trailing , 220)
                    .padding(.top ,70)
                )  .frame(width: 395 , height: 150)
                
            }//.offset(x:0,y: -365)
            .padding(.bottom , 850)

            
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




/////////////////////////////////ANSW QUAESTION ////////////////////////////////////////////////




struct try_AnsQuestions: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    @State private var currentIndex = 0
    @State private var userInputs = ["", "", ""]
    @State private var checkedIndex: Int? = nil
    @State private var isTimerRunning = false
    @State private var timeRemaining = 90  // 1.5 minutes in seconds
    @State private var shuffledQuestions: [Question] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray1
                    .ignoresSafeArea()
                
                Image("backgrund")
                    .resizable()
                    .frame(width: 400 , height: 170)
                    .padding(.bottom, 820)
                
                Text("Answer the Question")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.trailing , 100)
                    .padding(.bottom , 710)
              
                VStack {
                    Text(formattedTime(timeRemaining))
                        .font(.system(size: 60, weight: .bold))
                        .padding(.bottom, 20)
                    
                    if !shuffledQuestions.isEmpty {
                        Text(shuffledQuestions[currentIndex].text)
                            //.bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(nil) // Allow multiple lines
                            .padding(.trailing)
                            .fixedSize(horizontal: false, vertical: true) // Expand vertically
                        
                        Button("New Question >>") {
                            // Generate a new index and clear the text fields and checkbox
                            currentIndex = getNextIndex()
                            userInputs = ["", "", ""]
                            checkedIndex = nil
                        }
                        .padding(.bottom, 10)
                        .foregroundColor(.orange1)
                        
                        VStack {
                            ForEach(0..<3, id: \.self) { index in
                                HStack {
                                    if !userInputs[index].isEmpty {
                                        Image(systemName: checkedIndex == index ? "checkmark.circle" : "circle")
                                            .resizable()
                                            .foregroundColor(.button)
                                            .frame(width: 22, height: 22)
                                            .padding(.trailing , 20)
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
                                    .foregroundColor(.black)
                                    .accentColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                }
                                .padding(.leading , 20)
                                .padding(.trailing , 15)
                                .padding(.bottom , 30)
                            }
                        }.padding(.bottom, 80)
                        
                        VStack {
                            Text("* check mark the one that resonates with you the most.")
                                .foregroundColor(.gray)
                                .frame(alignment: .center)
                                .font(.system(size: 12))
                            
                            NavigationLink(
                                destination: AnsQuestions_Summ(texts: [""], userInputs: userInputs, checkedInput: userInputs[checkedIndex ?? 0], displayedQuestion: shuffledQuestions[currentIndex].text),
                                isActive: .constant(false), // Disable default navigation
                                label: {
                                    Text("Next")
                                        .frame(width: 337, height: 39)
                                        .background(nextButtonEnabled ? Color.button : Color.gray)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            )
                            .simultaneousGesture(TapGesture().onEnded {
                                if nextButtonEnabled {
                                    // Perform the navigation
                                    NavigationLink(destination: AnsQuestions_Summ(texts: [""], userInputs: userInputs, checkedInput: userInputs[checkedIndex ?? 0], displayedQuestion: shuffledQuestions[currentIndex].text)) {
                                        EmptyView()
                                    }
                                }
                            })
                            .disabled(!nextButtonEnabled) // Disable button when conditions are not met
                            .padding(.bottom, 20)
                        }
                        
                    } else {
                        Text("No questions available")
                            .padding()
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    showPopup.toggle()
                }, label: {
                    Image(systemName: "plus")
                }))
                .sheet(isPresented: $showPopup) {
                    // NewQuestionView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Shuffle the questions when the view appears
            shuffledQuestions = dataManager.questions.shuffled()
            currentIndex = 0
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer finished, reset
                    isTimerRunning = false
                    timeRemaining = 90  // Reset timer for the next question
                }
            }
        }
        .environmentObject(DataManager())
    }

    // Computed property to determine if the Next button should be enabled
    private var nextButtonEnabled: Bool {
        return !userInputs.contains("") && checkedIndex != nil
    }

    func getNextIndex() -> Int {
        let nextIndex = currentIndex + 1
        return nextIndex < shuffledQuestions.count ? nextIndex : 0
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


/////////////////////////////////Random word ////////////////////////////////////////////////




struct try_RandomWords: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentIndex = 0
    @State private var likedWords: [String] = []
    @State private var dragState = CGSize.zero
    @State private var likedWordBoxes: [String?] = Array(repeating: nil, count: 3)
    @State private var isTimerRunning = false
    @State private var timeRemaining = 60
    @State private var navigateToNextPage = false
    @State private var shuffledWords: [Word] = []

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray1
                    .ignoresSafeArea()
                
                Image("backgrund")
                    .resizable()
                    .frame(width: 400, height: 150)
                    .padding(.bottom, 750)
                
                VStack {
                    Text("Random Word")
                        .font(.system(size: 29, weight: .semibold))
                        .padding(.bottom, 680)
                        .padding(.trailing, 170)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                }
                
                VStack {
                    Text(timerString)
                        .font(.system(size: 60, weight: .bold))
                        .padding(.top, 150)
                        .padding(.bottom, 20)
                    
                    Text("Double-tap meaningful words or swipe to change.")
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 60)
                    
                    if !shuffledWords.isEmpty {
                        ZStack {
                            ForEach(shuffledWords.indices.reversed(), id: \.self) { index in
                                CardView1(word: shuffledWords[index].text)
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
                            LikedWordBox(word: likedWordBoxes[index] ?? "")
                        }
                    }
                    .padding(.top, 50)
                    
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
                    .padding(.top, 20)
                    .padding(.bottom, 30)
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
            .onAppear {
                shuffledWords = dataManager.words.shuffled()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var timerString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimerIfNeeded() {
        if !isTimerRunning {
            isTimerRunning = true
            timeRemaining = 60
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


struct try_RandomWords2: View {
    var likedWords: [String]
    @State private var enteredValues: [String]
    @State private var selectedWord: String?
    @State private var showCheckmarks: Bool = false
    @State private var showNextButton: Bool = false
    @State private var navigateToSummary: Bool = false
    @State private var isTimerRunning = false
    @State private var timeRemaining = 120
    @State private var checkedIndex: Int? = nil  // Optional Int to keep track of which checkbox is checked

    @Environment(\.colorScheme) var colorScheme
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(likedWords: [String]) {
        self.likedWords = likedWords
        self._enteredValues = State(initialValue: Array(repeating: "", count: likedWords.count))
    }

    var isNextStepButtonEnabled: Bool {
        return enteredValues.allSatisfy { !$0.isEmpty } && checkedIndex != nil
    }

    var isNextButtonEnabled: Bool {
        return selectedWord != nil
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.gray1
                    .ignoresSafeArea()

                Image("backgrund")
                    .resizable()
                    .frame(width: 400, height: 150)
                    .padding(.bottom, 750)

                Spacer()
                ScrollView {
                    VStack {
                        Text("Random Word")
                            .font(.system(size: 29, weight: .semibold))
                            .padding(.top, 95)
                            .padding(.trailing, 170)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                        
                        Text(timerString)
                            .font(.system(size: 60, weight: .bold))
                            .padding(.top, 25)
                            .padding(.bottom, 20)
                            .onReceive(timer) { _ in
                                if isTimerRunning {
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    } else {
                                        navigateToSummary = true
                                        isTimerRunning = false
                                    }
                                }
                            }
                        
                        
                        Text("Place these words into possible ideas or solutions:")
                            .font(.system(size: 17, weight: .medium))
                            .padding(.bottom, 30)
                            .padding(.trailing, 50)
                        
                        
                        VStack {
                            ForEach(0..<likedWords.count, id: \.self) { index in
                                VStack(alignment: .leading) {
                                    //                                    Text(likedWords[index])
                                    //                                        .font(.system(size: 18))
                                    HStack{
                                        Text("First word:")
                                            .font(.system(size: 15))
                                            .padding(.bottom, 10)
                                            .padding(.leading, 50)
                                            .foregroundColor(.gray)
                                        Text(likedWords[index])
                                            .font(.system(size: 15))
                                            .padding(.bottom, 10)
                                            .padding(.leading, 5)
                                            .foregroundColor(.gray)
                                    }
                                    HStack {
                                        
                                        Image(systemName: selectedWord == likedWords[index] ? "checkmark.circle.fill" : "circle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.button)
                                            .onTapGesture {
                                                selectedWord = likedWords[index]
                                            }
                                        TextField("Enter a value", text: $enteredValues[index])
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .onChange(of: enteredValues[index]) { newValue in
                                                startTimerIfNeeded()
                                            }
                                    }.padding(.trailing,20)
                                        .padding(.leading,20)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        VStack{
                            
                            Text("* check mark the word that resonates with you the most.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                            
                            
                        } .padding(.top, 100)
                        Button(action: {
                            navigateToSummary = selectedWord != nil
                        }) {
                            Text("Next Step")
                                .font(.system(size: 18))
                                .padding()
    //                            .background(likedWords.count >= 3 ? Color.orange : Color.gray)
                                .frame(width: 337, height: 39)
                                .background(Color.button)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .opacity(selectedWord != nil ? 1.0 : 0.5)
                                .disabled(selectedWord == nil)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 30)
                        
                        if selectedWord != nil {
                            NavigationLink(
                                destination: RWSummary(
                                    texts: [""],
                                    selectedWord: selectedWord,
                                    enteredValue: enteredValues[likedWords.firstIndex(of: selectedWord ?? "") ?? 0]
                                ),
                                isActive: $navigateToSummary
                            ) {
                               EmptyView()
                            }
                        }}
                }
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    isTimerRunning = false
                    navigateToSummary = true
                }
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
        if !isTimerRunning {
            isTimerRunning = true
            timeRemaining = 120
        }
    }
}

struct try_RandomWords2_Previews: PreviewProvider {
    static var previews: some View {
        let likedWords: [String] = ["Idea 1", "Idea 2", "Idea 3"]
        return try_RandomWords2(likedWords: likedWords)
            .environmentObject(DataManager()) // If you use EnvironmentObject
    }
}

struct CardView1: View {
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

struct LikedWordBox: View {
    var word: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 1)
            .frame(width: 100, height: 50)
            .background(Color.white1)
            .overlay(
                Text(word)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            )
    }
}


struct RWSummary: View {
@State private var showAllTexts = false
@State private var additionalTexts: [String] = []
var texts: [String]
var selectedWord: String?
var enteredValue: String
    @Environment(\.colorScheme) var colorScheme

var body: some View {
NavigationStack{
    ZStack{
        
        Color.gray1
            .ignoresSafeArea()

        Image("backgrund")
            .resizable()
            .frame(width: 400, height: 150)
            .padding(.bottom, 800)
        
        VStack {
            Text("Activity Summery")
                .font(.system(size: 29, weight: .semibold))
                .frame(width: 250)
                .padding(.bottom,680)
                .padding(.trailing, 120)
                .foregroundColor(colorScheme == .dark ? .black : .white)
        }
        
        ScrollView{(
            
            VStack{
                
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .frame(width: 351,height: 132).overlay(
                            HStack{
                                
                                Image(systemName: "lightbulb.min")
                                    .resizable()
                                    .frame(width: 41 , height: 53)
                                    .foregroundColor(.orange1)
                                VStack{
                                    
                                    if let selectedWord = selectedWord {
                                        Text(" Through your experience, you have come to big idea: \(selectedWord) ")
                                            .font(.system(size: 12, weight: .regular))
                                            .multilineTextAlignment(.leading)
                                            .padding(.horizontal)
                                    }}
                            } .padding(.horizontal)
                        )
                        .padding()
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .frame(width: 361,height: 132)
                        .overlay(
                            HStack{
                                Image(systemName: "doc.text")
                                    .resizable()
                                    .frame(width: 41 , height: 53)
                                    .foregroundColor(.orange1)
                                
                                VStack{
                                    Text("Your statement: ")
                                        .font(.system(size: 12, weight: .regular))
//                                    Text("\(enteredValue)")
//                                        .frame(width: 300 )
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
//                                    .padding()
                                }.padding()
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
                                
                            }.padding(.horizontal)
                        )
                    
                    ZStack{
                                           RoundedRectangle(cornerRadius: 10)
                                               .foregroundColor(.white)
                                               .shadow(radius: 3)
                                               .frame(width: 361,height: 200)
                                               .padding()
                                           VStack{
                                               HStack{
                                                   Image(systemName: "checkmark.circle")
                                                       .resizable()
                                                       .frame(width: 53 , height: 53)
                                                       .foregroundColor(.orange1)
                                                       .padding(.horizontal)
                                                   
                                                   Text("Fantastic work on sparking your big idea! Are you ready to dive even deeper and expand your creative horizons? ")
                                                       .font(.callout)
                                                       .bold()
                                                       .padding()
                                               }
                                               VStack{
                                                   Text("Let's keep the momentum going try the other technique, it will enhance your ability to think outside the box and refine your concepts.")
                                                       .font(.caption)
                                                      // .padding(.horizontal)
                                               }
                                           }
                                       } .padding(.horizontal)

                }
                NavigationLink(destination: HomePage()){
                    
                    
                    Rectangle()
                        .frame(width: 337 , height: 39)
                        .cornerRadius(5)
                        .foregroundColor(.laitOrange)
                    Text("done")
                        .foregroundColor(.white)
                    
                }
                
            }.padding(.top , 200)
            
            // }
            
        )}}
}.navigationBarBackButtonHidden(true)
}
}
struct try_ReverseBrainstorming: View {
    struct TopLeadingTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .multilineTextAlignment(.leading)
                .padding(.leading) // Push text to the left
                .padding(.bottom, 40) // Push text to the top
        }
    }

    @State private var statement = ""
    @State public var answer1: String = ""
    @State public var Answer2: String = ""
    @State public var Answer3: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray1.ignoresSafeArea()
                VStack {
                    ZStack {
                        Image("backgrund")
                            .resizable()
                            .overlay(
                                Text("Revers Brainstorming")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.trailing, 120)
                                    .padding(.top, 70)
                            )
                            .frame(width: 400, height: 150)
                    }

                    VStack {
                        Text("Enter your problem statements:")
                            .padding(.trailing, 100)

                        ZStack(alignment: .topLeading) {
                            TextField("EX: Improving the COVID-19 Vaccination Process ", text: $statement)
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .textFieldStyle(TopLeadingTextFieldStyle())
                                .padding()
                        }

                        Text("How can you make it worse?")
                            .padding(.trailing, 100)

                        ZStack {
                            Rectangle()
                                .frame(width: 343, height: 82)
                                .cornerRadius(10)
                                .foregroundColor(.orange2)
                            ZStack(alignment: .topLeading) {
                                TextField("Not Scaling up vaccine manufacturing ", text: $answer1)
                                    .font(.caption)
                                    .frame(width: 322, height: 63)
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .textFieldStyle(TopLeadingTextFieldStyle())
                                    .padding()
                            }
                        }
                    }
                    .padding(.top, 40)

                    ZStack {
                        Rectangle()
                            .frame(width: 343, height: 82)
                            .cornerRadius(10)
                            .foregroundColor(.orange3)
                        ZStack(alignment: .topLeading) {
                            TextField("Delaying vaccination for adults above the age of 65", text: $Answer2)
                                .font(.caption)
                                .frame(width: 322, height: 63)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .textFieldStyle(TopLeadingTextFieldStyle())
                                .padding()
                        }
                    }

                    ZStack {
                        Rectangle()
                            .frame(width: 343, height: 82)
                            .cornerRadius(10)
                            .foregroundColor(.orange4)
                        ZStack(alignment: .topLeading) {
                            TextField("To not prioritize vaccination in areas with rising cases", text: $Answer3)
                                .font(.caption)
                                .frame(width: 322, height: 63)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .textFieldStyle(TopLeadingTextFieldStyle())
                                .padding()
                        }
                    }

                    NavigationLink(destination: ReversAnswers(statement: statement, answer1: $answer1, answer2: $Answer2, answer3: $Answer3)) {
                        ZStack {
                            Rectangle()
                                .frame(width: 337, height: 39)
                                .cornerRadius(5)
                                .foregroundColor(isNextButtonEnabled() ? .laitOrange : .gray)
                            Text("Next")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 50)
                    }
                    .disabled(!isNextButtonEnabled())
                }
                .padding(.bottom, 110)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func isNextButtonEnabled() -> Bool {
        return !statement.isEmpty && !answer1.isEmpty && !Answer2.isEmpty && !Answer3.isEmpty
    }
}
    
struct ReversAnswers: View {
    
    struct TopLeadingTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .multilineTextAlignment(.leading)
                .padding(.leading)
                .padding(.bottom, 40)
        }
    }

    var statement: String
    @State public var Answer4 = ""
    @State public var Answer5 = ""
    @State public var Answer6 = ""
    @Binding var answer1: String
    @Binding var answer2: String
    @Binding var answer3: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray1.ignoresSafeArea()
                VStack {
                    ZStack {
                        Image("backgrund")
                            .resizable()
                            .overlay(
                                Text("Revers Brainstorming")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.trailing, 120)
                                    .padding(.top, 70)
                            )
                            .frame(width: 400, height: 150)
                    }
                    
                    Text("Revers your answers:")
                        .padding(.trailing, 175)
                        .padding()
                    
                    Text("First Answer: \(answer1)")
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.trailing, 175)
                        .padding()
                    
                    ZStack(alignment: .topLeading) {
                        TextField("Scaling up vaccine manufacturing ", text: $Answer4)
                            .font(.caption)
                            .frame(width: 331, height: 58)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .textFieldStyle(TopLeadingTextFieldStyle())
                            .padding()
                    }
                    
                    Text("Second Answer: \(answer2)")
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.trailing, 175)
                        .padding()
                    
                    ZStack(alignment: .topLeading) {
                        TextField("Speeding up vaccination for adults above the age of 65", text: $Answer5)
                            .font(.caption)
                            .frame(width: 331, height: 58)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .textFieldStyle(TopLeadingTextFieldStyle())
                            .padding()
                    }
                    .padding()
                    
                    Text("Third Answer: \(answer3)")
                        .foregroundColor(.gray)
                        .bold()
                        .padding(.trailing, 175)
                        .padding()
                    
                    ZStack(alignment: .topLeading) {
                        TextField("Prioritize vaccination in areas with rising cases", text: $Answer6)
                            .font(.caption)
                            .frame(width: 331, height: 58)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .textFieldStyle(TopLeadingTextFieldStyle())
                            .padding()
                    }
                    
                    NavigationLink(destination: ReversAnswers2(answer4: $Answer4, answer5: $Answer5, answer6: $Answer6)) {
                        ZStack {
                            Rectangle()
                                .frame(width: 337, height: 39)
                                .cornerRadius(5)
                                .foregroundColor(isNextButtonEnabled() ? .laitOrange : .gray)
                            Text("Next")
                                .foregroundColor(.white)
                        }
                        .padding(.top, 50)
                    }
                    .disabled(!isNextButtonEnabled())
                }
                .padding(.bottom, 110)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func isNextButtonEnabled() -> Bool {
        return !Answer4.isEmpty && !Answer5.isEmpty && !Answer6.isEmpty
    }
}
    
    
struct ReversAnswers2: View {
    struct TopLeadingTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .multilineTextAlignment(.leading)
                .padding(.leading)
                .padding(.bottom, 40)
        }
    }
    
    @State private var statement2 = ""
    @Binding var answer4: String
    @Binding var answer5: String
    @Binding var answer6: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.gray1.ignoresSafeArea()
                VStack {
                    ZStack {
                        Image("backgrund")
                            .resizable()
                            .overlay(
                                Text("Revers Brainstorming")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.trailing, 120)
                                    .padding(.top, 70)
                            )
                            .frame(width: 400, height: 150)
                    }
                    .padding(.bottom, 50)
                    
                    ZStack(alignment: .topLeading) {
                        Text("The Reversed Answers: \(answer4) \(answer5) \(answer6)")
                            .padding(.trailing, 90)
                            .padding(.bottom, 100)
                            .multilineTextAlignment(.leading)
                            .frame(width: 336, height: 156)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 150)
                    
                    VStack {
                        Text("How can we combine all the answers into a solution?")
                            .font(.callout)  // You can change the font size if needed
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)  // Ensure the text wraps and is not clipped
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)  // Ensure the VStack takes up available width
                    .padding()
                  //  .padding()
                   // .padding(.horizontal)
                    
                    ZStack(alignment: .topLeading) {
                        TextField("we can now analyze them to determine which ones to prioritize first", text: $statement2)
                            .font(.caption)
                            .font(.system(size: 3))
                            .frame(width: 331, height: 58)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .textFieldStyle(TopLeadingTextFieldStyle())
                            .padding()
                    }
                    .padding()
                    
                    NavigationLink(destination: ReverseBSum(texts: [""],statement2:statement2 )) {
                        ZStack {
                            Rectangle()
                                .frame(width: 337, height: 39)
                                .cornerRadius(5)
                                .foregroundColor(isNextButtonEnabled() ? .laitOrange : .gray)
                            Text("Next")
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(!isNextButtonEnabled())
                    .padding(.top, 50)
                }
                .padding(.bottom, 110)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func isNextButtonEnabled() -> Bool {
        return !statement2.isEmpty
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
                        ZStack {
                            Image("backgrund")
                                .resizable()
                                .overlay(
                                    Text("Activity Summery")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.trailing, 120)
                                        .padding(.top, 70)
                                )
                                .frame(width: 400, height: 150)
                                .offset(x: 0 , y: -90)
                        }
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                                .frame(width: 351,height: 132)
                            HStack{
                                
                                Image(systemName: "lightbulb.min")
                                    .resizable()
                                    .frame(width: 48 , height: 53)
                                    .foregroundColor(.orange1)
                                    .padding(.horizontal)
                                VStack{
                                    Text(" Research time :")
                                        .bold()
                                        .font(.title3)
                                       // .padding(.horizontal)
                                        .padding(.trailing , 105)
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
                                .padding()
                            HStack{
                                Image(systemName: "doc.text")
                                    .resizable()
                                    .frame(width: 41 , height: 53)
                                    .foregroundColor(.orange1)
                                    .padding(.horizontal)
                                
                                VStack{
                                    Text("Solution :")
                                        .font(.title3)
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
                                    } // .padding()
                                }
                                
                                
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                        }
               
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(radius: 3)
                                .frame(width: 361,height: 200)
                                .padding()
                            VStack{
                                HStack{
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 53 , height: 53)
                                        .foregroundColor(.orange1)
                                        .padding(.horizontal)
                                    
                                    Text("Fantastic work on sparking your big idea! Are you ready to dive even deeper and expand your creative horizons? ")
                                        .font(.callout)
                                        .bold()
                                        .padding()
                                }
                                VStack{
                                    Text("Let's keep the momentum going try the other technique, it will enhance your ability to think outside the box and refine your concepts.")
                                        .font(.caption)
                                       // .padding(.horizontal)
                                }
                            }
                        } .padding(.horizontal)
                        
                        NavigationLink(destination: HomePage()){
                            
                            ZStack{
                                Rectangle()
                                    .frame(width: 337 , height: 39)
                                    .cornerRadius(5)
                                    .foregroundColor(.laitOrange)
                                Text("done")
                                    .foregroundColor(.white)
                            }
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

struct try_RandomWords_Previews: PreviewProvider {
    static var previews: some View {
        try_RandomWords().environmentObject(DataManager())
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
