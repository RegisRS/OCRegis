//
//  Apagar.swift
//  OCRegis
//
//  Created by Admin on 09/06/21.
//

import SwiftUI

struct Apagar : View {
    @State var image = NSImage(named: "image")
    @State private var dragOver = false

    var body: some View {
        HSplitView {
            Image(nsImage: image ?? NSImage())
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                .onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers -> Bool in
                    providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                        if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                            let image = NSImage(contentsOf: url)
                            DispatchQueue.main.async {
                                self.image = image
                            }
                        }
                    })
                    return true
                }
                .onDrag {
                    let data = self.image?.tiffRepresentation
                    let provider = NSItemProvider(item: data as NSSecureCoding?, typeIdentifier: kUTTypeTIFF as String)
                    provider.previewImageHandler = { (handler, _, _) -> Void in
                        handler?(data as NSSecureCoding?, nil)
                    }
                    return provider
                }
                .border(dragOver ? Color.red : Color.clear)
        }.padding()

    }
}
struct Apagar_Previews: PreviewProvider {
    static var previews: some View {
        Apagar()
    }
}
