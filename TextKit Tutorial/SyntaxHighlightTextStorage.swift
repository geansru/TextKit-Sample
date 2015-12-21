//
//  SyntaxHighlightTextStorage.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//

import Foundation
import UIKit

class SyntaxHighlightTextStorage: NSTextStorage {
    let backingStore = NSMutableAttributedString()
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
        
    }
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        print("\(__FUNCTION__) range: \(range) , withString: \(str) ")
        
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString: str)
        let length = str.characters.count - range.length
        edited([.EditedCharacters, .EditedAttributes], range: range, changeInLength: length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        print("\(__FUNCTION__) attrs: \(attrs), range: \(range)")
        
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        performReplacementsForRange(self.editedRange)
        super.processEditing()
    }
    
    func applyStylesToRange(searchRange: NSRange) {
        // 1. Create some fonts
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let boldDescription = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
        let boldFont = UIFont(descriptor: boldDescription, size: 0)
        let normalFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        // 2. Match items surrounded by asterisks
        let regexStr = "(\\*\\w+(\\s\\w+)*\\*)"
        let regex = try! NSRegularExpression(pattern: regexStr, options: NSRegularExpressionOptions.CaseInsensitive)
        let boldAttributes = [NSFontAttributeName: boldFont]
        let normalAttributes = [NSFontAttributeName: normalFont]
        
        // 3. Iterate over each match, making the text bold
        regex.enumerateMatchesInString(string, options: NSMatchingOptions.Anchored, range: searchRange) {
            (match: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            guard let matchRange = match?.rangeAtIndex(1) else { return }
            self.addAttributes(boldAttributes, range: matchRange)
            
            // 4. reset style to the original
            let maxRange = matchRange.location + matchRange.length
            if maxRange + 1 < self.length {
                self.addAttributes(normalAttributes, range: NSMakeRange(maxRange, 1))
            }
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(extendedRange)
    }
}