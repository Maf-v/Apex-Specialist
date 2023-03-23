@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest
    static void scheduleTest() {
        Test.setMock(HttpCalloutMock.class , new WarehouseCalloutServiceMock());
        
        Test.startTest();
        String cronExp = '0 0 4 * * ?';
        String jobId = System.schedule('WarehouseSyncScheduleJobTest', cronExp, new WarehouseSyncSchedule());
        
        CronTrigger ct = [SELECT TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();

    }
}