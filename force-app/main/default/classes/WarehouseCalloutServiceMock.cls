public class WarehouseCalloutServiceMock implements HttpCalloutMock{
    // implement http mock callout
    public HttpResponse respond(HttpRequest request) {
        String body = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Test Name 1","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Test Name 2","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]';
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(body);
        response.setHeader('Content-Type', 'application/json');
        
        return response;
    }
}