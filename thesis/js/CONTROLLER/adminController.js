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
    $scope.prodfiles = {};
    $scope.prodfiles.file = "";
    fetch();
    fetchcount();
    $scope.show_fetch = function(){
        fetch();
        fetchcount();
    }
    $scope.show_fetch2 = function(){
        fetch2();
        fetchcount();
    }
    function fetch(){
        
        var promise = adminFactory.fetch($scope.filter);
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
                    
            $scope.fetch = data.data.result;
            $scope.fetch.status = true;
            console.log($scope.fetch);

            })
            .then(null, function(data){
                $scope.fetch.status = false;

            });
    }
    function fetch2(){
        if($scope.viewTitle.length > 0){
            $scope.filter.type = $scope.viewTitle;
        }
        var promise = adminFactory.fetch($scope.filter);
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
                  
                    
            $scope.fetch = data.data.result;
            })
            .then(null, function(data){

            });
    }
    function fetchcount(){
     
        var promise = adminFactory.fetchcount();
            promise.then(function(data){
                    
                  
                    
            $scope.fetch.bilang = data.data.result[0].bilang;
            })
            .then(null, function(data){

            });
    }

    $scope.csv = function(){
        window.open('../../php/FUNCTIONS/csv.php', '_blank');
        console.log('sample');
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
        console.log($scope.prodfiles);

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
                fetchcount();
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
            fetch();
    }
    $scope.editmodal = function(){
       
        var promise = adminFactory.editprod($scope.modal);
        promise.then(function(data){
                $scope.message = {successmsg:'Success'};
                alert('success');
                fetch();
            })
            .then(null, function(data){
                $scope.message = {msg:'Error Title exist!'};
            });
    }
    $scope.editclose = function(){
        fetch();
    }
    $scope.Selectopt = function(){
        if($scope.viewTitle == 'Title'){
            $scope.viewTitle.item = 'item';
        }
        if($scope.viewTitle == 'Date'){
            $scope.viewTitle.date = 'created_at';
        }
        if($scope.viewTitle == 'Price'){
            $scope.viewTitle.price = 'price';
        }
        if($scope.viewTitle == 'Category'){
            $scope.viewTitle.type = 'type';
        }
        fetch();
            // var promise = adminFactory.selectprod($scope.viewTitle);
            // promise.then(function(data){
            //         fetch();
            //     })
            //     .then(null, function(data){
            //         $scope.message = {msg:'Error Title exist!'};
            //     });

    }
    $scope.recommend = function(value){
        $scope.val = value;
        var promise = adminFactory.recommend($scope.val);
            promise.then(function(data){
                alert('success');
            })
            .then(null, function(data){
                alert('error');
            });
    }


   
        







});