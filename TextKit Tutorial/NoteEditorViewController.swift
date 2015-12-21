//
//  NoteEditorViewController.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//


import UIKit

class NoteEditorViewController: UIViewController {

    // MARK: Public properties
    var textView: UITextView!
    var textStorage: SyntaxHighlightTextStorage!
    var note: Note!
    var timeView: TimeIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.sharedManager.notifyOnSizeChanged(self)
        createTextView()
        timeView = TimeIndicatorView(date: note.timestamp)
        textView.addSubview(timeView)
    }
    
    override func viewDidLayoutSubviews() {
        updateTimeIndicatorFrame()
    }
    
    // MARK: Helper
    private func createTextView() {
        // 1. Create the text storage that backs to the editor
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attrsString  = NSAttributedString(string: note.contents, attributes: attrs)
        textStorage = SyntaxHighlightTextStorage()
        textStorage.appendAttributedString(attrsString)
        
        let newTextViewBounds = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        
        // 3. Create text container
        let containerSize = CGSize(width: newTextViewBounds.width, height: CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create UITextView
        textView = UITextView(frame: newTextViewBounds, textContainer: container)
        textView.delegate = self
        view.addSubview(textView)
    }
    private func textViewUpdateTextSize() {
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }

    private func updateTimeIndicatorFrame() {
        timeView.updateSize()
        timeView.frame = CGRectOffset(timeView.frame, textView.frame.width - timeView.frame.width, 0)
        let exclusionPath = timeView.curvePathWithOrigin(timeView.center)
        textView.textContainer.exclusionPaths = [exclusionPath]
    }
}

// MARK: Protocol TextSizeChangeable implementation
extension NoteEditorViewController: TextSizeChangeable {
    func preferredContentSizeChanged(notification: NSNotification) {
        textViewUpdateTextSize()
        updateTimeIndicatorFrame()
    }
}

// MARK: Protocol UITextViewDelegate implementation
extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidEndEditing(textView: UITextView) {
        note.contents = textView.text
    }
}