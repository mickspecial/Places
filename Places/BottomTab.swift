//
//  BottomTab.swift
//  Places
//
//  Created by Michael Schembri on 21/2/20.
//  Copyright © 2020 Michael Schembri. All rights reserved.
//

import SwiftUI

struct BottomTab: View {

	@Binding var selected: Int

	var body: some View {
		HStack {
			Spacer(minLength: 20)

			Button(action: { self.selected = 0 }) {
				Image(systemName: "list.dash")
					.foregroundColor(self.selected == 0 ? .red : .blue)
			}

			Spacer(minLength: 20)

			Button(action: { self.selected = 1 }) {
				Image(systemName: "map.fill")
					.foregroundColor(self.selected == 1 ? .red : .blue)
			}

//			Spacer(minLength: 20)
//
//			Button(action: { self.selected = 2 }) {
//				Image(systemName: "location")
//					.foregroundColor(self.selected == 2 ? .red : .blue)
//			}

			Spacer(minLength: 20)
		}
		.font(.system(size: 30, weight: .medium))
		.padding(.vertical, 18)
	}
}

struct BottomTab_Previews: PreviewProvider {
    static var previews: some View {
		BottomTab(selected: .constant(1))
			.previewLayout(.sizeThatFits)
    }
}
