//
//  ExerciseFormKey.swift
//  Workout Planner
//
//  Details which exercise form type is assigned to which colour.
//

import SwiftUI

struct ExerciseFormKey: View {
    
    var formTypes: [String]
    var colours: [Color]
    
    var body: some View {
        
        HStack {
            ForEach(formTypes.indices, id: \.self) { i in
                Spacer()
                VStack {
                    
                    // Motion type name
                    Text(formTypes[i] == "Other" ? "Resting" : addSpaces(text: formTypes[i]))
                        .foregroundColor(.black)
                    
                    // Colour
                    Rectangle()
                        .fill(colours[formTypes.firstIndex(of: formTypes[i]) ?? 0])
                        .frame(width: 20, height: 20)
                        .cornerRadius(5)

                }
            }
            Spacer()
        }
        .padding([.top, .bottom])
        .background(Color.gray)
        .cornerRadius(10)
    }
}
