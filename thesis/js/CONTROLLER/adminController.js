app.controller('adminController', function(
                                    $scope,
                                    adminFactory
                                        
                                    
                                    ){
    $scope.prod = {};
    $scope.message = {};                                    

    $scope.reset = function(){
        $scope.prodname = null;
        $scope.proddescript = null;
        $scope.prodcateg = null;
        $scope.prodprice = null;
        $scope.prodstock = null;
        $scope.message = null;
    }
    $scope.prodsubmit = function(){
        $scope.prod.name = $scope.prodname;
        $scope.prod.descript = $scope.proddescript;
        $scope.prod.price = $scope.prodprice;
        $scope.prod.stock = $scope.prodstock;
        $scope.prod.category = $scope.prodcateg;

        if($scope.prod.name == null){
                $scope.message = {nullmsg:'All fields are requed!'};
                return false;
        } 
        if($scope.prod.descript == null){
            $scope.message = {nullmsg:'All fields are requed!'};
            return false;
    } 
        if($scope.prod.price == null){
            $scope.message = {nullmsg:'All fields are requed!'};
            return false;
    } 
        if($scope.prod.stock == null){
            $scope.message = {nullmsg:'All fields are requed!'};
            return false;
    } 
        if($scope.prod.category == null){
            $scope.message = {nullmsg:'All fields are requed!'};
            return false;
    } 

        var promise = adminFactory.addProd($scope.prod);
            promise.then(function(data){
                $scope.message = {successmsg:'Success'};
            })
            .then(null, function(data){
                $scope.message.data = {msg:'Error Invalid data'};
            });
    };


   
        







});