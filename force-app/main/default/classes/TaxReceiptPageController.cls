public without sharing class TaxReceiptPageController {
    @AuraEnabled(cacheable=true)
    public static ContactAndDonationYearsWrapper getContactDetails(String contactId) {
        ContactAndDonationYearsWrapper objContactAndDonationYears = null;
        System.debug('RG:TaxReceiptPageController: getContactDetails: contactId:  ' + contactId);
        List<Contact> lstContacts = [
                                        SELECT FirstName, LastName, Name, WFP_Supporter_ID__c, TR_EncodeContactId__c, TR_TaxReceiptLanguage__c 
                                        FROM Contact 
                                        WHERE TR_EncodeContactId__c != null AND TR_EncodeContactId__c = :contactId
                                    ];
        if(lstContacts.size() > 0){
            System.debug('RG:TaxReceiptPageController: getContactDetails: contact:  ' + lstContacts.get(0));
            objContactAndDonationYears = new ContactAndDonationYearsWrapper();
            objContactAndDonationYears.objContact = lstContacts.get(0);
            objContactAndDonationYears.lstContactDonationsYears = getDonationYearsByContact(lstContacts.get(0).Id);
            return objContactAndDonationYears;
        }else{
            System.debug('RG: TaxReceiptPageController: getContactDetails: contact list size is Zero: ');
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Integer getExpireValue() {
        TaxReceipt__mdt taxReceiptMetadata = [SELECT Link_Valid_For__c FROM TaxReceipt__mdt WHERE DeveloperName = 'Tax_Receipt_Public_Site_Link' LIMIT 1];
        return (taxReceiptMetadata != null) ? Integer.valueOf(taxReceiptMetadata.Link_Valid_For__c) : 0;            
    }

    @AuraEnabled
    public static TaxReceiptLog__c getTimeLimitPublicSiteURL(String encodedContactId, String yearSelected) {
        System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: encodedContactId: ' + encodedContactId);
        System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: yearSelected: ' + yearSelected);
        Integer selectedYear;
        selectedYear = Integer.valueOf(yearSelected);
        // Get the Contact record based on the provided contactId        
        List<Contact> lstContacts = [SELECT Id, Email, FirstName, LastName, Name, TR_EncodeContactId__c, TR_TaxReceiptLanguage__c FROM Contact WHERE TR_EncodeContactId__c = :encodedContactId];
        if(lstContacts.size() > 0){
            Contact contactRecord = lstContacts.get(0);
            System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: contactRecord: ' + contactRecord);
                // Retrieve the TaxReceipt__mdt custom metadata record
            TaxReceipt__mdt taxReceiptCustomMetadata = TR_TaxReceiptUtility.retrieveTaxReceiptMetadata();
                System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: taxReceiptCustomMetadata: ' + taxReceiptCustomMetadata);
            Integer validUptoInMinutes = Integer.valueOf(taxReceiptCustomMetadata.Link_Valid_For__c);
            // Create a new TaxReceiptLog__c record with the required fields
            TaxReceiptLog__c taxReceiptLogRecord = new TaxReceiptLog__c(
                Link_Valid_upto__c = Datetime.now().addMinutes(validUptoInMinutes),
                ContactId__c = contactRecord.Id
            );
    
            // Insert the record
                System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: Before Insert taxReceiptLogRecord: ' + taxReceiptLogRecord);
            insert taxReceiptLogRecord;
                System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: After Insert taxReceiptLogRecord: ' + taxReceiptLogRecord);
        
            String uniqueKey = EncodingUtil.base64Encode(Blob.valueOf(String.valueOf(taxReceiptLogRecord.Id))); 
                System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: uniqueKey: ' + uniqueKey);
        
            TaxReceiptLog__c taxReceiptLogRecordUpdate = new TaxReceiptLog__c(
                Security_Link__c = taxReceiptCustomMetadata.Tax_Receipt_Public_Site_Link__c + '/apex/RG_TR_PublicSiteVFPageToLWC?encodedId=' + contactRecord.TR_EncodeContactId__c + '&trlogid=' + uniqueKey + '&yearSelected=' + selectedYear,
                Unique_Key__c = uniqueKey,
                Id = taxReceiptLogRecord.Id,
                ContactId__c = taxReceiptLogRecord.ContactId__c
            );
            System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: before update taxReceiptLogRecord: ' + taxReceiptLogRecordUpdate);
            update  taxReceiptLogRecordUpdate;
                System.debug('RG: RG_TaxReceiptHomePageLWCController: getTimeLimitPublicSiteURL: After update taxReceiptLogRecord: ' + taxReceiptLogRecordUpdate);
            
            String emailSubject = 'Tax Receipt Link';
            String emailTextBody = 'Dear: ' + contactRecord.FirstName;
            emailTextBody +='<br/><br/>';
            emailTextBody += '<p><b>Please click the link below to see your tax receipts. Access is time-limited,<br/>so please do it now. Otherwise, you will need to request another link.</b></p>';
            emailTextBody += '<br/>';
            emailTextBody += '<a href="' + taxReceiptLogRecordUpdate.Security_Link__c + '">Access your tax receipts.</a>';
            emailTextBody += '<br/><br/><b>Your support is very important to us, and these steps are to make sure your data is completely secure  at all times</b>';
            emailTextBody += '<br/><br/><b>Thank you,</b>';
            emailTextBody += '<br/><b>Your Supporter Care Team</b>';  
        
                System.debug('RG: emailSubject: ' + emailSubject);
                System.debug('RG: emailTextBody: ' + emailTextBody);
        
            // Send email to the contact with the link
            
            try{
                TR_TaxReceiptUtility.sendEmailWithPublicSiteHomePageURLLink(contactRecord, emailSubject, emailTextBody );
            }catch(Exception e){
                System.debug('RG: Tax Receipt Send Email Exception: ' + e);
            }
            return taxReceiptLogRecordUpdate;
        }else{
            return null;
        }
    }

    
    private static List<String> getDonationYearsByContact(String contactId){
        Set<Integer> setDonationYearsByContact = new Set<Integer>();
        List<Integer> lstOneTimeDonationsYears = getOneTimeDonationYearsByContact(contactId);
        List<Integer> lstRecurringDonationsYears = getRecurringDonationYearsByContact(contactId);

        // Determine the current year and its previous year
        Integer currentYear = Date.today().year();
        Integer previousYear = currentYear - 1;

        // Check if current year or its previous year exists in either list
        Boolean currentOrPreviousYearExists = lstOneTimeDonationsYears.contains(currentYear) || 
                                                lstOneTimeDonationsYears.contains(previousYear) || 
                                                lstRecurringDonationsYears.contains(currentYear) || 
                                                lstRecurringDonationsYears.contains(previousYear);

        // If current year or its previous year exists in either list, add them to the set
        if (currentOrPreviousYearExists) {
            if (lstOneTimeDonationsYears.contains(previousYear) || lstRecurringDonationsYears.contains(previousYear)) {
                setDonationYearsByContact.add(previousYear);
            }
            if (lstOneTimeDonationsYears.contains(currentYear) || lstRecurringDonationsYears.contains(currentYear)) {
                setDonationYearsByContact.add(currentYear);
            }
        }
        
        List<String> lstContactDonationsYears = new List<String>();
        
        if(setDonationYearsByContact.size() > 0){
            // Iterate through the set of Integers and convert each one to a String
            for(Integer yearInteger : setDonationYearsByContact) {
                // Convert Integer to String using String.valueOf() method
                String yearString = String.valueOf(yearInteger);
                
                // Add the converted String year to the list
                lstContactDonationsYears.add(yearString);
            }
        }
        return lstContactDonationsYears;
    }
    
    private static List<Integer> getOneTimeDonationYearsByContact(String contactId){
        List<Integer> lstOneTimeDonationsYears = new List<Integer>();
        System.debug('RG:getOneTimeDonationYearsByContact: contactId: ' + contactId);
        List<AggregateResult> lstAggResults = [
                                                Select CALENDAR_YEAR(CloseDate) DonationYear
                                                FROM Opportunity 
                                                WHERE CloseDate != null AND 
                                                    StageName = 'Closed Won' AND 
                                                    npsp__Primary_Contact__c != null AND 
                                                    npsp__Primary_Contact__c = :contactId AND		// '0037h00000snexVAAQ' AND 
                                                    npe03__Recurring_Donation__c = null AND 
                                                    RecordTypeId = : TR_TaxReceiptUtility.OPPORTUNITY_RECORDTYPE_INDIVIDUAL_GIFTS 
                                                GROUP BY CALENDAR_YEAR(CloseDate)
                                            ];
        System.debug('RG:getOneTimeDonationYearsByContact: lstAggResults size: ' + lstAggResults.size());
        System.debug('RG:getOneTimeDonationYearsByContact: lstAggResults: ' + lstAggResults);
        if(lstAggResults.size() > 0){
            for(AggregateResult objAggResult : lstAggResults){
                System.debug('RG:getOneTimeDonationYearsByContact: objAggResult: ' + objAggResult);
                lstOneTimeDonationsYears.add((Integer)objAggResult.get('DonationYear'));
            }
            if(lstOneTimeDonationsYears.size() > 0){
                System.debug('RG: lstOneTimeDonationsYears: ' + lstOneTimeDonationsYears);
            }
        }
        return lstOneTimeDonationsYears;
    }
    
    private static List<Integer> getRecurringDonationYearsByContact(String contactId){
        List<Integer> lstRecurringDonationsYears = new List<Integer>();
        System.debug('RG: getRecurringDonationYearsByContact: contactId: ' + contactId);
        List<AggregateResult> lstAggResults = [
                                                Select CALENDAR_YEAR(CloseDate) DonationYear 
                                                FROM Opportunity 
                                                WHERE CloseDate != null AND 
                                                    StageName = 'Closed Won' AND 
                                                    npe03__Recurring_Donation__c != null AND 
                                                    npe03__Recurring_Donation__r.npe03__Contact__c != null AND 
                                                    npe03__Recurring_Donation__r.npe03__Contact__c = :contactId AND 
                                                    RecordTypeId = : TR_TaxReceiptUtility.OPPORTUNITY_RECORDTYPE_INDIVIDUAL_GIFTS 
                                                GROUP BY CALENDAR_YEAR(CloseDate)
                                            ];
        System.debug('RG: getRecurringDonationYearsByContact: lstAggResults size: ' + lstAggResults.size());
        System.debug('RG: getRecurringDonationYearsByContact: lstAggResults: ' + lstAggResults);
        if(lstAggResults.size() > 0){
            for(AggregateResult objAggResult : lstAggResults){
                System.debug('RG: getRecurringDonationYearsByContact: objAggResult: ' + objAggResult);
                lstRecurringDonationsYears.add((Integer)objAggResult.get('DonationYear'));
            }
            if(lstRecurringDonationsYears.size() > 0){
                System.debug('RG: lstRecurringDonationsYears: ' + lstRecurringDonationsYears);
            }
        }
        return lstRecurringDonationsYears;
    }   
    
    public class ContactAndDonationYearsWrapper{
        @AuraEnabled public Contact objContact {get;set;}
        @AuraEnabled public List<String> lstContactDonationsYears {get;set;}
    }
}