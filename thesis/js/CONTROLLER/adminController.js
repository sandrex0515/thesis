app.controller('adminController', function(
                                    $scope,
                                    adminFactory
                                        
                                    
                                    ){
    $scope.prod = {};
    $scope.message = {};                                    

    $scope.prodsubmit = function(){
        $scope.prod.name = $scope.prodname;
        $scope.prod.descript = $scope.proddescript;
        $scope.prod.price = $scope.prodprice;
        $scope.prod.stock = $scope.prodstock;
        $scope.prod.category = $scope.prodcateg;

        if($scope.prod.name == null || $scope.prod.descript == null || $scope.prod.price == null || 
            $scope.prod.stock == null|| $scope.prod.category == null){
                $scope.message = {nullmsg:'Field Empty'};
        }
        var promise = adminFactory.addProd($scope.prod);
            promise.then(function(data){
                alert("success");
            })
            .then(null, function(data){
                
            });
    };


   
        







});