public class DevelperActionHelper {
	
    //public list<Dev> activeDevs { get; set; }
    public List<Developer_Action__c> currentDevActions;
    public Map<Id, Developer_Action__c> developmentItemIdToDeveloperAction;

    public DevelperActionHelper() {

       // checkForNewActions();

	}
/*
    public void checkForNewActions(){

        Map<Id,Dev> userToDev = new Map<Id,Dev>();

        // to-do: add where clause to filter on LastModifiedDate based on last polling time.
        DateTime pollingTime = dateTime.now().addHours(-1);
        // hard-coding a date for this currently

        for(ApexTrigger t:[SELECT Id,Name,Body,LastModifiedBy.Name,LastModifiedBy.LastName,LastModifiedDate FROM ApexTrigger WHERE LastModifiedDate > pollingTime]){
            


        }
        
        for(ApexClass c:[select Id,Name,CreatedById,CreatedBy.Name,CreatedDate,LastModifiedById,LastModifiedBy.Name,LastModifiedBy.LastName,LastModifiedDate from ApexClass where LastModifiedDate=LAST_N_DAYS:7]){
            
            if(!userToDev.containsKey(c.LastModifiedById)){
                
                Dev nd = new Dev(c.LastModifiedBy);
                
                userToDev.put(c.LastModifiedById,nd);
                activeDevs.add(nd);
                
            }
            
            userToDev.get(c.LastModifiedById).items.add(new DevItem(c));
            
        }   
        
        for(ApexPage p:[select Id,Name,CreatedById,CreatedBy.Name,CreatedDate,LastModifiedById,LastModifiedBy.Name,LastModifiedBy.LastName,LastModifiedDate from ApexPage where LastModifiedDate=LAST_N_DAYS:7]){
            
            if(!userToDev.containsKey(p.LastModifiedById)){
                
                Dev nd = new Dev(p.LastModifiedBy);
                
                userToDev.put(p.LastModifiedById,nd);
                activeDevs.add(nd);
                
            }
            
            userToDev.get(p.LastModifiedById).items.add(new DevItem(p));
            
        }   
        
        for(ApexComponent c:[select Id,Name,CreatedById,CreatedBy.Name,CreatedDate,LastModifiedById,LastModifiedBy.Name,LastModifiedBy.LastName,LastModifiedDate from ApexComponent where LastModifiedDate=LAST_N_DAYS:7]){
            
            if(!userToDev.containsKey(c.LastModifiedById)){
                
                Dev nd = new Dev(c.LastModifiedBy);
                
                userToDev.put(c.LastModifiedById,nd);
                activeDevs.add(nd);
                
            }
            
            userToDev.get(c.LastModifiedById).items.add(new DevItem(c));
            
        }   
        
        Map<String, List<Dev>> devsByName = new Map<String,List<Dev>>();    
        
        for(Dev d:activeDevs){
            
            if(!devsByName.containsKey(d.devLastName)){
                
                devsByName.put(d.devLastName,new list<Dev>());
                
            }
            
            devsByName.get(d.devLastName).add(d);
            
            d.sortItems();
            
        }               
        
        List<String> devNames = new List<String>();
        devNames.addAll(devsByName.keySet());
        
        devNames.sort();
        
        activeDevs = new List<Dev>();
        
        for(String s:devNames){
            
            activeDevs.addAll(devsByName.get(s));
            
        }
    }*/
}