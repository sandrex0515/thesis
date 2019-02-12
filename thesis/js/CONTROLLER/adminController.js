app.controller('adminController', function(
                                    $scope,
                                    adminFactory
                                        
                                    
                                    ){
    $scope.prod = {};
    $scope.message = {};                                    
    $scope.fetch = {};
    $scope.filter = {};
    fetch();
    console.log($scope.fetch);
    function fetch(){
        var promise = adminFactory.fetch();
            promise.then(function(data){
                    var t = data.data.result[0].created_at.split(/[- :]/);
                    var d = new Date(Date.UTC(t[0], t[1]-1, t[2], t[3], t[4], t[5]));
                    console.log(d);
            $scope.fetch = data.data.result;
            })
            .then(null, function(data){

            });
    }

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
                $scope.prodname = null;
                $scope.proddescript = null;
                $scope.prodcateg = null;
                $scope.prodprice = null;
                $scope.prodstock = null;
                fetch();
            })
            .then(null, function(data){
                $scope.message = {msg:'Error Product Title Exist!'};
            });
    };

    $scope.proddel = function(value){
        $scope.stock_id = value;
        console.log($scope.stock_id);
        var promise = adminFactory.delprod($scope.stock_id);
            promise.then(function(data){
                fetch();
            })
            .then(null, function(data){
                
            });
         
    };


   
        







});