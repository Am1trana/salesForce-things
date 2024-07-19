import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import LEAD_SOURCE_FIELD from '@salesforce/schema/Contact.LeadSource';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ACCOUNT_ID from '@salesforce/schema/Contact.AccountId';

export default class CreateMultiCon extends LightningElement {
    @api contactObject = 'Contact';
    @track picklistValues;

    @wire(getObjectInfo, { objectApiName: '$contactObject' })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: LEAD_SOURCE_FIELD
    })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.picklistValues = data.values;
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    saveRecord() {
        console.log('hello');
        // const urlParams = new URLSearchParams(window.location.search);
        // const recordId = urlParams.get('recordId'); // Fetch recordId
        // console.log(urlParams);
        // console.log(recordId); // Ensure this logs the correct recordId


        const firstName = this.template.querySelectorAll('lightning-input')[0].value;
        const lastName = this.template.querySelectorAll('lightning-input')[1].value;
        const email = this.template.querySelectorAll('lightning-input')[2].value;
        const leadSource = this.template.querySelector('lightning-combobox').value;

        const fields = {};
        fields[FIRST_NAME_FIELD.fieldApiName] = firstName;
        fields[LAST_NAME_FIELD.fieldApiName] = lastName;
        fields[EMAIL_FIELD.fieldApiName] = email;
        fields[LEAD_SOURCE_FIELD.fieldApiName] = leadSource;
        fields[ACCOUNT_ID.fieldApiName] = recordId;

        const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(result => {
                console.log('Contact created with ID:', result.id);

                // Show success toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact created successfully',
                        variant: 'success',
                    }),
                );

                // Reset input fields
                this.template.querySelectorAll('lightning-input').forEach(input => {
                    input.value = '';
                });
                this.template.querySelector('lightning-combobox').value = '';
            })
            .catch(error => {
                console.log(recordInput);
                console.error('Error creating contact:', error, recordInput);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
            });
    }
}
