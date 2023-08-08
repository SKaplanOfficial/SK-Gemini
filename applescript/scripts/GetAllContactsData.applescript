use framework "Contacts"

set contactStore to my CNContactStore's alloc()'s init()

-- All possible keys
set targetKeys to {my CNContactIdentifierKey, my CNContactTypeKey, my CNContactPropertyAttribute, my 
CNContactNamePrefixKey, my CNContactGivenNameKey, my CNContactMiddleNameKey, my CNContactFamilyNameKey, my 
CNContactPreviousFamilyNameKey, my CNContactNameSuffixKey, my CNContactNicknameKey, my CNContactPhoneticGivenNameKey, my 
CNContactPhoneticMiddleNameKey, my CNContactPhoneticFamilyNameKey, my CNContactJobTitleKey, my 
CNContactDepartmentNameKey, my CNContactOrganizationNameKey, my CNContactPhoneticOrganizationNameKey, my 
CNContactPostalAddressesKey, my CNContactEmailAddressesKey, my CNContactUrlAddressesKey, my 
CNContactInstantMessageAddressesKey, my CNContactPhoneNumbersKey, my CNContactSocialProfilesKey, my CNContactBirthdayKey, 
my CNContactNonGregorianBirthdayKey, my CNContactDatesKey, my CNContactNoteKey, my CNContactImageDataKey, my 
CNContactThumbnailImageDataKey, my CNContactImageDataAvailableKey, my CNContactRelationsKey, my CNGroupNameKey, my 
CNGroupIdentifierKey, my CNContainerNameKey, my CNContainerTypeKey, my CNInstantMessageAddressServiceKey, my 
CNInstantMessageAddressUsernameKey, my CNSocialProfileServiceKey, my CNSocialProfileURLStringKey, my 
CNSocialProfileUsernameKey, my CNSocialProfileUserIdentifierKey}

-- Obtain contact data
set containerID to contactStore's defaultContainerIdentifier()
set contactsPredicate to my (CNContact's predicateForContactsInContainerWithIdentifier:containerID)
set contactData to contactStore's unifiedContactsMatchingPredicate:contactsPredicate keysToFetch:targetKeys 
|error|:(missing value)

-- Improve performance by querying for all data at once instead of making multiple Apple Event calls
set contactKeyLists to {identifier, contactType, namePrefix, givenName, middleName, familyName, previousFamilyName, 
nameSuffix, nickname, phoneticGivenName, phoneticMiddleName, phoneticFamilyName, jobTitle, departmentName, 
organizationName, phoneticOrganizationName, postalAddresses, emailAddresses, urlAddresses, phoneNumbers, socialProfiles, 
birthday, nonGregorianBirthday, |dates|, note, imageData, thumbnailImageData, imageDataAvailable, contactRelations, 
instantMessageAddresses} of contactData

-- Organize contact data into list of records
set contacts to {}
repeat with index from 1 to (count item 1 of contactKeyLists)
	set theData to {contactIdentifier:(item index of item 1 of contactKeyLists) as text, contactType:(item index of 
item 2 of contactKeyLists) as text, namePrefix:(item index of item 3 of contactKeyLists) as text, givenName:(item index 
of item 4 of contactKeyLists) as text, middleName:(item index of item 5 of contactKeyLists) as text, familyName:(item 
index of item 6 of contactKeyLists) as text, previousFamilyName:(item index of item 7 of contactKeyLists) as text, 
nameSuffix:(item index of item 8 of contactKeyLists) as text, nickname:(item index of item 9 of contactKeyLists) as text, 
phoneticGivenName:(item index of item 10 of contactKeyLists) as text, phoneticMiddleName:(item index of item 11 of 
contactKeyLists) as text, phoneticFamilyName:(item index of item 12 of contactKeyLists) as text, jobTitle:(item index of 
item 13 of contactKeyLists) as text, departmentName:(item index of item 14 of contactKeyLists) as text, 
organizationName:(item index of item 15 of contactKeyLists) as text, phoneticOrganizationName:(item index of item 16 of 
contactKeyLists) as text, postalAddresses:(item index of item 17 of contactKeyLists), emailAddresses:(item index of item 
18 of contactKeyLists), urlAddresses:(item index of item 19 of contactKeyLists) as list, phoneNumbers:(item index of item 
20 of contactKeyLists), socialProfiles:(item index of item 21 of contactKeyLists), birthday:(item index of item 22 of 
contactKeyLists), nonGregorianBirthday:(item index of item 23 of contactKeyLists), |dates|:(item index of item 24 of 
contactKeyLists), note:(item index of item 25 of contactKeyLists) as text, imageData:(item index of item 26 of 
contactKeyLists), thumbnailImageData:(item index of item 27 of contactKeyLists), imageDataAvailable:(item index of item 
28 of contactKeyLists) as boolean, contactRelations:(item index of item 29 of contactKeyLists), 
instantMessageAddresses:(item index of item 30 of contactKeyLists)}
	copy theData to the end of contacts
end repeat

return contacts
