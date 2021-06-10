//
//  Apagar2.swift
//  OCRegis
//
//  Created by Admin on 09/06/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct Apagar2: View {
    @State private var pastedText: String = ""
    let plainTextUTIIdentifier = UTType.utf8PlainText.identifier

    var body: some View {
        HStack {
            PasteButton(
                supportedContentTypes: [.utf8PlainText]
             ) { itemProviders in
                itemProviders.first(where: {
                                        $0.hasItemConformingToTypeIdentifier(
                                            plainTextUTIIdentifier)})?
                    .loadDataRepresentation(forTypeIdentifier:
                                                plainTextUTIIdentifier) { data, _ in
                        if let data = data,
                           let string = String(data: data, encoding: .utf8) {
                            pastedText = string
                        }
                    }
            }
            Divider()
            Text(pastedText)
            Spacer()
        }
    }
}



