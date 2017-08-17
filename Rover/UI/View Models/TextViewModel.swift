//
//  TextViewModel.swift
//  Rover
//
//  Created by Sean Rucker on 2017-08-17.
//  Copyright © 2017 Rover Labs Inc. All rights reserved.
//

import UIKit

protocol TextViewModel {
    var textModel: Text { get }
    var attributedText: NSAttributedString? { get }
}

extension TextViewModel {
    
    var boldFontWeight: UIFont.Weight {
        switch textModel.textFont.weight {
        case .ultraLight:
            return UIFont.Weight.regular
        case .thin:
            return UIFont.Weight.medium
        case .light:
            return UIFont.Weight.semibold
        case .regular:
            return UIFont.Weight.bold
        case .medium:
            return UIFont.Weight.heavy
        case .semiBold, .bold, .heavy, .black:
            return UIFont.Weight.black
        }
    }
    
    var font: UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    var fontSize: CGFloat {
        return CGFloat(textModel.textFont.size)
    }
    
    var fontWeight: UIFont.Weight {
        switch textModel.textFont.weight {
        case .ultraLight:
            return UIFont.Weight.ultraLight
        case .thin:
            return UIFont.Weight.thin
        case .light:
            return UIFont.Weight.light
        case .regular:
            return UIFont.Weight.regular
        case .medium:
            return UIFont.Weight.medium
        case .semiBold:
            return UIFont.Weight.semibold
        case .bold:
            return UIFont.Weight.bold
        case .heavy:
            return UIFont.Weight.heavy
        case .black:
            return UIFont.Weight.black
        }
    }
    
    var paragraphStyle: NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        return paragraphStyle
    }
    
    var text: String {
        return textModel.textValue
    }
    
    var textAlignment: NSTextAlignment {
        switch textModel.textAlignment {
        case .center:
            return .center
        case .left:
            return .left
        case .right:
            return .right
        }
    }
    
    var textColor: UIColor {
        return textModel.textColor.uiColor
    }
    
    var attributedText: NSAttributedString? {
        guard let data = textModel.textValue.data(using: String.Encoding.unicode) else {
            return nil
        }
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        guard let attributedString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        let range = NSMakeRange(0, attributedString.length)
        
        // Bold and italicize
        
        attributedString.enumerateAttribute(NSAttributedStringKey.font, in: range, options: []) { (value, range, stop) in
            guard let value = value as? UIFont else {
                return
            }
            
            let traits = value.fontDescriptor.symbolicTraits
            
            let size = fontSize
            let weight = traits.contains(.traitBold) ? boldFontWeight : fontWeight
            var font = UIFont.systemFont(ofSize: size, weight: weight)
            
            if traits.contains(.traitItalic) {
                let descriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic)!
                font = UIFont(descriptor: descriptor, size: size)
            }
            
            attributedString.removeAttribute(NSAttributedStringKey.font, range: range)
            attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        }
        
        let attributes = [NSAttributedStringKey.foregroundColor: textColor,
                          NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        attributedString.addAttributes(attributes, range: range)
        
        // Remove double newlines at end of string
        
        let string = attributedString.string
        if attributedString.length > 0 && string.substring(from: string.characters.index(string.endIndex, offsetBy: -1)) == "\n" {
            attributedString.replaceCharacters(in: NSMakeRange(attributedString.length - 1, 1), with: "")
        }
        
        return attributedString
    }
}
