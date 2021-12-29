/**
 * @ngdoc directive
 * @name lightning.directive:wordCloud
 * @restrict E
 * @author Claire Do
 *
 * @description
 * Word cloud visualization for trending searches using wordcloud2 (https://github.com/timdream/wordcloud2.js)
 * See license -> https://github.com/timdream/wordcloud2.js/blob/gh-pages/LICENSE
 */  
/*@ngInject*/
export function wordCloud($document) {
    var directive = {
        restrict: 'E',
        transclude: true,
        scope: {},
        link: {
            post: function ($scope, element, $attrs) {
                // console.log("wordCloudDirective=======");

                setTimeout(function(){
                    // Proceed only if there is data to for wordcloud
                    if($scope.wordcloudData != null && $scope.wordcloudData.facets != null) {

                        var canvas = document.getElementById($attrs.name);
                        var response = $scope.wordcloudData.facets.query_alias.filters;

                        var list = [];
                        for (var i=0; i < response.length; i++) {
                            var item = response[i];
                            list.push([item["val"], item["count"]])
    
                            if(i > 15) {
                                break;
                            }
                        }
                        
                        // WordCloud.minFontSize = "26px";
                        WordCloud(canvas, { 
                            list: list,
                            shape: "triangle",
                            gridSize: Math.round(16 * canvas.offsetWidth / 1024),
                            weightFactor: function (size) {
                                return Math.pow(size, 2.3) * canvas.offsetWidth / 1024;
                            },
                            fontFamily: 'Helvetica',
                            // color: function (word, weight) {
                            //     return (weight === 12) ? '#f02222' : '#c09292';
                            // },
                            rotateRatio: 0,
                            rotationSteps: 2,
                            backgroundColor: '#ffffff',
                            classes: "wordcloud-item",
                            click: function(item, dimension, event) {
                                // console.log(item[0]);
                                $location.url('/search?q='+item[0]);
                            },
                            // hover: function(item, dimension, event) {
                            //     // console.log(item[0]);
                            //     document.getElementById("wordcloudTooltip").innerHTML = item[0];
                            //     document.getElementById("wordcloudTooltip").style.display = "block";
                            //     console.log("dimension -=-===== ");
                            //     console.log(dimension);
                            //     console.log("event -=-===== ");
                            //     console.log(event);
                            // }
                        } );
                    }

                }, 2000);


            }
        },
        template: function (e, attrs) {
            var html = '';

            return html;
        }
    };

    return directive;
}

