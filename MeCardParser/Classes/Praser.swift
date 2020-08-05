// Copyright (c) 2020 Kishore Prakash <kishore.balasa@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//  Praser.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//

import Foundation
import Contacts

public struct Parser {
    
    public static func parserMeCard(data: String) -> CNContact? {
        if data.count <= 7, !data.lowercased().hasPrefix("mecard:") {
            return nil
        }
        let data = data.dropFirst(7) // Remove mecard from data
        let contents = data.split(separator: ";")
        let contact = CNMutableContact()
        var phoneNumbers: [CNLabeledValue<CNPhoneNumber>]? = nil
        for content in contents {
            var entries = content.split(separator: ":")
            for i in 0..<entries.count {
                if entries[0].uppercased() == "URL", entries.count == 3 {
                    entries[i+1] = entries[i+1] + ":" + entries[i+2]
                    entries.remove(at: i+2)
                }
            }
            if entries.count >= 2 {
                switch entries[0].uppercased() {
                case "N":
                    let fullName = entries[1].split(separator: ",")
                    contact.givenName = String(fullName[0]).trimmingCharacters(in: .whitespaces)
                    if fullName.count > 1 {
                        contact.familyName = String(fullName[0]).trimmingCharacters(in: .whitespaces)
                        contact.givenName = String(fullName[1]).trimmingCharacters(in: .whitespaces)
                    }
                case "ADR":
                    let fullAddressArr = entries[1].split(separator: ",")
                    let postalAddress = CNMutablePostalAddress()
                    for i in 0..<fullAddressArr.count {
                        switch i {
                        case 0:
                            postalAddress.street = String(fullAddressArr[i].trimmingCharacters(in: .whitespaces))
                        case 1:
                            postalAddress.street = postalAddress.street.appending(", \(String(fullAddressArr[i].trimmingCharacters(in: .whitespaces)))")
                        case 2:
                            postalAddress.street = postalAddress.street.appending(", \(String(fullAddressArr[i].trimmingCharacters(in: .whitespaces)))")
                        case 3:
                            postalAddress.city = String(fullAddressArr[i].trimmingCharacters(in: .whitespaces))
                        case 4:
                            if #available(iOS 10.3, *) {
                                postalAddress.subAdministrativeArea = String(fullAddressArr[i].trimmingCharacters(in: .whitespaces))
                            }
                        case 5:
                            postalAddress.postalCode = String(fullAddressArr[i].trimmingCharacters(in: .whitespaces))
                        case 6:
                            postalAddress.country = String(fullAddressArr[i].trimmingCharacters(in: .whitespaces))
                        default:
                            break
                        }
                    }
                    contact.postalAddresses = [CNLabeledValue(label: CNLabelHome, value: postalAddress)]
                case "BDAY":
                    if entries[1].count == 8 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyyMMdd"
                        if let dob = dateFormatter.date(from: String(entries[1])) {
                            contact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: dob)
                        }
                    }
                case "EMAIL":
                    contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: String(entries[1]) as NSString)]
                case "NICKNAME":
                    contact.nickname = String(entries[1])
                case "NOTE":
                    contact.note = String(entries[1])
                case "SOUND":
                    let fullName = entries[1].split(separator: ",")
                    contact.phoneticGivenName = String(fullName[0]).trimmingCharacters(in: .whitespaces)
                    if fullName.count > 1 {
                        contact.phoneticFamilyName = String(fullName[0]).trimmingCharacters(in: .whitespaces)
                        contact.phoneticGivenName = String(fullName[1]).trimmingCharacters(in: .whitespaces)
                    }
                case "TEL":
                    let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: String(entries[1].trimmingCharacters(in: .whitespaces))))
                    if let _ = phoneNumbers {
                        phoneNumbers!.append(homePhone)
                    } else {
                        phoneNumbers = [homePhone]
                    }
                case "TEL-AV":
                    let otherPhone = CNLabeledValue(label: CNLabelOther, value: CNPhoneNumber(stringValue: String(entries[1].trimmingCharacters(in: .whitespaces))))
                    if let _ = phoneNumbers {
                        phoneNumbers!.append(otherPhone)
                    } else {
                        phoneNumbers = [otherPhone]
                    }
                case "URL":
                    contact.urlAddresses = [CNLabeledValue(label: CNLabelHome, value: String(entries[1]) as NSString)]
                default:
                    break
                }
            }
        }
        if let phoneNumbers = phoneNumbers {
            contact.phoneNumbers = phoneNumbers
        }
        
        return contact
    }
}
