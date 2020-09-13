/**
 * Created by JJ93 on 13.09.2020.
 */

public with sharing class FuturePractice {
    @Future
    public static void unSyncContactsByAccountBillingAddress() {
        List<Account> accounts = [SELECT Id,BillingAddress FROM Account LIMIT 150];
        List<Contact> contactsToProcess = new List<Contact>();
        for (Account account : accounts) {
            if (account.BillingAddress != null) {
                contactsToProcess.addAll([SELECT Id FROM Contact WHERE AccountId = :account.Id]);
            }
        }
        for (Contact contact : contactsToProcess) {
            contact.Is_Synced__c = false;
            contact.Processed_By_Future__c = true;
        }
        update contactsToProcess;


    }
}