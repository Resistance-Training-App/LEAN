//
//  StretchingControls.swift
//  StretchingControls
//
//  Main controls used when stretching (Navigate to the previous and next stretch).
//

import SwiftUI

struct StretchingControls: View {

    @State var showingAlert = false
    
    let stretches: [Stretch]
        
    var body: some View {
        HStack {
            
            // Return to the previous stretch.
            StretchingPrevious(stretches: stretches)

            Spacer()

            // Go to the next stretch.
            StretchingNext(stretches: stretches)
        }
    }
}
