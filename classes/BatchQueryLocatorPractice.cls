/**
 * Created by JJ93 on 13.09.2020.
 */

public with sharing class BatchQueryLocatorPractice implements Database.Batchable<SObject> {
    public String query = 'SELECT Id,AccountId FROM Contact WHERE Is_Synced__c = FALSE';

    public void execute(Database.BatchableContext context, List<Contact> scope) {
        List<Contact> notSyncedContacts = new List<Contact>();
        List<Account> accountsToSetUpdatedByAccount = new List<Account>();
        for (Contact contact : scope) {

            if (contact.AccountId != null) {
                Account account = [
                        SELECT Id,BillingCountry,BillingCity,BillingGeocodeAccuracy,BillingLatitude,
                                BillingLongitude,BillingPostalCode, BillingState, BillingStreet
                        FROM Account
                        WHERE Id = :contact.AccountId
                ];
                account.Updated_By_Contact__c = true;
                if (!accountsToSetUpdatedByAccount.contains(account)) {
                    accountsToSetUpdatedByAccount.add(account);
                }
                setContactMailingAddressViaAccountBillingAddress(contact, account);
            }
            contact.Is_Synced__c = true;
            notSyncedContacts.add(contact);
        }
        update notSyncedContacts;
        update accountsToSetUpdatedByAccount;
    }

    private void setContactMailingAddressViaAccountBillingAddress(Contact contact, Account account) {
        contact.MailingCountry = account.BillingCountry;
        contact.MailingCity = account.BillingCity;
        contact.MailingGeocodeAccuracy = account.BillingGeocodeAccuracy;
        contact.MailingLatitude = account.BillingLatitude;
        contact.MailingLongitude = account.BillingLongitude;
        contact.MailingPostalCode = account.BillingPostalCode;
        contact.MailingState = account.BillingState;
        contact.MailingStreet = account.BillingStreet;
    }

    public void finish(Database.BatchableContext context) {
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }


}
