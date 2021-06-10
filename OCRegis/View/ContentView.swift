//
//  ContentView.swift
//  OCRegis
//
//  Created by Admin on 09/06/21.
//

import SwiftUI

struct ContentView: View {
    @State var image = NSImage(named: "image")
    @State var dragOver = false

    var body: some View {
        HSplitView {
            List() {
                Section(header: Text("Imagem")) {
                    Image(nsImage: image ?? NSImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .focusable()
                        .onDrop(of: ["public.file-url"], isTargeted: $dragOver, perform: { provider in
                            print("Essa merda funcionou")
                            provider.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { data, error in
                                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                                    let image = NSImage(contentsOf: url)
                                    DispatchQueue.main.async {
                                        self.image = image
                                    }
                                }
                            })
                            return true
                        })
                }
            }
            
            List() {
                Section(header: Text("Texto Extraido")) {
                    TextEditor(text: .constant("Placeholder"))
                }
            }
            
        }
        .frame(minWidth: 500, idealWidth: 1000, maxWidth: .infinity, minHeight: 250, idealHeight: 500, maxHeight: .infinity, alignment: .center)
    }
}







struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


