//
//  ContentView.swift
//  OCRegis
//
//  Created by Admin on 09/06/21.
//

import SwiftUI
import Vision
struct ContentView: View {
    @State var image = NSImage(named: "Image-1")
    @State var dragOver = false
    @State var textoExtraido: Array<String> = []
    var body: some View {
        HSplitView {
            List() {
                Section(header: Text("Imagem")) {
                    Image(nsImage: image ?? NSImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .focusable()
                        .onDrop(of: ["public.file-url"], isTargeted: $dragOver, perform: { provider in
                            provider.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { data, error in
                                if let data = data, let path = NSString(data: data, encoding: 4), let url = URL(string: path as String) {
                                    let image = NSImage(contentsOf: url)
                                    DispatchQueue.main.async {
                                        self.image = image
                                        textoExtraido = []
                                        let request = VNRecognizeTextRequest { request, error in
                                            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                                                fatalError("Received invalid observations")
                                            }

                                            for observation in observations {
                                                guard let bestCandidate = observation.topCandidates(1).first else {
                                                    print("No candidate")
                                                    continue
                                                }
                                                textoExtraido.append(bestCandidate.string)
                                            }
                                        }
                                        
                                        let requests = [request]

                                        DispatchQueue.global(qos: .userInitiated).async {
                                            guard let img = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                                                fatalError("Missing image to scan")
                                            }

                                            let handler = VNImageRequestHandler(cgImage: img, options: [:])
                                            try? handler.perform(requests)
                                        }
                                    }
                                }
                            })
                            return true
                        })
                }
            }
            List() {
                Section(header: Text("Texto Extraido")) {
                    TextEditor(text: .constant(textoExtraido.joined(separator: "\n")))
                }
            }
        }
        .frame(minWidth: 500, idealWidth: 1000, maxWidth: .infinity, minHeight: 250, idealHeight: 500, maxHeight: .infinity, alignment: .center)
    }
}
