//
//  OnBording.swift
//  Eureka1
//
//  Created by NorahAlmukhlifi on 10/11/1445 AH.
//

import SwiftUI
import Lottie
struct OnbordingSteps {
    let Title : String
    let description : String
}

private let onbordingSteps = [
    OnbordingSteps( Title: "Welcome to Eureka 👋", description:"Designed specifically for creative thinkers, our platform offers unique techniques and tools to ignite your creativity. Whether you're working on a new project, tackling a problem, or simply looking to boost your creative thinking" ),
    OnbordingSteps( Title:"Welcome to Eureka 👋", description: "our app is your ultimate companion for inspiration and brainstorming. Dive in today and unleash your creative potential with us!")]



struct OnBording: View {
 @State private var currentStep = 0
    init(){
        UIScrollView.appearance().bounces = false
    }
    @State private var isOnbordingDone = false
    var body: some View {
        ZStack{
            Image("backgrund")
                .resizable()
                .frame(width: 395 , height: 411)
                .offset(x: 0, y: -235)
            LottieView(animation: .named("AnimationOnbording"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .resizable()
                .frame(width: 240)
                .offset(x: 0, y: -235)
             
            VStack{
                HStack{
                    Spacer()
                    Button(action:{
                        self.currentStep = onbordingSteps.count - 1
                        isOnbordingDone = true
                        
                    }){
                        Text("Skip")
                            .padding(16)
                            .foregroundColor(.black)
                    }
                }
            }.offset(x:0 , y: -350)
            
            
            if isOnbordingDone {
                NavigationLink(destination: HomePage(), isActive: $isOnbordingDone) {
                    EmptyView()
                }
             
            } else{
                TabView(selection: $currentStep){
                    ForEach(0..<onbordingSteps.count){ it in
                        VStack{
                            Text(onbordingSteps[it].Title)
                                .bold()
                                .padding(.top , 150)
                        
                            
                            Text(onbordingSteps[it].description)
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                            
                                .padding(.top)
                        }.tag(it)
                    }
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
                HStack{
                    ForEach(0..<onbordingSteps.count){
                        it in
                        if it == currentStep {
                            Rectangle()
                                .frame(width: 20 , height: 10)
                                .cornerRadius(10)
                                .foregroundColor(.orange1)
                        } else{
                            Circle()
                                .frame(width: 10 , height: 10)
                                .foregroundColor(.gray)
                        }
                    }
                }.padding(.top,500)
                
                
                Button(action:{
                    if self.currentStep < onbordingSteps.count - 1 {
                        self.currentStep += 1
                    } else{
                        isOnbordingDone = true
                    }
                    
                }) {
                    Text(currentStep < onbordingSteps.count - 1 ? "Next" : "Start Now")
                    
                        .frame(width: 337,height: 39)
                        .background(Color.laitOrange)
                        .cornerRadius(5)
                        .foregroundColor(.white)
                        .offset(x:0 , y: 300)
                    
                } .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    OnBording()
}
