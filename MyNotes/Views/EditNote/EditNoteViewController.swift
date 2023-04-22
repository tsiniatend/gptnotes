//
//  EditNoteViewController.swift
//  MyNotes
//
//  Created by tsiniate endalkachew on 19/08/2021.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    static let identifier = "EditNoteViewController"
    
    var note: Note!
    weak var delegate: ListNotesDelegate?

    @IBOutlet weak private var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note?.text
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK:- Methods to implement
    private func updateNote() {
        // TODO update the note in database
    
        
        note.lastUpdated = Date()
        CoreDataManager.shared.save()
        delegate?.refreshNotes()
    }
    
    private func deleteNote() {
        delegate?.deleteNote(with: note.id)
        CoreDataManager.shared.deleteNote(note: note)
    }
}

// MARK:- UITextView Delegate
extension EditNoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note?.text = textView.text
        if note?.title.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
