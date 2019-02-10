app.controller('adminController', function(
                                    $scope,
                                    adminFactory
                                        
                                    
                                    ){
    $scope.prod = {};


    $scope.prodsubmit = function(){
        $scope.prod.name = $scope.prodname;
        $scope.prod.descript = $scope.proddescript;
        $scope.prod.price = $scope.prodprice;
        $scope.prod.stock = $scope.prodstock;
        $scope.prod.category = $scope.prodcateg;

        var promise = adminFactory.addProd($scope.prod);
            promise.then(function(data){
                alert("success");
            })
            .then(null, function(data){
                alert("error");
            });
    };


   
        







});