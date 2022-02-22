import { LightningElement, wire, api, track } from 'lwc';
import getTransactionalQueries from '@salesforce/apex/TransactionalQueriesController.getTransactionalQueries';
import insertTransactionalQueries from '@salesforce/apex/TransactionalQueriesController.insertTransactionalQueries';
import updateTransactionalQueries from '@salesforce/apex/TransactionalQueriesController.updateTransactionalQueries';
import { refreshApex } from '@salesforce/apex';
//const endpointURL = 'https://demo3262908.mockable.io/retreiveTransactionDetails';

export default class GetPostTransactionalQuesries extends LightningElement {
    @api recordId;
    @track columns = [
        { label: 'reference', fieldName: 'reference' },
        { label: 'transactionDate', fieldName: 'transactionDate', type: 'text', typeAttributes: { day: "numeric", month: "numeric", year: "numeric" } },
        { label: 'transactionAmount', fieldName: 'transactionAmount', type: 'decimal' },
        { label: 'description', fieldName: 'description', type: 'text', editable: 'true' },
    ];
    respdata;

    connectedCallback() {
        getTransactionalQueries({ strAccountName: '$recordId' })
            .then(result => {
                console.log(result)
                this.respdata = result
            })
            .catch(error => {
                console.log(error)
            })
    }
    finalrec = []
    draftValues = [];
    handlesave(e) {
        //let finalrec = []
        this.draftValues = e.detail.draftValues;
        let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
        let sRecords = JSON.parse(JSON.stringify(selectedRecords));
        let recordInputs = JSON.parse(JSON.stringify(this.draftValues));
        let srecordInputs = JSON.parse(JSON.stringify(recordInputs));
        let result1 = sRecords.map(obj => {
            let data = srecordInputs.find(item => item.reference === obj.reference);
            return { ...obj, ...data }
        });
        this.finalrec.push(result1)
        console.log('recordInputs are ', this.finalrec);

        insertTransactionalQueries({ data: result1, recId: '$recordId' })
            .then(result => {
                var ref = [];
                result.forEach(function (message) {
                    ref.push({
                        "reference": message.Transaction_Reference__c
                    });
                    return refreshApex(this.respdata).then(() => {
                        this.draftValues = [];

                    });
                });
                if (result) {
                    updateTransactionalQueries({ tqtoprocess: JSON.stringify(result) })
                        .then(res => {

                        })
                        .catch(error => {
                            console.log(error)
                        })
                }
            })
            .catch(error => {
                console.log(error)
            })

    }
}