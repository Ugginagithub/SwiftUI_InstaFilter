//
//  ContentView.swift
//  InstaFilterApp
//
//  Created by Tarun on 25/06/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
//    @State private var blurAmount = 0.0
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    //CoreImage varaibles
    @State private var image: Image?
    
    var body: some View {
        //        VStack{
        //            Text("Hello, world!")
        //                .blur(radius: blurAmount)
        //
        //            Slider(value:$blurAmount, in: 0...20)
        //                .onChange(of: blurAmount) {oldValue, newValue in //even if you write didset, it will not print the reqired amount everytime when we change.
        //                        print("New value blurAmount: \(newValue)")
        //                }
        //        }
        
        //        Button("Hello, world"){
        //            showingConfirmation.toggle()
        //        }
        //        .frame(width: 300, height: 300)
        //        .background(backgroundColor)
        //        .confirmationDialog("Change Background Color", isPresented: $showingConfirmation){
        //            Button("Red") { backgroundColor = Color.red }
        //            Button("Greeen") { backgroundColor = Color.green }
        //            Button("Blue") { backgroundColor = Color.blue }
        //            Button("Cancel", role: .cancel) {}
        //        } message: {
        //            Text("Select a new color.")
        //        }
        
        //MARK: CoreImage integrating
        //        VStack {
        //            image?
        //                .resizable()
        //                .scaledToFit()
        //        }
        //        .onAppear(perform: loadImage)
        
        //MARK: things to do when contentUnavailable
                ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any snippets"))

    }
    
    func loadImage() {
//        image = Image(.krishna)
        
        let inputImage = UIImage(resource: .krishna)
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.bloom()
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
