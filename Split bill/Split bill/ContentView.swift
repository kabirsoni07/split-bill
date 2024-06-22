//
//  ContentView.swift
//  Split bill
//
//  Created by Kabir Soni  on 30/01/23.
//

import SwiftUI

struct ContentView: View {
    @State  var totalcost = ""
    @State var other = ""
    @State  var people = 1
    @State private var index = 0
//    @State private var nameOfthebill = [ "Restaurant Bill",
//                                         "Movie Ticket",
//                                         "Fast Food Bill",
//                                         "Electricity Bill",
//                                         "Rent Payment Bill",
//                                         "Internet Bill",
//                                         "Groceries Bill",
//                                         "Trip Cost",
//                                         "Maintenance Bill",
//                                         "Other Bill"]
    @State private var isShareSheetPresented = true
    
    func cost() -> Double  {
        _ = String((Double(totalcost) ?? 0) / (Double(people) ) )
        return (Double(totalcost) ?? 0) / (Double(people) )
        
    }
    
   
    
    // for pdf
    
    func generatePDFData() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "My App",
            kCGPDFContextAuthor: "My Name"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pdfData = NSMutableData()
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 2,  width: 210, height: 297), format: format)
        
        
        let text = """
            
            
                                           || जय श्री राम ||
            
            Total Amount: \(totalcost)
            
            Current Date: \(formattedDate())
            
            Bill Type: \(other)
            
            Number Of People: \(people)
            
            Total Amount Per Person: \(cost())
                  
            ******************* Thank You ****************
            
            
            """
        
        // for pdf to print
        let pdf = renderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8)
            ]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: CGRect(x: 0, y: 0, width: 500, height: 500))
        }
        
        pdfData.append(pdf)
        
        return pdfData as Data
    }
    
   
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text ("Enter Amount(₹)")) {
                    TextField("Amount", text: $totalcost).keyboardType(.decimalPad)
                }
//                Section(header: Text("which kind of bill"))
//                {
//                    Picker(selection: $index, label: Text("Bill Type")) {
//                        ForEach(0 ..< 10) {
//                            Text(self.nameOfthebill[$0])
//                        }
//                    }
//                }
                
                Section(header: Text("Which Kind Of bill")){
                    TextField("Define Bill",text: $other).keyboardType(.alphabet)
                }
                Section(header: Text("How Many Person")) {
                    Picker("Number Of Person", selection: $people){
                        ForEach(0..<50){
                            Text("\($0) Person")
                                .bold()
                        }
                    }
                }
                
                Section(header: Text("Total Per Person")) {
                    Text("₹ \(cost(), specifier: "%.2f" ) ")
                        .foregroundColor(Color.red)
                        .bold()
                }
                
                Button("Share As PDF") {
                    isShareSheetPresented = true
                        
                }
                
                Text("\t\t\t\tThank You")
                    .bold().foregroundColor(Color.green)
                
               
                
                
            } .navigationTitle("Split Bill")
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .navigationViewStyle(StackNavigationViewStyle()) // Use for iPhone
                .navigationViewStyle(DoubleColumnNavigationViewStyle()) // Use for iPad
        } .padding(.all)
        
            .sheet(isPresented: $isShareSheetPresented) {
                // Use the ShareSheet to present the share options
                ShareSheet(activityItems: [generatePDFData()], applicationActivities: nil)
                
            }
            
    }
    
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Function to format the current date as a string
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

