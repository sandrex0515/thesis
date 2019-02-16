app.controller('adminController', function(
                                    $scope,
                                    adminFactory
                                        
                                    
                                    ){
    $scope.prod = {};
    $scope.message = {};                                    
    $scope.fetch = {};
    $scope.filter = {};
    $scope.modal = {};
    $scope.pk = {};
    fetch();



    function fetch(){
        var promise = adminFactory.fetch();
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
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
        var promise = adminFactory.delprod($scope.stock_id);
            promise.then(function(data){
                fetch();
            })
            .then(null, function(data){
                
            });
         
    };
    $scope.prodedit = function(value){
            $scope.modal = value;
            console.log($scope.modal);
    }
    $scope.editmodal = function(){
        $scope.pk.id = $scope.modal.id;
        console.log($scope.pk);
        // var promise = adminFactory.editprod($scope.pk);
        // promise.then(function(data){
        //         $scope.message = {successmsg:'Success'};
        //         $scope.prodname = null;
        //         $scope.proddescript = null;
        //         $scope.prodcateg = null;
        //         $scope.prodprice = null;
        //         $scope.prodstock = null;
        //         fetch();
        //     })
        //     .then(null, function(data){
        //         $scope.message = {msg:'Error Title exist!'};
        //     });
    }


   
        







});