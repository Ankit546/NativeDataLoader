public class CSVHandler {
    @AuraEnabled
    public static List<Map<String, String>> processCSVFile(Id DocumentId){
        //get the attachment
        //contentdocument doc = [select id, title,filetype,parentid,ownerid from contentdocument where Id =: DocumentId];
        ContentVersion contentVersion = [
            SELECT VersionData 
            FROM ContentVersion 
            WHERE ContentDocumentId = :DocumentId 
            ORDER BY VersionNumber DESC LIMIT 1
        ];
        //conver the blob to String
        String csvContent = contentVersion.VersionData.toString();
        System.debug('csvContentVersionData## '+csvContent);
        //parse the csv
        List<Map<String, String>> parsedData = CSVParser.parseCSV(csvContent);

        System.debug('parsedDate## '+parsedData);

        return parsedData;
    }
}