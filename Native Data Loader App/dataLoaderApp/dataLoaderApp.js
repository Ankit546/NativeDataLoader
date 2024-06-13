import { LightningElement, track, wire } from 'lwc';
import csvHandler from '@salesforce/apex/CSVHandler.processCSVFile';
import startOpDataLoad from '@salesforce/apex/StartOperationDataLoad.operationStart';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DataLoaderApp extends LightningElement {

    @track contentDocumentIds = [];
    @track contentDetails = [];
    dataReceived = false;
    @track csvParsedData = {};
    @track selectedObject = '';
    @track finalResult = '';
    get acceptedFormats() {
        return ['.csv'];
    }
    selectedOperation = ['Insert'];

    get operationOptions(){
        return [
            {label: 'Insert', value: 'Insert'},
            {label: 'Update', value: 'Update'},
            {label: 'Delete', value: 'Delete'}
        ];
    }
    
    handleObjectSelectionFromChild(event){
        console.log('objectSelection## '+JSON.stringify(event));
        this.selectedObject = event.detail;
        console.log('selectedObject# '+this.selectedObject);

    }
    handleOperationChange(e){
        this.selectedOperation = e.detail.value;
        console.log('selected Operation## '+this.selectedOperation);
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;

        console.log('uploadedFiles# '+JSON.stringify(uploadedFiles));
        
        console.log('uploadedFiles.documentId## '+uploadedFiles[0].documentId);
        
        this.contentDocumentIds = uploadedFiles[0].documentId;
        console.log('No. of files uploaded : ' + uploadedFiles.length);  
        console.log('Uploaded File Ids# '+this.contentDocumentIds);
       
    }

    handleClickAfterFileUpload(){
        const docId = this.contentDocumentIds;
        console.log('docId## '+docId);
        csvHandler({ DocumentId : docId })
        .then(result => {
            console.log('OK! Got the data');
           console.log('parsedData is ## '+JSON.stringify(this.cleanCSVData(result)));
           this.csvParsedData = JSON.stringify(this.cleanCSVData(result));
           console.log('Cleaned parsedData is ## '+this.csvParsedData);

            this.dataReceived = true;

        })
        .catch(error =>{
            console.error('Error## '+JSON.stringify(error));
        });
    }

    cleanCSVData(data) {
        return data.map(row => {
            const cleanedRow = {};
            for (let key in row) {
                const cleanedKey = key.trim().replace(/\r$/, ''); // Remove trailing \r from keys
                const cleanedValue = row[key].toString().trim().replace(/\r$/, ''); // Remove trailing \r from values
                cleanedRow[cleanedKey] = cleanedValue;
            }
            return cleanedRow;
        });
    }
    
    handleFinalSubmit(){
        startOpDataLoad({operation: this.selectedOperation, csvData: this.csvParsedData, objectName : this.selectedObject})
        .then(result =>{
            console.log('csvParsedData## '+this.csvParsedData);
            console.log('objectName## '+this.selectedObject);
            console.log('Started operation!'+this.selectedOperation);
            this.finalResult = result;
            console.log('result## '+result);
            this.showToast('Success', 'Records created successfully '+this.finalResult, 'success');

        })
        .catch(error=>{
            console.error('Error in operation call '+JSON.stringify(error));
            this.showToast('Error', 'Error creating records '+error, 'error');
            this.finalResult = error;
            console.log('error## '+error);

        })
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }

}