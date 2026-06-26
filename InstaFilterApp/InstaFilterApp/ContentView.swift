//
//  ContentView.swift
//  InstaFilterApp
//
//  Created by Tarun on 25/06/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins

import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
//    @State private var blurAmount = 0.0
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    
    //CoreImage varaibles
    @State private var image: Image?
    
    //PhotosUI varaibles
//    @State private var pickerItems = [PhotosPickerItem]()
//    @State private var selectedImage = [Image]()
    
    //StoreKit for review and rating
    @Environment(\.requestReview) var requestReview
    
    //Actual Apps varaibles
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedImage: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    @State private var showingFilters = false
    @AppStorage("filterCount") var filterCount = 0
    
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
//                ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any snippets"))

        
        //MARK: PhotosUI
//        VStack{
//            PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .images){
//                Label("Select an image", systemImage: "photo")
//            }
//            
//            ForEach(0..<selectedImage.count, id: \.self) { i in
//                    selectedImage[i]
//                        .resizable()
//                        .scaledToFit()
//            }
//        }
//        .onChange(of: pickerItems){
//            Task{
//                selectedImage.removeAll()
//                
//                for item in pickerItems{
//                    if let loadedImage = try await item.loadTransferable(type: Image.self){
//                        selectedImage.append(loadedImage)
//                    }
//                }
//            }
//        }
        
        //MARK: ShareLink
//        ShareLink(item:URL(string: "https://www.apple.com")!){
//            Label("Apple share", systemImage: "swift")
//        }
        
        //Now sharing images
//        let exampleImage = Image(.krishna)
//        ShareLink(item: exampleImage, preview: SharePreview("Kirshna Photo", image: exampleImage)){
//            Label("Click to share", systemImage: "airplane")
//        }
        
        //MARK: StoreKIT, requesting the review.
//        Button("Leave a review"){
//            requestReview()
//        }
        
        //MARK: Bulding actual app.
        NavigationStack{
            VStack{
                Spacer()
                
                PhotosPicker(selection: $selectedImage){
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    }else {
                        ContentUnavailableView("No photo", systemImage: "photo.badge.plus", description: Text("Tap to import images."))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImage, loadImage)
                
                Spacer()
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                
                HStack{
                    Button("Change Filter", action: changeFilter)
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("InstaFilter image",image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Insta Filter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters){
                Button("Crystallize") { setFilter(CIFilter.crystallize() )}
                Button("Edges") { setFilter(CIFilter.edges() )}
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur() )}
                Button("Pixellate") { setFilter(CIFilter.pixellate() )}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone() )}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask() )}
                Button("Vignette") { setFilter(CIFilter.vignette() )}
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    //MARK: CoreImage requirement(This function is implemented only when CoreImage is implemented.)
//    func loadImage() {
////        image = Image(.krishna)
//        
//        let inputImage = UIImage(resource: .krishna)
//        let beginImage = CIImage(image: inputImage)
//        
//        let context = CIContext()
//        let currentFilter = CIFilter.bloom()
//        
//        currentFilter.inputImage = beginImage
//        currentFilter.intensity = 1
//        
//        guard let outputImage = currentFilter.outputImage else { return }
//        
//        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
//        
//        let uiImage = UIImage(cgImage: cgImage)
//        image = Image(uiImage: uiImage)
//    }
    
    
    //Actual app's functions.
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            
            guard let imageInput = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: imageInput)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
        
    }
    
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()

        filterCount += 1

        if filterCount >= 3 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
