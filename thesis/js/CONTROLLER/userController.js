app.controller('userController', function(
                                         $scope,
                                         $rootScope,
                                         adminFactory,
                                         md5,
                                         sessionFactory
        
                                      ){
    $scope.pk = '';
    $scope.new = {};
    $scope.tableData = {};
    $scope.n1 = {};
    $scope.dataStored = {};
    $scope.msgDel = {};
    $scope.fetch = {};
    $scope.filter = {};
    $scope.search = {};
    init();
    fetch();
    $scope.topsearch = {};
    console.log($scope.topsearch);
    $rootScope.search = {};
   console.log($scope.search);
    $scope.show_fetch = function(){
        fetch();
    }
    
 function init() {
    var promise = sessionFactory.session();
    promise.then(function (data) {
            var _id = 'pk';
            $scope.pk = data.data[_id];  
            get_prof();

    })
        .then(null, function (data) {
        });
}
    function get_prof(){
        var filters = {
            'pk': $scope.pk
        };
        var promise = adminFactory.get_info(filters);
            promise.then(function (data){
                $scope.info = data.data.result[0];
                $scope.info.status = true;
            })
            .then(null, function (data){
                $scope.info.status = false;
            })
    }
 function fetch(){
        
        var promise = adminFactory.fetch($scope.filter);
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
                  
            $scope.fetch = data.data.result;
            $scope.fetch.status = true;
            $rootScope = $scope.fetch;
            console.log($scope.fetch);

            })
            .then(null, function(data){
                $scope.fetch.status = false;
            });
    }
    $scope.topsearch = function(v){
        console.log(v);
        $scope.topsearch = v;
    }
    $scope.searchres = function(v){
        $scope.search = v;
        // var url = "http://" + $window.location.host + "/sites/thesis/#/search?&" + 'searchString=' + $scope.filter.searchString;
        // $log.log(url);

        // $window.self.location = url;
        // window.location = window.location.href.replace("https://google.com");
        // window.History.pushState({urlPath: 'http://localhost/sites/thesis/#/search'});
    }
 





});