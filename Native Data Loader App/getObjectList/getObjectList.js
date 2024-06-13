import { LightningElement, track, wire } from 'lwc';
import getAllObjects from '@salesforce/apex/GetObjectListDataLoader.getAllObjects';

export default class GetObjectList extends LightningElement {

    //@track objects;
    @track error;
    @track objectOptions = [];
    @track selectedObject;
    @track value = '';
    @wire(getAllObjects)
    wiredObjects({ data, error }){
        if(data){
            this.objectOptions = data.map(obj => {
                return { label: obj, value: obj };
            });
        }
        else{
            console.error('Error fetching object names:', error);
        }
    }
    handleObjectChange(event) {
        this.value = event.detail.value;
        const selectedObjectEvent = new CustomEvent('objectselection',{
            detail: this.value
        });
        this.dispatchEvent(selectedObjectEvent);

        console.log('selectedObjectChild# '+this.value);
    }
    
}