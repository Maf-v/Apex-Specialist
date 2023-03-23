@IsTest
private class WarehouseCalloutServiceTest {
    
	@isTest
    static void calloutService() {
        Test.setMock(HttpCalloutMock.class , new WarehouseCalloutServiceMock());
        
        Test.startTest();
        System.enqueueJob(new WareHouseCalloutService());
        Test.stopTest();
        
        List<Product2> equipmentList = [SELECT Id, Name FROM Product2 WHERE Name LIKE 'Test Name%'];
        System.assertEquals(2, equipmentList.size());
        
    }
}