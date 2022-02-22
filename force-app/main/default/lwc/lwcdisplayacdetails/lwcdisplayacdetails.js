import { LightningElement, api, track, wire } from 'lwc';
import getAccountdetails from '@salesforce/apex/testclass.getAccountdetails';
export default class Lwcdisplayacdetails extends LightningElement {
    accounts;
    error;
    connectedCallback() {
        getAccountdetails()
            .then(result => {
                this.accounts = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
}