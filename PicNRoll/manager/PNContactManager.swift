//
//  PNContactManager.swift
//  PicNRoll
//
//  Created by diana on 12/27/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Contacts

class PNContactManager{
    
    var contactBookInfo: [PNUser] = []

    static let shared = PNContactManager()

    func syncContacts(_ completionHandler:@escaping (_ result : Bool) -> Void) {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) in
            if accessGranted {
                self.contactBookInfo = self.getContacts()
            }
            completionHandler(accessGranted)
        }
    }

    func getContacts() -> [PNUser]{
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactIdentifierKey,
            CNContactImageDataAvailableKey,
            CNContactThumbnailImageDataKey,
            CNContactDatesKey
            ] as [Any]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
        if #available(iOS 10.0, *) {
            fetchRequest.mutableObjects = false
        } else {
            
        }
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        
        let contactStoreID = CNContactStore().defaultContainerIdentifier()
        print("\(contactStoreID)")
        
        var contacts: [PNUser] = []
        do {
            try CNContactStore().enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                if contact.phoneNumbers.count > 0 {
                    var phone_number = contact.phoneNumbers.first?.value.value(forKey: "digits") as? String
                    phone_number = phone_number?.replacingOccurrences(of: "+", with: "")
                    
                    let user = PNUser()
                    user.phoneNumber = phone_number!
                    user.email = "\(contact.emailAddresses[0].value)"
                    user.name = "\(contact.givenName) \(contact.familyName)"
                    contacts.append(user)
                 }
            })
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        return contacts
    }
}
