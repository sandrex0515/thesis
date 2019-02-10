var app = angular.module('app', ['ngRoute']);

app.config(function ($routeProvider){

    $routeProvider

    .when('/',
    {
        controller: 'loginController',
        templateUrl: './HTML/body.html'
    })
    .when('/admin',
    {
        controller: 'loginController',
        templateUrl: './admin/page/index.html'
    })
    
    .otherwise({redirecTo: '/' });
});