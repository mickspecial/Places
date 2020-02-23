//
//  AddButton.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct AddButton: View {

	var size: CGFloat = 60
	@Binding var isShowing: Bool

	var body: some View {
		Button(action: {
			withAnimation {
				self.isShowing.toggle()
			}
		}) {
			Image(systemName: "plus.circle.fill")
				.resizable()
				.frame(width: size, height: size)
				.foregroundColor(Color.green)
				.background(Color.white)
				.clipShape(Circle())
		}
	}
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
		AddButton(isShowing: .constant(true))
			.previewLayout(.sizeThatFits)
    }
}
