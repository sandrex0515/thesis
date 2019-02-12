var app = angular.module('app', ['ngRoute']);

app.config(function ($routeProvider){

    $routeProvider

    .when('/',
    {
        controller: 'adminController',
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
    
    .otherwise({redirecTo: '/' });
});