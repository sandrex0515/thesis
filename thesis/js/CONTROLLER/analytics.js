app.controller('analytics', function(
                                    $scope,
                                    adminFactory
                                    ){
$scope.fetch = {};
$scope.pending = {};
$scope.prodcateg = {};
$scope.dataresult = {};
$scope.sum = {};
$scope.value = {};
$scope.getlastyear = {};
$scope.year = {};
$scope.todaysales = {};
analytics();
analytics2();
analytics3();
todaysales();
pending();
showmodal();
    function showmodal(){
        var promise = adminFactory.showmodal();
            promise.then(function(data){


            })
            .then(null, function(data){
              $('#showmodal').modal('show'); 
            });
    }
    function analytics2(){

        var month = new Array();
        month[0] = "January";
        month[1] = "February";
        month[2] = "March";
        month[3] = "April";
        month[4] = "May";
        month[5] = "June";
        month[6] = "July";
        month[7] = "August";
        month[8] = "September";
        month[9] = "October";
        month[10] = "November";
        month[11] = "December";
      
        var d = new Date();
        var n = month[d.getMonth()];
        var nn = month[d.getMonth() - 1];
       $scope.value.n = n;
       $scope.value.nn = nn;
        var dd = new Date();
        $scope.value.d = dd.getFullYear();
        $scope.value.dd = dd.getFullYear() - 1;
        var promise = adminFactory.analytics2($scope.value);
            promise.then(function(data){
                $scope.getlastyear = data.data.result;

                var lastyear = [parseInt($scope.getlastyear[0].january) + 
                parseInt($scope.getlastyear[0].february) + 
                parseInt($scope.getlastyear[0].march) + 
                parseInt($scope.getlastyear[0].april) + 
                parseInt($scope.getlastyear[0].may) + 
                parseInt($scope.getlastyear[0].june) +  
                parseInt($scope.getlastyear[0].july) + 
                parseInt($scope.getlastyear[0].august) + 
                parseInt($scope.getlastyear[0].september) + 
                parseInt($scope.getlastyear[0].october) + 
                parseInt($scope.getlastyear[0].november) + 
                parseInt($scope.getlastyear[0].december) 
                  ];
                  $scope.getlastyear.get = lastyear;
            })
            .then(null, function(data){

            });
    }
    function analytics3(){
      var promise = adminFactory.analytics3();
          promise.then(function(data){
            $scope.analytics3 = data.data.result;
          })
          .then(null, function(data){

          });
    }

    function analytics(){
        var month = new Array();
        month[0] = "January";
        month[1] = "February";
        month[2] = "March";
        month[3] = "April";
        month[4] = "May";
        month[5] = "June";
        month[6] = "July";
        month[7] = "August";
        month[8] = "September";
        month[9] = "October";
        month[10] = "November";
        month[11] = "December";
      
        var d = new Date();
        var n = month[d.getMonth()];
        var nn = month[d.getMonth() - 1];
       $scope.value.n = n;
       $scope.value.nn = nn;
        var dd = new Date();
        $scope.value.d = dd.getFullYear();
        $scope.value.dd = dd.getFullYear() - 1;
        var promise = adminFactory.analytics($scope.value);
            promise.then(function(data){
                              $scope.dataresult = data.data.result;

                var month = new Array();
                month[0] = "January";
                month[1] = "February";
                month[2] = "March";
                month[3] = "April";
                month[4] = "May";
                month[5] = "June";
                month[6] = "July";
                month[7] = "August";
                month[8] = "September";
                month[9] = "October";
                month[10] = "November";
                month[11] = "December";
              
                var d = new Date();
                var n = month[d.getMonth()];
              $scope.dataresult.month = $scope.dataresult[0].n;
                var sum = [
                    parseInt($scope.dataresult[0].january) + 
                    parseInt($scope.dataresult[0].february) + 
                    parseInt($scope.dataresult[0].march) + 
                    parseInt($scope.dataresult[0].april) + 
                    parseInt($scope.dataresult[0].may) + 
                    parseInt($scope.dataresult[0].june) + 
                    parseInt($scope.dataresult[0].july) +
                    parseInt($scope.dataresult[0].august) + 
                    parseInt($scope.dataresult[0].september) +
                    parseInt($scope.dataresult[0].october) +
                    parseInt($scope.dataresult[0].november) +
                    parseInt($scope.dataresult[0].december)
                ];
                var lastmonth = [
                       parseInt($scope.dataresult[0].getmonth)  - parseInt($scope.dataresult[0].getlastmonth)

                ];

                $scope.dataresult.compare =  parseFloat(lastmonth) / parseFloat($scope.dataresult[0].getlastmonth) * 100; 

                $scope.dataresult.compareyear =  Number(sum) - Number($scope.getlastyear.get);
                $scope.dataresult.yearget = Number($scope.dataresult.compareyear) / Number($scope.getlastyear.get) * 100;
                console.log(Number($scope.dataresult.yearget));
                $scope.dataresult.sum = sum[0];
                $scope.dataresult.getmonth = data.data.result[0].getmonth;
                if($scope.dataresult.compare >= 1){
                    $scope.dataresult.compare.status = true;
                }else{
                    $scope.dataresult.compare.status = false;
                }
                var ctx = document.getElementById("myChart").getContext('2d');
                var myChart = new Chart(ctx, {
                             type: 'line',
                             data: {
                              labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                               datasets: [{
                               label: 'Statistics',
                               data: [$scope.dataresult[0].january,
                                        $scope.dataresult[0].february,
                                        $scope.dataresult[0].march,
                                        $scope.dataresult[0].april,
                                        $scope.dataresult[0].may,
                                        $scope.dataresult[0].june,
                                        $scope.dataresult[0].july,
                                        $scope.dataresult[0].august,
                                        $scope.dataresult[0].september,
                                        $scope.dataresult[0].october,
                                        $scope.dataresult[0].november,
                                        $scope.dataresult[0].december],
                                borderWidth: 2,
                               backgroundColor: 'rgb(87,75,144)',
                               borderColor: 'rgb(87,75,144)',
                               borderWidth: 2.5,
                                pointBackgroundColor: '#ffffff',
                                pointRadius: 4
                                                           }]
                                                         },
                                                         options: {
                                                           legend: {
                                                             display: false
                                                           },
                                                           scales: {
                                                             yAxes: [{
                                                               ticks: {
                                                                 beginAtZero: true,
                                                                 stepSize: 200000
                                                               }
                                                             }],
                                                             xAxes: [{
                                                               gridLines: {
                                                                 display: false
                                                               }
                                                             }]
                                                           },
                                                         }
                                                       });
            })
            .then(null, function(data){

            })

                                        }

                                        function pending(){

                                            var promise = adminFactory.pending($scope.filter);
                                                promise.then(function(data){
                                                        var t = data.data.result[0].created_at;
                                                        var d = new Date(t.toLocaleString());
                                        
                                                $scope.pending = data.data.result;
                                                $scope.pending.status = true;
                                                $scope.pending.count = data.data.result.length;
                                                })
                                                .then(null, function(data){
                                                    $scope.pending.status = false;
                                        
                                                });
                                        }

function todaysales(){
  var promise = adminFactory.todaysales();
      promise.then(function(data){
        $scope.todaysales = data.data.result[0];
        console.log($scope.todaysales);
      })
      .then(null, function(data){

      })
}

$scope.prod = function(){
console.log($scope.prodcateg);
}
$scope.settoday = function(){
  var dd = new Date();
  $scope.year.yd = dd.getFullYear();
  $scope.year.sales = 0;
  var promise = adminFactory.settoday($scope.year);
      promise.then(function(data){
        $('#showmodal').modal('hide'); 
        alert('Success');
        showmodal();
      })
      .then(null, function(data){

      });
}
                                        
});