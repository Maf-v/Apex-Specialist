public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts{

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public void execute (QueueableContext c) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        List<deserializeJSON> deserializedResp = (List<deserializeJSON>)JSON.deserialize(response.getBody(), List<deserializeJSON>.class);
        
        // Crea los Equipment products a insertar
        List<Product2> equipmentList = new List<Product2>();
        for (deserializeJSON productData : deserializedResp) {
                equipmentList.add(new Product2(
                Name = productData.name,
            	Cost__c = productData.cost,
                Replacement_Part__c = productData.replacement,
                Current_Inventory__c = productData.quantity,
                Lifespan_Months__c = productData.lifespan,
                Maintenance_Cycle__c = productData.maintenanceperiod,
                Warehouse_SKU__c = productData.sku
            ));
        }
        System.debug(equipmentList);
		upsert equipmentList Warehouse_SKU__c;
    }
}