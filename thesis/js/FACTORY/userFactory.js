app.factory('userFactory', function($http){

    var factory = {};


   
    factory.fetch = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/fetch.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };
    factory.fetchsearch = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/fetchsearch.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };

    factory.cartfetch = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/cartfetch.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };
    
    factory.delcart = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/cartdel.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };
    factory.cart = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/cart.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };
    factory.get_info = function(data){
        var promise = $http({
            url: 'php/FUNCTIONS/get_info.php',
            method: 'POST',
            headers: {'Content-Type' : 'application/x-www-form-urlencoded'},
            transformRequest: function(obj){
                var str = [];
                for(var p in obj)
                    str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                return str.join("&");
                },
                data: data  
        });
        return promise;
    };
    return factory;
});