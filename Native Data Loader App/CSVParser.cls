public class CSVParser {

    public static List<Map<String, String>> parseCSV(String csvContent){
        List<Map<String, String>> resultList = new List<Map<String, String>>();

        //split CSV contents into lines
        List<String> lines = csvContent.split('\n');

        if(lines.size()>0){
            //get Headers
            List<String> headers = lines[0].split(',');

            //iterate over the lines - starting from first line
            for(Integer i=1;i<lines.size();i++){
                List<String> values = lines[i].split(',');
                Map<String, String> rowMap = new Map<String, String>();

                //map values to headers
                for(Integer j=0;j<headers.size();j++){
                    rowMap.put(headers[j], values[j]);
                }

                resultList.add(rowMap);
            }
        }

        return resultList;
    }

}