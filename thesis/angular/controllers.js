'use strict';


angular


    .module('app', ['angularFileUpload'])


    .controller('AppController', ['$scope', 'FileUploader', function($scope, FileUploader) {
        var uploader = $scope.uploader = new FileUploader({
            url: '../php/FUNCTIONS/uploadclerance.php'
        });

        // FILTERS
      dd();

      function dd(){
        $.ajax({
            type: 'POST',
            url: '../php/FUNCTIONS/getcat.php',
            dataType: 'json',
         
            success:function(data){
        
                    //     var dd = "";
                    //     for(var i = 0; i < data.result.length;i++){
                    // //   var dd = data.result[i].name;
                    // //   $('#cat').text(data.result[i].name);
                    //   $scope.dd = data.result[i];
                    //   $scope.dd.name = data.result[i].name;
                    //             console.log($scope.dd.name);
                    // }
        
                    $scope.dd = data.result;
                    console.log($scope.dd);

                    
              
            }
              
        
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
        // a sync filter
        uploader.filters.push({
            name: 'syncFilter',
            fn: function(item /*{File|FileLikeObject}*/, options) {
                // console.log('syncFilter');
                return this.queue.length < 10;
            }
        });
      
        // an async filter
        uploader.filters.push({
            name: 'asyncFilter',
            fn: function(item /*{File|FileLikeObject}*/, options, deferred) {
                // console.log('asyncFilter');
                setTimeout(deferred.resolve, 1e3);
            }
        });

        // CALLBACKS

        uploader.onWhenAddingFileFailed = function(item /*{File|FileLikeObject}*/, filter, options) {
            // console.info('onWhenAddingFileFailed', item, filter, options);
        };
        uploader.onAfterAddingFile = function(fileItem) {
            // console.info('onAfterAddingFile', fileItem);
        };
        uploader.onAfterAddingAll = function(addedFileItems) {
            // console.info('onAfterAddingAll', addedFileItems);
        };
        uploader.onBeforeUploadItem = function(item) {
            // console.info('onBeforeUploadItem', item);
        };
        uploader.onProgressItem = function(fileItem, progress) {
            // console.info('onProgressItem', fileItem, progress);
        };
        uploader.onProgressAll = function(progress) {
            // console.info('onProgressAll', progress);
        };
        uploader.onSuccessItem = function(fileItem, response, status, headers) {
            // console.info('onSuccessItem', fileItem, response, status, headers);
        };
        uploader.onErrorItem = function(fileItem, response, status, headers) {
            // console.info('onErrorItem', fileItem, response, status, headers);
        };
        uploader.onCancelItem = function(fileItem, response, status, headers) {
            // console.info('onCancelItem', fileItem, response, status, headers);
        };
        uploader.onCompleteItem = function(fileItem, response, status, headers) {
            // console.info(fileItem.file.name);
            $scope.response = fileItem.file.name;

        };
        uploader.onCompleteAll = function() {
            // console.info('onCompleteAll');
        };
        console.log($scope.response);

        // console.log($scope.response);
        // console.info('uploader', uploader);


     
    }]);
