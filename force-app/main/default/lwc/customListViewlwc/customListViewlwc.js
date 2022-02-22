import { api, LightningElement, track, wire } from 'lwc';
import fetchRecs from '@salesforce/apex/CustomListViewController.fetchRecs';
import { NavigationMixin } from 'lightning/navigation';

export default class CustomListViewlwc extends LightningElement {
    @track listRecs;
    @track initialListRecs;
    @track error;
    @track columns;
    @api AccountId;
    @api RelatedObject;
    @api Fields;
    @api RelatedField;
    @api TableColumns;
    @api Title;
    sortedBy;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';

    connectedCallback() {

        console.log('Columns are ' + this.TableColumns);
        this.columns = JSON.parse(this.TableColumns.replace(/([a-zA-Z0-9]+?):/g, '"$1":').replace(/'/g, '"'));
        console.log('Columns are ' + this.columns);

    }

    get vals() {

        return this.RelatedObject + '-' + this.Fields + '-' +
            this.RelatedField + '-' + this.AccountId;

    }

    @wire(fetchRecs, { listValues: '$vals' })
    wiredRecs({ error, data }) {

        if (data) {

            console.log('Records are ' + JSON.stringify(data));
            this.listRecs = data;
            this.initialListRecs = data;

        } else if (error) {

            this.listRecs = null;
            this.initialListRecs = null;
            this.error = error;

        }

    }

    handleKeyChange(event) {

        const searchKey = event.target.value.toLowerCase();
        console.log('Search Key is ' + searchKey);

        if (searchKey) {

            this.listRecs = this.initialListRecs;

            if (this.listRecs) {

                let recs = [];
                for (let rec of this.listRecs) {

                    console.log('Rec is ' + JSON.stringify(rec));
                    let valuesArray = Object.values(rec);
                    console.log('valuesArray is ' + valuesArray);

                    for (let val of valuesArray) {

                        if (val.toLowerCase().includes(searchKey)) {

                            recs.push(rec);
                            break;

                        }

                    }

                }

                console.log('Recs are ' + JSON.stringify(recs));
                this.listRecs = recs;

            }

        } else {

            this.listRecs = this.initialListRecs;

        }

    }

    onHandleSort(event) {

        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.listRecs];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.listRecs = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

    }

    sortBy(field, reverse, primer) {

        const key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };

    }

    handleRowAction(event) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view':
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view',
                    },
                }).then(url => {
                    window.open(url);
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: this.RelatedObject,
                        actionName: 'edit'
                    }
                });
                break;
            default:
        }

    }

    createNew() {

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.RelatedObject,
                actionName: 'new'
            }
        });

    }
}