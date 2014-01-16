public class DevelopmentItemHelper {
    
    public List<Development_Item__c> updatedDevItems;
    public List<Development_Item__c> newDevItems;
    public DevelopmentItemHelper(){

        // Query all current DevelopmentItem records

        List<Development_Item__c> currentDevItems = [SELECT Id,Name,Type__c,Item_Id__c FROM Development_Item__c];
        updatedDevItems = new List<Development_Item__c>();
        newDevItems = new List<Development_Item__c>();

        refreshDevItems(currentDevItems);

    }
    
    public void refreshDevItems(List<Development_Item__c> currentDevItems){
        
        List<Set<Id>> devItemIdSets = new List<Set<Id>>();
        boolean isFirstTime = false;

        if(currentDevItems.size()>0){
            devItemIdSets = sortCurrentDevItems(currentDevItems);
        }else{
            isFirstTime = true;
        }

        for(ApexTrigger t:[SELECT Id,Name FROM ApexTrigger]){
            if(!isFirstTime){
                if(devItemIdSets[0].contains(t.id)){
                    for(Development_Item__c d:currentDevItems){
                        if(d.Item_Id__c==t.id && d.Name != t.Name){
                            d.Name=t.Name;
                            updatedDevItems.add(d);
                            break;
                        }
                    }
                }
            }else{
                Development_Item__c newDevItem = new Development_Item__c(
                    Name = t.Name,
                    Item_Id__c = t.Id,
                    Type__c = 'Trigger'
                );
                newDevItems.add(newDevItem);
            }
        }

        for(ApexClass c:[SELECT Id,Name FROM ApexClass]){
            if(!isFirstTime){
                if(devItemIdSets[1].contains(c.id)){
                    for(Development_Item__c d:currentDevItems){
                        if(d.Item_Id__c==c.id && d.Name != c.Name){
                            d.Name=c.Name;
                            updatedDevItems.add(d);
                            break;
                        }
                    }
                }
            }else{
                Development_Item__c newDevItem = new Development_Item__c(
                    Name = c.Name,
                    Item_Id__c = c.Id,
                    Type__c = 'Class'
                );
                newDevItems.add(newDevItem);
            }
        }

        for(ApexPage p:[SELECT Id,Name FROM ApexPage]){
            if(!isFirstTime){
                if(devItemIdSets[2].contains(p.id)){
                    for(Development_Item__c d:currentDevItems){
                        if(d.Item_Id__c==p.id && d.Name != p.Name){
                            d.Name=p.Name;
                            updatedDevItems.add(d);
                            break;
                        }
                    }
                }
            }else{
                Development_Item__c newDevItem = new Development_Item__c(
                    Name = p.Name,
                    Item_Id__c = p.Id,
                    Type__c = 'Page'
                );
                newDevItems.add(newDevItem);
            }
        }

        for(ApexComponent c:[SELECT Id,Name FROM ApexComponent]){
            if(!isFirstTime){
                if(devItemIdSets[3].contains(c.id)){
                    for(Development_Item__c d:currentDevItems){
                        if(d.Item_Id__c==c.id && d.Name != c.Name){
                            d.Name=c.Name;
                            updatedDevItems.add(d);
                            break;
                        }
                    }
                }
            }else{
                Development_Item__c newDevItem = new Development_Item__c(
                    Name = c.Name,
                    Item_Id__c = c.Id,
                    Type__c = 'Component'
                );
                newDevItems.add(newDevItem);
            }
        }
        if(updatedDevItems.size()>0){
            update updatedDevItems;
        }
        if(newDevItems.size()>0){
            insert newDevItems;
        }
    }

    public List<Set<Id>> sortCurrentDevItems(List<Development_Item__c> currentDevItems){

        List<Set<Id>> devItemSetsByname = new List<Set<Id>>();
        Set<Id> triggers = new Set<Id>();
        Set<Id> classes = new Set<Id>();
        Set<Id> pages = new Set<Id>();
        Set<Id> components = new Set<Id>();

        for(Development_Item__c d : currentDevItems){
            if(d.Type__c=='Trigger'){
                triggers.add(d.Item_Id__c);
            }else if(d.Type__c=='Class'){
                classes.add(d.Item_Id__c);
            }else if(d.Type__c=='Page'){
                pages.add(d.Item_Id__c);
            }else if(d.Type__c=='Component'){
                components.add(d.Item_Id__c);
            }
        }

        devItemSetsByname.add(triggers);
        devItemSetsByname.add(classes);
        devItemSetsByname.add(pages);
        devItemSetsByname.add(components);

        return devItemSetsByname;
    }

}