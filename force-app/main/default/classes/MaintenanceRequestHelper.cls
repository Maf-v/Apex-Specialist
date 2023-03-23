public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Id> caseIds) {
        // TODO: Complete the method to update workorders
        List<Case> caseList = [SELECT Id, Vehicle__c, (SELECT Id, Equipment__r.Maintenance_Cycle__c, Quantity__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Id IN :caseIds];
     	
        List<Case> newCases = new List<Case>();
        List<Equipment_Maintenance_Item__c> newEMIList = new List<Equipment_Maintenance_Item__c>();
        for(Case maintenanceReq : caseList) {
            // Crea una lista que contiene la cantidad de dias de ciclo, para cada producto involucrado en el mantenimiento
            List<Integer> cycleDaysList = new List<Integer>();
            for(Equipment_Maintenance_Item__c equipMaintItem : maintenanceReq.Equipment_Maintenance_Items__r) {
                cycleDaysList.add((Integer)equipMaintItem.Equipment__r.Maintenance_Cycle__c);
                
                newEMIList.add(new Equipment_Maintenance_Item__c(
                	    Maintenance_Request__c = maintenanceReq.Id,
                        Equipment__c = equipMaintItem.Equipment__c,
                        Quantity__c = equipMaintItem.Quantity__c
                ));
            }
            // Ordena la lista para que el primer elemento sea el de menor cantidad de dias
            cycleDaysList.sort();
			
            newCases.add(new Case(
                Status = 'New',
            	Vehicle__c = maintenanceReq.Vehicle__c,
                Type = 'Routine Maintenance',
                Subject = 'Routine Maintenance',
                Date_Reported__c = Date.today(),
                Date_Due__c = Date.today() + cycleDaysList[0]
            ));    
        }
        List<Database.SaveResult> results = Database.insert(newCases);
        
        List<Id> newCasesId = new List<Id>();
        for (Database.SaveResult result : results) {
            newCasesId.add(result.getId());
        }
        
        List<Case> casesInserted = [SELECT Id, (SELECT Id, Equipment__c, Quantity__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Id IN :newCasesId];
		Map<Id, Id> mapId = new Map<Id,Id>();
        for (Integer  i = 0; i < caseList.size(); i++) {
            mapId.put(caseList[i].Id, casesInserted[i].Id);
        }
        
        for (Equipment_Maintenance_Item__c newEMI : newEMIList) {
            newEMI.Maintenance_Request__c = mapId.get(newEMI.Maintenance_Request__c);
        }
        
        List<Database.SaveResult> insertedEMI = Database.insert(newEMIList);
    }        
    
}