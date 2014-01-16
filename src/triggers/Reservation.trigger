trigger Reservation on Reservation__c (after insert, after update) {

    Set<Id> devItemIds = new Set<Id>();

    for(Reservation__c res : trigger.new){
        devItemIds.add(res.Development_Item__c);
    }

    List<Development_Item__c> devItems = [SELECT Id, Current_Reservations__c, Currently_Reserved__c,(
                                            SELECT Developer__c FROM Reservations__r WHERE Status__c =
                                            'Out') FROM Development_Item__c WHERE Id in :devItemIds];
    

    for(Development_Item__c d : devItems){
        String currentReservations;
        Integer x = 0;
        for(Reservation__c r : d.Reservations__r){
            if(x==0){
                currentReservations = r.Developer__c;
            }else{
                currentReservations += '; '+ r.Developer__c;
            }
            x++;
        }
        if(currentReservations!=null){
            d.Currently_Reserved__c = true;
            d.Current_Reservations__c = currentReservations;
        }else{
            d.Currently_Reserved__c = false;
            d.Current_Reservations__c = null;
        }
    }

    update devItems;
}