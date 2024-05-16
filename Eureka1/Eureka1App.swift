//
//  Eureka1App.swift
//  Eureka1
//
//  Created by Noura Alqahtani on 16/05/2024.
//



import SwiftUI
import SwiftData
import Firebase
@main
struct Eureka1App: App {
@StateObject var dataManager = DataManager()

init() {
    FirebaseApp.configure()
}
var body: some Scene {
    WindowGroup {
        NavigationView{

            HomePage()
    }}
.modelContainer(for: DataItem.self) // Provide model container for DataItem
.environmentObject(dataManager)    }
}

