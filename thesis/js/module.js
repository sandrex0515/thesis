var app = angular.module('app', ['ngRoute', 'angular-md5']);

app.config(function ($routeProvider){

    $routeProvider
    
    .when('/',
    {
        controller: 'userController',
        templateUrl: './HTML/body.html'
    })

    .when('/admin',
    {
        controller: 'loginController',
        templateUrl: './admin/page/index.html'
    })
    .when('/search',
    {
        controller: 'userController',
        templateUrl: './HTML/search.html'
    })
    
    .otherwise({redirecTo: '/' });
});