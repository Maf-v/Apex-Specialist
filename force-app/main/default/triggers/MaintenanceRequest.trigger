trigger MaintenanceRequest on Case (after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    List<Id> caseIds = new List<Id>();
    for(Case maintenanceRequest : Trigger.new) {
        if((maintenanceRequest.Type == 'Repair' || maintenanceRequest.Type == 'Routine Maintenance') && maintenanceRequest.Status == 'Closed' ) {
            caseIds.add(maintenanceRequest.Id);
        }
    }

    if(caseIds.size() > 0) {
        MaintenanceRequestHelper.updateWorkOrders(caseIds);
    }
}