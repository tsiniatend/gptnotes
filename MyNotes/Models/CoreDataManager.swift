//
//  CoreDataManager.swift
//  MyNotes
//
//  Created by tsiniate endalkachew on 3/12/23.
//

import Foundation
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager(modelName: "MyNotes")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        persistentContainer.loadPersistentStores{
            (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    func save(){
        if viewContext.hasChanges{
            do{
                try viewContext.save()
            } catch{
                print("an error occured while saving:\(error.localizedDescription)")
            }
        }
    }
}


//MARK:- Helper functions
extension CoreDataManager{
    func createNote() -> Note{
        let note = Note(context: viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }
    func fetchNotes(filter: String? = nil ) -> [Note] {
        let request: NSFetchRequest<Note> =
        Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath:\Note.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "text contains[cd] %@", filter)
            request.predicate = predicate 
        }
        return (try?  viewContext.fetch(request)) ?? []
    }
    func deleteNote(note: Note){
        viewContext.delete(note)
        save()
    }
}
