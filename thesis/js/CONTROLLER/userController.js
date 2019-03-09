app.controller('userController', function(
                                         $scope,
                                         $rootScope,
                                         userFactory,
                                         md5,
                                         sessionFactory,
                                         $window
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
    $scope.topsearch = {};
    $scope.t = {};
    $scope.quantity = 1;
    $scope.cart = {};
    $scope.holder = {};
    $scope.hhh = {};
    $scope.hh = {};
  
    init();
    fetch();
    fetchsearch();
    cartfetch();
    fetchcateg();
    getsub();
    // $scope.newl = {};

    console.log($scope.newl);



    $scope.show_fetch = function(){
        fetch();
        fetchsearch();
        cartfetch();
 
    }
    
    function numberWithCommas(count) {
        var parts = count.toString().split(".");
        parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        return parts.join(".");
    }
    function fetchsearch(){
        var search = $scope.filter.searchString;
        var filters = {
            'pk': $scope.pk,
            'search' : search
        };
        var promise = userFactory.fetchsearch(filters);
            promise.then(function(data){
                var count = 0;
                
                for(i=0;i < data.data.result.length; i ++){
                    count++;
                }
            
                $scope.searchfetch = data.data.result;
                $scope.searchfetch.search = data.data.result[0].search;
              
                numberWithCommas(count);
                $scope.searchfetch.count = count;
                


                $scope.status = true;
            })
            .then(null, function(data){
                $scope.status = false;
            });
    }
 function init() {
    var promise = sessionFactory.session();
    promise.then(function (data) {
            var _id = 'pk';
            $scope.pk = data.data[_id];  
            get_prof();
            fetchsearch();
            cartfetch();

    })
        .then(null, function (data) {
        });
}
    function get_prof(){
        var filters = {
            'pk': $scope.pk
        };
        var promise = userFactory.get_info(filters);
            promise.then(function (data){
                $scope.info = data.data.result[0];
                $scope.info.status = true;
            })
            .then(null, function (data){
                $scope.info.status = false;
            })
    }

    function getsub(){
         var promise = userFactory.getsub($scope.hhh);
             promise.then(function(data){
                $scope.hh = data.data.result;
                $scope.hh.status = true; 
                console.log($scope.hh);
             })
             .then(null, function(data){
                 $scope.hhh.status = false;
             });
     }

    function cartfetch(){
        $scope.holder.pk = $scope.pk;
        $scope.holder.sa = 9382;
        var promise = userFactory.cartfetch($scope.holder);
            promise.then(function (data){
                
                $scope.newl = data.data.result;
               
                for(var total = 0; total < data.data.result.length;total++);
                // $scope.newl.total =  $scope.newl.price.reduce((partial_sum, a) => partial_sum + a);
                $scope.newl.count = total;

                

                // for(var i in data.data.result){
                // $scope.newl.item = data.data.result[i].item
                // console.log(i);
                // }
                // var total =  $scope.newl;
                // for(var i in total){
                //   var newl1 = total[i];
                // $scope.newl2 = newl1;
                // console.log($scope.newl2);

                // }
                $scope.newl.status = true;
                console.log($scope.newl);
            })
            .then(null, function (data){
                $scope.newl.status = false;
                $scope.newl.count = 0;
            })
    }

 function fetch(){
        
        var promise = userFactory.fetch($scope.filter);
            promise.then(function(data){
                    var t = data.data.result[0].created_at;
                    var d = new Date(t.toLocaleString());
                  
            $scope.fetch = data.data.result;
            $scope.fetch.status = true;
            $rootScope = $scope.fetch;
            console.log($scope.fetch);
//ready function calculate the sum
// var total = 0;
// for(var i = 0; i < $scope.cart.item.length;i++){
//     var product = $scope.cart.item[i];
//     total += (product.price * product.quantity);
// }
            })
            .then(null, function(data){
                $scope.fetch.status = false;
            });
    }
    // $scope.cartItem = function(newl){
      
    //       console.log(newl);

    // }

    function fetchcateg(){
        var promise = userFactory.fetchcateg();
            promise.then(function(data){
                $scope.fetchcateg = data.data.result;
                $scope.fetchcateg.status = true;
            })
            .then(null, function(data){
                $scope.fetchcateg.status = false;

            });
    }


    
    $scope.deletecart = function(v){
        
        var promise = userFactory.delcart(v)
            promise.then(function(data){
                alert('Item Has been removed');
                cartfetch();
            })
            .then(null, function(data){
                //
            });
      
    }
    $scope.topsearch = function(v){
        console.log(v);
        $scope.topsearch = v;
    }
    $scope.top = function(v){
        $scope.t = v;
        $scope.quantity = 1 ;
    }
    $scope.plus = function(t){
        $scope.quantity +=  1;
        if($scope.quantity === t.quantity){
            $scope.quantity = t.quantity;
            e.preventDefault();
        }
     
    }
    $scope.minus = function(){
        $scope.quantity = $scope.quantity - 1;
        if($scope.quantity < 0){
            $scope.quantity = 1;
        }
    }
    $scope.ord = function(newl){
        for(var i = 0; i < newl.length;i++){
            var filter = newl[i];
            
            var promise = userFactory.ord(filter);
        }
                promise.then(function(data){
                    alert('Succes');
                })
                .then(null, function(data){
                    alert('error');
                });
         
    }
    $scope.cart = function(t){
        $scope.cart.item_id = t.item_id;
        $scope.cart.pk =  $scope.pk;
        $scope.cart.quantity = $scope.quantity;

        if($scope.cart.quantity === 0){
            $scope.msg = 'Add Atleast 1 Quantity';
            return false;
        }
        
        var promise = userFactory.cart($scope.cart);
            promise.then(function(data){
                alert('Item added to cart');
                fetchsearch();
                cartfetch();
            })
            .then(null, function(data){
                alert('Error connection error');
            })

    }
    $scope.searchres = function(){
        
        // var url = "http://" + $window.location.host + "/sites/thesis/#/search?&" + 'searchString=' + $scope.filter.searchString;
        // $log.log(url);

        // $window.self.location = url;
        // window.location = window.location.href.replace("../php/FUNCTIONS/temp.php?");
        // window.History.pushState({urlPath: 'http://localhost/sites/thesis/#/search'});
        var uri = $scope.filter.searchString;
        var urien = $window.encodeURIComponent(uri);
        location.replace('./php/FUNCTIONS/temp.php?&searchString=' + urien + "&pk=" + $scope.pk);

    }

    $scope.getsub = function(v){
        $scope.hhh = v;
        getsub();
     }
  
 





});