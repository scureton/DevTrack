public class ReservationHelper {
	
    public List<Reservation__c> currentReservations { get; set; }
    public List<Development_Item__c> devItems { get; set; }
    public Development_Item__c devItem { get; set; }
    public List<DevItemWrapper> devItemWrappers { get; set; }
    public String devName { get; set; }
    public String itemName { get; set; }

    public List<Reservation__c> newReservations { get; set; }


    public ReservationHelper() {
		
        devName = UserInfo.getName();
        devItems = new List<Development_Item__c>();

	}

    public void getDevItems(){

        devItemWrappers = new List<DevItemWrapper>();
        String searchString = '%'+itemName+'%';

        devItems = [SELECT Id, Name, Type__c, Currently_Reserved__c, Current_Reservations__c,(SELECT Id, Developer__c,
                    Status__c, Time_Checked_Out__c, User_Story__c FROM Reservations__r WHERE Status__c = 'Out')
                    FROM Development_Item__c WHERE Name LIKE :searchString];


        for(Development_Item__c d : devItems){
            devItemWrappers.add(new DevItemWrapper(d));
        }
    }

    public boolean hasReservations(){

        currentReservations = new list<Reservation__c>();

        if(currentReservations.size()>0){
            return true;
        }else{
            return false;
        }

    }

    public void makeReservation(){

        List<Development_Item__c> checkedItems = new List<Development_Item__c>();
        List<Reservation__c> newReservations = new List<Reservation__c>();

        for(devItemWrapper d : devItemWrappers){
            if(d.reserveCheckbox){
                checkedItems.add(d.developmentItem);
            }
        }

        for(Development_Item__c d : checkedItems){
            if(d.Reservations__r.isEmpty()){
                Reservation__c newRes = new Reservation__c(
                    Developer__c = devName,
                    Development_Item__c = d.id,
                    Status__c = 'Out',
                    Time_Checked_Out__c = dateTime.now()
                    //to-do: include population of the User Story field with some user input
                    );

                newReservations.add(newRes);
                String confirmation = d.name + ' has been reserved.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, confirmation));
                // also need to make different error message if the reservation is by the same user.
            }else{
                String warning = d.name + ' is already reserved by: ' + d.Reservations__r[0].Developer__c;
                warning += '.  You can over-ride and reserve anyway by clicking Reserve again.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, warning));
            }
        }

        if(newReservations.size()>0){
            insert newReservations;
        }
        getDevItems();

    }

    public void releaseReservation(){

        List<Development_Item__c> checkedItems = new List<Development_Item__c>();

        for(devItemWrapper d : devItemWrappers){
            if(d.reserveCheckbox){
                checkedItems.add(d.developmentItem);
            }
        }

        List<Reservation__c> reservationsToUpdate = new List<Reservation__c>();

        for(Development_Item__c d : checkedItems){
            if(d.Currently_Reserved__c){
                if(d.Current_Reservations__c.contains(devName)){    
                    for(Reservation__c r : d.Reservations__r){
                        if(r.Developer__c == devName){
                            r.Status__c = 'Returned';
                            r.Time_Released__c = dateTime.now();
                            reservationsToUpdate.add(r);
                            String confirmation = d.name + ' has been released from reservation.';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, confirmation));
                        }
                    }
                }else{
                    String warning = d.name + ' is not reserved by you so you can not release it.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, warning));
                }
            }else{
                String warning = d.name + ' is not currently reserved by anyone so it can not be released.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, warning));
            }
        }

        if(reservationsToUpdate.size()>0){
            update reservationsToUpdate;
        }
        getDevItems();
    }

    public class DevItemWrapper{

        public Development_Item__c developmentItem { get; set; }
        public Boolean reserveCheckbox { get; set; }

        public DevItemWrapper(Development_Item__c d){
            this.developmentItem = d;
            this.reserveCheckbox = false;
        }
    }



    // Add an HTTP:POST to stratosource on creation or update of Reservation records.  Or have Stratosource query
    // these records as part of its polling.

    // Need to method to check a Development Item for existing reservations and check it out if there are none.  Display
    // a warning and a second 'save' button if there are.  Should set the Check-Out time and the Developer if the
    // reservation is made.

    // Need a method for the 'save' over-ride to allow checking out of an already-reserved Item.  Should set the check-Out time
    // and the developer if a reservation is made.

}