//
//  Apagar1.swift
//  OCRegis
//
//  Created by Admin on 11/06/21.
//

import SwiftUI
import Vision

struct Apagar1: View {
    //@State var image = NSImage(named: "Image-1")
    @State var image = NSImage(named: "Image-1")
    @State var dragOver = false
    @State var test: Array<String> = []
    

    var body: some View {
        HSplitView {
            List(){
                Section(header: Text("Imagem")) {
                    Image(nsImage: image ?? NSImage())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .focusable()
                }
            }
            List() {
                Section(header: Text("Texto Extraido")) {
                    Button(action: {
                        
                        let request = VNRecognizeTextRequest { request, error in
                            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                                fatalError("Received invalid observations")
                            }

                            for observation in observations {
                                guard let bestCandidate = observation.topCandidates(1).first else {
                                    print("No candidate")
                                    continue
                                }

                                //print("Found this candidate: \(bestCandidate.string)")
                                test.append(bestCandidate.string)
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
                        
                        
                        //print(test)
                        
                        
                        
                        
                        //requests = [requere()]
                        

                        //textoExtaido = exaIma(requisitos: requests, image: image)
           
                                                
                    }, label: {
                        Text("Imagem > Texto")
                            .frame(maxWidth: 100, maxHeight: 24)
 
                    })
                    .buttonStyle(BlueButtonStyle())
                    
                    TextEditor(text: .constant(test.joined(separator: "\n")))
                }
            }
        }
        .frame(minWidth: 500, idealWidth: 1000, maxWidth: .infinity, minHeight: 250, idealHeight: 500, maxHeight: .infinity, alignment: .center)
    }
}




//Função que define estilo do botão. Não funciona direto.
struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(6.0)
            .padding()
    }
}

//Funcção para reconhecer o texto
func requere() -> VNRecognizeTextRequest {
    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            fatalError("Received invalid observations")
        }
        
        

        for observation in observations {
            guard let bestCandidate = observation.topCandidates(1).first else {
                print("No candidate")
                continue
            }

            print("Found this candidate: \(bestCandidate.string)")
        }
    }
    return request

}

func exaIma(requisitos: [VNRecognizeTextRequest], image: NSImage? ) -> String {//
    DispatchQueue.global(qos: .userInitiated).async {
        guard let img = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            fatalError("Missing image to scan")
        }

        let handler = VNImageRequestHandler(cgImage: img, options: [:])
        try? handler.perform(requisitos)
    }
    
    return ""
}






struct Apagar1_Previews: PreviewProvider {
    static var previews: some View {
        Apagar1()
    }
}
