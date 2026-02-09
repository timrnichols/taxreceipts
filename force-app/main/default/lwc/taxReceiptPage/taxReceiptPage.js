import { LightningElement, wire, api } from 'lwc';
import TR_NewWFP_LOGO from '@salesforce/resourceUrl/TR_NewWFP_LOGO';
import TR_NewWFP_LOGO_French from '@salesforce/resourceUrl/TR_NewWFP_LOGO_French';
import TR_NewTaxReceiptListPageHeader2 from '@salesforce/resourceUrl/TR_NewTaxReceiptListPageHeader2';
import TR_RedErorIcon from '@salesforce/resourceUrl/TR_RedErorIcon';
import WFP_LOGO_WHITE from '@salesforce/resourceUrl/WFP_Logo_White';
import TR_Footer_French_White from '@salesforce/resourceUrl/TR_Footer_French_White';
import TR_Facebook_White from '@salesforce/resourceUrl/TR_Facebook_White';
import TR_Instagram_White from '@salesforce/resourceUrl/TR_Instagram_White';
import TR_LinkedIn_White from '@salesforce/resourceUrl/TR_LinkedIn_White';
import TR_Youtube_White from '@salesforce/resourceUrl/TR_Youtube_White';
import twitter_LOGO from '@salesforce/resourceUrl/TR_Twitter_White';
import getContactDetails from '@salesforce/apex/TaxReceiptPageController.getContactDetails';
import getExpireValue from '@salesforce/apex/TaxReceiptPageController.getExpireValue';
import getTimeLimitPublicSiteURL from "@salesforce/apex/TaxReceiptPageController.getTimeLimitPublicSiteURL";
import TR_RequestTaxReceiptEmail_01 from '@salesforce/label/c.TR_RequestTaxReceiptEmail_01';
import TR_RequestTaxReceiptEmail_01_French from '@salesforce/label/c.TR_RequestTaxReceiptEmail_01_French';
import TR_RequestTaxReceiptEmail_02 from '@salesforce/label/c.TR_RequestTaxReceiptEmail_02';
import TR_RequestTaxReceiptEmail_02_French from '@salesforce/label/c.TR_RequestTaxReceiptEmail_02_French';
import TR_RequestTaxReceiptEmail_03 from '@salesforce/label/c.TR_RequestTaxReceiptEmail_03';
import TR_RequestTaxReceiptEmail_03_French from '@salesforce/label/c.TR_RequestTaxReceiptEmail_03_French';
import TR_RequestTaxReceiptEmailConfirmation from '@salesforce/label/c.TR_RequestTaxReceiptEmailConfirmation';
import TR_RequestTaxReceiptEmailConfirmation_French from '@salesforce/label/c.TR_RequestTaxReceiptEmailConfirmation_French';
import TR_AfterEXpiredLinkRequestTaxReceiptEmail_01 from '@salesforce/label/c.TR_AfterEXpiredLinkRequestTaxReceiptEmail_01';
import TR_AfterEXpiredLinkRequestTaxReceiptEmail_01_French from '@salesforce/label/c.TR_AfterEXpiredLinkRequestTaxReceiptEmail_01_French';
import TR_AfterEXpiredLinkRequestTaxReceiptEmail_02 from '@salesforce/label/c.TR_AfterEXpiredLinkRequestTaxReceiptEmail_02';
import TR_AfterEXpiredLinkRequestTaxReceiptEmail_02_French from '@salesforce/label/c.TR_AfterEXpiredLinkRequestTaxReceiptEmail_02_French';
import 	TR_Privacy_Notice_English from '@salesforce/label/c.TR_Privacy_Notice_English';
import 	TR_Privacy_Notice_French from '@salesforce/label/c.TR_Privacy_Notice_French';
import 	TR_Terms_and_Conditions_English from '@salesforce/label/c.TR_Terms_and_Conditions_English';
import 	TR_Terms_and_Conditions_French from '@salesforce/label/c.TR_Terms_and_Conditions_French';
import 	TR_LinkExpired_English from '@salesforce/label/c.TR_LinkExpired_English';
import 	TR_LinkExpired_French from '@salesforce/label/c.TR_LinkExpired_French';
import 	TR_TaxReceiptRequestPageLabel_English from '@salesforce/label/c.TR_TaxReceiptRequestPageLabel_English';
import 	TR_TaxReceiptRequestPageLabel_French from '@salesforce/label/c.TR_TaxReceiptRequestPageLabel_French';
import 	TR_WelcomeLabel_English from '@salesforce/label/c.TR_WelcomeLabel_English';
import 	TR_WelcomeLabel_French from '@salesforce/label/c.TR_WelcomeLabel_French';
import 	TR_WFP_Supporter_ID_Label_English from '@salesforce/label/c.TR_WFP_Supporter_ID_Label_English';
import 	TR_WFP_Supporter_ID_Label_French from '@salesforce/label/c.TR_WFP_Supporter_ID_Label_French';
import 	TR_YearDropDownCaption_English from '@salesforce/label/c.TR_YearDropDownCaption_English';
import 	TR_YearDropDownCaption_French from '@salesforce/label/c.TR_YearDropDownCaption_French';
import 	TR_RequestTaxReeipt_English from '@salesforce/label/c.TR_RequestTaxReeipt_English';
import 	TR_RequestTaxReeipt_French from '@salesforce/label/c.TR_RequestTaxReeipt_French';
import 	TR_UnauthorisedAccressLabel_English from '@salesforce/label/c.TR_UnauthorisedAccressLabel_English';
import 	TR_UnauthorisedAccressLabel_French from '@salesforce/label/c.TR_UnauthorisedAccressLabel_French';
import 	TR_TaxReceipt_FAQ_English from '@salesforce/label/c.TR_TaxReceipt_FAQ_English';
import 	TR_TaxReceipt_FAQ_French from '@salesforce/label/c.TR_TaxReceipt_FAQ_French';
import 	TR_TaxReceipt_PrivacyNotice_Link_English from '@salesforce/label/c.TR_TaxReceipt_PrivacyNotice_Link_English';
import 	TR_TaxReceipt_PrivacyNotice_Link_French from '@salesforce/label/c.TR_TaxReceipt_PrivacyNotice_Link_French';
import 	TR_TaxReceipt_TermConditions_English from '@salesforce/label/c.TR_TaxReceipt_TermConditions_English';
import 	TR_TaxReceipt_TermConditions_French from '@salesforce/label/c.TR_TaxReceipt_TermConditions_French';
import 	TR_TaxReceipt_FAQ_Link_English from '@salesforce/label/c.TR_TaxReceipt_FAQ_Link_English';
import 	TR_TaxReceipt_FAQ_Link_French from '@salesforce/label/c.TR_TaxReceipt_FAQ_Link_French';
import 	TR_Twitter_Link_English from '@salesforce/label/c.TR_Twitter_Link_English';
import 	TR_Twitter_Link_French from '@salesforce/label/c.TR_Twitter_Link_French';
import 	TR_Facebook_Link_English from '@salesforce/label/c.TR_Facebook_Link_English';
import 	TR_Facebook_Link_French from '@salesforce/label/c.TR_Facebook_Link_French';
import 	TR_Instagram_Link_English from '@salesforce/label/c.TR_Instagram_Link_English';
import 	TR_Instagram_Link_French from '@salesforce/label/c.TR_Instagram_Link_French';
import 	TR_LinkedIn_Link_English from '@salesforce/label/c.TR_LinkedIn_Link_English';
import 	TR_LinkedIn_Link_French from '@salesforce/label/c.TR_LinkedIn_Link_French';
import 	TR_Youtube_Link_English from '@salesforce/label/c.TR_Youtube_Link_English';
import 	TR_Youtube_Link_French from '@salesforce/label/c.TR_Youtube_Link_French';

export default class TaxReceiptPage extends LightningElement {
    @api encodedContactId;
    @api previousLinkExpired;    
    showUI;
    trWfpLogoUrl;
    wfpWhiteLogo;    
    twitterLogo = twitter_LOGO;
    facebookLogoWhite = TR_Facebook_White;
    instagramLogoWhite = TR_Instagram_White;
    linkedInLogoWhite = TR_LinkedIn_White;
    youtubeLogoWhite = TR_Youtube_White;
    trSitePageHeaderUrl = TR_NewTaxReceiptListPageHeader2;
    redErrorIcon = TR_RedErorIcon;
    contactInfo;
    expireValue = 0;
    showRequestMessage = false;
    requestConfirmationMessage;
    showMessage;
    showExpiredLinkMessage;
    dataSecurityMessage;
    privateNotoceMessage;
    termAndConditionMessage;    
    faqLabel;
    linkExpiredLabel;
    taxReceiptRequestPageLabel;
    welcomeLabel;
    wfpSupporterIdLabel;
    yearDropDownLabel;
    taxReceiptRequesButtonLabel;
    unauthorizedUserMessage;
    privateNoticeSiteLink;
    termConditionsLink;
    faqLink;
    twitterMediaLink;
    facebookMediaLink;
    instagramMediaLink;
    linkedInMediaLink;
    youTubeMediaLink;

    // Declare a property to track button disable state
    showButtonSpinner = false;
    
    donationYears = [];
    _selectedYear = '';
    yearOptions = [];

     // Getter property to dynamically set the default value
    get selectedYear() {
        if (!this._selectedYear) {
            if(this.yearOptions.length > 0){
                console.log('RG:  get selectedYear if this.yearOptions[0].value: ' , this.yearOptions[0].value);
                this._selectedYear = this.yearOptions[0].value;
            }
        }
        console.log('RG:  get selectedYear this._selectedYear: ' , this._selectedYear);
        return this._selectedYear;
    }

    // Setter for handling changes to the selected year
    set selectedYear(value) {
        this._selectedYear = value;
    }

    get isPreviousLinkExpired(){
        if(this.previousLinkExpired === "previousLinkExpired"){            
            return true;
        }
        return false;
    }

    connectedCallback() {
        console.log("RG: TaxReceiptPage.js ConnectedCallback: " , this.encodedContactId );
        // Calculate the Current Year and Previous Year dynamically
        const currentYear = new Date().getFullYear();
        const previousYear = currentYear - 1;
        getExpireValue()
        .then(result => {
                this.expireValue = result; 
                this.expireValue = this.expireValue / 60;               
            }
        )
        .catch(error => {
                    console.error('RG: Error fetching Tax Receipt details:', error);
                }
        )
    }

    get myLanguage(){
        if(this.contactInfo){
            return this.contactInfo.TR_TaxReceiptLanguage__c
        }else{
            return null;
        }
    }

    @wire(getContactDetails, { contactId: '$encodedContactId' })
    wiredContactInfo({ error, data }) {
        if(this.encodedContactId) {
            if (data) {
                let clonedObject;
                console.log('RG:getContactDetails: data:  ', data);
                console.log('RG:getContactDetails: data.objContact:  ', data.objContact);
                this.contactInfo = Object.assign({}, data.objContact);
                this.transformContactData();
                this.donationYears = data.lstContactDonationsYears;     
                console.log('RG:getContactDetails: After Conversion this.contactInfo:  ', this.contactInfo);
                console.log('RG:getContactDetails: this.donationYears:  ', this.donationYears);                
                const donationYearsLength =   this.donationYears.length;            
                console.log('RG: getContactDetails: donationYearsLength: ', donationYearsLength);  
                if(donationYearsLength > 0){                    
                    //Populate the yearOptions array with the calculated years
                    for (let i = 0; i < donationYearsLength; i++) {
                        console.log('RG: loop: this.donationYears[0]: ', this.donationYears[0]);
                        let anonymousObject = {
                            label: this.donationYears[i],
                            value: this.donationYears[i],
                        };
                        console.log('RG: getContactDetails: Loop: anonymousObject: ', anonymousObject);
                        clonedObject = Object.assign({}, anonymousObject);                       
                        console.log('RG: getContactDetails: Loop: clonedObject: ', clonedObject);
                        this.yearOptions.push(clonedObject);
                    }
                    this._selectedYear = this.yearOptions[this.yearOptions.length - 1].value;
                } else{
                    this.yearOptions = [
                        { label: "No Donation Year", value: "No" },                
                    ];
                    this.showButtonSpinner = true;
                }
                console.log('RG: getContactDetails: this.yearOptions: ', this.yearOptions);
            }
            if (error) {
                this.contactInfo = null;
                console.log('RG: getContactDetails: error: ', error);
                this.handleError(error);
            }
            this.showUI = true;
        }
    }
    
    renderedCallback(){
        if(this.myLanguage != 'French'){
            const expiryValueInHours = this.expireValue;
            console.log("RG: G renderedCallback: not french expiryValueInHours: " , expiryValueInHours);
            this.showMessage = TR_RequestTaxReceiptEmail_01 + " " + expiryValueInHours + " hours. "; // + TR_RequestTaxReceiptEmail_02;
            this.linkExpiredLabel = TR_LinkExpired_English;
            this.showExpiredLinkMessage = TR_AfterEXpiredLinkRequestTaxReceiptEmail_01 + " ( " + expiryValueInHours + " hours ) "; // + TR_AfterEXpiredLinkRequestTaxReceiptEmail_02;
            this.dataSecurityMessage = TR_RequestTaxReceiptEmail_03;
            this.privateNotoceMessage = TR_Privacy_Notice_English;
            this.termAndConditionMessage = TR_Terms_and_Conditions_English;
            this.taxReceiptRequestPageLabel = TR_TaxReceiptRequestPageLabel_English;
            this.welcomeLabel = TR_WelcomeLabel_English;
            this.wfpSupporterIdLabel  =TR_WFP_Supporter_ID_Label_English;
            this.yearDropDownLabel = TR_YearDropDownCaption_English;
            this.taxReceiptRequesButtonLabel = TR_RequestTaxReeipt_English;
            this.unauthorizedUserMessage = TR_UnauthorisedAccressLabel_English;
            this.faqLabel = TR_TaxReceipt_FAQ_English;
            this.privateNoticeSiteLink = TR_TaxReceipt_PrivacyNotice_Link_English;
            this.termConditionsLink = TR_TaxReceipt_TermConditions_English;
            this.faqLink = TR_TaxReceipt_FAQ_Link_English;
            this.trWfpLogoUrl = TR_NewWFP_LOGO;
            this.wfpWhiteLogo = WFP_LOGO_WHITE;
            this.twitterMediaLink = TR_Twitter_Link_English;
            this.facebookMediaLink = TR_Facebook_Link_English;
            this.instagramMediaLink = TR_Instagram_Link_English;
            this.linkedInMediaLink = TR_LinkedIn_Link_English;
            this.youTubeMediaLink = TR_Youtube_Link_English;
        }else if (this.myLanguage == 'French'){
            const expiryValueInHours = this.expireValue;
            console.log("RG: G renderedCallback: not french expiryValueInHours: " , expiryValueInHours);           
            this.showMessage = TR_RequestTaxReceiptEmail_01_French + " (" + expiryValueInHours + " heures) " + TR_RequestTaxReceiptEmail_02_French;            
            this.linkExpiredLabel = TR_LinkExpired_French;
            this.showExpiredLinkMessage = TR_AfterEXpiredLinkRequestTaxReceiptEmail_01_French + " (" + expiryValueInHours + " heures) " + TR_AfterEXpiredLinkRequestTaxReceiptEmail_02_French;            
            this.dataSecurityMessage = TR_RequestTaxReceiptEmail_03_French;
            this.privateNotoceMessage = TR_Privacy_Notice_French;
            this.termAndConditionMessage = TR_Terms_and_Conditions_French;
            this.taxReceiptRequestPageLabel = TR_TaxReceiptRequestPageLabel_French;
            this.welcomeLabel = TR_WelcomeLabel_French;
            this.wfpSupporterIdLabel  =TR_WFP_Supporter_ID_Label_French;
            this.yearDropDownLabel = TR_YearDropDownCaption_French;
            this.taxReceiptRequesButtonLabel = TR_RequestTaxReeipt_French;
            this.unauthorizedUserMessage = TR_UnauthorisedAccressLabel_French;
            this.faqLabel = TR_TaxReceipt_FAQ_French;
            this.privateNoticeSiteLink = TR_TaxReceipt_PrivacyNotice_Link_French;
            this.termConditionsLink = TR_TaxReceipt_TermConditions_French;
            this.faqLink = TR_TaxReceipt_FAQ_Link_French;
            this.trWfpLogoUrl = TR_NewWFP_LOGO_French;
            this.wfpWhiteLogo = TR_Footer_French_White;
            this.twitterMediaLink = TR_Twitter_Link_French;
            this.facebookMediaLink = TR_Facebook_Link_French;
            this.instagramMediaLink = TR_Instagram_Link_French;
            this.linkedInMediaLink = TR_LinkedIn_Link_French;
            this.youTubeMediaLink = TR_Youtube_Link_French;
        }
    }

    handleYearChange(event){
         // Update the selectedYear property with the selected value from the dropdown
        this.selectedYear = event.detail.value;
        console.log('RG: handleYearChange: this.selectedYear: ' , this.selectedYear); 
        if(this.selectedYear === "No"){
            console.log("RG: handleYearChange selectedYear: ", this.selectedYear);
            this.showButtonSpinner = true; // Disable the button when clicked
            return;
        }else{
            this.showRequestMessage = true;
            this.requestConfirmationMessage = null;
        }
    }

    handleClick(event){
        // console.log('RG: handleClick Request for Tax Receipts Links Clicked!!!: event: ', event);
        // console.log('RG: handleClick getTimeLimitPublicSiteURL called!!!');       
        this.showButtonSpinner = true; // Disable the button when clicked
        const selectedYear = this.template.querySelector(".year-combobox").value;        
        // Check if a year is selected (not an empty value)
        if (selectedYear) {
            getTimeLimitPublicSiteURL(
                                            { 
                                                encodedContactId: this.encodedContactId,
                                                yearSelected: selectedYear
                                            }
                                        )
            .then(result => {
                const expiryValueInHours = this.expireValue;
                // console.log('RG: expiryValueInHours: ' , expiryValueInHours);
                if(this.contactInfo.TR_TaxReceiptLanguage__c != "French"){
                    this.requestConfirmationMessage = TR_RequestTaxReceiptEmailConfirmation + " " + expiryValueInHours + " hours.";
                }else if (this.contactInfo.TR_TaxReceiptLanguage__c == "French"){
                    this.requestConfirmationMessage = TR_RequestTaxReceiptEmailConfirmation_French + " (" + expiryValueInHours + " heures).";
                }
                // console.log('RG: this.requestConfirmationMessage: ' , this.requestConfirmationMessage);
                this.showRequestMessage = true;                
                // Enable the button after the promise resolves
                this.showButtonSpinner = false;
            })
            .catch(error => {
                console.error('RG: Error fetching Tax Receipt details:', error);
                this.showButtonSpinner = false;
            })
        } else {
            console.log("Please select a year before clicking.");
        }
    }

    handleError(error) {
        console.error('RG: An error occurred: ', error);
        // Handle the error, e.g., show an error message to the user
    }

    transformContactData() {
        // Check if the required fields exist in the contact data
        if (
            this.contactInfo.FirstName &&
            this.contactInfo.LastName
        ) {
            // Function to convert a string to title case
            const toTitleCase = (str) => {
                console.log('RG: str: ', str);
                return str.replace(/\w\S*/g, (txt) =>
                    txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
                );
            };

            // Transform the first and last names to title case
            this.contactInfo.FirstName = toTitleCase(this.contactInfo.FirstName);
            this.contactInfo.LastName = toTitleCase(this.contactInfo.LastName);
            console.log('RG: contactInfo.FirstName: ',  this.contactInfo.FirstName);
            console.log('RG: contactInfo.LastName: ', this.contactInfo.LastName);
            console.log('RG: Final this.contactInfo: ', this.contactInfo);
        }
    }
}