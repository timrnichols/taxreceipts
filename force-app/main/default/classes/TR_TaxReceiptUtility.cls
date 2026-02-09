/**
 * @File Name          : TR_TaxReceiptUtility.cls
 * @Description        : This class contains methods for Tax Receipt Functionality
 * @Author             : Rajesh Gupta
 * @Group              : 
 * @Last Modified By   : Rajesh Gupta
 * @Last Modified On   : 04-Aug-23
 * @Modification Log   : 
 * Ver       Date            Author      		     Modification
 * 1.0      04-Aug-23        Rajesh Gupta            Initial Version 
**/
public without sharing class TR_TaxReceiptUtility {
    public static final String CONTACT_RECORDTYPE_INDIVIDUAL_SUPPORTER = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Individual_Supporter').getRecordTypeId();
    public static final String OPPORTUNITY_RECORDTYPE_INDIVIDUAL_GIFTS =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Individual_Gift').getRecordTypeId();
	public static final String CONTACT_RECORDTYPE_PRIVATE_SECTOR_CONTACT = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('PGP_Contact').getRecordTypeId();
    
	public static TaxReceipt__mdt retrieveTaxReceiptMetadata() {
        // Query the specific TaxReceipt__mdt record by DeveloperName
        List<TaxReceipt__mdt> taxReceiptSettings = [SELECT Link_Valid_For__c, Tax_Receipt_Public_Site_Link__c, Countries_Allowed__c FROM TaxReceipt__mdt WHERE DeveloperName = 'Tax_Receipt_Public_Site_Link'];
        TaxReceipt__mdt taxReceiptCustomMetadata = null;
        if (!taxReceiptSettings.isEmpty()) {
            taxReceiptCustomMetadata = taxReceiptSettings[0]; 
        } else {
            // Handle the case when no matching records are found
            System.debug('RG: No matching TaxReceipt__mdt records found.');
        }
        return taxReceiptCustomMetadata;
    }
    
    public static List<String> getValidGDPaymentAccountIds(){
        List<String> lstGDAccountIds = null;        
        try{
            // Query for TaxReceipt__mdt records
            List<TaxReceipt__mdt> taxReceiptCustomMetadata = [
                                                                SELECT TR_Valid_GD_Payment_Accounts_Ids__c 
                                                                FROM TaxReceipt__mdt 
                                                                WHERE DeveloperName = 'Tax_Receipt_Public_Site_Link'
                                                            ];            

            if(taxReceiptCustomMetadata.size() > 0 ){
                // Process the record and extract country names
                TaxReceipt__mdt objTaxReceiptMetaData = taxReceiptCustomMetadata.get(0);    
                System.debug('RG: valid GD Payment Account Ids Allowed: ' + objTaxReceiptMetaData.TR_Valid_GD_Payment_Accounts_Ids__c);            
                String validGDAccountIds = objTaxReceiptMetaData.TR_Valid_GD_Payment_Accounts_Ids__c;                
                if (!String.isBlank(validGDAccountIds)) {
                    List<String> lstValidGDAccountsIds = validGDAccountIds.split(',');
                    lstGDAccountIds = new List<String>();
                    lstGDAccountIds.addAll(lstValidGDAccountsIds);
                }else{
                    throw new TaxReceiptGDAccountIdsException('The list of GD Payment Account Ids is null');
                }
                return lstGDAccountIds;
            }
        }catch(Exception e){
            System.debug('RG Exception: GD Payment Account Ids: ' + e);
            System.debug('RG Exception Meesage: GD Payment Account Ids: ' + e.getMessage());
            return lstGDAccountIds;
        }
        return lstGDAccountIds;
    }

    public static List<String> getCountriesAllowed(){
        List<String> lstCountriesAllowed = null;        
        try{
            // Query for TaxReceipt__mdt records
            List<TaxReceipt__mdt> taxReceiptCustomMetadata = [SELECT Countries_Allowed__c FROM TaxReceipt__mdt WHERE DeveloperName = 'Tax_Receipt_Public_Site_Link'];            

            if(taxReceiptCustomMetadata.size() > 0 ){
                // Process the record and extract country names
                TaxReceipt__mdt objTaxReceiptMetaData = taxReceiptCustomMetadata.get(0);    
                System.debug('RG: Countries Allowed: ' + objTaxReceiptMetaData.Countries_Allowed__c);            
                String countriesAllowed = objTaxReceiptMetaData.Countries_Allowed__c;                
                if (!String.isBlank(countriesAllowed)) {
                    List<String> lstCountryNames = countriesAllowed.split(',');
                    lstCountriesAllowed = new List<String>();
                    lstCountriesAllowed.addAll(lstCountryNames);
                }else{
                    throw new TaxReceiptCountriesNotAllowedException('The list of Country Names is null');
                }
                return lstCountriesAllowed;
            }
        }catch(Exception e){
            System.debug('RG Exception: Country Names: ' + e);
            System.debug('RG Exception Meesage: Country Names: ' + e.getMessage());
            return lstCountriesAllowed;
        }
        return lstCountriesAllowed;
    }


    public static void sendEmailWithPublicSiteHomePageURLLink(Contact objContact, String subject, String publicSiteURL){
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: objContact: ' + objContact);
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: subject: ' + subject);
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: publicSiteURL: ' + publicSiteURL);
        List<OrgWideEmailAddress> lstOrgWideEmailAddressList = [select Id, Address from OrgWideEmailAddress where Address = 'supportercare@wfp.org'];

        List<Messaging.SingleEmailMessage> lstMails = new List<Messaging.SingleEmailMessage>();
        // for(Contact objContact : lstUpdatedContacts){
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: objContact.Email: ' + objContact.Email);
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: objContact.TR_TaxReceiptLanguage__c: ' + objContact.TR_TaxReceiptLanguage__c);            
        System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: lstOrgWideEmailAddressList: ' + lstOrgWideEmailAddressList);
        //Set Download public URL link as an email content
        String htmlbodyStr = null;
        // if(String.isBlank(publicSiteURL)){
        //     mail.setToAddresses(new String[] { objContact.Email }); 
        //     mail.setOrgWideEmailAddressId(lstOrgWideEmailAddressList[0].Id);
        //     mail.setSubject(subject);
        //     htmlbodyStr = '<h1>Generate PDF from Apex Salesforce</h1><a href=\'' + objContact.TR_PublicSiteURL__c + '\'>Public Site Home Page</a>';
        //     System.debug('RG: sendEmailWithPublicSiteHomePageURLLink: publicSiteURL is Blank: htmlbodyStr: ' + htmlbodyStr);
        //     mail.setHtmlBody(htmlbodyStr);               
        // }
        if(!String.isBlank(publicSiteURL)){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            htmlbodyStr = publicSiteURL;
            mail.setHtmlBody(htmlbodyStr);
            String emailTemplateName = null;
            if(objContact.TR_TaxReceiptLanguage__c != 'French'){
                emailTemplateName = 'WFP Access Tax Receipt Links';                    
            }else if(objContact.TR_TaxReceiptLanguage__c == 'French'){
                emailTemplateName = 'WFP Access Tax Receipt Links French';
            }
            List<EmailTemplate> lstEmailTemplates = [SELECT Id FROM EmailTemplate WHERE Name =: emailTemplateName]; 
            Id emailTemplateId = lstEmailTemplates.get(0).Id;
            mail = Messaging.renderStoredEmailTemplate(emailTemplateId, objContact.Id, null);
            mail.setToAddresses(new List<String>{objContact.Email});
            mail.setOrgWideEmailAddressId(lstOrgWideEmailAddressList[0].Id);
            System.debug('RG: mail: ' + mail);
            lstMails.add(mail);
            if(!Test.isRunningTest()){
                // Messaging.sendEmail(lstMails);
                try{
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(lstMails);                
                    if(results[0].success){
                        System.debug('The email was sent successfully.');
                    }else{
                        System.debug('The email failed to send: ' + results[0].errors[0].message);
                    }
                }catch(Exception e){
                    System.debug('Single email is not enabled for your organization or profile.');
                    return;
                }
            }   
        }    
    }    
    
    public class TaxReceiptCountriesNotAllowedException  extends Exception {}
    public class TaxReceiptGDAccountIdsException  extends Exception {}
    public class TaxReceiptContactEMailException  extends Exception {}
    public class TaxReceiptContactRecordTypeException  extends Exception {}
    
    public static List<Contact> createContactRecords(List<String> lstCountryNames, String contactRecordTypeId, Boolean isInsert){
        System.debug('RG: TR_TaxReceiptUtility: createContactRecords: lstCountryNames ' + lstCountryNames);
        System.debug('RG: TR_TaxReceiptUtility: createContactRecords: contactRecordTypeId ' + contactRecordTypeId);
        System.debug('RG: TR_TaxReceiptUtility: createContactRecords: isInsert ' + isInsert);
        List<Contact> lstContactsToInsert = new List<Contact>();
        for(Integer i = 0; i < lstCountryNames.size(); i++){        
            Contact objNewContact = new Contact(
                                                    FirstName='Contact' + (i+1),				
                                                    LastName='Test ' + (i+1),				
                                                    Email= ('Tom' + (i +1)) + 'taxreceipt@trial.com',                                                     
                                                    Phone='990080070' + i,
                                                    MailingCountry = lstCountryNames.get(i),                                                     
                                                    RecordTypeId = contactRecordTypeId                									
                                                );
            System.debug('RG: TR_TaxReceiptUtility objNewContact: ' + objNewContact);
            lstContactsToInsert.add(objNewContact);
        }
        if(lstContactsToInsert.size() > 0){
            if(isInsert == true){
				insert lstContactsToInsert;                
            }
        }
        return lstContactsToInsert;
    }
    
    public static List<npe03__Recurring_Donation__c> createRecurringDonationRecords(List<Contact> lstContacts, Boolean isInsert){
        System.debug('RG: TR_TaxReceiptUtility: createRecurringDonationRecords: lstContacts ' + lstContacts);        
        System.debug('RG: TR_TaxReceiptUtility: createRecurringDonationRecords: isInsert ' + isInsert);
         List<npe03__Recurring_Donation__c> lstRecurringDonations = new List<npe03__Recurring_Donation__c>();
         for(Integer i = 0; i < lstContacts.size(); i++){        
            npe03__Recurring_Donation__c objRecurringObject = new npe03__Recurring_Donation__c(
                                                    Name='Raj Recurring ' + (i+1),				
                                                    npe03__Next_Payment_Date__c = Date.today().addMonths(1),
                									Expected_Payment_Date__c = Date.today(),
                									npe03__Contact__c = lstContacts.get(0).Id,
                									npe03__Installment_Period__c = 'Monthly',
                									npe03__Open_Ended_Status__c = 'Open',
                									npe03__Date_Established__c = Date.today(),
                									Country__c = 'CA'   
                                                );
            System.debug('RG: TR_TaxReceiptUtility lstRecurringDonations: ' + objRecurringObject);
            lstRecurringDonations.add(objRecurringObject);
        }
        if(lstRecurringDonations.size() > 0){
            if(isInsert == true){
				insert lstRecurringDonations;                
            }
        }
        return lstRecurringDonations;
    }
    
    
    public static List<Opportunity> createOneTimeOpportunitesRecords(List<Contact> lstContacts, String opprtunityRecordTypeId, Boolean isInsert){
       	//Id opportunityRecordTypeId = TR_TaxReceiptUtility.OPPORTUNITY_RECORDTYPE_INDIVIDUAL_GIFTS;
        List<Opportunity> lstOpportunitiesToInsert = new List<Opportunity>();
        List<String> lstOppStageNames = new List<String>{'Closed Won', 'Pending'};
       // List<Id> lstOppRecordTypIds  = new List<Id>{TR_TaxReceiptUtility.OPPORTUNITY_RECORDTYPE_INDIVIDUAL_GIFTS,'012f3000000QOuTAAW'};
        //for(Integer i = 0; i < lstCountryNames.size(); i++){
        for(Integer i = 0; i < 1; i++){
            Opportunity objNewOpprtunity = new Opportunity(
                                                    Name='Raj Opp Test 8' + i,                                                    
                                                    RecordTypeId = opprtunityRecordTypeId,
                									npsp__Primary_Contact__c = lstContacts.get(0).Id,                									
                									StageName = lstOppStageNames[0],
                									CurrencyIsoCode = 'CAD', 
                									CloseDate = Date.today(),
                									Amount = 8 + i,
                									npe03__Recurring_Donation__c = null
                                                );
            System.debug('RG: TR_TaxReceiptUtility objNewOpprtunity: ' + objNewOpprtunity);
            lstOpportunitiesToInsert.add(objNewOpprtunity);
        }
        if(lstOpportunitiesToInsert.size() > 0){
            System.debug('RG: TR_TaxReceiptUtility lstOpportunitiesToInsert Size: ' + lstOpportunitiesToInsert.size());
            if(isInsert){
                insert lstOpportunitiesToInsert;
            }
            System.debug('RG: TR_TaxReceiptUtility lstOpportunitiesToInsert: ' + lstOpportunitiesToInsert);
            //TR_OpportunityTriggerHelper.updateContactOpportunityCount(lstOpportunitiesToInsert,  null);
            //TR_ContactTriggerHelper.encodeContactId(lstOpportunitiesToInsert, null);
        }
        return lstOpportunitiesToInsert;
    }
    
    public static List<Opportunity> createRecurringOpportunitesRecords(List<npe03__Recurring_Donation__c> lstRecurringDonations, String opprtunityRecordTypeId, Boolean isInsert){
        List<Opportunity> lstOpportunitiesToInsert = new List<Opportunity>();
        List<String> lstOppStageNames = new List<String>{'Closed Won', 'Pending'};
        for(Integer i = 0; i < 1; i++){
            Opportunity objNewOpprtunity = new Opportunity(
                                                    Name='Raj Opp Test 8' + i,                                                    
                                                    RecordTypeId = opprtunityRecordTypeId,
                									//npsp__Primary_Contact__c = lstRecurringDonations.get(0).npe03__Contact__c,	// lstContacts.get(0).Id,                									
                									StageName = lstOppStageNames[0],
                									CurrencyIsoCode = 'CAD', 
                									CloseDate = Date.today(),
                									Amount = 8 + i,
                									npe03__Recurring_Donation__c = lstRecurringDonations.get(0).Id
                                                );
            System.debug('RG: TR_TaxReceiptUtility objNewOpprtunity: ' + objNewOpprtunity);
            lstOpportunitiesToInsert.add(objNewOpprtunity);
        }
        if(lstOpportunitiesToInsert.size() > 0){
            System.debug('RG: TR_TaxReceiptUtility lstOpportunitiesToInsert Size: ' + lstOpportunitiesToInsert.size());
            if(isInsert){
                insert lstOpportunitiesToInsert;
            }
            System.debug('RG: TR_TaxReceiptUtility lstOpportunitiesToInsert: ' + lstOpportunitiesToInsert);
            //TR_OpportunityTriggerHelper.updateContactOpportunityCount(lstOpportunitiesToInsert,  null);
            //TR_ContactTriggerHelper.encodeContactId(lstOpportunitiesToInsert, null);
        }
        return lstOpportunitiesToInsert;
    }
}