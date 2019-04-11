//
//  Theme.swift
//  Places
//
//  Created by Michael Schembri on 11/4/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

enum Theme {
	static var current: ThemeProtocol = Default()
}

protocol ThemeProtocol {
	var themeName: String { get }
	var primary: UIColor { get }
	var primaryDark: UIColor { get }
	var cellDark: UIColor { get }
}

struct Default: ThemeProtocol {
	let themeName: String = "Dark"
	let primary = UIColor(r: 68, g: 65, b: 69)
	let primaryDark = UIColor(r: 49, g: 47, b: 47)
	let cellDark = UIColor(r: 54, g: 52, b: 54)
}

extension UIColor {

	convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
		assert(r >= 0 && r <= 255, "Invalid red component")
		assert(g >= 0 && g <= 255, "Invalid green component")
		assert(b >= 0 && b <= 255, "Invalid blue component")
		self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
	}

	convenience init(netHex: Int) {
		self.init(r: (netHex >> 16) & 0xff, g: (netHex >> 8) & 0xff, b: netHex & 0xff)
	}

	enum FlatColor {
		enum Green {
			static let Fern = UIColor(netHex: 0x6ABB72)
			static let MountainMeadow = UIColor(netHex: 0x3ABB9D)
			static let ChateauGreen = UIColor(netHex: 0x4DA664)
			static let PersianGreen = UIColor(netHex: 0x2CA786)
		}

		enum Blue {
			static let PictonBlue = UIColor(netHex: 0x5CADCF)
			static let Mariner = UIColor(netHex: 0x3585C5)
			static let CuriousBlue = UIColor(netHex: 0x4590B6)
			static let Denim = UIColor(netHex: 0x2F6CAD)
			static let Chambray = UIColor(netHex: 0x485675)
			static let BlueWhale = UIColor(netHex: 0x29334D)
			static let LapisLazuli  = UIColor(netHex: 0x1F4788)
			static let JellyBean = UIColor(r: 42, g: 117, b: 187)
			static let Jordy = UIColor(r: 139, g: 197, b: 242)
			static let Fountain = UIColor(r: 94, g: 152, b: 189)
			static let Hoki  = UIColor(netHex: 0x67809f)
		}

		enum Violet {
			static let Wisteria = UIColor(netHex: 0x9069B5)
			static let BlueGem = UIColor(netHex: 0x533D7F)
		}

		enum Yellow {
			static let Energy = UIColor(netHex: 0xF2D46F)
			static let Turbo = UIColor(netHex: 0xF7C23E)
		}

		enum Orange {
			static let NeonCarrot = UIColor(netHex: 0xF79E3D)
			static let Sun = UIColor(netHex: 0xEE7841)
		}

		enum Red {
			static let TerraCotta = UIColor(netHex: 0xE66B5B)
			static let Valencia = UIColor(netHex: 0xCC4846)
			static let Cinnabar = UIColor(netHex: 0xDC5047)
			static let WellRead = UIColor(netHex: 0xB33234)
		}

		enum Gray {
			static let AlmondFrost = UIColor(netHex: 0xA28F85)
			static let WhiteSmoke = UIColor(netHex: 0xEFEFEF)
			static let Iron = UIColor(netHex: 0xD1D5D8)
			static let IronGray = UIColor(netHex: 0x75706B)
			static let Clouds = UIColor(netHex: 0xECF0F1)
			static let SilverSand = UIColor(netHex: 0xbdc3c7)
			static let OuterSpace = UIColor(netHex: 0x2e3131)
			static let Shark = UIColor(netHex: 0x24252a)
			static let PencilLead = UIColor(netHex: 0x596275)
		}
	}
}
