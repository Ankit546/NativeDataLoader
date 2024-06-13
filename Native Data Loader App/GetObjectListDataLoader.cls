public class GetObjectListDataLoader {

    @AuraEnabled(cacheable=true)
    public static List<String> getAllObjects(){
        Map<String,String> objectMap = new Map<String,String>();
        List<String> objectList = new List<String>();

        for (Schema.SObjectType objTyp : Schema.getGlobalDescribe().values()){
            String name = objTyp.getDescribe().getName();
            String label = objTyp.getDescribe().getLabel();
            if(!name.containsignorecase('history') && !name.containsignorecase('tag') &&
                !name.containsignorecase('share') && !name.containsignorecase('feed') && 
               	!name.containsignorecase('group') && !name.containsignorecase('public') &&
                !objTyp.getDescribe().isCustomSetting() && objTyp.getDescribe().isCreateable() &&
                objTyp.getDescribe().getRecordTypeInfos().size() > 0){      
                objectMap.put(name,label);
                objectList.add(name);
           }
        }
        System.debug('objectList## '+objectList);
        if(objectList != null && objectList.size() > 0){
        	return objectList;   
        }else{
            return null;
        }
    }
}