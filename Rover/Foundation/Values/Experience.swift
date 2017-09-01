//
//  Experience.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import Foundation

public struct Experience: Codable {
    public var id: ID
    public var homeScreen: Screen
    public var screens: [Screen]
}

// MARK: Background

public protocol Background {
    var backgroundColor: Color { get }
    var backgroundContentMode: BackgroundContentMode { get }
    var backgroundImage: Image? { get }
    var backgroundScale: BackgroundScale { get }
}

// MARK: BackgroundContentMode

public enum BackgroundContentMode: String, Codable {
    case original
    case stretch
    case tile
    case fill
    case fit
}

// MARK: BackgroundScale

public enum BackgroundScale: String, Codable {
    case x1
    case x2
    case x3
}

// MARK: BarcodeBlock

public struct BarcodeBlock: Block, Background, Border {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var barcodeScale: Int
    public var barcodeText: String
    public var barcodeFormat: BarcodeFormat
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var insets: Insets
    public var horizontalAlignment: HorizontalAlignment
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}

// MARK: BarcodeFormat

public enum BarcodeFormat: String, Codable {
    case qrCode
    case aztecCode
    case pdf417
    case code128
}

// MARK: Block

public protocol Block: Codable {
    var action: BlockAction? { get }
    var autoHeight: Bool { get }
    var experienceID: ID { get }
    var height: Length { get }
    var id: ID { get }
    var insets: Insets { get }
    var horizontalAlignment: HorizontalAlignment { get }
    var offsets: Offsets { get }
    var opacity: Double { get }
    var position: Position { get }
    var rowID: ID { get }
    var screenID: ID { get }
    var verticalAlignment: VerticalAlignment { get }
    var width: Length { get }
}

// MARK: BlockAction

public enum BlockAction: Codable {
    case goToScreen(experienceID: ID, screenID: ID)
    case openURL(url: URL)
    
    private enum CodingKeys: String, CodingKey {
        case typeName = "__typename"
    }
    
    private enum GoToScreenKeys: String, CodingKey {
        case experienceID = "experienceId"
        case screenID = "screenId"
    }
    
    private enum OpenURLKeys: String, CodingKey {
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try values.decode(String.self, forKey: .typeName)
        
        switch typeName {
        case "GoToScreenAction":
            let values = try decoder.container(keyedBy: GoToScreenKeys.self)
            let experienceID = try values.decode(ID.self, forKey: .experienceID)
            let screenID = try values.decode(ID.self, forKey: .screenID)
            self = .goToScreen(experienceID: experienceID, screenID: screenID)
        case "OpenUrlAction":
            let values = try decoder.container(keyedBy: OpenURLKeys.self)
            let url = try values.decode(URL.self, forKey: .url)
            self = .openURL(url: url)
        default:
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.typeName, in: values, debugDescription: "\(typeName) is not a valid action")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .goToScreen(experienceID, screenID):
            try container.encode("GoToScreenAction", forKey: .typeName)
            
            var goToScreenContainer = encoder.container(keyedBy: GoToScreenKeys.self)
            try goToScreenContainer.encode(experienceID, forKey: .experienceID)
            try goToScreenContainer.encode(screenID, forKey: .screenID)
        case let .openURL(url):
            try container.encode("OpenUrlAction", forKey: .typeName)
            
            var openURLContainer = encoder.container(keyedBy: OpenURLKeys.self)
            try openURLContainer.encode(url, forKey: .url)
        }
    }
}

// MARK: Border

public protocol Border {
    var borderColor: Color { get }
    var borderRadius: Int { get }
    var borderWidth: Int { get }
}

// MARK: ButtonBlock

public struct ButtonBlock: Block {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var disabled: ButtonState
    public var experienceID: ID
    public var height: Length
    public var highlighted: ButtonState
    public var horizontalAlignment: HorizontalAlignment
    public var id: ID
    public var insets: Insets
    public var normal: ButtonState
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var selected: ButtonState
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}

// MARK: ButtonState

public struct ButtonState: Background, Border, Text, Codable {
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var textAlignment: TextAlignment
    public var textColor: Color
    public var textFont: Font
    public var textValue: String
}

// MARK: Color

public struct Color: Codable {
    public var red: Int
    public var green: Int
    public var blue: Int
    public var alpha: Double
}

// MARK: Font

public struct Font: Codable {
    public var size: Int
    public var weight: FontWeight
}

// MARK: FontWeight

public enum FontWeight: String, Codable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case heavy
    case black
}

// MARK: HorizontalAlignment

public enum HorizontalAlignment: String, Codable {
    case center
    case left
    case right
    case fill
}

// MARK: Image

public struct Image: Codable {
    public var height: Int
    public var isURLOptimizationEnabled: Bool
    public var name: String
    public var size: Int
    public var width: Int
    public var url: URL
}

// MARK: ImageBlock

public struct ImageBlock: Block, Background, Border {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var image: Image?
    public var insets: Insets
    public var horizontalAlignment: HorizontalAlignment
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}

// MARK: Insets

public struct Insets: Codable {
    public var bottom: Int
    public var left: Int
    public var right: Int
    public var top: Int
}

// MARK: Length

public struct Length: Codable {
    public var unit: Unit
    public var value: Double
}

// MARK: Offsets

public struct Offsets: Codable {
    public var bottom: Length
    public var center: Length
    public var left: Length
    public var middle: Length
    public var right: Length
    public var top: Length
}

// MARK: Position

public enum Position: String, Codable {
    case stacked
    case floating
}

// MARK: RectangleBlock

public struct RectangleBlock: Block, Background, Border {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var insets: Insets
    public var horizontalAlignment: HorizontalAlignment
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}

// MARK: Row

public struct Row: Background, Codable {
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var blocks: [Block]
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var screenID: ID
    
    enum CodingKeys: String, CodingKey {
        case autoHeight
        case backgroundColor
        case backgroundContentMode
        case backgroundImage
        case backgroundScale
        case blocks
        case experienceID
        case height
        case id
        case screenID
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        autoHeight = try values.decode(Bool.self, forKey: .autoHeight)
        backgroundColor = try values.decode(Color.self, forKey: .backgroundColor)
        backgroundContentMode = try values.decode(BackgroundContentMode.self, forKey: .backgroundContentMode)
        backgroundImage = try values.decode(Image.self, forKey: .backgroundImage)
        backgroundScale = try values.decode(BackgroundScale.self, forKey: .backgroundScale)
        blocks = try values.decode([Block].self, forKey: .blocks)
        experienceID = try values.decode(ID.self, forKey: .experienceID)
        height = try values.decode(Length.self, forKey: .height)
        id = try values.decode(ID.self, forKey: .id)
        screenID = try values.decode(ID.self, forKey: .screenID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(autoHeight, forKey: .autoHeight)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(backgroundContentMode, forKey: .backgroundContentMode)
        try container.encode(backgroundImage, forKey: .backgroundImage)
        try container.encode(backgroundScale, forKey: .backgroundScale)
        try container.encode(blocks, forKey: .blocks)
        try container.encode(experienceID, forKey: .experienceID)
        try container.encode(height, forKey: .height)
        try container.encode(id, forKey: .id)
        try container.encode(screenID, forKey: .screenID)
    }
}

// MARK: Screen

public struct Screen: Background, Codable {
    public var autoColorStatusBar: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var experienceID: ID
    public var id: ID
    public var isStretchyHeaderEnabled: Bool
    public var rows: [Row]
    public var statusBarStyle: StatusBarStyle
    public var statusBarColor: Color
    public var titleBarBackgroundColor: Color
    public var titleBarButtons: TitleBarButtons
    public var titleBarButtonColor: Color
    public var titleBarText: String
    public var titleBarTextColor: Color
    public var useDefaultTitleBarStyle: Bool
}

// MARK: StatusBarStyle

public enum StatusBarStyle: String, Codable {
    case dark
    case light
}

// MARK: Text

public protocol Text {
    var textValue: String { get }
    var textAlignment: TextAlignment { get }
    var textColor: Color { get }
    var textFont: Font { get }
}

// MARK: TextAlignment

public enum TextAlignment: String, Codable {
    case center
    case left
    case right
}

// MARK: TextBlock

public struct TextBlock: Block, Background, Border, Text, Codable {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var insets: Insets
    public var horizontalAlignment: HorizontalAlignment
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var textAlignment: TextAlignment
    public var textColor: Color
    public var textFont: Font
    public var textValue: String
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}

// MARK: TitleBarButtons

public enum TitleBarButtons: String, Codable {
    case close
    case back
    case both
}

// MARK: Unit

public enum Unit: String, Codable {
    case points
    case percentage
}

// MARK: VerticalAlignment

public enum VerticalAlignment: String, Codable {
    case bottom
    case middle
    case fill
    case top
}

// MARK: WebViewBlock

public struct WebViewBlock: Block, Background, Border, Codable {
    public var action: BlockAction?
    public var autoHeight: Bool
    public var backgroundColor: Color
    public var backgroundContentMode: BackgroundContentMode
    public var backgroundImage: Image?
    public var backgroundScale: BackgroundScale
    public var borderColor: Color
    public var borderRadius: Int
    public var borderWidth: Int
    public var experienceID: ID
    public var height: Length
    public var id: ID
    public var insets: Insets
    public var isScrollingEnabled: Bool
    public var horizontalAlignment: HorizontalAlignment
    public var offsets: Offsets
    public var opacity: Double
    public var position: Position
    public var rowID: ID
    public var screenID: ID
    public var url: URL
    public var verticalAlignment: VerticalAlignment
    public var width: Length
}
