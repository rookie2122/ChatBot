//
//  ContentView.swift
//  ChatBot01
//
//  Created by Sena Çırak on 27.10.2024.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro",apiKey: APIKey.default)
    @State  var userInput = ""
    @State  var messages: [String] = ["How can i help you today?"]
    @State var isLoading = false
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack{
            Text("Gemini AI")
                .font(.largeTitle)
                .padding(.top)
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(messages,id:\.self) { message in
                        Text(message)
                            .padding()
                            .background(message.starts(with: "You:") ? Color.blue.opacity(0.5) : Color.indigo.opacity(0.5) )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(maxWidth: .infinity, alignment: message.starts(with: "You:") ? .trailing : .leading)
                            .transition(.move(edge: .trailing))
                        
                    }
                    if isLoading{
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(Color.purple, lineWidth: 5)
                            .frame(width: 30, height: 30)
                            .rotationEffect(Angle(degrees: rotation))
                            .animation(.linear(duration:1).repeatForever(autoreverses: false), value: rotation)
                            .onAppear {
                                rotation = 360
                            }
                            .padding()
                    }
                }
                .padding()
                
              
            }
            
            
            HStack{
                TextField("Type here...", text: $userInput)
                    .padding()
                    .background(Color.cyan.opacity(0.2),in:Capsule())
                    .autocorrectionDisabled()
                    .onSubmit {
                        sendmessage()
                    }
                    
                
                Button{
                    sendmessage()
                }label: {
                    Image(systemName: "paperplane")
                        .padding()
                        .background(Color.blue, in: Capsule())
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        
    }
    func sendmessage(){
        guard !userInput.isEmpty else { return }
        
        messages.append("You: \(userInput)")
        
        let currentInput = userInput
        userInput = ""
        isLoading = true
        
        Task {
            do {
                let result = try await model.generateContent(currentInput)
                let response = result.text ?? "No response found"
                messages.append("AI: \(response)")
            } catch {
                messages.append("AI: Something went wrong! \n\(error.localizedDescription)")
            }
            isLoading = false
        }
        
        
    }
}
  
#Preview {
    ContentView()
}

