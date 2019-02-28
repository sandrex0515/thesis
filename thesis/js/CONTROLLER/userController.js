app.controller('userController', function(
                                         $scope,
                                         adminFactory
        
                                        ){
    $scope.new = {};
    $scope.tableData = {};
    $scope.n1 = {};
    $scope.dataStored = {};
    $scope.msgDel = {};
    $scope.fetch = {};
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





});