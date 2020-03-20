//
//  ContentView.swift
//  DevApp
//
//  Created by Andrew Lo on 2020-03-19.
//  Copyright © 2020 Andrew Lo. All rights reserved.
//

import SwiftUI

struct WebImage: Decodable, Hashable {
    var url: String
}

struct ArtImage: Decodable, Identifiable, Hashable {
    var id: String
    var title: String
    var webImage: WebImage
}

struct ArtImageResults: Decodable {
    public var artObjects: [ArtImage]
    
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @State private var dates = [Date]()
    @State private var artImages = [ArtImage]()
//    @State var movies = [Movie]()

    var body: some View {
        NavigationView {
            MasterView(dates: $dates, artImages: $artImages)
                .navigationBarTitle(Text("List"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { self.dates.insert(Date(), at: 0) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            DetailView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            .onAppear(perform: loadData)
    }

    func loadData() {
        print("load data!")
        let url = URL(string: "https://www.rijksmuseum.nl/api/en/collection?q=&key=pUaGTYo5&format=json")!
        
            URLSession.shared.dataTask(with: url) {(data,response,error) in
                do {
                    if let d = data {
                        let decoded = try JSONDecoder().decode(ArtImageResults.self, from: d)
                        DispatchQueue.main.async {
                            print("decoded", decoded)
                            self.artImages = decoded.artObjects
                        }
                    }else {
                        print("No Data")
                    }
                } catch {
                    print ("Error", error)
                }
                
            }.resume()
    }
}

struct MasterView: View {
    @Binding var dates: [Date]
    @Binding var artImages: [ArtImage]

    var body: some View {
        VStack() {
//            Button(action: {
//                print("button clicked!")
//            }) {
//                Text("Button")
//            }
//            List {
//                ForEach(dates, id: \.self) { date in
//                    NavigationLink(
//                        destination: DetailView(selectedDate: date)
//                    ) {
//                        Text("\(date, formatter: dateFormatter)")
//                    }
//                }.onDelete { indices in
//                    indices.forEach { self.dates.remove(at: $0) }
//                }
//            }
            if artImages.isEmpty {
                Text("Loading...")
            } else {
                
                List {
                    ForEach(artImages, id: \.self) { artImage in
                        Text("\(artImage.title)")
                            .font(.largeTitle)
                            .fontWeight(.ultraLight)
    //                        .foregroundColor(Color.orange)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .padding(.leading, 4.0)
                            
                    }
    //                .onDelete { indices in
    //                    indices.forEach { self.artImages.remove(at: $0) }
    //                }
                }
            }

        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        Group {
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
