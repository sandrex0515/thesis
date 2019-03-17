var app = angular.module('app', ['ngRoute']);

app.config(function ($routeProvider){

    $routeProvider

    .when('/',
    {
        controller: 'analytics',
        templateUrl: '../../HTML/dashboard.html'
    })
    .when('/addproduct',
    {
        controller: 'adminController',
        templateUrl: '../../HTML/addproduct.html'
    })
    .when('/productbl',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/producttbl.html'
    })
    .when('/productbl2',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/producttbl2.html'
    })
    .when('/stock2', 
    {
        controller: 'adminController',
        templateUrl : '../../HTML/productstock.html'
    })
    .when('/stock',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/stock2.html'
    })
    .when('/process',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/process.html'
    })
    .when('/process2',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/process2.html'
    })
    .when('/fordelivery',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/delivery.html'
    }) 
    .when('/fordelivery2',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/delivery2.html'
    })
    .when('/delivered2',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/delivered2.html'
    })
    .when('/delivered',
    {
        controller: 'adminController',
        templateUrl : '../../HTML/delivered.html'
    })
    
 
    
    .otherwise({redirecTo: '/' });
});