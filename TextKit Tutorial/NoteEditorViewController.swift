//
//  NoteEditorViewController.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//


import UIKit

class NoteEditorViewController: UIViewController {

    // MARK: @IBOutlet
    @IBOutlet var textView: UITextView!

    // MARK: Public properties
    var note: Note!
    var timeView: TimeIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note.contents
        textViewUpdateTextSize()
        NotificationManager.sharedManager.notifyOnSizeChanged(self)
        timeView = TimeIndicatorView(date: note.timestamp)
        textView.addSubview(timeView)
    }
    
    override func viewDidLayoutSubviews() {
        updateTimeIndicatorFrame()
    }
    
    // MARK: Helper
    private func textViewUpdateTextSize() {
        textView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }

    private func updateTimeIndicatorFrame() {
        timeView.updateSize()
        timeView.frame = CGRectOffset(timeView.frame, textView.frame.width - timeView.frame.width, 0)
    }
}

// MARK: Protocol TextSizeChangeable implementation
extension NoteEditorViewController: TextSizeChangeable {
    func preferredContentSizeChanged(notification: NSNotification) {
        textViewUpdateTextSize()
    }
}

// MARK: Protocol UITextViewDelegate implementation
extension NoteEditorViewController: UITextViewDelegate {
    func textViewDidEndEditing(textView: UITextView) {
        note.contents = textView.text
    }
}