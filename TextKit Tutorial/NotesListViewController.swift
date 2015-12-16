//
//  NotesListViewController.swift
//  TextKit Tutorial
//
//  Created by Дмитрий on 16.12.15.
//  Copyright © 2015 Дмитрий. All rights reserved.
//
import UIKit

class NotesListViewController: UITableViewController {

    // MARK: Public properties
    let label: UILabel = {
        let aux = UILabel(frame: CGRect(x: 0, y: 0, width: Int.max, height: Int.max))
        aux.text = "TEST"
        return aux
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.sharedManager.notifyOnSizeChanged(self)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }


    // Mark: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let note = notes[indexPath.row]
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        let textColor = UIColor(red: 0.175, green: 0.458, blue: 0.832, alpha: 1)
        let attributes = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: font,
            NSTextEffectAttributeName: NSTextEffectLetterpressStyle
        ]
        let attributedString = NSAttributedString(string: note.title, attributes: attributes)
        cell.textLabel?.attributedText = attributedString
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.sizeToFit()
        return label.frame.height * 1.7
    }

    // Mark: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let editorVC = segue.destinationViewController as? NoteEditorViewController {
            guard let identifier = segue.identifier else { return }
            switch identifier {
            case "CellSelected":
                guard let path = tableView.indexPathForSelectedRow else { return }
                editorVC.note = notes[path.row]
            case "AddNewNote":
                let note = Note(text: " ")
                editorVC.note = note
                notes.append(note)
            default: break
            }
        }
    }

}

extension NotesListViewController: TextSizeChangeable {
    func preferredContentSizeChanged(notification: NSNotification) {
        tableView.reloadData()
    }
}