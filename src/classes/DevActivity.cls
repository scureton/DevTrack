public class DevActivity {

    public list<Dev> activeDevs { get; set; }   
    
    public DevActivity(){
        
        refreshActiveDevs();
        
    }
    
    public void refreshActiveDevs(){
        
        activeDevs = new List<Dev>();
        
        Map<Id,Dev> userToDev = new Map<Id,Dev>();
        
        for(ApexTrigger t:[select Id,Name,CreatedById,CreatedBy.Name,CreatedDate,LastModifiedById,LastModifiedBy.Name,LastModifiedBy.LastName,LastModifiedDate from ApexTrigger where LastModifiedDate=LAST_N_DAYS:7]){
            
            if(!userToDev.containsKey(t.LastModifiedById)){
                
                Dev nd = new Dev(t.LastModifiedBy);
                
                userToDev.put(t.LastModifiedById,nd);
                activeDevs.add(nd);
                
            }
            
            userToDev.get(t.LastModifiedById).items.add(new DevItem(t));
            
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
        
    }
    
    public class Dev{
        
        public Id userId { get; set; }
        public String devName { get; set; }
        public String devLastName { get; set; }
        public List<DevItem> items { get; set; }
        
        public Dev(User u){
            
            this.userId = u.Id;
            this.devName = u.Name;
            this.devLastName = u.LastName;
            
            items = new List<DevItem>();
            
        }
        
        public void sortItems(){
            
            Map<DateTime,list<DevItem>> itemsByModifiedDate = new Map<DateTime,list<DevItem>>();
            
            for(DevItem i:this.items){
                
                if(!itemsByModifiedDate.containsKey(i.lastModifiedDate)){
                    
                    itemsByModifiedDate.put(i.lastModifiedDate,new List<DevItem>());
                                    
                }
                
                itemsByModifiedDate.get(i.lastModifiedDate).add(i);
                
            }
            
            List <DateTime> modifiedDates = new List<DateTime>();
            
            modifiedDates.addAll(itemsByModifiedDate.keyset());
            
            modifiedDates.sort();
            
            this.items = new list<DevItem>();
            
            for(integer x = (modifiedDates.size() - 1); x >= 0; x--){
                
                this.items.addAll(itemsByModifiedDate.get(modifiedDates[x]));
                
            }
            
        }
        
    }
    
    public class DevItem{
        
        public Id itemId { get; set; }
        public String itemName { get; set; }
        public String itemType { get; set; }
        public DateTime lastModifiedDate { get; set; }
        public DateTime createdDate { get; set; }
        public String lastModifiedDateFormat { 
            get{
                return lastModifiedDate.format('MM/dd/yyyy hh:mm aaa');
            }
            set; 
        }
        public String createdDateFormat { 
            get{
                return createdDate.format('MM/dd/yyyy hh:mm aaa');
            }
            set; 
        }       
        public User lastModifiedBy { get; set; }
        public User createdBy { get; set; }
        
        public DevItem(ApexTrigger t){
            
            this.itemId = t.Id;
            this.itemName = t.Name;
            this.itemType = 'Apex Trigger';
            this.lastModifiedDate = t.LastModifiedDate;
            this.createdDate = t.CreatedDate;
            this.lastModifiedBy = t.LastModifiedBy;
            this.createdBy = t.CreatedBy;
            
        }
        
        public DevItem(ApexClass c){
            
            this.itemId = c.Id;
            this.itemName = c.Name;
            this.itemType = 'Apex Class';
            this.lastModifiedDate = c.LastModifiedDate;
            this.createdDate = c.CreatedDate;
            this.lastModifiedBy = c.LastModifiedBy;
            this.createdBy = c.CreatedBy;
            
        }       
        
        public DevItem(ApexPage p){
            
            this.itemId = p.Id;
            this.itemName = p.Name;
            this.itemType = 'Visualforce Page';
            this.lastModifiedDate = p.LastModifiedDate;
            this.createdDate = p.CreatedDate;
            this.lastModifiedBy = p.LastModifiedBy;
            this.createdBy = p.CreatedBy;
            
        }   
        
        public DevItem(ApexComponent c){
            
            this.itemId = c.Id;
            this.itemName = c.Name;
            this.itemType = 'Visualforce Component';
            this.lastModifiedDate = c.LastModifiedDate;
            this.createdDate = c.CreatedDate;
            this.lastModifiedBy = c.LastModifiedBy;
            this.createdBy = c.CreatedBy;
            
        }           
        
    }

}