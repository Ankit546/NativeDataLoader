public class StartOperationDataLoad {

    @AuraEnabled
    public static String operationStart(String operation, String csvData, String objectName){
        System.debug('csvData# '+csvData);
        //List<Map<String, String>> data = CSVParser.parseCSV(csvData);
        List<Object> data = (List<Object>) JSON.deserializeUntyped(csvData);
        String res;
        
        System.debug('data# '+data);
        System.debug('operation# '+operation);
        System.debug('objectName# '+objectName);
        
        if(operation == 'Insert'){
            res = insertRecords(objectName, data);
        }
        else if(operation == 'Update'){
            res = updateRecords(objectName, data);
        }
        else if(operation == 'Delete'){
            res = deleteRecords(objectName, data);
           
        }
        return res;
    }
    
    public static String insertRecords(String objectName, List<Object> csvData){
        List<SObject> records = new List<SObject>();
        String successId;
        String errorMsg;
        for(Object row: csvData){
            Map<String, Object> rowMap = (Map<String, Object>)row;
            SObject record = (SObject)Type.forName('Schema.'+objectName).newInstance();
            System.debug('record# '+record);
            for(String key : rowMap.keySet()){
                record.put(key, rowMap.get(key));
            }
            records.add(record);
        }
        System.debug('records## '+records);
        if(!records.isEmpty()){
           Database.SaveResult[] srList = Database.insert(records, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {

                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Record ID: ' + sr.getId());
                successId = sr.getId();
                return successId;
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Record fields that affected this error: ' + err.getFields());
                    errorMsg = err.getMessage();
                    //return errorMsg;
                }
                }
                }
                System.debug('records# '+records);
                System.debug('successId# '+successId);
                if(errorMsg!=null)
                    return errorMsg;
            
        
        }
        return successId;
    }
    
    public static String updateRecords(String objectName, List<Object> csvData){
        List<SObject> records = new List<SObject>();
        String successId;
        String errorMsg;
        System.debug('updateRecords# ');
        System.debug('csvData# '+csvData);
        
        for(Object row : csvData){
            Map<String, Object> rowMap = (Map<String, Object>) row;
            //how to get the objectName??
            SObject record = (SObject)Type.forName('Schema.'+objectName).newInstance();
            System.debug('record# '+record);

            for(String key : rowMap.keySet()){
                record.put(key, rowMap.get(key));
            }
            records.add(record);
            
        }
        System.debug('records## '+records);
        if(!records.isEmpty()){
           Database.SaveResult[] srList = Database.update(records, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {

                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated record. Record ID: ' + sr.getId());
                successId = sr.getId();
                return successId;
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Record fields that affected this error:' + err.getFields());
                    errorMsg = err.getMessage();
                    //return errorMsg;
                }
                }
                }
                System.debug('records# '+records);
                System.debug('successId# '+successId);
                if(errorMsg!=null)
                    return errorMsg;
            
        
        }
        return successId;
        
    }

    public static String deleteRecords(String objectName, List<Object> csvData){
        List<SObject> records = new List<SObject>();
        String successId;
        String errorMsg;
        System.debug('updateRecords# ');
        System.debug('csvData# '+csvData);
        
        for(Object row : csvData){
            Map<String, Object> rowMap = (Map<String, Object>) row;
            //how to get the objectName??
            SObject record = (SObject)Type.forName('Schema.'+objectName).newInstance();
            System.debug('record# '+record);

            for(String key : rowMap.keySet()){
                record.put(key, rowMap.get(key));
            }
            records.add(record);
            
        }
        System.debug('records## '+records);
        if(!records.isEmpty()){
           Database.DeleteResult[] srList = Database.delete(records, false);

        // Iterate through each returned result
        for (Database.DeleteResult sr : srList) {
            if (sr.isSuccess()) {

                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted record. Record Id ' + sr.getId());
                successId = sr.getId();
                return successId;
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Record fields that affected this error: ' + err.getFields());
                    errorMsg = err.getMessage();
                    //return errorMsg;
                }
                }
                }
                System.debug('records# '+records);
                System.debug('successId# '+successId);
                if(errorMsg!=null)
                    return errorMsg;
            
        
        }
        return successId;
    }
}