app.controller('userController', function(
                                         $scope,
                                         adminFactory,
                                         $window,
                                         $log
        
                                        ){
    $scope.new = {};
    $scope.tableData = {};
    $scope.n1 = {};
    $scope.dataStored = {};
    $scope.msgDel = {};
    $scope.fetch = {};
    $scope.filter = {};
    fetch();
    console.log($scope.search);


    $scope.show_fetch = function(){
        fetch();
    }
 
    function fetch(){
        
        var promise = adminFactory.fetch($scope.filter);
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
                  
                    
            $scope.fetch = data.data.result;
            $scope.fetch.status = true;
            })
            .then(null, function(data){
                $scope.fetch.status = false;

            });
    }

    $scope.searchres = function(v){
        $scope.search = v;
        var url = "http://" + $window.location.host + "/sites/thesis/#/search";
        $log.log(url);

        $window.location = url;

    }
 





});