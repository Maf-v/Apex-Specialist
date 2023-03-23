@isTest
public with sharing class MaintenanceRequestHelperTest {

    @isTest
    static void triggerBulk() {
        Product2 newProduct = new Product2(Name = 'Test Product', Maintenance_Cycle__c = 15, Replacement_Part__c = true);
        insert newProduct;
        
        Vehicle__c newVehicle = new Vehicle__c(Name = 'Vehicle Test');
        insert newVehicle;
        
        List<Case> newCases = new List<Case>();
        for (Integer i = 0; i < 300; i++) {
            newCases.add(new Case(
                Type = 'Routine Maintenance',
                Status = 'New',
                Subject = 'Testing',
                Date_Reported__c = Date.today(),
                ProductId = newProduct.id,
                Vehicle__c = newVehicle.Id
            ));
        }
        insert newCases;
        
        List<Equipment_Maintenance_Item__c> listEMI = new List<Equipment_Maintenance_Item__c>();
        for (Case newCase : newCases) {
            listEMI.add(new Equipment_Maintenance_Item__c(
            	Maintenance_Request__c = newCase.Id,
                Equipment__c = newProduct.Id,
                Quantity__c = 10
            ));
        }
        insert listEMI;
        
        for(Case newCase : newCases) {
            newCase.Status = 'Closed';
        }
        
		update newCases;
        
        List<Case> casesCreated = [SELECT Id, Date_Reported__c, Status FROM Case WHERE Status = 'New' AND Subject = 'Routine Maintenance' AND Date_Reported__c = :Date.today() ];
        System.debug(casesCreated.size());
        System.assertEquals(300, casesCreated.size());
    }
    
    @isTest
    static void triggerPositive() {
        Product2 newProduct = new Product2(Name = 'Test Product', Maintenance_Cycle__c = 15, Replacement_Part__c = true);
        insert newProduct;
        
        Vehicle__c newVehicle = new Vehicle__c(Name = 'Vehicle Test');
        insert newVehicle;
        
        Case newCase = new Case(
                Type = 'Routine Maintenance',
                Status = 'New',
                Subject = 'Testing',
                Date_Reported__c = Date.today(),
                ProductId = newProduct.id,
            	Vehicle__c = newVehicle.id
        );
        insert newCase;
        
        Equipment_Maintenance_Item__c newEMI = new Equipment_Maintenance_Item__c(
            	Maintenance_Request__c = newCase.Id,
                Equipment__c = newProduct.Id,
                Quantity__c = 10
        );
        insert newEMI;
        
        newCase.Status = 'Closed';
        update newCase;
        
        List<Case> casesCreated = [SELECT Id, Date_Reported__c, Status, Vehicle__c, (SELECT Id, Equipment__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Status = 'New' AND Subject = 'Routine Maintenance' AND Date_Reported__c = :Date.today() ];
        System.assertEquals(1, casesCreated.size());
        System.assertEquals(false, String.isBlank(casesCreated[0].Vehicle__c));
        for (Equipment_Maintenance_Item__c EMI : casesCreated[0].Equipment_Maintenance_Items__r) {
        	System.assertEquals(false, String.isBlank(EMI.Equipment__c));  
        }
        
    }
    
    @isTest
    static void triggerNegative() {
        Product2 newProduct = new Product2(Name = 'Test Product', Maintenance_Cycle__c = 15, Replacement_Part__c = true);
        insert newProduct;
        
        Case newCase = new Case(
                Type = 'Routine Maintenance',
                Status = 'New',
                Subject = 'Testing',
                Date_Reported__c = Date.today(),
                ProductId = newProduct.id
        );
        insert newCase;
        
        Equipment_Maintenance_Item__c newEMI = new Equipment_Maintenance_Item__c(
            	Maintenance_Request__c = newCase.Id,
                Equipment__c = newProduct.Id,
                Quantity__c = 10
        );
        insert newEMI;
        
        newCase.Status = 'Working';
        update newCase;
        
        List<Case> casesAfter = [SELECT Id, Date_Reported__c, Status FROM Case WHERE Status = 'New' AND Subject = 'Routine Maintenance' AND Date_Reported__c = :Date.today()  ];
        System.assertEquals(true, casesAfter.isEmpty());
    }
    
}