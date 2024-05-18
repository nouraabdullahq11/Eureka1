//
//  SplashScreen.swift
//  Eureka1
//
//  Created by NorahAlmukhlifi on 10/11/1445 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isActive {
            OnBording()
        } else {
            VStack{
                ZStack{
                    ZStack{
                        Image("Icon")
                            .resizable()
                            .frame(width: 119 , height: 180)
                        
                        Text("Eureka")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.orange1)
                            .padding(.top , 700)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.2)){
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
                    
                    
                    Image("image2")
                        .resizable()
                        .frame(width: 393,height: 69)
                        .scaledToFit()
                        .scaleEffect(y: 1.2 )
                    
                        .padding(.bottom,794)
                    
                    
                    Image("image1")
                        .resizable()
                        .frame(width: 393,height: 69)
                        .padding(.top,760)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
