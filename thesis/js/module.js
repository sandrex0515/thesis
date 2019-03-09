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
    .when('/categories',
    {
        controller: 'userController',
        templateUrl: './HTML/categories.html'
    })
    .when('/categoriessub',
    {
        controller: 'userController',
        templateUrl: './HTML/categoriessub.html'
    })
    
    .otherwise({redirecTo: '/' });
});